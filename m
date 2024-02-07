Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E66CB83CAB
	for <patches@lists.linux.dev>; Wed,  7 Feb 2024 17:50:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707328211; cv=none; b=s76El/7igCSpt9rAketJpk+KMrWLdTXGU6haI/alA8pkWUAZqlnDc2qx+Nyp1jkyMIT2DYjVjaXDCqzMhAbcPvNBBfYgcli2NKrXeewAGX4QlpHPgLGkDpyWP9wDKbsOgwLXEtEd/c0DLlJJRd2cFqmjNVNw3rmcdeEEPpDn5ys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707328211; c=relaxed/simple;
	bh=Mmz2szsEa8fRc/5VWn+xclgZaQqFrv3+O6GWDXybBIU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HpsEfDUilN1TAHletAeinXc+vTAJAPk5IgKrst8dbOMvlUzApWV5/gEx6r/+1qCIq63Nf+TRjlcN5W94oDJ8Fb8eA3YBOnH6+GPOHOxVC9IZ1Rt/7LguLVZ14d1Re5JcFYJtj0EG8mx6gzEROe1zLob5XTnbdJ+OnI6yy4z7Cg4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TmZL/KQh; arc=none smtp.client-ip=209.85.208.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TmZL/KQh"
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-55a5e7fa471so1110078a12.1
        for <patches@lists.linux.dev>; Wed, 07 Feb 2024 09:50:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1707328207; x=1707933007; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HGDFZCXJsgP/e+y8DEUUTJO395BJkBwgpdtBp6SsTfM=;
        b=TmZL/KQhqX+jXdHFLhBOulkQ0DXEU897kvS6kLbv9/50LuzFdtAZF12qZgDZeUhvjX
         9vCWjnB3TrCKSzEbQuqoT/kPJ9aINurFZq8nAN7AOERb3pgcylftxkzQmoUX9T5+Y9H5
         on1iC5M5S+0W4e06MHGD6IJvVi6ZJQ8onz9NSa/RiNR+uj9pbKXqExckLBTP27XvcifQ
         rYDJctyk8BNrsomBNGsVIW1AcH2i3e7e1654WtgrZZZbgLPV8BBMB4LPm3l0Q9Ig3F8p
         2s6AaTnEDaqSrvhZdjn1sWUoZD9CTjcVixNmirNxg2mFwp9h5Vc3Og/TO5OXC144x00b
         eEcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707328207; x=1707933007;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HGDFZCXJsgP/e+y8DEUUTJO395BJkBwgpdtBp6SsTfM=;
        b=f4XHN7yrL6BH5I6L+2bhLv1Rc+ezJyDyiVC+zR3oJ1weISSclIvcHqfLMr/wx36r9j
         DyUNg9jEA8lqbM+Y+/1hwZFyNzHfb8BsTB9CkZpc4sKThm7m+mcH8nZZAWTHcSKDa0Ia
         8H6roCkDHAAVqUhZTFlQH06/EP2BcaauBABdvtHmIakx0cxLLnJ0M7jtCjdC10D11frn
         5o6Zj9QcjhFkbzTh60HZZZanoNiV+VRXECmmRSo2G5LyfC5CD6d3xcghWdezH/DT1n5Z
         L8QvynfOwVjehYghcSticm/TK3emHrA/iXX6WgNsHGCLT0GVgFn9M1oPilg9VWcFhTXi
         yroA==
X-Gm-Message-State: AOJu0YyQoDUjVDeq82Tua799QV6jdk7yzSU9bbNN3Xp4Rp1Iq1kWSVwU
	eCritcB8SPrSsLMN/5IAwqNXVQcSKQKRmvwzrL7Jna0cSEOh6AhI
