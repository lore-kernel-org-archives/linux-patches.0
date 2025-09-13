Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 367A2199939
	for <patches@lists.linux.dev>; Sat, 13 Sep 2025 01:14:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757726046; cv=none; b=fziVypJqvB/2zlHyHSzfXgBrZq1VzN7Hz0jxfci4b2OcbWLFMua3xb0qOiSAZJavAZZiW2/akAmbBat+qpokan7CHHo4U9t9FApfAznkzuvKPvcjM1Ccbd3H2NsG28qCnRwABd+nSmZtl0KZZmJPmWtbBcAHPV1A/yb/JBlPKU4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757726046; c=relaxed/simple;
	bh=62K0YkfDdlhI1a+nelUifSqHM+TzXEz2TygIEqrA7f8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bZroMu5b3fkHBsP6LeuWK+G5AFPkS45yRkAGFD0xlAsniVIIgsJe7n6tQ1EnISGrvXIwM443/8LS8W9SF42rGvVrd+nRcOWzGI5HlwHEKPAYOfzo4y4RnhPZVdFQxyTso63OiunsA6/BCHyrqnPYnPp/S9DLwPUvbt3REBfWc6M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FCNdTjNR; arc=none smtp.client-ip=209.85.218.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FCNdTjNR"
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-b07dac96d1eso101202066b.1
        for <patches@lists.linux.dev>; Fri, 12 Sep 2025 18:14:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757726041; x=1758330841; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XKplWAnltyYUA7miE90Ca2CY8VaXOWztn2OaioKTh7Y=;
        b=FCNdTjNRrnj/gFQLnbCNRATWOB7odNkXqg2wlnIDvYt8k03D+BARfizhi5HkBbnpJa
         4TecZUIcnjI5+RHavpEzlLKY9pu2l2/rkmuBHzWBdeaKvEZ9i+lZYDTNqRnHBecwq6mz
         ykXQdTF3ST2Zjn9Rxgd39VR4jvX3QMe5OHpI9CeG1EdVTcBjv6MUySMc0HkVXg3+Kt2n
         ZizL6D2gzfBkVbxRljdY4ptIp8Nh1gCwYf/cWkJS+QwZpRVumdut34BhvPFX60xdbw9C
         oIYj+/dd7hhBbObCzkV0/C5/vZHqglDj/HXVt8oHu/mqocc0hS6X1jLh27M1HEh6To+J
         L0iQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757726041; x=1758330841;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XKplWAnltyYUA7miE90Ca2CY8VaXOWztn2OaioKTh7Y=;
        b=m5bGWqzGpmB/uyJbAbUfGO4d17cWFB0Kn11qv3ELmZJC8NvvCvhdrqWQRm44MHNHTx
         2yqmS2NqeEVrzXH/cLnnklr40sdSy+NApB4PckBCwiamqEuLgejnYoP7wiwn5RpQ0n+e
         +MTljOCjpxs1PjZf+xHdcx2lmYtqXLBnAm+xBsPRW1iNjDmfHmGhKvvSI005kJq+Izq3
         FQu/t3DDr+yNuSyXj7E91pbSfRdVKE+mO3wx7zFKxRAgGL2XbKbHv38HTceZq0FVGrJ2
         7qQvFUSFqJpKY+l+WT8+AyT6xsTMv7v4k114V5pN65I3qavgtnrNgglT6EU3sWVfO7I2
         b5zQ==
X-Forwarded-Encrypted: i=1; AJvYcCXf2L9l5sHA1Xv6ADW09Bxg96asrQ4Wx602fWL2iZs2m9125kOBQ3r0W0mCT/Y2y0HWwBGp+hm2@lists.linux.dev
X-Gm-Message-State: AOJu0YxwOYsXfhaxWnYhCV2+0Gh3u0dix/IkYD6KmsAlyLx24gzuri4C
	jEUPyNgvNJpI6jQzC8t71P6WGuGwIg2dEwKnPJF07kDgeDwxl/tqIBCx
X-Gm-Gg: ASbGnct7Nc/3P66Eo1LtYH2FF8h/BPKkjreRIFwglc8ALJXGjSYwMQsiSLEMsp3qv+R
	pcGkHV55UjuABwaqYkn3opi6qp1wSa7bMf1P7/MAg50ZPbOCddQEY7ig1yR/oeg4uFzbFMz/ry6
	w5EeOPKxqVoepS6dWHX7YEnj4V4o0SCjXFV2alDhgG67C1e33PxZRrrsE06LMXexSbmoAZd+4Y6
	W5AO2DrFNgCmqe3TJXUTZXvrWo+qRx820MqQ96rYq57hbR4Ip9c0YIB83yU7v2mVpBjjlIjeQKO
	56iwuEkA3v1bpHMvnwlflI0lq7fy71jb48OPgeFZPKLmGt3RuZfkXcZaWKZQN/R0Fy+ZiymaNa6
	RiWwhByrnywWhJ3VZ3go=
