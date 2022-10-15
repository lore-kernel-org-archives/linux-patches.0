Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53F07370
	for <patches@lists.linux.dev>; Sat, 15 Oct 2022 00:46:57 +0000 (UTC)
Received: by mail-pf1-f179.google.com with SMTP id d10so6343481pfh.6
        for <patches@lists.linux.dev>; Fri, 14 Oct 2022 17:46:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=R97F6tafPKuH3Wb7fiZxQjJXQ8j8fICZkLtVUZ7PMKs=;
        b=QLOUkKXyXKxnryU68yEhMzW1PSO+tRC1EVQ8JePXkfSzUNUQJ0RadH5pPzjAzQTFIT
         X+zIARW2wZiFSM0322qGBZ8JMTApMuHr87RSSBerUKjjkwMjN6cySAwNasjkY+rfRB6g
         FH8xHUljGnHr+qyB3oOQFLvZTK5dme12KdxQQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=R97F6tafPKuH3Wb7fiZxQjJXQ8j8fICZkLtVUZ7PMKs=;
        b=Qesd/OMVAvcB9IKlHzh1tUg1a++I+wVIEgSiYFBlYCxNk679Ky0WoIHM4uAlHZDvws
         LNa5HLOJWh0Z6PXqlS3yG+x1RtQ9Zgko1/fyC7fm8ZOV09Bxpe2W73WtCMN3dzvXFbgA
         27WpcJM/627AthqYbQ7NwKVqzIHDWGrgnonbOSL/ascOKxB1I7RLJio3Jgh1DC5rg60p
         JMYnmFsbI0hklwNU5IeNAC3i7jsnvSq+hw61+A2SkYdjJCbZGBgjLCl6m2zGBcFQPak0
         YDySvtqL2cHvh2Q2JZtPFVUxsCvS8HJ9y+vENRoEr7gYrsk09OYV1TdAZDROC3BbI6i+
         0Llw==
X-Gm-Message-State: ACrzQf0KROvEGyKnLzds/MK9OM+gRgElFcDd5udrAsGgsfEknHz7LPUA
	ezKpxfN4aJx2p/QlSD9ftoEnFQ==
X-Google-Smtp-Source: AMsMyM5BFZx0QDc7pR9+g4YFHVAhun5z2HILPgjazDPHaBjdjuDPXO1Gf0dWyqcBdWzhp7aXYiemcg==
X-Received: by 2002:a63:1145:0:b0:46a:e00c:579c with SMTP id 5-20020a631145000000b0046ae00c579cmr479334pgr.279.1665794816651;
        Fri, 14 Oct 2022 17:46:56 -0700 (PDT)
Received: from smtp.gmail.com ([2620:15c:9d:2:9f6e:fc87:d13f:1fa6])
        by smtp.gmail.com with ESMTPSA id b4-20020a170902bd4400b0016d72804664sm2230802plx.205.2022.10.14.17.46.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Oct 2022 17:46:55 -0700 (PDT)
From: Stephen Boyd <swboyd@chromium.org>
To: Andy Gross <agross@kernel.org>,
	Bjorn Andersson <bjorn.andersson@linaro.org>
Cc: linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	linux-arm-msm@vger.kernel.org,
	Konrad Dybcio <konrad.dybcio@somainline.org>
Subject: [PATCH 1/2] soc: qcom: cmd-db: Mark device as having no PM support
Date: Fri, 14 Oct 2022 17:46:53 -0700
Message-Id: <20221015004654.3930122-1-swboyd@chromium.org>
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