X-Google-Smtp-Source: AGHT+IH9xD0ZoHBG4Q6eKYQphgfJ1ej5/WN2oX5gK7W7O7t8ZQSiENBsrXlUdeTnPhAhjCDUydEiig==
X-Received: by 2002:aa7:cf99:0:b0:55f:fd10:5e73 with SMTP id z25-20020aa7cf99000000b0055ffd105e73mr4160390edx.20.1707328207371;
        Wed, 07 Feb 2024 09:50:07 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCWGu6sWkBlNncMKRcXdn/T/yb4cLtusRzgoQNkriY5/pMQCTIw63d/+IgLuLYBPVkXJw2fTL444mEkyKSiKtS/98MgjhgrRzF0xsp6Xyv7V+nWt/qz6Kx9G0WtAmr3OtwoAlGHLVwBpnkGK/P+fxqKjTWWjifA2ooXe9k673XQksK5b0MDWHDkj92uUQJ8+MUp2OLJe/kVzO0XIHH6qhDMF5Y1WMwX02A3kIJUHXMCGIeqydSRMBKyylP6WgW8oRHcC4L4ChpdVistbJ1Z5BSsjS2dayDpMvM8X7DxB+6JozeOXVVk5pp9GAsGxqGHPeQ==
Received: from toolbox.int.toradex.com (31-10-206-125.static.upc.ch. [31.10.206.125])
        by smtp.gmail.com with ESMTPSA id c18-20020aa7df12000000b00560f3954ffdsm180992edy.24.2024.02.07.09.50.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Feb 2024 09:50:07 -0800 (PST)
From: max.oss.09@gmail.com
To: stable@vger.kernel.org
Cc: gregkh@linuxfoundation.org,
	patches@lists.linux.dev,
	s.hauer@pengutronix.de,
	han.xu@nxp.com,
	tomasz.mon@camlingroup.com,
	richard@nod.at,
	tharvey@gateworks.com,
	linux-mtd@lists.infradead.org,
	Max Krummenacher <max.krummenacher@toradex.com>
Subject: [regression 5.4.y][RFC][PATCH mtd: rawnand: gpmi: busy_timeout_cycles 1/1]  Revert "Revert "mtd: rawnand: gpmi: Fix setting busy timeout setting""
Date: Wed,  7 Feb 2024 18:49:11 +0100
Message-ID: <20240207174911.870822-2-max.oss.09@gmail.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20240207174911.870822-1-max.oss.09@gmail.com>
References: <20240207174911.870822-1-max.oss.09@gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Max Krummenacher <max.krummenacher@toradex.com>

This reverts commit 15a3adfe75937c9e4e0e48f0ed40dd39a0e526e2.

The backport of [1] relies on having [2] also backported. Having only
one of the two results in a bogus hw->timing1 setting.

If only [2] is backportet the 16 bit register value likely underflows
resulting in a busy_wait_timeout of 0.
Or if only [1] is applied the value likely overflows with chances of
having last 16 LSBs all 0 which would then result in a
busy_wait_timeout of 0 too.

Both cases may lead to NAND data corruption, e.g. on a Colibri iMX7
setup this has been seen.

[1] commit 0fddf9ad06fd ("mtd: rawnand: gpmi: Set WAIT_FOR_READY
timeout based on program/erase times")
[2] commit 06781a5026350 ("mtd: rawnand: gpmi: Fix setting busy
timeout setting")

Signed-off-by: Max Krummenacher <max.krummenacher@toradex.com>
---
 drivers/mtd/nand/raw/gpmi-nand/gpmi-nand.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mtd/nand/raw/gpmi-nand/gpmi-nand.c b/drivers/mtd/nand/raw/gpmi-nand/gpmi-nand.c
index b806a762d079f..fdf5cf5565f99 100644
--- a/drivers/mtd/nand/raw/gpmi-nand/gpmi-nand.c
+++ b/drivers/mtd/nand/raw/gpmi-nand/gpmi-nand.c
@@ -684,7 +684,7 @@ static void gpmi_nfc_compute_timings(struct gpmi_nand_data *this,
 	hw->timing0 = BF_GPMI_TIMING0_ADDRESS_SETUP(addr_setup_cycles) |
 		      BF_GPMI_TIMING0_DATA_HOLD(data_hold_cycles) |
 		      BF_GPMI_TIMING0_DATA_SETUP(data_setup_cycles);
-	hw->timing1 = BF_GPMI_TIMING1_BUSY_TIMEOUT(busy_timeout_cycles * 4096);
+	hw->timing1 = BF_GPMI_TIMING1_BUSY_TIMEOUT(DIV_ROUND_UP(busy_timeout_cycles, 4096));
 
 	/*
 	 * Derive NFC ideal delay from {3}:
-- 
2.42.0