X-Google-Smtp-Source: AGHT+IEnK8aPf5G48k9Kvznzx9z/ncVW6jv1PE49Xay12m4larnapJ0sjzKIoAPfuRHHNKc71/ZXZg==
X-Received: by 2002:a17:907:86a7:b0:afe:8420:1152 with SMTP id a640c23a62f3a-b07a6490897mr877727966b.18.1757726040472;
        Fri, 12 Sep 2025 18:14:00 -0700 (PDT)
Received: from localhost ([212.73.77.104])
        by smtp.gmail.com with UTF8SMTPSA id a640c23a62f3a-b07b3128a1esm461508066b.29.2025.09.12.18.13.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Sep 2025 18:13:59 -0700 (PDT)
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
Subject: [PATCH RESEND 31/62] init: rename initrd_below_start_ok to initramfs_below_start_ok
Date: Sat, 13 Sep 2025 00:38:10 +0000
Message-ID: <20250913003842.41944-32-safinaskar@gmail.com>
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

It refers to initramfs, not to initrd

Signed-off-by: Askar Safin <safinaskar@gmail.com>
---
 arch/csky/kernel/setup.c     | 2 +-
 arch/mips/kernel/setup.c     | 2 +-
 arch/openrisc/kernel/setup.c | 2 +-
 arch/parisc/mm/init.c        | 2 +-
 arch/xtensa/kernel/setup.c   | 4 ++--
 drivers/of/fdt.c             | 2 +-
 include/linux/initrd.h       | 2 +-
 init/do_mounts_initrd.c      | 2 +-
 init/initramfs.c             | 2 +-
 init/main.c                  | 2 +-
 10 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/arch/csky/kernel/setup.c b/arch/csky/kernel/setup.c
index ce128888462e..403a977b8c1f 100644
--- a/arch/csky/kernel/setup.c
+++ b/arch/csky/kernel/setup.c
@@ -40,7 +40,7 @@ static void __init setup_initrd(void)
 	pr_info("Initial ramdisk at: 0x%p (%lu bytes)\n",
 		(void *)(virt_external_initramfs_start), size);
 
-	initrd_below_start_ok = 1;
+	initramfs_below_start_ok = 1;
 
 	return;
 
diff --git a/arch/mips/kernel/setup.c b/arch/mips/kernel/setup.c
index da11ae875539..aed454ebd751 100644
--- a/arch/mips/kernel/setup.c
+++ b/arch/mips/kernel/setup.c
@@ -225,7 +225,7 @@ static void __init finalize_initrd(void)
 	maybe_bswap_initrd();
 
 	memblock_reserve(__pa(virt_external_initramfs_start), size);
-	initrd_below_start_ok = 1;
+	initramfs_below_start_ok = 1;
 
 	pr_info("Initial ramdisk at: 0x%lx (%lu bytes)\n",
 		virt_external_initramfs_start, size);
diff --git a/arch/openrisc/kernel/setup.c b/arch/openrisc/kernel/setup.c
index f387dc57ec35..337a0381c452 100644
--- a/arch/openrisc/kernel/setup.c
+++ b/arch/openrisc/kernel/setup.c
@@ -246,7 +246,7 @@ void __init setup_arch(char **cmdline_p)
 	} else {
 		printk(KERN_INFO "Initial ramdisk at: 0x%p (%lu bytes)\n",
 		       (void *)(virt_external_initramfs_start), virt_external_initramfs_end - virt_external_initramfs_start);
-		initrd_below_start_ok = 1;
+		initramfs_below_start_ok = 1;
 	}
 #endif
 
diff --git a/arch/parisc/mm/init.c b/arch/parisc/mm/init.c
index 74bfe9797589..af7a33c8bd31 100644
--- a/arch/parisc/mm/init.c
+++ b/arch/parisc/mm/init.c
@@ -308,7 +308,7 @@ static void __init setup_bootmem(void)
 			} else {
 				initrd_reserve = virt_external_initramfs_end - virt_external_initramfs_start;
 			}
