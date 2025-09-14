Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 506642264C6
	for <patches@lists.linux.dev>; Sun, 14 Sep 2025 04:03:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757822630; cv=none; b=nWXYzmrqlieW/cbYxCC5NUMc+miqzS4Eq4L3CahGsTYV7YRRxyIHfVSK1C05mpuUfLk2wkqSeqdFrHZD2LN8gAlKPOMun9O0ch6rYEtPrq33U/hY2gcWNVJLT37S4vkfSfswGbknpSZfQkg/CTA+96ga5Q7cdjWClXEYgF/d2nA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757822630; c=relaxed/simple;
	bh=0pWVJOTP21rCoJtKKoUiFKXGaGdV+v1BFOeqtnNyxpM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YS3bJH2PWHAB3YjXOhA057iRLsa/5olSWs2dBPmEq49z9etcUN5tgTW5eArhWl5GY2Mj5nrNqZ+BO56aB/NQ+8SgScTk4O+UrdyaqtR5Mu2nx/mvT4iUgqQDWfeONGzJcvi+GiCn2eghongRzHPriwcGk5ZTzG6z18CLMPc91vM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cbMThkW6; arc=none smtp.client-ip=209.85.208.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cbMThkW6"
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-6228de280ccso6261479a12.3
        for <patches@lists.linux.dev>; Sat, 13 Sep 2025 21:03:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757822626; x=1758427426; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VsOamTozKEbtevaUIkeHFHddobOLWaVp/WNglpXBTPs=;
        b=cbMThkW68y2UWlO1BG/Wafr57SQlyAFCBndQv69TN4VhHaGroZcXhqahNZXtGeKxfL
         sNiceh7S1lIkL2rIuPg9INGA0j2RlT0oC3BoGkr8cLx5IGZp3EgF962OvEZ6GxJBtvYu
         w0yHmaON1rI3AK8Hpfl+ZNCQV/MJp6TZo4LUUNPZdc4DDumv177w1kkaKdd8lfZpn4dt
         ue6UEJ8p1bVg+Jjv4WTqbLGmEdC/dYV4voO6tFNG2QqL7Y2HP7CDN+HZj4PFCrhniJDP
         vjWjSyKo/5nn4yBr49tysDSQzcl4bQ8hQGprdBQnngxxAeLMkxhDC1WAHlAcnGXJ20t/
         VNqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757822626; x=1758427426;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VsOamTozKEbtevaUIkeHFHddobOLWaVp/WNglpXBTPs=;
        b=HRSm0up+Fwo2m0SGfgmfJ/QEi/Sitq92vMwwzjNg39GwACwLY8k+p0gxPJ18sMNq9I
         QZVyjPZ2N5J8w9isx2skvjondQ+UxNtcXnyas/KjrvQ5wKpudt+8CvDUdCNewtJXWWay
         2TckC5tSxLSftqy4bgvX3CuU9kPaQeob9ATwzGGpTlYacDqDhzUWOXObX48BdKz+SK1d
         t4Xrxirr9Tf1CYjoKl+Ls8j3Hti5AL6TV23oLqQRblt9BIGj3MwgwdM2sWICzsumUZee
         BBIuf+dEYDoHYwHmF1544rfpDEq9PFsy13w90TgKoKMkYxGiNdvm68Zt8QjX9JsM7rIR
         ilwA==
X-Forwarded-Encrypted: i=1; AJvYcCXoD2HmL5qF2LBlud1hhars+CTKXugJs5krHNPdiyZEdaPlLAUMkEUK7Pmj8mTwM2UoK5COMlqm@lists.linux.dev
X-Gm-Message-State: AOJu0Yzqsj3dAsLjw9K9V+OTi3qXzUE00AooipZDz4xtzXTfQud3DbKZ
	LuvcjaWnZQgFZXy+OQM6INvvE+9t0J6jz0wx/5YFPvLVf97KVK8ZsPmx
