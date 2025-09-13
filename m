Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFE5B6BB5B
	for <patches@lists.linux.dev>; Sat, 13 Sep 2025 00:47:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757724466; cv=none; b=tCvC+DjImfEQGIUcesm44xAKlXl9fjzQasTtf+408O/R+5foGBV81grEbreYrTsAuumENWOVxU23LacUP/DBK35o/hoImBnQombcHE0BnPiWJSZnute8+LHVV8K3nHJX93u3CwH39t7e1oc/nfIjCFhhnYOYGG5BVtVfNMI2HpU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757724466; c=relaxed/simple;
	bh=VrIhE6DR0UxTy1zLmeYzHJtIzcnVxbHuxWIBZzITpiQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j+vKllpqDjFznOpI1JTgj4FNle4xGxPY2X+u1te666mb3MNLvzkgTlDrHSC5fhJNhO4Pv/MJXtDnl7n2y/gH3p35fUtATvmZcbIpeHj6ODHWQ0EZm6aJpe1Bv8LHX/0uXCQHO9f92SJ3pqWEDL+9RNqM5q9UVHyTd3vqn1ZRB6s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=l2LcWNn8; arc=none smtp.client-ip=209.85.208.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="l2LcWNn8"
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-62ee43b5e96so1603141a12.1
        for <patches@lists.linux.dev>; Fri, 12 Sep 2025 17:47:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757724460; x=1758329260; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4fVjgLbGK8Q3VzkUirE6fakA1teoXIVC6opbXGA1ZT4=;
        b=l2LcWNn8DeDhouJJ9h+YxFAhtdLUkGycRREAOIm1LPj8NubkobRbTFCgkzl0JdML+Z
         y5PG9meqRe/flLGHAO7h+7ObqPmlN8c6WAxEA7iRgJoYGWrDsTocUCsCy7Yl/qowrkCx
         vwnqEuXscleVHqcEjbLZnJFTsCrQEBdgZZsxN0ilgov3WMPbWs6y+0hGaciKifU19OTD
         z2kV+IcBef3dFRub8b61CVfpndNb13FLebX8g2mkglnQwWYKxwKuJqI7hUfTKhNfygGK
         UJFXYBw9nbTs9ftPbeK340R72KNf/tuCnYc4zR0v4QPgnJ6XwkfLHutPKNyN/ZmZY50C
         j8wA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757724460; x=1758329260;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4fVjgLbGK8Q3VzkUirE6fakA1teoXIVC6opbXGA1ZT4=;
        b=JojMQkNvAwPBl/UyoQDmnxoNiCPC4nclTAprN1vjsszkq2UTMQ5aHEElEpC2qRcjGN
         QkUB28s/LQ9HtHc9h8R+VjMWf8B7+dd0MDX4HszsJY8osI6qrLSFt2bJliFf0z7e4BtU
         xylk75hh15yvIU1eJji3wZk/ojZOyzeXOHklasP7i19MBUGIKiXFRqgibsAPCpf7ArNd
         ZroydupIKYTL1GzlHfD6G+24PhVBaKKadrRkNZ7uOLIVtSaipKt7kBwbCs9YuNX0gZGv
         wl5oIuEpXFaRAZ/qeLtboO1OD46eOVoMzdO97QZU7rn6Q/1jLQulmkQVvkZpxBSJJTF7
         V6Aw==
X-Forwarded-Encrypted: i=1; AJvYcCXqMeQb8iEfJ1BC4Iz7vsH1GYhbr+/ybTpQL0gxBYopcfR5cWK4wF/Yk092Va4+9zws0VVDMxdi@lists.linux.dev
X-Gm-Message-State: AOJu0YxSVZaA6l1hNtd5tv/MzZFGHxKVDdrDAiSEaimWsmu+39adEnlw
	bm9cR+ROaFnsEWZPnRkznqesytP0Dio3m6bnWr3s3UlQyDaEBVkgHmBY
X-Gm-Gg: ASbGncvODuInq3MJvHrUBInYy3pfoqfCj9i5KhhfjobuTMd0z1WbFctshnEhuabNOrK
	z2mILWoR0h5Hn6BQWsGgh6iNKjbJfJOiYTZ8NHmEJmYk5nNAWm556aHZjqLPRKiXbXhRK6KTZa9
	XAU2KclALrUcL7Kb9LxEkwCD7I01/v7y6F50HCiInKh7m8EHAnwTtp1ZQdYxUkD5iKKLhdkkD77
	ivlxVApfQVK6g7m/JezU1Z8pPvGopKpXgNRA3LYf7OdMuyc+YlHbnDGT0lJvZQJ4DrfJZiQUsgq
	ZsApxQqSmA9w1SlKzrEEwtulyZwsXYSoAv5u6PR/+tE+4dM5rWh/q8PvLUbAGL3SjY5HfejS/tS
	99KxlExuNhID33S4W5TE=
