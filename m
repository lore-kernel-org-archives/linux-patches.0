Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7014018E373
	for <patches@lists.linux.dev>; Mon, 21 Oct 2024 11:10:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729509048; cv=none; b=Do6MsY7BoUFkcPDQHMaJ1ew/bIcv8ZemixLeQvwG31MF7ZS5ooFYTcCJgtUVMXcYmnIyGOagPymhlVWMYBZq83Ogi5wxc6bpDQHTHKareSwofAQkyU1PDxtLr25UyuBNgRzO0bXxb1BAbmsFltY2KOxnN8+01I8vTjuNl7MQK9U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729509048; c=relaxed/simple;
	bh=lFIu1wxPmYSFSEnv+yTyyGJgC+WEdcbyJsmcqLbMDZg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=CKl3UKCdiMCkKw8OJUrfHE5+wgvJHzWU3Z9zhhfQueEu2YLHcskjPnVix6bqxCuaYbpM0PHgG+8EISrrXlAddZGlNdQ2mjQPhQXQ3g5Dkeme944OXvQR/lXpW5ANo7b1DhuWafw0cbmxfB5w9fZYhLoKqRP7Xdc7gWDrVR1A01Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=baylibre.com; spf=pass smtp.mailfrom=alien8.de; dkim=fail (2048-bit key) header.d=baylibre-com.20230601.gappssmtp.com header.i=@baylibre-com.20230601.gappssmtp.com header.b=nsUyMBYi reason="signature verification failed"; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=baylibre.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=baylibre-com.20230601.gappssmtp.com header.i=@baylibre-com.20230601.gappssmtp.com header.b="nsUyMBYi"
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 6A95140E0198
	for <patches@lists.linux.dev>; Mon, 21 Oct 2024 11:10:44 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id i1MjMUXLzySC for <patches@lists.linux.dev>;
	Mon, 21 Oct 2024 11:10:34 +0000 (UTC)
Received: from zn.tnic (p5de8e8eb.dip0.t-ipconnect.de [93.232.232.235])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 12CC540E0194
	for <patches@lists.linux.dev>; Mon, 21 Oct 2024 11:10:33 +0000 (UTC)
Resent-From: Borislav Petkov <bp@alien8.de>
Resent-Date: Mon, 21 Oct 2024 13:10:25 +0200
Resent-Message-ID: <20241021111025.GCZxY2oQ1QYYQwS17N@fat_crate.local>
Resent-To: patches <patches@lists.linux.dev>
Received: from mail.alien8.de
	by mad with LMTP
	id eMuQCJovFmc6OTkAc81XFw
	(envelope-from <ukleinek@baylibre.com>)
	for <bp@alien8.de>; Mon, 21 Oct 2024 10:40:26 +0000
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 09D2E40E0219
	for <bp@alien8.de>; Mon, 21 Oct 2024 10:40:26 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id IEv1gNAvZqyF for <bp@alien8.de>;
	Mon, 21 Oct 2024 10:40:15 +0000 (UTC)
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPS id 94E6C40E0169
	for <bp@alien8.de>; Mon, 21 Oct 2024 10:40:07 +0000 (UTC)
Received: by mail-wm1-x32c.google.com with SMTP id 5b1f17b1804b1-4315f24a6bbso34661105e9.1
        for <bp@alien8.de>; Mon, 21 Oct 2024 03:40:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20230601.gappssmtp.com; s=20230601; t=1729507206; x=1730112006; darn=alien8.de;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=8a27U+8qWI9YDCpmefCKmabD4nR9aB9qGDyTrA2CljM=;
        b=nsUyMBYi1cQSJ8pI7EjY1G3eEXjEaKIPO2w7qQVXUTBkjIOCX6J4Bt7mv6NvZcjAYV
         QOksFFDsNXhoEsxpL7JTL+TwiHhDejEsWJ+h4IuGLO0+G4TRZMx1xjDUKCj5bkp7/mbK
         MiwN1dtmHYzGXKTmcIhQ4jwTgUpJuLX9Q2nn8PMfw1mlTRxd0Dqv2dTxZ2RSghfTcDvv
         KDSiQI/Fw4YNW1E9ZnIV6VqeT7GhRtcOHLb8xgPosGynfNoQ/dJGbtIK0qG9lfRDI9sv
         uKYveFEEugzHN9UEeMzM1FvBRGZcvkwlP4QGJzkFmd6JMc8N9bsVaLaMWz6mXpFMIEGk
         06rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729507206; x=1730112006;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8a27U+8qWI9YDCpmefCKmabD4nR9aB9qGDyTrA2CljM=;
        b=Ce8e+z4Vr1TCJQ1JcgFbagmSurZSwjymcsS09JTbMB7gBPwDw20G3HgbTZTS4y9DSl
         kMh2sbIekPbdGF/r8ieKpkRdVZ3zk49wBWKt1cryztvBKcjzvtHyxbzP8boRyd5YJx7O
         vYPXf3yEQmjzZNZjBdFBVKGzFJRExweT+9y/lZ39jAGXPykPfSmwEiDSZjv7xSX5ELjg
         8MKafHfYFeD5vfxIpLYXfiWYvJAzWpnK1XcEcDGYzdv+7Pnm+weSvUqE41AbS4nxksJz
         2ZhYY+8EL6o7EBhmcjKl3yv4K5XJIghrfX8rAKoi/IPqzqXxv3wJj1oGBrKf+G2hRfHN
         MW0Q==
