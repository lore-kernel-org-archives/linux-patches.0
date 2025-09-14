Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B37E266B56
	for <patches@lists.linux.dev>; Sun, 14 Sep 2025 03:51:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757821909; cv=none; b=eUASvH9DL2My5EpqBA/NvqBiGHtpCIE7RGjFLebzSMn82zgcxbRjHpuRyTXR2lL1Cduh1rspNKjY3g9/HpjNfsFdGwIYqrfyN2umxHBJpkLifp+22+syocdmWpXcUAab6y5OpLCrwyV1xCU8h6P7yUil/c5jw98vZF4cRuFtJ7M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757821909; c=relaxed/simple;
	bh=E44LF/8lHGTYomA5WWH/VDahlaDv99Wi8d81CdQz9ho=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ohagv7QYmFOhU/G/RUtBUooBZoNttWzU4bK12inZxeX8YnrmEf1jn9HCnl3eREAZlu5VSXx8WSHVDIBTJdUDZksp0ZjeJcuMSAUWtQeX/R9olCubfGAUsZLDYLZ4ENtkTjPNbqTVu1NjQwoUJLqFnajJ+rxsuB+JUOh+4X/EIx0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=iAb+A7HN; arc=none smtp.client-ip=209.85.218.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iAb+A7HN"
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-b0415e03e25so404342766b.0
        for <patches@lists.linux.dev>; Sat, 13 Sep 2025 20:51:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757821905; x=1758426705; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eXT46s/O30O5D6iGHqIIZ8OQqeCOoCO9YfqStJzQ+0w=;
        b=iAb+A7HND0H/AgGbvISY2dyX0x+5zAINAZ1a1JKtrKuxDDC+zKfqV7stndI09+xITM
         4DKVzkebuc9mgrbGsy7A93mrFHjLOJ1owQror+Pc3JCcEaKDWr/gXpV/doE4GKLvgtZj
         zhP9YzSbJLO0ijmx2/tLoUgi1LjxnZ21WVSF3ZVEKbIrImyfUnY+PNXZBAV/EbA6/kh5
         Re/RTbS24ZnQICZkNgMJPd+P44j1aQM/JAte67OcwFvVsf5C8CS2N+COwlR2zYVvOiuX
         EDBvGXtKw2KY0dE7qy6V7FfejcP+pWpZ76HcXAGYfrjfqm6h6Ok3SAO2OadQIbCbKpKl
         +uLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757821905; x=1758426705;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=eXT46s/O30O5D6iGHqIIZ8OQqeCOoCO9YfqStJzQ+0w=;
        b=UrnGqZ1za2IT1C0Rhv6/+gI9noGpPWnjFGFU3Rv9YTQCthKvfdshva1E3vRKJHE/wH
         Z2AHynMu1S1tMqSKFNHdS97XRmb2uFQ1ddI+umkEqBsgmJoY6TK7Xhe5JpnVwoMyObCr
         i2pOYjTkOodGKsYCtyHH++cTncCjCwvnhkTV2Za0rkzANso5z7l2C0CUSX/lAfizbMyo
         ZK70uEnX8OiInr6QULeSkqi95q/PJdFP0zlhNaIFt0Hmi4YaAFllU6ZEOVpeBpXACo+u
         qLBxVMNJuIGoHZue3QT25YctWcI0mYPPC44Bi3mEekBjVyw0qNBNnc5UxXLTuNDizVLm
         h+/w==
X-Forwarded-Encrypted: i=1; AJvYcCUPhxqCNaWfSZmrU/o4jAt/n3vEAo0xnzMqNBzG5pGs6llQhIdDJvOcsg4WP4a9zRTkkgZ7Z91D@lists.linux.dev
X-Gm-Message-State: AOJu0Yz/XZWdt76rixz5vlYCowJp00Q7Ildk2v46L3OAxlg6SN0P+xji
	eIM0vT/4BonduzvPgSxZ6lDjpbtBLx0BdTpKh/E5WvCDh2uJUlAlTf3D
X-Gm-Gg: ASbGncvjTS7FLYwi91AUVfbKp93lncGGiGCphfZFqaSE3mz0luBGfh0xgVQm2RUAehw
	DyYrFpTN0CRM0ebK4jsn5ucx0/Foe+XTsoEQGSFKxx61ZPzxZxt9uvtXoAS/SABJN1PZCO2dVuN
	QzuDw1VMObdq7xMCN3oS+NVS3rIbTet8e3YxRlPUVtG+HJ5W0Jlv1D+9o6c5QuXxzbPKEJOws9z
	vxKe99IXMBk/5nIq7mpIFMqj6IBGBguPvN9W9GM0WUdd512cr2VBUKktvNyukzM96r66rGbKXsz
	lLK2dpkmiBj5E1aXenS2y5SGOWj/I6+Qb0uY+44O98hAV1a0x5FqT9pncjB5biyG7uHuk/3I/Sj
	OlD9tqVOtt55MCcAyS98=
X-Google-Smtp-Source: AGHT+IEAFUpwy9YyLhSCGMZ/kQuTAA3iwfbEpQd1MDgVvquhbXlSq99pqpi7zF/bJ0OEdeyJIf4Tkg==
X-Received: by 2002:a17:907:3f07:b0:b04:7ad5:b567 with SMTP id a640c23a62f3a-b07c35be704mr853139866b.16.1757821904788;
        Sat, 13 Sep 2025 20:51:44 -0700 (PDT)