X-Gm-Gg: ASbGncu8UF1rho0raceus5kWY5BqDpPS17y40oS0KJB0efPEcYtISXm0Fc2QMSYoory
	d8cxAqtxnYHAlM54QapsGQWaJWXPjOWG4rtdGXIFgyUXQovM92RIY1cCbaDAyeLHVa4SKk4MnhE
	zZhBLdr7NHseiyAzq6Gu4sAiVPyGXz7qygIq4+K5OCjoET1wVLxdNu4Xnb7RYgFQ1Xf1vfDxEyI
	9ZOnqo9aECquMgCb5AD/ALTOxyA6uKixRDy0wZ7DUPnjdM4m0ZwGOMXiAVYHkpPf8ooY3uoNaiJ
	QoAgUeCRxk/hupMPfaKubh9RjysiUCWBHS75cB3vqzX4uKejHujr+YLtczQRhu8s0E4X2dzOiHr
	TGs8QpdYldt5VBglVKZk=
X-Google-Smtp-Source: AGHT+IGIk0SwDpnTjpBVT7sJgIMOGKNGXW+rOPL9oM2bCvwkhtwd2LPazr69GK44eCdlALX7ivqu/A==
X-Received: by 2002:a05:6402:2341:b0:628:66cd:d839 with SMTP id 4fb4d7f45d1cf-62ed82599aemr7456895a12.7.1757822625662;
        Sat, 13 Sep 2025 21:03:45 -0700 (PDT)
Received: from localhost ([212.73.77.104])
        by smtp.gmail.com with UTF8SMTPSA id 4fb4d7f45d1cf-62f2e1d5b5bsm463001a12.3.2025.09.13.21.03.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 13 Sep 2025 21:03:44 -0700 (PDT)
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
Subject: [PATCH RESEND 60/62] init: rename CONFIG_RD_LZO to CONFIG_INITRAMFS_DECOMPRESS_LZO
Date: Sun, 14 Sep 2025 07:03:39 +0300
Message-ID: <20250914040339.3831241-1-safinaskar@gmail.com>
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

Initrd support was removed,
and CONFIG_RD_LZO has nothing to do with ramdisks.

Update your configs

Signed-off-by: Askar Safin <safinaskar@gmail.com>
---
 arch/arm/configs/aspeed_g4_defconfig       | 2 +-
 arch/arm/configs/aspeed_g5_defconfig       | 2 +-
 arch/arm/configs/lpc18xx_defconfig         | 2 +-
 arch/arm/configs/sp7021_defconfig          | 2 +-
 arch/mips/configs/ath25_defconfig          | 2 +-
 arch/mips/configs/bmips_stb_defconfig      | 2 +-
 arch/openrisc/configs/simple_smp_defconfig | 2 +-
 arch/powerpc/configs/44x/fsp2_defconfig    | 2 +-
 arch/powerpc/configs/skiroot_defconfig     | 2 +-
 arch/riscv/configs/nommu_k210_defconfig    | 2 +-
 arch/riscv/configs/nommu_virt_defconfig    | 2 +-
 arch/sh/configs/sdk7786_defconfig          | 2 +-
 arch/xtensa/configs/cadence_csp_defconfig  | 2 +-
 arch/xtensa/configs/nommu_kc705_defconfig  | 2 +-
 usr/Kconfig                                | 4 ++--
 15 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/arch/arm/configs/aspeed_g4_defconfig b/arch/arm/configs/aspeed_g4_defconfig
index af891a2b2d6c..2b22ce99e42d 100644
--- a/arch/arm/configs/aspeed_g4_defconfig
+++ b/arch/arm/configs/aspeed_g4_defconfig
@@ -10,7 +10,7 @@ CONFIG_CGROUPS=y
 CONFIG_NAMESPACES=y
 CONFIG_INITRAMFS=y
 # CONFIG_INITRAMFS_DECOMPRESS_BZIP2 is not set
-# CONFIG_RD_LZO is not set
+# CONFIG_INITRAMFS_DECOMPRESS_LZO is not set
 # CONFIG_RD_LZ4 is not set
 CONFIG_EXPERT=y
 # CONFIG_UID16 is not set
diff --git a/arch/arm/configs/aspeed_g5_defconfig b/arch/arm/configs/aspeed_g5_defconfig
index a16aed0abcaa..764fde3d416b 100644
--- a/arch/arm/configs/aspeed_g5_defconfig
+++ b/arch/arm/configs/aspeed_g5_defconfig
@@ -10,7 +10,7 @@ CONFIG_CGROUPS=y
 CONFIG_NAMESPACES=y
 CONFIG_INITRAMFS=y
 # CONFIG_INITRAMFS_DECOMPRESS_BZIP2 is not set
