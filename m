Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86F85256D
	for <patches@lists.linux.dev>; Fri,  5 Apr 2024 00:01:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712275277; cv=none; b=ZN4xVOL9bl2rVGvngWLEPeJkzPlZPTrfQf0TB+xA+p5SFmSgpVNMJWBaIIqdmrvw7IBmBJlelmBrCQiHGTWqZCHysK6LSqNuXrl2v3knUVGjAn0+xP9JRAby2v9rU2s0xE9kkYg/XTw5Bf/EUcQQOgM2uWCbNIN6u/lHrfVkmQ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712275277; c=relaxed/simple;
	bh=2hEg4h0cVL/sUuyeZmcQ7gN4Akq8EJcgFWl7SsXVeeM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=DEHDtIgQOa71kjalSh+G9WCZjy447EMtBFr+1FFU9nRWPKD0rUj9bgRaxLlPxU9aAfWng92xwwwgYk9FppaYoLnNafbFr1EUgPq8D+6bM2nb0vL9v8kZ1jyPmFR9sxU8uC0WcqOKfFYLYjoebkjniee1nRWxSQGlpFAilzp9bJM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=cKgexu1Q; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="cKgexu1Q"
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-1e0878b76f3so13892935ad.0
        for <patches@lists.linux.dev>; Thu, 04 Apr 2024 17:01:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1712275275; x=1712880075; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=BubB/ZTZXGyOlYIo5JvJ2GYL9k/6VJ0RRIgGr3QHUG4=;
        b=cKgexu1QloeW6F5aq1Trl8hnenLYXkZX5qSPlBOcf+bVn/SLjfw2ccMlZMytfTWFkH
         4fh9plckDotmpxmdZl9ahv2mbEIVFl+GLVPkkkMJ2suQKRf1eE9UgblH7aRwmtMfhCbO
         68AgxAOcZefTFNN77JE64oqv10FWr8xfxT6+o=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712275275; x=1712880075;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=BubB/ZTZXGyOlYIo5JvJ2GYL9k/6VJ0RRIgGr3QHUG4=;
        b=Eu4YhwahW+0ZhU6y5vv2LSGHeB4jThlwZhFMa4hfomV4l4fB5v938LftEiZowDRQMK
         9Ikiw8Ynw/D8Yu0rdchaF/tnF0QxUE5l71UShMvaetVBKEUOd7KhBZhX9hcOW059eqx6
         fFen6pgTWfEWZd72yV9doe9U5MoIbGWfgt/JOntzyeDOCWTYoWynbg+86DE5b/z606uU
         JO+XWuAZBUcK8vGE1p8xLgNkX5Ilhlp3lf/odBLAR+iPJLox8p9pg/G90TrO3CD2evpB
         pTT4/S8GAuKfcanmu3EYnBGhc3/Wya0EfEcao6BKHgAEBrymyBhKZAPYP7/rqCmHlQoS
         sHPA==
X-Forwarded-Encrypted: i=1; AJvYcCWHguMmhwol2CTc7CsBke3UdEynKfsXu3liIYBZ7q8lXZPJhzEeIJnB8HW8We3L+TXgZuA8xvaCDh7sHzsw+DOB/f8BdQkkKw==
X-Gm-Message-State: AOJu0YwKOq59a5eKHhUz0ws7xsZP/T3fOXj+UADkSN8WB5nItX6Y2sy3
	OrmrlhyAWSgdK6jVGNvkytJO30tsD5oaxnhyknq8RzPHYSNMcKNwx8iC+gUqkpxc99DWbYS/jNw
	=
X-Google-Smtp-Source: AGHT+IHHeoBPsIh9g3n+aMvqQ0ly90tm+3kUGSMVbGHLtLA2CIsxae6F593S7l6qGq8fl7xOPFRfEw==
X-Received: by 2002:a17:902:e747:b0:1e0:30ca:62c with SMTP id p7-20020a170902e74700b001e030ca062cmr1469256plf.1.1712275274803;
        Thu, 04 Apr 2024 17:01:14 -0700 (PDT)
