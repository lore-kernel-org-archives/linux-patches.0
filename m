Received: from mail-oa1-f45.google.com (mail-oa1-f45.google.com [209.85.160.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81BE8620
	for <patches@lists.linux.dev>; Sat, 15 Oct 2022 00:49:48 +0000 (UTC)
Received: by mail-oa1-f45.google.com with SMTP id 586e51a60fabf-1364357a691so7741821fac.7
        for <patches@lists.linux.dev>; Fri, 14 Oct 2022 17:49:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=pfHTz2OiIbmF5iJHdVMyVQbaziXuWRN/1ILDt+PkeHY=;
        b=MrSYbcpuKKcBRkcAzlV3l7P6XU9wDVllDs/MR3NbeWINr715oJSEWn6iEsPc1CSQWj
         MI0zrDOx6A/wPXt2bIf3TQMUhIEyDYJPQCI6ZBYGqK0zBlJE03t0IEeb+wHG/5oobp6/
         VXIGFF063PHMRaDxv9u4jZuxjaQl23euz1tdU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pfHTz2OiIbmF5iJHdVMyVQbaziXuWRN/1ILDt+PkeHY=;
        b=X7OPVFtkM025k4EH8LiY2fMjNMtqP8qEeYy/p7pr8el7HJzlGhLzbx5RRQR3kqyecD
         H1vUPquherKe5hsoBHEHZo1x2XtuM4PqOeWMV6qwVqseKPbCP6BXTLRBoE/m2wmrk4Rj
         8Z0Y84tBnW4NlEf8HuXkv5l8JcmiFOtHCLsSqcPoywclCMn44OMiQ0etlddbSelTxzdG
         2Zxhobj2s3Yh50Q8tuFiJLkLYxJ37THuoirSmKmaPJrFJ4R2cPjibn8Sj2Jnn72BBTNF
         lQcgsSfDaorFGSubr/hbvBfsvRmcecqj1PvWjlNGe0nFl+ST/LjFW2aD2ao6bZkrbF74
         8Rfw==
X-Gm-Message-State: ACrzQf1I5i+UHtDAi/5Yj7Z8mTHNProEnAMuKWL0Mk/QJ/WH+/1o4qbH
	fvc6sy8HByHoQlhrovfyrbYb2N6KKIL/DA==
X-Google-Smtp-Source: AMsMyM4VVo6qGwJQySMZ7zlfLU0Fq5lgz4oc223JraE6Pou5fDW6iQi7VlQERJsrU1YszVLxPDT9sA==
X-Received: by 2002:a17:90b:4b49:b0:20d:3e36:3c7d with SMTP id mi9-20020a17090b4b4900b0020d3e363c7dmr20717121pjb.52.1665794976652;
        Fri, 14 Oct 2022 17:49:36 -0700 (PDT)
Received: from smtp.gmail.com ([2620:15c:9d:2:9f6e:fc87:d13f:1fa6])
        by smtp.gmail.com with ESMTPSA id i10-20020a170902c94a00b00179f370dbe7sm2256142pla.287.2022.10.14.17.49.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Oct 2022 17:49:36 -0700 (PDT)
From: Stephen Boyd <swboyd@chromium.org>
To: Andy Gross <agross@kernel.org>,
	Bjorn Andersson <andersson@kernel.org>
Cc: linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	linux-arm-msm@vger.kernel.org,
	Konrad Dybcio <konrad.dybcio@somainline.org>
Subject: [PATCH RESEND 1/2] soc: qcom: cmd-db: Mark device as having no PM support
Date: Fri, 14 Oct 2022 17:49:33 -0700
Message-Id: <20221015004934.3930651-1-swboyd@chromium.org>
X-Mailer: git-send-email 2.38.0.413.g74048e4d9e-goog
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

Resend to fix Bjorn's email.

 drivers/soc/qcom/cmd-db.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/soc/qcom/cmd-db.c b/drivers/soc/qcom/cmd-db.c
index 629a7188b576..33856abd560c 100644
--- a/drivers/soc/qcom/cmd-db.c
+++ b/drivers/soc/qcom/cmd-db.c
@@ -338,6 +338,8 @@ static int cmd_db_dev_probe(struct platform_device *pdev)
 
 	debugfs_create_file("cmd-db", 0400, NULL, NULL, &cmd_db_debugfs_ops);
 
+	device_set_pm_not_required(&pdev->dev);
+
 	return 0;
 }
 

base-commit: 4fe89d07dcc2804c8b562f6c7896a45643d34b2f
-- 
https://chromeos.dev