-# CONFIG_RD_LZO is not set
+# CONFIG_INITRAMFS_DECOMPRESS_LZO is not set
 # CONFIG_RD_LZ4 is not set
 CONFIG_EXPERT=y
 # CONFIG_UID16 is not set
diff --git a/arch/arm/configs/lpc18xx_defconfig b/arch/arm/configs/lpc18xx_defconfig
index 816586530ff5..b14ebbe5b023 100644
--- a/arch/arm/configs/lpc18xx_defconfig
+++ b/arch/arm/configs/lpc18xx_defconfig
@@ -4,7 +4,7 @@ CONFIG_INITRAMFS=y
 # CONFIG_INITRAMFS_DECOMPRESS_BZIP2 is not set
 # CONFIG_INITRAMFS_DECOMPRESS_LZMA is not set
 # CONFIG_INITRAMFS_DECOMPRESS_XZ is not set
-# CONFIG_RD_LZO is not set
+# CONFIG_INITRAMFS_DECOMPRESS_LZO is not set
 # CONFIG_RD_LZ4 is not set
 CONFIG_CC_OPTIMIZE_FOR_SIZE=y
 # CONFIG_UID16 is not set
diff --git a/arch/arm/configs/sp7021_defconfig b/arch/arm/configs/sp7021_defconfig
index 2d9bbda67e85..e65c94f24341 100644
--- a/arch/arm/configs/sp7021_defconfig
+++ b/arch/arm/configs/sp7021_defconfig
@@ -9,7 +9,7 @@ CONFIG_LOG_BUF_SHIFT=14
 # CONFIG_INITRAMFS_DECOMPRESS_BZIP2 is not set
 # CONFIG_INITRAMFS_DECOMPRESS_LZMA is not set
 # CONFIG_INITRAMFS_DECOMPRESS_XZ is not set
-# CONFIG_RD_LZO is not set
+# CONFIG_INITRAMFS_DECOMPRESS_LZO is not set
 # CONFIG_RD_LZ4 is not set
 CONFIG_CC_OPTIMIZE_FOR_SIZE=y
 CONFIG_PERF_EVENTS=y
diff --git a/arch/mips/configs/ath25_defconfig b/arch/mips/configs/ath25_defconfig
index e401b29ce706..baf32dfe8295 100644
--- a/arch/mips/configs/ath25_defconfig
+++ b/arch/mips/configs/ath25_defconfig
@@ -6,7 +6,7 @@ CONFIG_INITRAMFS=y
 # CONFIG_INITRAMFS_DECOMPRESS_GZIP is not set
 # CONFIG_INITRAMFS_DECOMPRESS_BZIP2 is not set
 # CONFIG_INITRAMFS_DECOMPRESS_XZ is not set
-# CONFIG_RD_LZO is not set
+# CONFIG_INITRAMFS_DECOMPRESS_LZO is not set
 # CONFIG_RD_LZ4 is not set
 CONFIG_CC_OPTIMIZE_FOR_SIZE=y
 # CONFIG_FHANDLE is not set
diff --git a/arch/mips/configs/bmips_stb_defconfig b/arch/mips/configs/bmips_stb_defconfig
index 072bfdc87771..44830de10527 100644
--- a/arch/mips/configs/bmips_stb_defconfig
+++ b/arch/mips/configs/bmips_stb_defconfig
@@ -18,7 +18,7 @@ CONFIG_MIPS_O32_FP64_SUPPORT=y
 # CONFIG_INITRAMFS_DECOMPRESS_BZIP2 is not set
 # CONFIG_INITRAMFS_DECOMPRESS_LZMA is not set
 CONFIG_INITRAMFS_DECOMPRESS_XZ=y
-# CONFIG_RD_LZO is not set
+# CONFIG_INITRAMFS_DECOMPRESS_LZO is not set
 # CONFIG_RD_LZ4 is not set
 CONFIG_PCI=y
 CONFIG_PCI_MSI=y
