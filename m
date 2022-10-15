Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64507620
	for <patches@lists.linux.dev>; Sat, 15 Oct 2022 00:49:38 +0000 (UTC)
Received: by mail-pj1-f51.google.com with SMTP id q10-20020a17090a304a00b0020b1d5f6975so6240669pjl.0
        for <patches@lists.linux.dev>; Fri, 14 Oct 2022 17:49:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZQKr6gxcoyxbVjA/4utImOsMAnHB8ip1bwqG26rMhL0=;
        b=UNaV+xml2akMbPhD2QHmFAA8pfCMe+3CkGKIM72CP1hO+V/OAyZ9/cBQxOEE7dgQq4
         v5KaiMedRXdVjRLj2/4q03YlrRHnmyBYA05i4epji0U1mO7XL00ry82NsBb5slWwEPrG
         ohpL4iEFpvBjbupLCA/wiaAvRHB12BMZEisx0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZQKr6gxcoyxbVjA/4utImOsMAnHB8ip1bwqG26rMhL0=;
        b=nmbC6hdZAgeUP9meCcThc5F8+I6raN4XejyoS4A2gT5ZuoAkFMsOeMLwSYoF+3BXuC
         0QIZYV6Ri/A36DMDgOPXyzJcGAebmpsl34vZl0Fsqlpnp2RcRowFf0tm84Dh4KvzTEsP
         do/vSaTtesq5MDTMC2XoUpCL4l3dvPlQZaQ16EOycyvdKhxgz4IFHuAbZ01ecWJXJoYU
         zvE2bPQ3Wk5pFNHlsjL4v50XhDnWJ9OYUc/xSGSAjhA3mPCxCZ1AbhiPt7gOtDf4tp+l
         8q3BgJPTlWEjm0Fp6c3E9NDaWmP4D+bPUyYNlKO50yE3SJW2FQM92wmn6op3aDnhAw+z
         o87A==
X-Gm-Message-State: ACrzQf0AKa2Flo+OeVGMAI+20m3A7VI0lJ/eW0MS+7Pdn7WiUsco2KP3
	2xofjU8Tbg8x0v4Inh2tev70Vg==
X-Google-Smtp-Source: AMsMyM5M+YvV5wFht/uuppEYJ/Zz+P9fRYkhf/H0EYK2VZM6XBBCA5PfpfebdJ8em7GzUb7eg+YdAA==
X-Received: by 2002:a17:90b:17c4:b0:20d:4d79:55b1 with SMTP id me4-20020a17090b17c400b0020d4d7955b1mr631817pjb.125.1665794977885;
        Fri, 14 Oct 2022 17:49:37 -0700 (PDT)
Received: from smtp.gmail.com ([2620:15c:9d:2:9f6e:fc87:d13f:1fa6])
        by smtp.gmail.com with ESMTPSA id i10-20020a170902c94a00b00179f370dbe7sm2256142pla.287.2022.10.14.17.49.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Oct 2022 17:49:37 -0700 (PDT)
From: Stephen Boyd <swboyd@chromium.org>
To: Andy Gross <agross@kernel.org>,
	Bjorn Andersson <andersson@kernel.org>
Cc: linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	linux-arm-msm@vger.kernel.org,
	Konrad Dybcio <konrad.dybcio@somainline.org>
Subject: [PATCH RESEND 2/2] soc: qcom: stats: Mark device as having no PM support
Date: Fri, 14 Oct 2022 17:49:34 -0700
Message-Id: <20221015004934.3930651-2-swboyd@chromium.org>
X-Mailer: git-send-email 2.38.0.413.g74048e4d9e-goog
In-Reply-To: <20221015004934.3930651-1-swboyd@chromium.org>
References: <20221015004934.3930651-1-swboyd@chromium.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This driver purely exposes information from memory to the kernel. Let's
mark it as not having any device PM functionality, so that during
suspend we skip even trying to call a suspend function on this device.
This clears up suspend logs more than anything else, but it also shaves
a few cycles off suspend.

Cc: Konrad Dybcio <konrad.dybcio@somainline.org>
Signed-off-by: Stephen Boyd <swboyd@chromium.org>
---
 drivers/soc/qcom/qcom_stats.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/soc/qcom/qcom_stats.c b/drivers/soc/qcom/qcom_stats.c
index d6bfd1bbdc2a..d89453a77408 100644
--- a/drivers/soc/qcom/qcom_stats.c
+++ b/drivers/soc/qcom/qcom_stats.c
@@ -217,6 +217,8 @@ static int qcom_stats_probe(struct platform_device *pdev)
 
 	platform_set_drvdata(pdev, root);
 
+	device_set_pm_not_required(&pdev->dev);
+
 	return 0;
 }
 
-- 
https://chromeos.dev

