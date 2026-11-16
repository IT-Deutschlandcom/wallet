package de.ivy.wallet;

import android.app.Activity;
import android.graphics.Color;
import android.os.Bundle;
import android.webkit.WebSettings;
import android.webkit.WebView;

public class MainActivity extends Activity {
    private WebView web;

    @Override
    protected void onCreate(Bundle b) {
        super.onCreate(b);
        getWindow().setStatusBarColor(Color.parseColor("#0B0E1A"));
        web = new WebView(this);
        web.setBackgroundColor(Color.parseColor("#0B0E1A"));
        WebSettings s = web.getSettings();
        s.setJavaScriptEnabled(true);
        s.setDomStorageEnabled(true);
        web.loadUrl("file:///android_asset/index.html");
        setContentView(web);
    }

    @Override
    public void onBackPressed() {
        web.evaluateJavascript("window.onBack && window.onBack()", new android.webkit.ValueCallback<String>() {
            public void onReceiveValue(String value) {
                if (!"true".equals(value)) finish();
            }
        });
    }
}