diff --git a/arch/openrisc/configs/simple_smp_defconfig b/arch/openrisc/configs/simple_smp_defconfig
index 7080bdedea01..9f4bb9d940f0 100644
--- a/arch/openrisc/configs/simple_smp_defconfig
+++ b/arch/openrisc/configs/simple_smp_defconfig
@@ -6,7 +6,7 @@ CONFIG_INITRAMFS=y
 # CONFIG_INITRAMFS_DECOMPRESS_BZIP2 is not set
 # CONFIG_INITRAMFS_DECOMPRESS_LZMA is not set
 # CONFIG_INITRAMFS_DECOMPRESS_XZ is not set
-# CONFIG_RD_LZO is not set
+# CONFIG_INITRAMFS_DECOMPRESS_LZO is not set
 # CONFIG_RD_LZ4 is not set
 CONFIG_EXPERT=y
 # CONFIG_KALLSYMS is not set
diff --git a/arch/powerpc/configs/44x/fsp2_defconfig b/arch/powerpc/configs/44x/fsp2_defconfig
index ffb345222649..e5e4f6721728 100644
--- a/arch/powerpc/configs/44x/fsp2_defconfig
+++ b/arch/powerpc/configs/44x/fsp2_defconfig
@@ -11,7 +11,7 @@ CONFIG_LOG_BUF_SHIFT=16
 CONFIG_INITRAMFS=y
 # CONFIG_INITRAMFS_DECOMPRESS_LZMA is not set
 # CONFIG_INITRAMFS_DECOMPRESS_XZ is not set
-# CONFIG_RD_LZO is not set
+# CONFIG_INITRAMFS_DECOMPRESS_LZO is not set
 # CONFIG_RD_LZ4 is not set
 CONFIG_KALLSYMS_ALL=y
 CONFIG_BPF_SYSCALL=y
diff --git a/arch/powerpc/configs/skiroot_defconfig b/arch/powerpc/configs/skiroot_defconfig
index 008a63a90330..fc1a718af17a 100644
--- a/arch/powerpc/configs/skiroot_defconfig
+++ b/arch/powerpc/configs/skiroot_defconfig
@@ -13,7 +13,7 @@ CONFIG_INITRAMFS=y
 # CONFIG_INITRAMFS_DECOMPRESS_GZIP is not set
 # CONFIG_INITRAMFS_DECOMPRESS_BZIP2 is not set
 # CONFIG_INITRAMFS_DECOMPRESS_LZMA is not set
-# CONFIG_RD_LZO is not set
+# CONFIG_INITRAMFS_DECOMPRESS_LZO is not set
 # CONFIG_RD_LZ4 is not set
 CONFIG_CC_OPTIMIZE_FOR_SIZE=y
 CONFIG_EXPERT=y
diff --git a/arch/riscv/configs/nommu_k210_defconfig b/arch/riscv/configs/nommu_k210_defconfig
index 10ffb9ea40bd..7507045e9c4a 100644
--- a/arch/riscv/configs/nommu_k210_defconfig
+++ b/arch/riscv/configs/nommu_k210_defconfig
@@ -5,7 +5,7 @@ CONFIG_INITRAMFS=y
 # CONFIG_INITRAMFS_DECOMPRESS_BZIP2 is not set
 # CONFIG_INITRAMFS_DECOMPRESS_LZMA is not set
 # CONFIG_INITRAMFS_DECOMPRESS_XZ is not set
-# CONFIG_RD_LZO is not set
+# CONFIG_INITRAMFS_DECOMPRESS_LZO is not set
 # CONFIG_RD_LZ4 is not set
 # CONFIG_RD_ZSTD is not set
 CONFIG_CC_OPTIMIZE_FOR_SIZE=y
diff --git a/arch/riscv/configs/nommu_virt_defconfig b/arch/riscv/configs/nommu_virt_defconfig
index 9383e3445ead..afa79217f06e 100644
--- a/arch/riscv/configs/nommu_virt_defconfig
+++ b/arch/riscv/configs/nommu_virt_defconfig
@@ -4,7 +4,7 @@ CONFIG_INITRAMFS=y
 # CONFIG_INITRAMFS_DECOMPRESS_BZIP2 is not set
 # CONFIG_INITRAMFS_DECOMPRESS_LZMA is not set
 # CONFIG_INITRAMFS_DECOMPRESS_XZ is not set