X-Forwarded-Encrypted: i=1; AJvYcCXZRWk3fxky86oOsbcxwZpNMHOnlHpIM5reSNTbSh802CknN3zMzjZUureMG6V9wWCn4g==@alien8.de
X-Gm-Message-State: AOJu0YxxdO5AF1p9jc6XZeLaWBitjUjUNyaMQBYzOl9l6XLaYCi++HDL
	XQSByyMKZH8kA6eRQ092zho6G1tYydMamnRgc/y7KvtZ6c/K4oAPV1FeXJ1gNwk=
X-Google-Smtp-Source: AGHT+IEdVpOI1mXhFW6p1zqyQ9XY8m+GmA8oz0SYK0bVAdi2uJ1oqmRjlg+k1Bd6NbuKmPV/TJxoCQ==
X-Received: by 2002:a5d:54c3:0:b0:37d:3f42:9b59 with SMTP id ffacd0b85a97d-37eab4d13c2mr7027756f8f.11.1729507206287;
        Mon, 21 Oct 2024 03:40:06 -0700 (PDT)
Received: from localhost (p50915d2d.dip0.t-ipconnect.de. [80.145.93.45])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-37ee0a37bc0sm4000881f8f.13.2024.10.21.03.40.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Oct 2024 03:40:05 -0700 (PDT)
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@baylibre.com>
To: Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH] x86: Switch back to struct platform_driver::remove()
Date: Mon, 21 Oct 2024 12:39:53 +0200
Message-ID: <20241021103954.403577-2-u.kleine-koenig@baylibre.com>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Developer-Signature: v=1; a=openpgp-sha256; l=2859; i=u.kleine-koenig@baylibre.com; h=from:subject; bh=jOlR/hVHDvWGBucgAPkIoegp/nADwWI8a/dlI7ik8LM=; b=owEBbQGS/pANAwAKAY+A+1h9Ev5OAcsmYgBnFi96NK4wVk6pdkN845ED6+7pQq0AoDTluPqe/ qkb6UJ+ovuJATMEAAEKAB0WIQQ/gaxpOnoeWYmt/tOPgPtYfRL+TgUCZxYvegAKCRCPgPtYfRL+ TuVOB/9lLM7PtouFnPVI2psYtlukRnLqu2CW7LI6C3t3ajeai3QCbdxlaOKQwX6iHSI+ux49pno HqYHgWsG7lGDOEDCfB1dA55rZ5ElKNl63FmWyQq3EB1kv+rwv1b5a77Qp9nx02Y2ERuT/80/9gu b4XJ2TRtLrgoAkNzbS5XjAROT6lrlCtd3P2+Uphc53MTI3UsbR5H1bjsI+S+7KtSdLsr6FfYRQn U44iminLb7Nfi0h7385JSXAIQObo75k/Xuh1VqLfYbjZIodm2qPWGMznYQmLDXZOR5I6B2jCXlC rSPhWHWR5KKyO6U4SNESMren2G9kwrTCdcnmKXNtZK1GQQGJ
X-Developer-Key: i=u.kleine-koenig@baylibre.com; a=openpgp; fpr=0D2511F322BFAB1C1580266BE2DCDD9132669BD6
X-Rspamd-Queue-Id: 94E6C40E0169
X-Spamd-Result: default: False [-1.22 / 20.00];
	 RCVD_VIA_SMTP_AUTH(0.00)[];
	 TO_DN_SOME(0.00)[];
	 R_SPF_ALLOW(-0.20)[+ip6:2a00:1450:4000::/36];
	 RCPT_COUNT_FIVE(0.00)[6];
	 RBL_VIRUSFREE_UNKNOWN_FAIL(0.00)[2a00:1450:4864:20::32c:query timed out];
	 RCVD_COUNT_THREE(0.00)[3];
	 MAILSPIKE_FAIL(0.00)[2a00:1450:4864:20::32c:query timed out];
	 FORGED_SENDER(0.30)[u.kleine-koenig@baylibre.com,ukleinek@baylibre.com];
	 RECEIVED_SPAMHAUS_PBL(0.00)[80.145.93.45:received];
	 MIME_TRACE(0.00)[0:+];
	 ASN(0.00)[asn:15169, ipnet:2a00:1450::/32, country:US];
	 SPAMHAUS_FAIL(0.00)[2a00:1450:4864:20::32c:query timed out];
	 FROM_NEQ_ENVFROM(0.00)[u.kleine-koenig@baylibre.com,ukleinek@baylibre.com];
	 ARC_NA(0.00)[];
	 BAYES_HAM(-2.22)[96.29%];
	 FROM_HAS_DN(0.00)[];
	 MIME_GOOD(-0.10)[text/plain];
	 PREVIOUSLY_DELIVERED(0.00)[bp@alien8.de];
	 DMARC_NA(0.00)[baylibre.com];
	 TO_MATCH_ENVRCPT_SOME(0.00)[];
	 RBL_SEM_IPV6_FAIL(0.00)[2a00:1450:4864:20::32c:query timed out];
	 BLOCKLISTDE_FAIL(0.00)[2a00:1450:4864:20::32c:query timed out,80.145.93.45:query timed out];
	 MID_CONTAINS_FROM(1.00)[];
	 NEURAL_HAM(-0.00)[-0.986];
	 RBL_NIXSPAM_FAIL(0.00)[2a00:1450:4864:20::32c:query timed out];
	 RCVD_TLS_ALL(0.00)[]
