Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C119620
	for <patches@lists.linux.dev>; Sat, 15 Oct 2022 00:46:58 +0000 (UTC)
Received: by mail-pj1-f48.google.com with SMTP id h12so6390921pjk.0
        for <patches@lists.linux.dev>; Fri, 14 Oct 2022 17:46:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZQKr6gxcoyxbVjA/4utImOsMAnHB8ip1bwqG26rMhL0=;
        b=EWIIqrjn5mCAhLJM9VhfqrSQSfuHVkDTsVSgY/QN7vgNwzOFewGxxedSAVqzUWWaF5
         5WTBxM5EpiZ2+QfWi0l+6KNhgjao1+6+zW3Qm7lvVIr7TN5TfyZqnD7Mgm0dGXdiejKG
         Tyluw59VaUDWZG2fI3MirIJt19Y743wDnGfMI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZQKr6gxcoyxbVjA/4utImOsMAnHB8ip1bwqG26rMhL0=;
        b=Lmngt/nmmKMviKwevLm/9JqVORCRHSZ3Gr9ULxhZhFzujmsfNS4g75GQqfWMzvcDR+
         00GJERB0IGFkdhvpH4gRUuBjmz4qWwqhOCXUj/poeT9hmOqhmPQuBmAEXtSu2PNjR+Zv
         Usyt4lilK+zwAXxumoZRHLdOYyr++Q9XheeC6fo3SUJcapyGkCmYUyVlVH5jr54lrucw
         HCa/SZWVS4h+fQy2HAvZe4KphG38Xxdk6rmbpZAMnlPwb2P+M577BI00K51GuhJwarVm
         2i8UQuu61Ef0TAPEfJ0qRnJZL65pPcqQupdWONuc9DREbL0EM4ZyiIqB5S6Pb6mvguuZ
         L6KA==
X-Gm-Message-State: ACrzQf1Aoqzc+QMp8r6WSA3MBf2qhwP3SirtZKIFQ3Tjgey+7V3yLkQN
	QvSCmzuSMA3xrvZ0aL+DHjkXDg==
X-Google-Smtp-Source: AMsMyM7r29oBpMR7H67b79mXzxvDdQ1x+Np6mKFbOgC+l7l79oMFiIig5TI4oJF8rpKPcfykzgpfLw==
X-Received: by 2002:a17:90b:390c:b0:20d:a662:dac2 with SMTP id ob12-20020a17090b390c00b0020da662dac2mr12830551pjb.5.1665794818059;
        Fri, 14 Oct 2022 17:46:58 -0700 (PDT)
Received: from smtp.gmail.com ([2620:15c:9d:2:9f6e:fc87:d13f:1fa6])
        by smtp.gmail.com with ESMTPSA id b4-20020a170902bd4400b0016d72804664sm2230802plx.205.2022.10.14.17.46.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Oct 2022 17:46:57 -0700 (PDT)
From: Stephen Boyd <swboyd@chromium.org>
To: Andy Gross <agross@kernel.org>,
	Bjorn Andersson <bjorn.andersson@linaro.org>
Cc: linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	linux-arm-msm@vger.kernel.org,
	Konrad Dybcio <konrad.dybcio@somainline.org>
Subject: [PATCH 2/2] soc: qcom: stats: Mark device as having no PM support
Date: Fri, 14 Oct 2022 17:46:54 -0700
Message-Id: <20221015004654.3930122-2-swboyd@chromium.org>
X-Mailer: git-send-email 2.38.0.413.g74048e4d9e-goog
In-Reply-To: <20221015004654.3930122-1-swboyd@chromium.org>
References: <20221015004654.3930122-1-swboyd@chromium.org>
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