-# CONFIG_RD_LZO is not set
+# CONFIG_INITRAMFS_DECOMPRESS_LZO is not set
 # CONFIG_RD_LZ4 is not set
 CONFIG_CC_OPTIMIZE_FOR_SIZE=y
 CONFIG_EXPERT=y
diff --git a/arch/sh/configs/sdk7786_defconfig b/arch/sh/configs/sdk7786_defconfig
index f19e9915e6de..7465ebf36df2 100644
--- a/arch/sh/configs/sdk7786_defconfig
+++ b/arch/sh/configs/sdk7786_defconfig
@@ -29,7 +29,7 @@ CONFIG_NET_NS=y
 CONFIG_INITRAMFS=y
 CONFIG_INITRAMFS_DECOMPRESS_BZIP2=y
 CONFIG_INITRAMFS_DECOMPRESS_LZMA=y
-CONFIG_RD_LZO=y
+CONFIG_INITRAMFS_DECOMPRESS_LZO=y
 # CONFIG_COMPAT_BRK is not set
 CONFIG_PROFILING=y
 CONFIG_KPROBES=y
diff --git a/arch/xtensa/configs/cadence_csp_defconfig b/arch/xtensa/configs/cadence_csp_defconfig
index f102ed913e9b..dad9383c6deb 100644
--- a/arch/xtensa/configs/cadence_csp_defconfig
+++ b/arch/xtensa/configs/cadence_csp_defconfig
@@ -17,7 +17,7 @@ CONFIG_INITRAMFS_SOURCE="$$KERNEL_INITRAMFS_SOURCE"
 # CONFIG_INITRAMFS_DECOMPRESS_BZIP2 is not set
 # CONFIG_INITRAMFS_DECOMPRESS_LZMA is not set
 # CONFIG_INITRAMFS_DECOMPRESS_XZ is not set
-# CONFIG_RD_LZO is not set
+# CONFIG_INITRAMFS_DECOMPRESS_LZO is not set
 # CONFIG_RD_LZ4 is not set
 CONFIG_CC_OPTIMIZE_FOR_SIZE=y
 CONFIG_EXPERT=y
diff --git a/arch/xtensa/configs/nommu_kc705_defconfig b/arch/xtensa/configs/nommu_kc705_defconfig
index d3916408eaf6..0a0e94ae7b1c 100644
--- a/arch/xtensa/configs/nommu_kc705_defconfig
+++ b/arch/xtensa/configs/nommu_kc705_defconfig
@@ -18,7 +18,7 @@ CONFIG_INITRAMFS=y
 # CONFIG_INITRAMFS_DECOMPRESS_BZIP2 is not set
 # CONFIG_INITRAMFS_DECOMPRESS_LZMA is not set
 # CONFIG_INITRAMFS_DECOMPRESS_XZ is not set
-# CONFIG_RD_LZO is not set
+# CONFIG_INITRAMFS_DECOMPRESS_LZO is not set
 # CONFIG_RD_LZ4 is not set
 CONFIG_EXPERT=y
 CONFIG_KALLSYMS_ALL=y
diff --git a/usr/Kconfig b/usr/Kconfig
index 69f95a5a1847..62c978018565 100644
--- a/usr/Kconfig
+++ b/usr/Kconfig
@@ -84,7 +84,7 @@ config INITRAMFS_DECOMPRESS_XZ
 	  Support loading of a XZ encoded initial ramfs.
 	  If unsure, say N.
 
-config RD_LZO
+config INITRAMFS_DECOMPRESS_LZO
 	bool "Support initial ramfs compressed using LZO"
 	default y
 	select DECOMPRESS_LZO
@@ -183,7 +183,7 @@ config INITRAMFS_COMPRESSION_XZ
 
 config INITRAMFS_COMPRESSION_LZO
 	bool "LZO"
-	depends on RD_LZO
+	depends on INITRAMFS_DECOMPRESS_LZO
 	help
 	  Its compression ratio is the second poorest amongst the choices. The
 	  kernel size is about 10% bigger than gzip. Despite that, its
-- 
2.47.2