X-Rspamd-Server: mad
Content-Transfer-Encoding: quoted-printable

After commit 0edb555a65d1 ("platform: Make platform_driver::remove()
return void") .remove() is (again) the right callback to implement for
platform drivers.

Convert all platform drivers below arch/x86 to use .remove(), with the
eventual goal to drop struct platform_driver::remove_new(). As .remove()
and .remove_new() have the same prototypes, conversion is done by just
changing the structure member name in the driver initializer.

Signed-off-by: Uwe Kleine-K=C3=B6nig <u.kleine-koenig@baylibre.com>
---
Hello,

given the simplicity of the individual changes I do this all in a single
patch. I you don't agree, please tell and I will happily split it.

It's based on Friday's next, feel free to drop changes that result in a
conflict when you come around to apply this. I'll care for the fallout
at a later time then. (Having said that, if you use b4 am -3 and git am
-3, there should be hardly any conflict.)

Best regards
Uwe

 arch/x86/platform/iris/iris.c         | 2 +-
 arch/x86/platform/olpc/olpc-xo1-pm.c  | 4 ++--
 arch/x86/platform/olpc/olpc-xo1-sci.c | 2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/platform/iris/iris.c b/arch/x86/platform/iris/iris.=
c
index c5f3bbdbdcfe..5591a2d9cfe8 100644
--- a/arch/x86/platform/iris/iris.c
+++ b/arch/x86/platform/iris/iris.c
@@ -73,7 +73,7 @@ static struct platform_driver iris_driver =3D {
 		.name   =3D "iris",
 	},
 	.probe          =3D iris_probe,
-	.remove_new     =3D iris_remove,
+	.remove         =3D iris_remove,
 };
=20
 static struct resource iris_resources[] =3D {
diff --git a/arch/x86/platform/olpc/olpc-xo1-pm.c b/arch/x86/platform/olp=
c/olpc-xo1-pm.c
index 6a9c42de74e7..424eeae12759 100644
--- a/arch/x86/platform/olpc/olpc-xo1-pm.c
+++ b/arch/x86/platform/olpc/olpc-xo1-pm.c
@@ -159,7 +159,7 @@ static struct platform_driver cs5535_pms_driver =3D {
 		.name =3D "cs5535-pms",
 	},
 	.probe =3D xo1_pm_probe,
-	.remove_new =3D xo1_pm_remove,
+	.remove =3D xo1_pm_remove,
 };
=20
 static struct platform_driver cs5535_acpi_driver =3D {
@@ -167,7 +167,7 @@ static struct platform_driver cs5535_acpi_driver =3D =
{
 		.name =3D "olpc-xo1-pm-acpi",
 	},
 	.probe =3D xo1_pm_probe,
-	.remove_new =3D xo1_pm_remove,
+	.remove =3D xo1_pm_remove,
 };
=20
 static int __init xo1_pm_init(void)
diff --git a/arch/x86/platform/olpc/olpc-xo1-sci.c b/arch/x86/platform/ol=
pc/olpc-xo1-sci.c
index 46d42ff6e18a..ccb23c73cbe8 100644
--- a/arch/x86/platform/olpc/olpc-xo1-sci.c
+++ b/arch/x86/platform/olpc/olpc-xo1-sci.c
@@ -616,7 +616,7 @@ static struct platform_driver xo1_sci_driver =3D {
 		.dev_groups =3D lid_groups,
 	},
 	.probe =3D xo1_sci_probe,
-	.remove_new =3D xo1_sci_remove,
+	.remove =3D xo1_sci_remove,
 	.suspend =3D xo1_sci_suspend,
 	.resume =3D xo1_sci_resume,
 };

base-commit: 63b3ff03d91ae8f875fe8747c781a521f78cde17
--=20
2.45.2