-			initrd_below_start_ok = 1;
+			initramfs_below_start_ok = 1;
 			printk(KERN_INFO "initrd: reserving %08lx-%08lx (mem_max %08lx)\n", __pa(virt_external_initramfs_start), __pa(virt_external_initramfs_start) + initrd_reserve, mem_max);
 
 			memblock_reserve(__pa(virt_external_initramfs_start), initrd_reserve);
diff --git a/arch/xtensa/kernel/setup.c b/arch/xtensa/kernel/setup.c
index 2e9003be3e8c..b86367178bce 100644
--- a/arch/xtensa/kernel/setup.c
+++ b/arch/xtensa/kernel/setup.c
@@ -51,7 +51,7 @@
 #ifdef CONFIG_BLK_DEV_INITRD
 extern unsigned long virt_external_initramfs_start;
 extern unsigned long virt_external_initramfs_end;
-extern int initrd_below_start_ok;
+extern int initramfs_below_start_ok;
 #endif
 
 #ifdef CONFIG_USE_OF
@@ -292,7 +292,7 @@ void __init setup_arch(char **cmdline_p)
 #ifdef CONFIG_BLK_DEV_INITRD
 	if (virt_external_initramfs_start < virt_external_initramfs_end &&
 	    !mem_reserve(__pa(virt_external_initramfs_start), __pa(virt_external_initramfs_end)))
-		initrd_below_start_ok = 1;
+		initramfs_below_start_ok = 1;
 	else
 		virt_external_initramfs_start = 0;
 #endif
diff --git a/drivers/of/fdt.c b/drivers/of/fdt.c
index baf8347e0314..127b37f211cb 100644
--- a/drivers/of/fdt.c
+++ b/drivers/of/fdt.c
@@ -767,7 +767,7 @@ static void __early_init_dt_declare_initrd(unsigned long start,
 	    !(IS_ENABLED(CONFIG_RISCV) && IS_ENABLED(CONFIG_64BIT))) {
 		virt_external_initramfs_start = (unsigned long)__va(start);
 		virt_external_initramfs_end = (unsigned long)__va(end);
-		initrd_below_start_ok = 1;
+		initramfs_below_start_ok = 1;
 	}
 }
 
diff --git a/include/linux/initrd.h b/include/linux/initrd.h
index f19efebe8221..364b603215ac 100644
--- a/include/linux/initrd.h
+++ b/include/linux/initrd.h
@@ -4,7 +4,7 @@
 #define __LINUX_INITRD_H
 
 /* 1 if it is not an error if virt_external_initramfs_start < memory_start */
-extern int initrd_below_start_ok;
+extern int initramfs_below_start_ok;
 
 extern unsigned long virt_external_initramfs_start, virt_external_initramfs_end;
 extern void free_initrd_mem(unsigned long, unsigned long);
diff --git a/init/do_mounts_initrd.c b/init/do_mounts_initrd.c
index 535ce459ab94..d8b809ced11b 100644
--- a/init/do_mounts_initrd.c
+++ b/init/do_mounts_initrd.c
@@ -12,7 +12,7 @@
 
 #include "do_mounts.h"
 
-int initrd_below_start_ok;
+int initramfs_below_start_ok;
 
 static int __init early_initrdmem(char *p)
 {
diff --git a/init/initramfs.c b/init/initramfs.c
index d2301cc6c470..a9c5d211665d 100644
--- a/init/initramfs.c
+++ b/init/initramfs.c
@@ -643,7 +643,7 @@ void __init reserve_initrd_mem(void)
 	/* Now convert initrd to virtual addresses */
 	virt_external_initramfs_start = (unsigned long)__va(phys_external_initramfs_start);
 	virt_external_initramfs_end = virt_external_initramfs_start + phys_external_initramfs_size;
-	initrd_below_start_ok = 1;
+	initramfs_below_start_ok = 1;
 
 	return;
 disable:
diff --git a/init/main.c b/init/main.c
index 5f4d860ab72a..58a7199c81f7 100644
--- a/init/main.c
+++ b/init/main.c
@@ -1047,7 +1047,7 @@ void start_kernel(void)
 	locking_selftest();
 
 #ifdef CONFIG_BLK_DEV_INITRD
-	if (virt_external_initramfs_start && !initrd_below_start_ok &&
+	if (virt_external_initramfs_start && !initramfs_below_start_ok &&
 	    page_to_pfn(virt_to_page((void *)virt_external_initramfs_start)) < min_low_pfn) {
 		pr_crit("initrd overwritten (0x%08lx < 0x%08lx) - disabling it.\n",
 		    page_to_pfn(virt_to_page((void *)virt_external_initramfs_start)),
-- 
2.47.2

