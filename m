Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 803942CA5
	for <patches@lists.linux.dev>; Wed, 12 Apr 2023 22:58:45 +0000 (UTC)
Received: by mail-pj1-f54.google.com with SMTP id d22-20020a17090a111600b0023d1b009f52so16195803pja.2
        for <patches@lists.linux.dev>; Wed, 12 Apr 2023 15:58:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1681340325; x=1683932325;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=mOEVsGPEHY97AUL8m2SEMppSOPhbxPinO2kLSevOP+4=;
        b=I8Y0cZoug/ztnrR16OVWxghDXXGVvYS0DhJuN5foZz2YL0O6PI7upnHhcCm8pj9w/a
         4tzAWEQdh9b1evPw2t82S2rr9B271r2pmyThue1tcOH7UBzmNU/+pYGgFVdjukUC+uII
         fBh2fl6k6FTim+SJUmosy0L5U0GVjKMGqlz7M=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681340325; x=1683932325;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mOEVsGPEHY97AUL8m2SEMppSOPhbxPinO2kLSevOP+4=;
        b=EttscvAi8u1KNNcqYweUInoYO/1dM44SzeS65ZnaM9VxpFMedQy8Rm8X4fQ2tO9oRC
         xQV849YJ3PwJvXcGwxq1cR4xG/AxM6EtbQ0lshb9bRcNIuJ17X4MXfkWA/sMa/oWE9pV
         kTG60ZDJUFBcdiRoF+yWY7+agLHq+4DdX8llKyEIFfSqcTsCTyWUDHj11U7/yRjjiaV7
         RzhrdLGIyps77uml0Qadiz2Z6TtR91zfaHPuhMZXKefMjdxNnPFHrf3+XvvBWpzeaYFo
         /X693KviqpQc0AZV5hIeeFk4XQUD4RxMXZW1ijrPmOrMNwX4dGNTpb2S6LvWPP6mLZTd
         LDOQ==
X-Gm-Message-State: AAQBX9ct5kAH/hsX1WwLl/ND1w1aNwR47UP5R3hIc649qaKje5WG07jI
	WA+UmjWljhheOXIGC7zth8fpig==
X-Google-Smtp-Source: AKy350Z6PmHSjVoWVa3Z0ae0fS064iOMOK5se8aQGdQNW+UJftxl9pxfZeIswsw0zSJvCF2hb+I/IQ==
X-Received: by 2002:a17:90a:648e:b0:23f:7ff6:eba with SMTP id h14-20020a17090a648e00b0023f7ff60ebamr1048624pjj.0.1681340324766;
        Wed, 12 Apr 2023 15:58:44 -0700 (PDT)
Received: from smtp.gmail.com ([2620:15c:11a:201:b369:7768:6a4a:9e77])
        by smtp.gmail.com with ESMTPSA id r22-20020a6560d6000000b00513468106d8sm122944pgv.1.2023.04.12.15.58.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Apr 2023 15:58:44 -0700 (PDT)
From: Stephen Boyd <swboyd@chromium.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Brian Norris <briannorris@chromium.org>
Subject: [PATCH] driver core: Don't require dynamic_debug for initcall_debug probe timing
Date: Wed, 12 Apr 2023 15:58:42 -0700
Message-Id: <20230412225842.3196599-1-swboyd@chromium.org>
X-Mailer: git-send-email 2.40.0.577.gac1e443424-goog
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Don't require the use of dynamic debug (or modification of the kernel to
add a #define DEBUG to the top of this file) to get the printk message
about driver probe timing. This printk is only emitted when
initcall_debug is enabled on the kernel commandline, and it isn't
immediately obvious that you have to do something else to debug boot
timing issues related to driver probe. Add a comment too so it doesn't
get converted back to pr_debug().

Fixes: eb7fbc9fb118 ("driver core: Add missing '\n' in log messages")
Cc: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc: Brian Norris <briannorris@chromium.org>
Signed-off-by: Stephen Boyd <swboyd@chromium.org>
---
 drivers/base/dd.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/base/dd.c b/drivers/base/dd.c
index 8def2ba08a82..1b16e0fb7658 100644
--- a/drivers/base/dd.c
+++ b/drivers/base/dd.c
@@ -708,7 +708,12 @@ static int really_probe_debug(struct device *dev, struct device_driver *drv)
 	calltime = ktime_get();
 	ret = really_probe(dev, drv);
 	rettime = ktime_get();
-	pr_debug("probe of %s returned %d after %lld usecs\n",
+	/*
+	 * Don't change this to pr_debug() because that requires
+	 * CONFIG_DYNAMIC_DEBUG and we want a simple 'initcall_debug' on the
+	 * kernel commandline to print this all the time at the debug level.
+	 */
+	printk(KERN_DEBUG "probe of %s returned %d after %lld usecs\n",
 		 dev_name(dev), ret, ktime_us_delta(rettime, calltime));
 	return ret;
 }

base-commit: fe15c26ee26efa11741a7b632e9f23b01aca4cc6
-- 
https://chromeos.dev

