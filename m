Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDF7418E
	for <patches@lists.linux.dev>; Fri, 15 Apr 2022 00:32:56 +0000 (UTC)
Received: by mail-pj1-f47.google.com with SMTP id o5-20020a17090ad20500b001ca8a1dc47aso10665765pju.1
        for <patches@lists.linux.dev>; Thu, 14 Apr 2022 17:32:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=C5t3e+cZTj4xwdAITByfx8113SkQvPNyKKAsLc7zHFM=;
        b=Sre7yJqjWog5IzWlAJouxhJIxDudi3P7KD3fupciGkuyrvofNEAvI6ORbO60O9ZAZl
         Ijh9lYeRczXJ1Vvrwlg9LZ0q5AjBBmPg0zqi98nw8R+2XJEJE/dy5VprhT6XO7G34/6y
         /5tfZ9uQuwRXXUQRMhjzq7HEs4yCBtKp7QfMU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=C5t3e+cZTj4xwdAITByfx8113SkQvPNyKKAsLc7zHFM=;
        b=a/s2zBa9ae7F7tn6o8eJ94nLjE8TfKVVjdbXAPZs3mHc82qOjjodod7yEVOovI9JcZ
         bY2WtUL805vBJPDxhyJj6b48RRlTfSIvz5UaZ3LRaKy0le1eh+oah+UbjSi/aKgmqv5u
         peST9sGYSu4+wiBluSYwxXHFrJWhyXtfBe7PyEYKspkuJdBe2JpOda96Bk/2iG/RxX8n
         i3ub33PiJe4jAScLmWoZ1prYyrhjwLXVgUGVeu/ibMjxlmLt7EqvoF8Sd6rkZPaxwSUe
         nuEASZuIBJQevnOI+o3B6hgRGjU2Hg4R7II2yMJWmc85XQjvwQO9OqvDAg/LTEgo1qOk
         y2WQ==
X-Gm-Message-State: AOAM530wVInsL+3G7j2bmTzfkGCY7CzsOGEvYfaE5kJx19zyA0bPmrOK
	VMsiXCKkLQ9mH3d/mc7VPFTs8g==
X-Google-Smtp-Source: ABdhPJyX/cNKS4BBDlZhUfNXn3R48lgEEQXevRhtV5J7S7Guj8PpbEYGPvwnRdf6ljVjJ3e+Vg2vtA==
X-Received: by 2002:a17:902:bd06:b0:158:8973:b16b with SMTP id p6-20020a170902bd0600b001588973b16bmr15242969pls.129.1649982776334;
        Thu, 14 Apr 2022 17:32:56 -0700 (PDT)
Received: from smtp.gmail.com ([2620:15c:202:201:e3e0:734:f81a:d2c1])
        by smtp.gmail.com with ESMTPSA id p12-20020a63ab0c000000b00381f7577a5csm2830187pgf.17.2022.04.14.17.32.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Apr 2022 17:32:56 -0700 (PDT)
From: Stephen Boyd <swboyd@chromium.org>
To: Benson Leung <bleung@chromium.org>
Cc: linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Lee Jones <lee.jones@linaro.org>,
	Daisuke Nojiri <dnojiri@chromium.org>,
	Guenter Roeck <groeck@chromium.org>,
	chrome-platform@lists.linux.dev
Subject: [PATCH 1/3] platform/chrome: cros_ec_proto: Add peripheral charger count API
Date: Thu, 14 Apr 2022 17:32:51 -0700
Message-Id: <20220415003253.1973106-2-swboyd@chromium.org>
X-Mailer: git-send-email 2.36.0.rc0.470.gd361397f0d-goog
In-Reply-To: <20220415003253.1973106-1-swboyd@chromium.org>
References: <20220415003253.1973106-1-swboyd@chromium.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add a peripheral charger count API similar to the one implemented in the
ChromeOS PCHG driver so we can use it to decide whether or not to
register the PCHG device in the cros_ec MFD driver.

Cc: Lee Jones <lee.jones@linaro.org>
Cc: Daisuke Nojiri <dnojiri@chromium.org>
Cc: Benson Leung <bleung@chromium.org>
Cc: Guenter Roeck <groeck@chromium.org>
Cc: <chrome-platform@lists.linux.dev>
Signed-off-by: Stephen Boyd <swboyd@chromium.org>
---
 drivers/platform/chrome/cros_ec_proto.c     | 31 +++++++++++++++++++++
 include/linux/platform_data/cros_ec_proto.h |  1 +
 2 files changed, 32 insertions(+)

diff --git a/drivers/platform/chrome/cros_ec_proto.c b/drivers/platform/chrome/cros_ec_proto.c
index c4caf2e2de82..42269703ca6c 100644
--- a/drivers/platform/chrome/cros_ec_proto.c
+++ b/drivers/platform/chrome/cros_ec_proto.c
@@ -832,6 +832,37 @@ bool cros_ec_check_features(struct cros_ec_dev *ec, int feature)
 }
 EXPORT_SYMBOL_GPL(cros_ec_check_features);
 
+/**
+ * cros_ec_pchg_port_count() - Return the number of peripheral charger ports.
+ * @ec: EC device.
+ *
+ * Return: Number of peripheral charger ports, or 0 in case of error.
+ */
+unsigned int cros_ec_pchg_port_count(struct cros_ec_dev *ec)
+{
+	struct cros_ec_command *msg;
+	const struct ec_response_pchg_count *rsp;
+	struct cros_ec_device *ec_dev = ec->ec_dev;
+	int ret, count = 0;
+
+	msg = kzalloc(sizeof(*msg) + sizeof(*rsp), GFP_KERNEL);
+	if (!msg)
+		return 0;
+
+	msg->command = EC_CMD_PCHG_COUNT + ec->cmd_offset;
+	msg->insize = sizeof(*rsp);
+
+	ret = cros_ec_cmd_xfer_status(ec_dev, msg);
+	if (ret >= 0) {
+		rsp = (const struct ec_response_pchg_count *)msg->data;
+		count = rsp->port_count;
+	}
+	kfree(msg);
+
+	return count;
+}
+EXPORT_SYMBOL_GPL(cros_ec_pchg_port_count);
+
 /**
  * cros_ec_get_sensor_count() - Return the number of MEMS sensors supported.
  *
diff --git a/include/linux/platform_data/cros_ec_proto.h b/include/linux/platform_data/cros_ec_proto.h
index df3c78c92ca2..8f5781bc2d7a 100644
--- a/include/linux/platform_data/cros_ec_proto.h
+++ b/include/linux/platform_data/cros_ec_proto.h
@@ -230,6 +230,7 @@ u32 cros_ec_get_host_event(struct cros_ec_device *ec_dev);
 bool cros_ec_check_features(struct cros_ec_dev *ec, int feature);
 
 int cros_ec_get_sensor_count(struct cros_ec_dev *ec);
+unsigned int cros_ec_pchg_port_count(struct cros_ec_dev *ec);
 
 int cros_ec_command(struct cros_ec_device *ec_dev, unsigned int version, int command, void *outdata,
 		    int outsize, void *indata, int insize);
-- 
https://chromeos.dev

