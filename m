Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7D335464E
	for <patches@lists.linux.dev>; Sat, 13 Sep 2025 00:46:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757724398; cv=none; b=ajevJQTf6/bBsFYRYDZvNYkKtOKofYlTaOACDLv3AQMPF6bzB555FPQK6s35V8u3nXvdJ0MFzCfYD+TXk0pDRlj5MslDYkZoST6Dl/5sVr8z+yi75XvyaBsRtNLlE3RCvTF+qmyR+/UsAn/E+3kvVhRjQtqbtkjVepY9KQ9WVTw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757724398; c=relaxed/simple;
	bh=zjnx3/NY9AOu8ee75jqsChu3O0QCH1Ezxe1gYYeY9CY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FdKCWVm/jAXOyKewjf/tKUn2jjgftobaZk0IOPmZpK0FK007ZnWYcjgoNdx927HNhLNCv4tJk4BaBx1q67Qn5fad75fk+mYFsd8WNpSL+ax/QIhQK5aa4etqCKClpoDAid1hLSxjT7hs0CJQkoTy+hYX+nmZWsjZw0e6O7vGglQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Myux3AEc; arc=none smtp.client-ip=209.85.218.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Myux3AEc"
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-b00a9989633so461777966b.0
        for <patches@lists.linux.dev>; Fri, 12 Sep 2025 17:46:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757724394; x=1758329194; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Y83Wia04Z/mNTHCUGozzAt26nJVQ29vmo/6z8Jb/IIM=;
        b=Myux3AEc7Al/ovmcZehzCpNjHsUZMf5OFuGkhu/R5s5T4n4GYkWWYLzsel3y2a7dwE
         EHVSz+ya3xT7f+K1pWzHE7h5Flmv7hxYEuvyTRQlXeu5HcEpAmW4FGPh3apYFxC7x152
         AKZYdk+wAHuEGuGBdbYfVcEf0TNpvKkYQfEaOn4qwe2MVBfO1x3TDX0VdUno9TddVQBB
         nrjr0BRgdhTL0XqaCX9Ylp2rgIGhoEMF0pSaA6vynOLphDYifaF3/rNtPl14jjQmiVxo
         S52rBPZf/A+QInFLbcI9oIvsyWrQ3+Fg8mYiDKBrnlNJly12wpAkyb10LYwhFq8NjYHR
         ngig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757724394; x=1758329194;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Y83Wia04Z/mNTHCUGozzAt26nJVQ29vmo/6z8Jb/IIM=;
        b=l1fYCt053kp4Frq1J3ecRip6uaHAS8xD21lg+v+6CDS/93cxvJlQ2NOs/0Y2U+q9rF
         E7kU2am4nydOhvtSfBTQi9H/F0w+LVvGJLIVpE6zyOOHtuAYtFnnJbKwgOsxjysmuszR
         45O5/ZWoAyFgvSQ165jEhTdGl48aZIVi9PdTFmfgYZE7Zt8zjd9o936aBZF0eFDoqHnU
         QZB9faOY6eEjVJON9wiOeXD12/JqU7nH9AHeqirkOX0KmtoWJCCqaS5liukkVRQKa8Lr
         AduZsA2bpC8MqcrrdH4JkaqrIMx5NiOhT9EA6cJlrxxvgfqdpoHI4IMx8D9oWpVrfGbt
         RM4g==
X-Forwarded-Encrypted: i=1; AJvYcCV5E1h7HLvMeBJjDdBJxJ03lk5noO82RewARf/Nooo3UjYZEBR50j2PvWCHuXoudJkVKlInUyla@lists.linux.dev
X-Gm-Message-State: AOJu0Yy1JsA/SnySZSu9QRAfH3YCAZby6si7IIwzASUnoMKwN8R+9omk
	RwjvLsLTLEcc9oLQoJWMJCMTD8OMvKI4Joo6hU2WiANfExFD4oL7mRVu
X-Gm-Gg: ASbGncuDlq6j1Vo/bg/vNJm0t/2bkd+Jtc7oO7lG4DAAW3/pJOLUR86OTxDt5VY4o9w
	k7wRTifekNRZ8p4vhleuLKbOW4yRQ52h/ptFhwklx3wLrjhwe/cIZhH43USI6yYQgtXczUiTRfz
	gKiQarUniFqChBrrommENw1MTUzAE8+nV1+O9pq/JporOo3wpoM0oajE0pkAXJEvNviMCaVuzpo
	/OSIxrgH7Zuxbawyuwb8hJgPM8K4w0QiA+ErQ4kgmG760mMQ3oRLjSchXxCqk9yr/JdTpST+zWa
	VXCJtETMHmRPN8Tm1RsBbuv0VaCNmZ3md3HNWnEtzxzanYLy/j0WrWC6h/A3EDSLUjuwTnQdUb2
	yDC/UF02KLK4/0ChPMU0=
X-Google-Smtp-Source: AGHT+IEhRE4IwIn6e21II3sG+AWhFOewnNElGtSUdTtt48+B8a0G24fjikoaCpJ97iRLzEKC56BiAg==
X-Received: by 2002:a17:907:96a3:b0:b07:e258:4629 with SMTP id a640c23a62f3a-b07e2584a05mr103605766b.16.1757724393999;
        Fri, 12 Sep 2025 17:46:33 -0700 (PDT)
Received: from localhost ([212.73.77.104])
        by smtp.gmail.com with UTF8SMTPSA id a640c23a62f3a-b07b32f2334sm475232966b.78.2025.09.12.17.46.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Sep 2025 17:46:33 -0700 (PDT)