Received: from localhost (4.198.125.34.bc.googleusercontent.com. [34.125.198.4])
        by smtp.gmail.com with UTF8SMTPSA id f7-20020a170902ce8700b001e26e1e62f9sm213048plg.176.2024.04.04.17.01.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Apr 2024 17:01:13 -0700 (PDT)
From: Stephen Boyd <swboyd@chromium.org>
To: Vinod Koul <vkoul@kernel.org>,
	Kishon Vijay Abraham I <kishon@kernel.org>
Cc: linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	linux-arm-msm@vger.kernel.org,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	linux-phy@lists.infradead.org,
	freedreno@lists.freedesktop.org,
	Douglas Anderson <dianders@chromium.org>,
	Abhinav Kumar <quic_abhinavk@quicinc.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Abel Vesa <abel.vesa@linaro.org>,
	Steev Klimaszewski <steev@kali.org>,
	Johan Hovold <johan+linaro@kernel.org>,
	Bjorn Andersson <quic_bjorande@quicinc.com>
Subject: [PATCH] phy: qcom: qmp-combo: Fix register base for QSERDES_DP_PHY_MODE
Date: Thu,  4 Apr 2024 17:01:03 -0700
Message-ID: <20240405000111.1450598-1-swboyd@chromium.org>
X-Mailer: git-send-email 2.44.0.478.gd926399ef9-goog
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The register base that was used to write to the QSERDES_DP_PHY_MODE
register was 'dp_dp_phy' before commit 815891eee668 ("phy:
qcom-qmp-combo: Introduce orientation variable"). There isn't any
explanation in the commit why this is changed, so I suspect it was an
oversight or happened while being extracted from some other series.
Oddly the value being 0x4c or 0x5c doesn't seem to matter for me, so I
suspect this is dead code, but that can be fixed in another patch. It's
not good to write to the wrong register space, and maybe some other
version of this phy relies on this.

Cc: Douglas Anderson <dianders@chromium.org>
Cc: Abhinav Kumar <quic_abhinavk@quicinc.com>
Cc: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Cc: Neil Armstrong <neil.armstrong@linaro.org>
Cc: Abel Vesa <abel.vesa@linaro.org>
Cc: Steev Klimaszewski <steev@kali.org>
Cc: Johan Hovold <johan+linaro@kernel.org>
Cc: Bjorn Andersson <quic_bjorande@quicinc.com>
Fixes: 815891eee668 ("phy: qcom-qmp-combo: Introduce orientation variable")
Signed-off-by: Stephen Boyd <swboyd@chromium.org>
---
 drivers/phy/qualcomm/phy-qcom-qmp-combo.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/phy/qualcomm/phy-qcom-qmp-combo.c b/drivers/phy/qualcomm/phy-qcom-qmp-combo.c
index 7d585a4bbbba..746d009d702b 100644
--- a/drivers/phy/qualcomm/phy-qcom-qmp-combo.c
+++ b/drivers/phy/qualcomm/phy-qcom-qmp-combo.c
@@ -2150,9 +2150,9 @@ static bool qmp_combo_configure_dp_mode(struct qmp_combo *qmp)
 	writel(val, qmp->dp_dp_phy + QSERDES_DP_PHY_PD_CTL);
 
 	if (reverse)
-		writel(0x4c, qmp->pcs + QSERDES_DP_PHY_MODE);
+		writel(0x4c, qmp->dp_dp_phy + QSERDES_DP_PHY_MODE);
 	else
-		writel(0x5c, qmp->pcs + QSERDES_DP_PHY_MODE);
+		writel(0x5c, qmp->dp_dp_phy + QSERDES_DP_PHY_MODE);
 
 	return reverse;
 }

base-commit: 4cece764965020c22cff7665b18a012006359095
-- 
https://chromeos.dev

