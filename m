Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 143B07A
	for <patches@lists.linux.dev>; Tue, 17 May 2022 19:33:08 +0000 (UTC)
Received: by mail-pl1-f175.google.com with SMTP id i17so18198920pla.10
        for <patches@lists.linux.dev>; Tue, 17 May 2022 12:33:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=5mBbynL6gMveM8Z9JZinN28MMyvflON2/SNJvg83S1s=;
        b=evYKYoCnXM9GXViETG+uO9hzdeRJhj6wULFI5sSjWoDfXEk81+FkXZo9Zjb8KPTa/5
         pVMH4x8AgnoHuwUaNVut5zlX3DziAjVlRk8QokH9Nyhnd0ajtyuCIrLu1/VIK189jkv9
         X05W1a+4DmY0kMrhfz9GdzzyhTWskoutn5jFU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=5mBbynL6gMveM8Z9JZinN28MMyvflON2/SNJvg83S1s=;
        b=pdDQJgCgLJgBWVCBqc1NOFj92YNANkc58xX14MHY9XMIMG5qh5bycPZwvxTIjo2/el
         9RjRKfCAT2lB7yB8fBrTFRL/LYF4my7mBgxODqiBy6Nf7oEAWKcoI7p8bgbTWAhF3bpD
         PH5rJAZ1KaqwPNaLj0d3LjGqdTiEkSUbWx07mzpnAIBMgY3BwL83OXv7j7hUAvHehQBA
         F1gVrzFN6tywLqRcRsSZtW91QY4ZZ6nFF3aEMVNCNoUh+crVxySa4J6FNUYXrE1LpCDg
         ZOhQqNpjbQ2Ml4WzCr57ji96lizNL8IFBvkCWidiyWsJdMAFibQi8IzQrI3wLBWyZUgw
         Zxow==
X-Gm-Message-State: AOAM531GV6IST/F3+CE1D4asZQQkiU8XmkgE17AL0gTJ4pEg5xCBiB4L
	hLyZI++np9fGYyGihHyR38p3mA==
X-Google-Smtp-Source: ABdhPJz+InTpwao5BILrfEs/xt20Ptzv3WuyXYsmjCrmujsuTd5RN/o+uzVFXDnJXEfLPqpaRb7P2w==
X-Received: by 2002:a17:902:b70c:b0:156:16f0:cbfe with SMTP id d12-20020a170902b70c00b0015616f0cbfemr23730222pls.152.1652815988531;
        Tue, 17 May 2022 12:33:08 -0700 (PDT)
Received: from smtp.gmail.com ([2620:15c:202:201:be81:6c26:5643:b3d9])
        by smtp.gmail.com with ESMTPSA id u8-20020a170902714800b0015e8d4eb281sm7680858plm.203.2022.05.17.12.33.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 May 2022 12:33:08 -0700 (PDT)
From: Stephen Boyd <swboyd@chromium.org>
To: Andy Gross <agross@kernel.org>,
	Bjorn Andersson <bjorn.andersson@linaro.org>
Cc: linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	linux-arm-msm@vger.kernel.org,
	Alex Elder <elder@linaro.org>,
	Matthias Kaehlcke <mka@chromium.org>
Subject: [PATCH] arm64: dts: qcom: sc7180: Remove ipa_fw_mem node on trogdor
Date: Tue, 17 May 2022 12:33:07 -0700
Message-Id: <20220517193307.3034602-1-swboyd@chromium.org>
X-Mailer: git-send-email 2.36.0.550.gb090851708-goog
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

We don't use this carveout on trogdor boards, and having it defined in
the sc7180 SoC file causes an overlap message to be printed at boot.

 OF: reserved mem: OVERLAP DETECTED!
 memory@86000000 (0x0000000086000000--0x000000008ec00000) overlaps with memory@8b700000 (0x000000008b700000--0x000000008b710000)

Delete the node in the trogdor dtsi file to fix the overlap problem and
remove the error message.

Cc: Alex Elder <elder@linaro.org>
Cc: Matthias Kaehlcke <mka@chromium.org>
Fixes: 310b266655a3 ("arm64: dts: qcom: sc7180: define ipa_fw_mem node")
Signed-off-by: Stephen Boyd <swboyd@chromium.org>
---
 arch/arm64/boot/dts/qcom/sc7180-trogdor.dtsi | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/boot/dts/qcom/sc7180-trogdor.dtsi b/arch/arm64/boot/dts/qcom/sc7180-trogdor.dtsi
index 732e1181af48..262224504921 100644
--- a/arch/arm64/boot/dts/qcom/sc7180-trogdor.dtsi
+++ b/arch/arm64/boot/dts/qcom/sc7180-trogdor.dtsi
@@ -42,6 +42,7 @@ charger-crit {
  */
 
 /delete-node/ &hyp_mem;
+/delete-node/ &ipa_fw_mem;
 /delete-node/ &xbl_mem;
 /delete-node/ &aop_mem;
 /delete-node/ &sec_apps_mem;

base-commit: 42226c989789d8da4af1de0c31070c96726d990c
-- 
https://chromeos.dev