From: Askar Safin <safinaskar@gmail.com>
To: linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Christian Brauner <brauner@kernel.org>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Jan Kara <jack@suse.cz>,
	Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>,
	Andy Shevchenko <andy.shevchenko@gmail.com>,
	Aleksa Sarai <cyphar@cyphar.com>,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
	Julian Stecklina <julian.stecklina@cyberus-technology.de>,
	Gao Xiang <hsiangkao@linux.alibaba.com>,
	Art Nikpal <email2tema@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Eric Curtin <ecurtin@redhat.com>,
	Alexander Graf <graf@amazon.com>,
	Rob Landley <rob@landley.net>,
	Lennart Poettering <mzxreary@0pointer.de>,
	linux-arch@vger.kernel.org,
	linux-alpha@vger.kernel.org,
	linux-snps-arc@lists.infradead.org,
	linux-arm-kernel@lists.infradead.org,
	linux-csky@vger.kernel.org,
	linux-hexagon@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-m68k@lists.linux-m68k.org,
	linux-mips@vger.kernel.org,
	linux-openrisc@vger.kernel.org,
	linux-parisc@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-riscv@lists.infradead.org,
	linux-s390@vger.kernel.org,
	linux-sh@vger.kernel.org,
	sparclinux@vger.kernel.org,
	linux-um@lists.infradead.org,
	x86@kernel.org,
	Ingo Molnar <mingo@redhat.com>,
	linux-block@vger.kernel.org,
	initramfs@vger.kernel.org,
	linux-api@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-efi@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	"Theodore Y . Ts'o" <tytso@mit.edu>,
	linux-acpi@vger.kernel.org,
	Michal Simek <monstr@monstr.eu>,
	devicetree@vger.kernel.org,
	Luis Chamberlain <mcgrof@kernel.org>,
	Kees Cook <kees@kernel.org>,
	Thorsten Blum <thorsten.blum@linux.dev>,
	Heiko Carstens <hca@linux.ibm.com>,
	patches@lists.linux.dev
Subject: [PATCH RESEND 06/62] arm: init: remove special logic for setting brd.rd_size
Date: Sat, 13 Sep 2025 00:37:45 +0000
Message-ID: <20250913003842.41944-7-safinaskar@gmail.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250913003842.41944-1-safinaskar@gmail.com>
References: <20250913003842.41944-1-safinaskar@gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

There is no any reason for having special mechanism
for setting ramdisk size.

Also this allows us to change rd_size variable to static

Signed-off-by: Askar Safin <safinaskar@gmail.com>
---
 arch/arm/kernel/atags_parse.c | 12 ------------
 drivers/block/brd.c           |  8 ++++----
 include/linux/initrd.h        |  3 ---
 3 files changed, 4 insertions(+), 19 deletions(-)

diff --git a/arch/arm/kernel/atags_parse.c b/arch/arm/kernel/atags_parse.c
index a3f0a4f84e04..615d9e83c9b5 100644
--- a/arch/arm/kernel/atags_parse.c
+++ b/arch/arm/kernel/atags_parse.c
@@ -87,18 +87,6 @@ static int __init parse_tag_videotext(const struct tag *tag)
 __tagtable(ATAG_VIDEOTEXT, parse_tag_videotext);
 #endif
 
-#ifdef CONFIG_BLK_DEV_RAM
-static int __init parse_tag_ramdisk(const struct tag *tag)
-{
-	if (tag->u.ramdisk.size)
-		rd_size = tag->u.ramdisk.size;
-
-	return 0;
-}
-
-__tagtable(ATAG_RAMDISK, parse_tag_ramdisk);
-#endif
-
 static int __init parse_tag_serialnr(const struct tag *tag)
 {
 	system_serial_low = tag->u.serialnr.low;
diff --git a/drivers/block/brd.c b/drivers/block/brd.c
index 0c2eabe14af3..72f02d2b8a99 100644
--- a/drivers/block/brd.c
+++ b/drivers/block/brd.c
@@ -27,6 +27,10 @@
 
 #include <linux/uaccess.h>
 
+static unsigned long rd_size = CONFIG_BLK_DEV_RAM_SIZE;
+module_param(rd_size, ulong, 0444);
+MODULE_PARM_DESC(rd_size, "Size of each RAM disk in kbytes.");
+
 /*
  * Each block ramdisk device has a xarray brd_pages of pages that stores
  * the pages containing the block device's contents.
@@ -209,10 +213,6 @@ static int rd_nr = CONFIG_BLK_DEV_RAM_COUNT;
 module_param(rd_nr, int, 0444);
 MODULE_PARM_DESC(rd_nr, "Maximum number of brd devices");
 
-unsigned long rd_size = CONFIG_BLK_DEV_RAM_SIZE;
-module_param(rd_size, ulong, 0444);
-MODULE_PARM_DESC(rd_size, "Size of each RAM disk in kbytes.");
-
 static int max_part = 1;
 module_param(max_part, int, 0444);
 MODULE_PARM_DESC(max_part, "Num Minors to reserve between devices");
diff --git a/include/linux/initrd.h b/include/linux/initrd.h
index 6320a9cb6686..b42235c21444 100644
--- a/include/linux/initrd.h
+++ b/include/linux/initrd.h
@@ -5,9 +5,6 @@
 
 #define INITRD_MINOR 250 /* shouldn't collide with /dev/ram* too soon ... */
 
-/* size of a single RAM disk */
-extern unsigned long rd_size;
-
 /* 1 if it is not an error if initrd_start < memory_start */
 extern int initrd_below_start_ok;
 
-- 
2.47.2

