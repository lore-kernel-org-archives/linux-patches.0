Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABB9A63D
	for <patches@lists.linux.dev>; Tue,  3 Oct 2023 00:34:36 +0000 (UTC)
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-690bfd4f3ebso258213b3a.3
        for <patches@lists.linux.dev>; Mon, 02 Oct 2023 17:34:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1696293276; x=1696898076; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ULFaUXbFksMdiOTX7EFeIrZO1zGruO/Y5COdeG+mbmw=;
        b=iJkzy+LP3i1Sb3pLtR73Hh6SLDc0xeQP5YxcZrz9wpctyZR7t6f319wwh8sQgIgX52
         YO+kLnwofSuEB81Tga8Jrnxv5yvX8U7UCIeiah7ViYh0j/t+b0q3/PzYvnQy3Lx17Xiy
         pNhsY6AR1yIMwT1IOHLNtF742EYKXP6o5QDp8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696293276; x=1696898076;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ULFaUXbFksMdiOTX7EFeIrZO1zGruO/Y5COdeG+mbmw=;
        b=FtuLR74B+upyQRLaFYKGzcpZ1kif5ZzozkAPmjSykJdAsHQO6uYKp5lnbDBJLoyVWl
         mw3KohNPgSiYUDJBFjFRZBCggrf5Me0B69RYSEwfwJVhLBhDSn5XqBGqndFQOP3P5bCE
         B+3e0rKbmXx1EWMIBNeA0mi0FeSrPG1wJB8nKGIHQ21MGAu9AFCwadUc9bfmCnmC6yQi
         Flk8ddg4ZWbq0k04tStAIZyVALW7U6Wh8cl/nPmQPXkNRUNv4mfSi0atXbsStYvSXf2C
         LK4Vj9OLL18P2UfeKxGiK7qo2LqoeDJhyBwpUjp+Q4FjMLNKwPeOBNK/HG98aqYdISzs
         YSVw==
X-Gm-Message-State: AOJu0YzO4ME2o/9uuaIuQbUvs41KVLqjO6/FafUH5WHu3mJlu21gHrFW
	sGSXbhOBD9DjsCvaHso6k4Ct8Q==
X-Google-Smtp-Source: AGHT+IFEG97ZEYV1LjW9w3tPX6P9RnwrvT9boD1/FLSuHTy5NIliBpsfZfToads/4dmEdvczCCLX0Q==
X-Received: by 2002:a05:6a00:1787:b0:68e:2478:d6c9 with SMTP id s7-20020a056a00178700b0068e2478d6c9mr13123617pfg.2.1696293275992;
        Mon, 02 Oct 2023 17:34:35 -0700 (PDT)
Received: from smtp.gmail.com ([2620:15c:11a:201:f676:8db:8677:aefe])
        by smtp.gmail.com with ESMTPSA id bm2-20020a056a00320200b0068a13b0b300sm101368pfb.11.2023.10.02.17.34.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Oct 2023 17:34:35 -0700 (PDT)
From: Stephen Boyd <swboyd@chromium.org>
To: Benson Leung <bleung@chromium.org>,
	Tzung-Bi Shih <tzungbi@kernel.org>
Cc: linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	chrome-platform@lists.linux.dev,
	Prashant Malani <pmalani@chromium.org>
Subject: [PATCH 4/4] platform/chrome: cros_ec_proto: Mark outdata as const
Date: Mon,  2 Oct 2023 17:34:28 -0700
Message-ID: <20231003003429.1378109-5-swboyd@chromium.org>
X-Mailer: git-send-email 2.42.0.582.g8ccd20d70d-goog
In-Reply-To: <20231003003429.1378109-1-swboyd@chromium.org>
References: <20231003003429.1378109-1-swboyd@chromium.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The 'outdata' is copied to the data buffer in cros_ec_cmd() before being
sent over to the EC. Mark the argument as const so that callers can pass
const pointers to this function and so that callers know the data won't
be modified.

Cc: Prashant Malani <pmalani@chromium.org>
Signed-off-by: Stephen Boyd <swboyd@chromium.org>
---
 drivers/platform/chrome/cros_ec_proto.c     | 2 +-
 include/linux/platform_data/cros_ec_proto.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/platform/chrome/cros_ec_proto.c b/drivers/platform/chrome/cros_ec_proto.c
index 475a6dd72db6..945b1b15a04c 100644
--- a/drivers/platform/chrome/cros_ec_proto.c
+++ b/drivers/platform/chrome/cros_ec_proto.c
@@ -1004,7 +1004,7 @@ EXPORT_SYMBOL_GPL(cros_ec_get_sensor_count);
 int cros_ec_cmd(struct cros_ec_device *ec_dev,
 		unsigned int version,
 		int command,
-		void *outdata,
+		const void *outdata,
 		size_t outsize,
 		void *indata,
 		size_t insize)
diff --git a/include/linux/platform_data/cros_ec_proto.h b/include/linux/platform_data/cros_ec_proto.h
index 4f9f756bc17c..8865e350c12a 100644
--- a/include/linux/platform_data/cros_ec_proto.h
+++ b/include/linux/platform_data/cros_ec_proto.h
@@ -258,7 +258,7 @@ bool cros_ec_check_features(struct cros_ec_dev *ec, int feature);
 
 int cros_ec_get_sensor_count(struct cros_ec_dev *ec);
 
-int cros_ec_cmd(struct cros_ec_device *ec_dev, unsigned int version, int command, void *outdata,
+int cros_ec_cmd(struct cros_ec_device *ec_dev, unsigned int version, int command, const void *outdata,
 		    size_t outsize, void *indata, size_t insize);
 
 /**
-- 
https://chromeos.dev