Received: from localhost ([212.73.77.104])
        by smtp.gmail.com with UTF8SMTPSA id a640c23a62f3a-b07b32f35cdsm661712966b.92.2025.09.13.20.51.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 13 Sep 2025 20:51:43 -0700 (PDT)
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
Subject: [PATCH RESEND 40/62] init: rename free_initrd_mem to free_initramfs_mem
Date: Sun, 14 Sep 2025 06:51:38 +0300
Message-ID: <20250914035138.3631173-1-safinaskar@gmail.com>
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

This is cleanup after initrd removal

Signed-off-by: Askar Safin <safinaskar@gmail.com>
---
 arch/arm/mm/init.c     |  2 +-
 arch/x86/mm/init.c     |  2 +-
 include/linux/initrd.h |  2 +-
 init/initramfs.c       | 10 +++++-----
 4 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/arch/arm/mm/init.c b/arch/arm/mm/init.c
index 4faeec51c522..290e9f9874c9 100644
--- a/arch/arm/mm/init.c
+++ b/arch/arm/mm/init.c
@@ -437,7 +437,7 @@ void free_initmem(void)
 }
 
 #ifdef CONFIG_BLK_DEV_INITRD
-void free_initrd_mem(unsigned long start, unsigned long end)
+void free_initramfs_mem(unsigned long start, unsigned long end)
 {
 	if (start == virt_external_initramfs_start)
 		start = round_down(start, PAGE_SIZE);
diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
index bb57e93b4caf..c7ca996fb430 100644
--- a/arch/x86/mm/init.c
+++ b/arch/x86/mm/init.c
@@ -981,7 +981,7 @@ void __ref free_initmem(void)
 }
 
 #ifdef CONFIG_BLK_DEV_INITRD
-void __init free_initrd_mem(unsigned long start, unsigned long end)
+void __init free_initramfs_mem(unsigned long start, unsigned long end)
 {
 	/*
 	 * end could be not aligned, and We can not align that,
diff --git a/include/linux/initrd.h b/include/linux/initrd.h
index 55239701c4e0..b2a0128c3438 100644
--- a/include/linux/initrd.h
+++ b/include/linux/initrd.h
@@ -7,7 +7,7 @@
 extern int initramfs_below_start_ok;
 
 extern unsigned long virt_external_initramfs_start, virt_external_initramfs_end;
-extern void free_initrd_mem(unsigned long, unsigned long);
+extern void free_initramfs_mem(unsigned long, unsigned long);
 
 #ifdef CONFIG_BLK_DEV_INITRD
 extern void __init reserve_initrd_mem(void);
diff --git a/init/initramfs.c b/init/initramfs.c
index 8ed352721a79..7a050e54ff1a 100644
--- a/init/initramfs.c
+++ b/init/initramfs.c
@@ -642,7 +642,7 @@ void __init reserve_initrd_mem(void)
 	if (!phys_external_initramfs_size)
 		return;
 	/*
-	 * Round the memory region to page boundaries as per free_initrd_mem()
+	 * Round the memory region to page boundaries as per free_initramfs_mem()
 	 * This allows us to detect whether the pages overlapping the initrd
 	 * are in use, but more importantly, reserves the entire set of pages
 	 * as we don't want these pages allocated for other purposes.
@@ -676,7 +676,7 @@ void __init reserve_initrd_mem(void)
 	virt_external_initramfs_end = 0;
 }
 
-void __weak __init free_initrd_mem(unsigned long start, unsigned long end)
+void __weak __init free_initramfs_mem(unsigned long start, unsigned long end)
 {
 #ifdef CONFIG_ARCH_KEEP_MEMBLOCK
 	unsigned long aligned_start = ALIGN_DOWN(start, PAGE_SIZE);
@@ -707,9 +707,9 @@ static bool __init kexec_free_initrd(void)
 	 */
 	memset((void *)virt_external_initramfs_start, 0, virt_external_initramfs_end - virt_external_initramfs_start);
 	if (virt_external_initramfs_start < crashk_start)
-		free_initrd_mem(virt_external_initramfs_start, crashk_start);
+		free_initramfs_mem(virt_external_initramfs_start, crashk_start);
 	if (virt_external_initramfs_end > crashk_end)
-		free_initrd_mem(crashk_end, virt_external_initramfs_end);
+		free_initramfs_mem(crashk_end, virt_external_initramfs_end);
 	return true;
 }
 #else
@@ -744,7 +744,7 @@ static void __init do_populate_rootfs(void *unused, async_cookie_t cookie)
 	 * free only memory that is not part of crashkernel region.
 	 */
 	if (!do_retain_initrd && virt_external_initramfs_start && !kexec_free_initrd()) {
-		free_initrd_mem(virt_external_initramfs_start, virt_external_initramfs_end);
+		free_initramfs_mem(virt_external_initramfs_start, virt_external_initramfs_end);
 	} else if (do_retain_initrd && virt_external_initramfs_start) {
 		bin_attr_initrd.size = virt_external_initramfs_end - virt_external_initramfs_start;
 		bin_attr_initrd.private = (void *)virt_external_initramfs_start;
-- 
2.47.2

