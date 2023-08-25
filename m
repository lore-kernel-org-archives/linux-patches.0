Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56C33198AA
	for <patches@lists.linux.dev>; Fri, 25 Aug 2023 23:31:21 +0000 (UTC)
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-68a1af910e0so1158141b3a.2
        for <patches@lists.linux.dev>; Fri, 25 Aug 2023 16:31:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1693006280; x=1693611080;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=T0DooFBD1A8V10MBqW1RginVqDYC6KQwP0qswiVYI6g=;
        b=WVNH5UzkHhUt8AlEXn0wpzIIigCdumsWXPrsEG9O1FoqdJ0I0WBT59w8oTPTTaw0Zx
         7C18046fBSkNWPvkDUSv2a4OoqV1nf/nL1PbLMzzJ3udjSxmHb5KdEpiiNWeMiqSVY4Z
         j+Mk6aYQcNWFp01T5LvipK/5CECUEUYyWumpY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693006280; x=1693611080;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=T0DooFBD1A8V10MBqW1RginVqDYC6KQwP0qswiVYI6g=;
        b=C8t8Iq6EW51OVzbUu9S18KpB0Djw8xb0dA4SKXkHSse1y9DWUxDbvOZ66XnpPvn9sF
         Tbb43VZLCz6SnpE77YD7OPJQjAcmL0OEg4EmR+OMlLpkW+8k5OjqIjptz0B27qGGTliL
         NLlHfuPmO5ot12wG5OA+U+MHsAU366Ywdczcpy/0ZFdyEtsKOdldBYyDuiu870VZLzgM
         pTf5deZz6givzMMQpCqW5z3FXRNZfdjdOv1B9ucCapp4bGYu71vTVnLFrctMqLG1HGfS
         /DlYpnpA1o+QeAXvrzzyRVQ3VtE5A9Iddxi0VYCb4iOOb+bUgfGVB7AEZTVvUXAtZPrt
         A5lA==
X-Gm-Message-State: AOJu0YyQaPLo4PYZjS0ztS5/LqfsWZf10QWv0cBQTpggtQan5b2ZNDRY
	AlLMKMbJnTJluJf5EO6o2GEKqw==
X-Google-Smtp-Source: AGHT+IFc6FIYdzvhev/WzyfpurbheqorRd31Zx1H4S9htxQ8xUE9T/owg0Q9qpe5SIifQWpPxwDP1g==
X-Received: by 2002:a05:6a00:10c3:b0:68c:1a0:46ac with SMTP id d3-20020a056a0010c300b0068c01a046acmr5243310pfu.15.1693006280672;
        Fri, 25 Aug 2023 16:31:20 -0700 (PDT)
Received: from smtp.gmail.com ([2620:15c:11a:201:d711:d7a0:fa61:8f24])
        by smtp.gmail.com with ESMTPSA id u11-20020aa7838b000000b0066a2e8431a0sm2092016pfm.183.2023.08.25.16.31.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Aug 2023 16:31:20 -0700 (PDT)
From: Stephen Boyd <swboyd@chromium.org>
To: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Maxime Ripard <mripard@kernel.org>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Daniel Vetter <daniel@ffwll.ch>,
	David Airlie <airlied@gmail.com>
Cc: linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	dri-devel@lists.freedesktop.org,
	Simon Ser <contact@emersion.fr>,
	Pekka Paalanen <pekka.paalanen@collabora.com>,
	Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [PATCH] drm/connector: Add newline to debug printk
Date: Fri, 25 Aug 2023 16:31:17 -0700
Message-ID: <20230825233118.2689222-1-swboyd@chromium.org>
X-Mailer: git-send-email 2.42.0.rc1.204.g551eb34607-goog
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This debug printk is missing a newline, causing drm debug logs to be
hard to read. Add a newline so that the message is on its own line.

Cc: Simon Ser <contact@emersion.fr>
Cc: Pekka Paalanen <pekka.paalanen@collabora.com>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Fixes: 8f86c82aba8b ("drm/connector: demote connector force-probes for non-master clients")
Signed-off-by: Stephen Boyd <swboyd@chromium.org>
---
 drivers/gpu/drm/drm_connector.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/drm_connector.c b/drivers/gpu/drm/drm_connector.c
index 3ed4cfcb350c..ab1467a15f9a 100644
--- a/drivers/gpu/drm/drm_connector.c
+++ b/drivers/gpu/drm/drm_connector.c
@@ -2923,7 +2923,7 @@ int drm_mode_getconnector(struct drm_device *dev, void *data,
 						     dev->mode_config.max_width,
 						     dev->mode_config.max_height);
 		else
-			drm_dbg_kms(dev, "User-space requested a forced probe on [CONNECTOR:%d:%s] but is not the DRM master, demoting to read-only probe",
+			drm_dbg_kms(dev, "User-space requested a forced probe on [CONNECTOR:%d:%s] but is not the DRM master, demoting to read-only probe\n",
 				    connector->base.id, connector->name);
 	}
 

base-commit: 706a741595047797872e669b3101429ab8d378ef
-- 
https://chromeos.dev