X-Google-Smtp-Source: AGHT+IEn7MCXvWnM/H721JcTSYIJ22gozO3aCU54l5QL6th5VdkTEU9iyn+bkfXPUmCFMabMmsyKeA==
X-Received: by 2002:a05:6402:40c9:b0:62e:ed71:601a with SMTP id 4fb4d7f45d1cf-62eed71640amr2549162a12.36.1757724460211;
        Fri, 12 Sep 2025 17:47:40 -0700 (PDT)
Received: from localhost ([212.73.77.104])
        by smtp.gmail.com with UTF8SMTPSA id 4fb4d7f45d1cf-62ec33f3c01sm4224385a12.34.2025.09.12.17.47.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Sep 2025 17:47:39 -0700 (PDT)
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
Subject: [PATCH RESEND 07/62] arm: init: remove ATAG_RAMDISK
Date: Sat, 13 Sep 2025 00:37:46 +0000
Message-ID: <20250913003842.41944-8-safinaskar@gmail.com>
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

Previous commit removed last reference to ATAG_RAMDISK,
so let's remove it

Signed-off-by: Askar Safin <safinaskar@gmail.com>
---
 arch/arm/Kconfig                  |  2 +-
 arch/arm/include/uapi/asm/setup.h | 10 ----------
 arch/arm/kernel/atags_compat.c    |  8 --------
 3 files changed, 1 insertion(+), 19 deletions(-)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index b1f3df39ed40..afc161d76c5f 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -1479,7 +1479,7 @@ config ARM_ATAG_DTB_COMPAT
 	depends on ARM_APPENDED_DTB
 	help
 	  Some old bootloaders can't be updated to a DTB capable one, yet
-	  they provide ATAGs with memory configuration, the ramdisk address,
+	  they provide ATAGs with memory configuration,
 	  the kernel cmdline string, etc.  Such information is dynamically
 	  provided by the bootloader and can't always be stored in a static
 	  DTB.  To allow a device tree enabled kernel to be used with such
diff --git a/arch/arm/include/uapi/asm/setup.h b/arch/arm/include/uapi/asm/setup.h
index 8e50e034fec7..3a70890ce80f 100644
--- a/arch/arm/include/uapi/asm/setup.h
+++ b/arch/arm/include/uapi/asm/setup.h
@@ -59,15 +59,6 @@ struct tag_videotext {
 	__u16		video_points;
 };
 
-/* describes how the ramdisk will be used in kernel */
-#define ATAG_RAMDISK	0x54410004
-
-struct tag_ramdisk {
-	__u32 flags;	/* bit 0 = load, bit 1 = prompt */
-	__u32 size;	/* decompressed ramdisk size in _kilo_ bytes */
-	__u32 start;	/* starting block of floppy-based RAM disk image */
-};
-
 /* describes where the compressed ramdisk image lives (virtual address) */
 /*
  * this one accidentally used virtual addresses - as such,
@@ -150,7 +141,6 @@ struct tag {
 		struct tag_core		core;
 		struct tag_mem32	mem;
 		struct tag_videotext	videotext;
-		struct tag_ramdisk	ramdisk;
 		struct tag_initrd	initrd;
 		struct tag_serialnr	serialnr;
 		struct tag_revision	revision;
diff --git a/arch/arm/kernel/atags_compat.c b/arch/arm/kernel/atags_compat.c
index 10da11c212cc..b9747061fa97 100644
--- a/arch/arm/kernel/atags_compat.c
+++ b/arch/arm/kernel/atags_compat.c
@@ -122,14 +122,6 @@ static void __init build_tag_list(struct param_struct *params, void *taglist)
 	tag->u.core.pagesize = params->u1.s.page_size;
 	tag->u.core.rootdev = params->u1.s.rootdev;
 
-	tag = tag_next(tag);
-	tag->hdr.tag = ATAG_RAMDISK;
-	tag->hdr.size = tag_size(tag_ramdisk);
-	tag->u.ramdisk.flags = (params->u1.s.flags & FLAG_RDLOAD ? 1 : 0) |
-			       (params->u1.s.flags & FLAG_RDPROMPT ? 2 : 0);
-	tag->u.ramdisk.size  = params->u1.s.ramdisk_size;
-	tag->u.ramdisk.start = params->u1.s.rd_start;
-
 	tag = tag_next(tag);
 	tag->hdr.tag = ATAG_INITRD;
 	tag->hdr.size = tag_size(tag_initrd);
-- 
2.47.2

