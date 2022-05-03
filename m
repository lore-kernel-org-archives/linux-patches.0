Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B1637F
	for <patches@lists.linux.dev>; Tue,  3 May 2022 00:42:00 +0000 (UTC)
Received: by mail-pl1-f169.google.com with SMTP id d15so13777535plh.2
        for <patches@lists.linux.dev>; Mon, 02 May 2022 17:42:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=nv/pSU+ZnWDELhz2wWC2INCxu/xtfe1TYKUv0ZzQucw=;
        b=SkVXXA94ffty5Mj2aWgSITnefdw4+ZrE8qSiePjbp7oHo9p4AVtJpl/Gk/HSyBfLe3
         3U6/cE8XNuzDetJ7BhMOVn7t4JgeZQOaEREfYgRLl8L2X8QuSwLDpCSqVLiv+fEWpIoq
         CrbYGst4DY2aRwIJIPspUfF6mvcmaba+HBuqQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=nv/pSU+ZnWDELhz2wWC2INCxu/xtfe1TYKUv0ZzQucw=;
        b=OSuCzuFhC/0XcokoMunfUPxJJRdQ+3/KUW3GjoRVoOyGx5S6LBKVeHhCyM4Wo35Y9a
         rPvm++fAHyrUN6aP9cOvsY1K6O8W8eHJ6UMLTRQYJvpy+uVrJ6iAl6xoidtsrl2w7esc
         jDkZioYWg6dWgCpRVxVIHChu9R/aQpzKm+53Db+5mrXKuvOJWcXbavBfWUNNLGVWCSrL
         ar2jplUinP4ClmNNBq5WHR/yjV8sXfxpCx9f0hKYfSXEge5IetjUpkAtA7jr0oU6sKfH
         StXc5I4Ypnbi8pYUZVoNk6SumM3DAMRJbgyt+ut65feBHAwzvpmJH2CNymWEHctNuZdU
         C4GA==
X-Gm-Message-State: AOAM532uW8WFa+qIJLRLYdTERZycAeVrSaXVmNe/td+Qww7CFNg2gNcG
	4NILtjCWNde3/WaCXPtfU5sbHA==
X-Google-Smtp-Source: ABdhPJz/hTWbt/I+UklgPRM/+6nN30JLRNTr2NxDCJCIBWJO3cx3gUrIinxBCPZLQnJkMWkFxuaaFQ==
X-Received: by 2002:a17:90a:ab81:b0:1ca:8a76:cdda with SMTP id n1-20020a17090aab8100b001ca8a76cddamr2016709pjq.26.1651538520161;
        Mon, 02 May 2022 17:42:00 -0700 (PDT)
Received: from smtp.gmail.com ([2620:15c:202:201:15e:c760:9a04:7fbe])
        by smtp.gmail.com with ESMTPSA id i10-20020aa78b4a000000b0050dc7628177sm5258794pfd.81.2022.05.02.17.41.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 May 2022 17:41:59 -0700 (PDT)
From: Stephen Boyd <swboyd@chromium.org>
To: Jonathan Cameron <jic23@kernel.org>
Cc: linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	devicetree@vger.kernel.org,
	linux-iio@vger.kernel.org,
	Gwendal Grignou <gwendal@chromium.org>,
	Rob Herring <robh+dt@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>
Subject: [PATCH 2/2] iio: sx9324: Add setting for CS idle mode
Date: Mon,  2 May 2022 17:41:56 -0700
Message-Id: <20220503004156.3559940-3-swboyd@chromium.org>
X-Mailer: git-send-email 2.36.0.464.gb9c8b46e94-goog
In-Reply-To: <20220503004156.3559940-1-swboyd@chromium.org>
References: <20220503004156.3559940-1-swboyd@chromium.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Based on device tree setting, set the CS idle mode.

Cc: Gwendal Grignou <gwendal@chromium.org>
Signed-off-by: Stephen Boyd <swboyd@chromium.org>
---
 drivers/iio/proximity/sx9324.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/drivers/iio/proximity/sx9324.c b/drivers/iio/proximity/sx9324.c
index 7f367f63e362..79683f0d4e9a 100644
--- a/drivers/iio/proximity/sx9324.c
+++ b/drivers/iio/proximity/sx9324.c
@@ -57,6 +57,11 @@
 	GENMASK(SX9324_REG_AFE_CTRL0_RINT_SHIFT + 1, \
 		SX9324_REG_AFE_CTRL0_RINT_SHIFT)
 #define SX9324_REG_AFE_CTRL0_RINT_LOWEST	0x00
+#define SX9324_REG_AFE_CTRL0_CSIDLE_SHIFT	4
+#define SX9324_REG_AFE_CTRL0_CSIDLE_MASK \
+	GENMASK(SX9324_REG_AFE_CTRL0_CSIDLE_SHIFT + 1, \
+		SX9324_REG_AFE_CTRL0_CSIDLE_SHIFT)
+#define SX9324_REG_AFE_CTRL0_RINT_LOWEST	0x00
 #define SX9324_REG_AFE_CTRL1		0x21
 #define SX9324_REG_AFE_CTRL2		0x22
 #define SX9324_REG_AFE_CTRL3		0x23
@@ -872,6 +877,8 @@ sx9324_get_default_reg(struct device *dev, int idx,
 {
 	static const char * const sx9324_rints[] = { "lowest", "low", "high",
 		"highest" };
+	static const char * const sx9324_csidle[] = { "hz", "hz", "gnd",
+		"vdd" };
 #define SX9324_PIN_DEF "semtech,ph0-pin"
 #define SX9324_RESOLUTION_DEF "semtech,ph01-resolution"
 #define SX9324_PROXRAW_DEF "semtech,ph01-proxraw-strength"
@@ -901,6 +908,15 @@ sx9324_get_default_reg(struct device *dev, int idx,
 		reg_def->def = raw;
 		break;
 	case SX9324_REG_AFE_CTRL0:
+		ret = device_property_read_string(dev,
+				"semtech,cs-idle-sleep", &res);
+		if (!ret)
+			ret = match_string(sx9324_csidle, ARRAY_SIZE(sx9324_csidle), res);
+		if (ret >= 0) {
+			reg_def->def &= ~SX9324_REG_AFE_CTRL0_CSIDLE_MASK;
+			reg_def->def |= ret << SX9324_REG_AFE_CTRL0_CSIDLE_SHIFT;
+		}
+
 		ret = device_property_read_string(dev,
 				"semtech,int-comp-resistor", &res);
 		if (ret)
-- 
https://chromeos.dev

