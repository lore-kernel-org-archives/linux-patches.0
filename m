Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CDEB26E6F3
	for <patches@lists.linux.dev>; Sun, 14 Sep 2025 04:04:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757822667; cv=none; b=SzIkcRz60HkrBNHC7hZzhgkA6AjPelGZ3UriruDXpmLyOTC7/U8XN+jvozeoIiMSm9Z0ZR2Nd1qGHVDzzqOYti9qyVxrjjy+KefJFMKwFNqOEMS7CHUaf6w2j/0iXDrM0omarqYqMCVVVdPyKVxVmDnBy+jsCC3iH0pLP15v4ik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757822667; c=relaxed/simple;
	bh=CLKN0vFxPTCS+4xpoDHyCjYmZBC4ifFWYJ0ane4ULJI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MgCzOp4578/A9lDLXHnkpBGuydSdXyUImbIMpTH5KqKBEYWvxB2LmopLVYiNI91J4C7QrEanw4xJJELomRi5XM2C9C11cdpo5OgWXMu8ZHBsWhaLSpQ+xPLcFdkn+8/Qn5IZUKGF2yp2S3UuiWv9E9oP6Mn5g3KK8wXH3UIdJiQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jboY+WWz; arc=none smtp.client-ip=209.85.218.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jboY+WWz"
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-b0787fc3008so458213566b.3
        for <patches@lists.linux.dev>; Sat, 13 Sep 2025 21:04:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757822661; x=1758427461; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zQmt9Zed9iIletHUt2qeYNjKhIuvjCTi/Cw19xUj63o=;
        b=jboY+WWzvV1vE9L6Awa8NeyPWSjdSbJnJz4pvCnXN6gv6DvI7GfdZXJQr1jVyCxiqu
         tWlLL80Z/4zDVVrXLkQaTETL6Zcm1L0H3hHWles8F1YboDIyME5V0AeyWgQR36MtewYE
         /Re0rfCZobYh1YzYfgiKpiTx7kzfaanBJhMiIxWbdk7btAreCtKfJYo0dAWEa59+6hKl
         xg+l2FH4NtqHxB9PRCrLrCfNVRNJGeBS6bndW81lhE0jwZt32ONPZuTvpyYhbj+DCd8w
         eIex5FJdsBV7RyeyB/hhAKWm7oIjHLernc5yxrQH9tq7BiBC+DG/UCkZZT9itTT9C9Cc
         rzWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757822661; x=1758427461;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zQmt9Zed9iIletHUt2qeYNjKhIuvjCTi/Cw19xUj63o=;
        b=eLJXDjvx3x5H+Ib15VmljlVz3LTOvUI5HZWSjBB4x6NT1S1Z1dpU9XJ9aVzF9V3t/W
         hBxbM3qllJ0oHbI791TMaMc9sC80V+BSuG2MdkrRFOQfcRnVN7FPCL99YKDDMaPHtSi5
         a8LtnWgZ5EsGvQsif/Tt+iRV66fLkqxmd6GfLn/vabJ7qZy07kOOiPoKQHfjwKmbssr3
         gTtO4aVH3C531M4TxcunIZxkG94bSqPqxwM3oVVvq4JCHPEbIKCMpIBp2VrI/FfdEpnr
         ei6N4HdUdcFgV5nTXfmG9PsmSe5O/j0d8nXJnnUUXkb6tHbC5GSArOxeN90Unf3nE3rj
         LGMg==
X-Forwarded-Encrypted: i=1; AJvYcCXO06oHYKefiSfqF6nRuhDaDhcRUVlGO3As6NC7elvcp+GjfGfovETlPpX5ZlADX7XFUO455eH1@lists.linux.dev
X-Gm-Message-State: AOJu0YzCiOCeldzmcSeGxIUOC98EHGy1wKOP4o6np9dvwdpQRhPzfxDw
	tJAsFN7Kd7kcEfoIm6fox3eSO71FmJP8PugWKuep4zGd7m/Y/PZUdKXu
X-Gm-Gg: ASbGncuEEhOsEyyXPBFFiOFIivMM3aehKjaZ5EvFoAJhUD9uTau3gAHT3ks+J+ba5nI
	OZT0UFU8FujIUwW8I9lJCjWyrpng0l9TN4RlWnlRuB+aocJx2A5YBJkMmtyzxYL2jkjJiNwrmsH
	PdQl+xiLgG2DzHMHTUp6XxpFIgwtDmcOBHIUjQBLKmbgsgG7c/C2T7A5/k4Ipc9cuwiQZTk8n1n
	AeJ9ec+ehogPceAJjSv9IraEBYdpEfCK1WCAVOiEcS7LXXbK1YmLXnoXwZLb0SNxGbyEF2Hf5OE
	qRF48FOX2D/5mczadJ1QjqtL5dERsiD1T+4moBtd6mHiwgD6CgQ9U/GEUWiVyXzkVNza1/Kch1D
	u0fLdYComCxrkSTcPgnFmd+YPcZPMVQ==
X-Google-Smtp-Source: AGHT+IHaFT6KFwuX+yIp0UoOdQj6J/d/IOTebo0H4gG0vMFBsMmT50PoMXVLJ+eEN7aUH8ZQwvBwiA==
X-Received: by 2002:a17:907:3ea6:b0:b09:48c6:b7b0 with SMTP id a640c23a62f3a-b0948c6c713mr431888166b.56.1757822661177;
        Sat, 13 Sep 2025 21:04:21 -0700 (PDT)
Received: from localhost ([212.73.77.104])
        by smtp.gmail.com with UTF8SMTPSA id a640c23a62f3a-b07b32dd57csm669318166b.52.2025.09.13.21.04.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 13 Sep 2025 21:04:20 -0700 (PDT)
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
Subject: [PATCH RESEND 61/62] init: rename CONFIG_RD_LZ4 to CONFIG_INITRAMFS_DECOMPRESS_LZ4
Date: Sun, 14 Sep 2025 07:04:15 +0300
Message-ID: <20250914040416.3840072-1-safinaskar@gmail.com>
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
and CONFIG_RD_LZ4 has nothing to do with ramdisks.

Update your configs

Signed-off-by: Askar Safin <safinaskar@gmail.com>
---
 arch/arm/configs/aspeed_g4_defconfig       | 2 +-
 arch/arm/configs/aspeed_g5_defconfig       | 2 +-
 arch/arm/configs/lpc18xx_defconfig         | 2 +-
 arch/arm/configs/sp7021_defconfig          | 2 +-
 arch/arm/configs/vf610m4_defconfig         | 2 +-
 arch/mips/configs/ath25_defconfig          | 2 +-
 arch/mips/configs/bmips_stb_defconfig      | 2 +-
 arch/openrisc/configs/simple_smp_defconfig | 2 +-
 arch/powerpc/configs/44x/fsp2_defconfig    | 2 +-
 arch/powerpc/configs/skiroot_defconfig     | 2 +-
 arch/riscv/configs/nommu_k210_defconfig    | 2 +-
 arch/riscv/configs/nommu_virt_defconfig    | 2 +-
 arch/xtensa/configs/cadence_csp_defconfig  | 2 +-
 arch/xtensa/configs/nommu_kc705_defconfig  | 2 +-
 usr/Kconfig                                | 4 ++--
 15 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/arch/arm/configs/aspeed_g4_defconfig b/arch/arm/configs/aspeed_g4_defconfig
index 2b22ce99e42d..a65bdc6e6c2f 100644
--- a/arch/arm/configs/aspeed_g4_defconfig
+++ b/arch/arm/configs/aspeed_g4_defconfig
@@ -11,7 +11,7 @@ CONFIG_NAMESPACES=y
 CONFIG_INITRAMFS=y
 # CONFIG_INITRAMFS_DECOMPRESS_BZIP2 is not set
 # CONFIG_INITRAMFS_DECOMPRESS_LZO is not set
-# CONFIG_RD_LZ4 is not set
+# CONFIG_INITRAMFS_DECOMPRESS_LZ4 is not set
 CONFIG_EXPERT=y
 # CONFIG_UID16 is not set
 # CONFIG_SYSFS_SYSCALL is not set
diff --git a/arch/arm/configs/aspeed_g5_defconfig b/arch/arm/configs/aspeed_g5_defconfig
index 764fde3d416b..24954645c34f 100644
--- a/arch/arm/configs/aspeed_g5_defconfig
+++ b/arch/arm/configs/aspeed_g5_defconfig
@@ -11,7 +11,7 @@ CONFIG_NAMESPACES=y
 CONFIG_INITRAMFS=y
 # CONFIG_INITRAMFS_DECOMPRESS_BZIP2 is not set
 # CONFIG_INITRAMFS_DECOMPRESS_LZO is not set
-# CONFIG_RD_LZ4 is not set
+# CONFIG_INITRAMFS_DECOMPRESS_LZ4 is not set
 CONFIG_EXPERT=y
 # CONFIG_UID16 is not set
 # CONFIG_SYSFS_SYSCALL is not set
diff --git a/arch/arm/configs/lpc18xx_defconfig b/arch/arm/configs/lpc18xx_defconfig
index b14ebbe5b023..4dee6346a6a8 100644
--- a/arch/arm/configs/lpc18xx_defconfig
+++ b/arch/arm/configs/lpc18xx_defconfig
@@ -5,7 +5,7 @@ CONFIG_INITRAMFS=y
 # CONFIG_INITRAMFS_DECOMPRESS_LZMA is not set
 # CONFIG_INITRAMFS_DECOMPRESS_XZ is not set
 # CONFIG_INITRAMFS_DECOMPRESS_LZO is not set
-# CONFIG_RD_LZ4 is not set
+# CONFIG_INITRAMFS_DECOMPRESS_LZ4 is not set
 CONFIG_CC_OPTIMIZE_FOR_SIZE=y
 # CONFIG_UID16 is not set
 CONFIG_BASE_SMALL=y
diff --git a/arch/arm/configs/sp7021_defconfig b/arch/arm/configs/sp7021_defconfig
index e65c94f24341..6b1166cbf478 100644
--- a/arch/arm/configs/sp7021_defconfig
+++ b/arch/arm/configs/sp7021_defconfig
@@ -10,7 +10,7 @@ CONFIG_LOG_BUF_SHIFT=14
 # CONFIG_INITRAMFS_DECOMPRESS_LZMA is not set
 # CONFIG_INITRAMFS_DECOMPRESS_XZ is not set
 # CONFIG_INITRAMFS_DECOMPRESS_LZO is not set
-# CONFIG_RD_LZ4 is not set
+# CONFIG_INITRAMFS_DECOMPRESS_LZ4 is not set
 CONFIG_CC_OPTIMIZE_FOR_SIZE=y
 CONFIG_PERF_EVENTS=y
 CONFIG_ARCH_SUNPLUS=y
diff --git a/arch/arm/configs/vf610m4_defconfig b/arch/arm/configs/vf610m4_defconfig
index 7d457a196dfc..acec039e2f16 100644
--- a/arch/arm/configs/vf610m4_defconfig
+++ b/arch/arm/configs/vf610m4_defconfig
@@ -3,7 +3,7 @@ CONFIG_INITRAMFS=y
 # CONFIG_INITRAMFS_DECOMPRESS_BZIP2 is not set
 # CONFIG_INITRAMFS_DECOMPRESS_LZMA is not set
 # CONFIG_INITRAMFS_DECOMPRESS_XZ is not set
-# CONFIG_RD_LZ4 is not set
+# CONFIG_INITRAMFS_DECOMPRESS_LZ4 is not set
 CONFIG_EXPERT=y
 CONFIG_KALLSYMS_ALL=y
 # CONFIG_MMU is not set
diff --git a/arch/mips/configs/ath25_defconfig b/arch/mips/configs/ath25_defconfig
index baf32dfe8295..5e84ee24e372 100644
--- a/arch/mips/configs/ath25_defconfig
+++ b/arch/mips/configs/ath25_defconfig
@@ -7,7 +7,7 @@ CONFIG_INITRAMFS=y
 # CONFIG_INITRAMFS_DECOMPRESS_BZIP2 is not set
 # CONFIG_INITRAMFS_DECOMPRESS_XZ is not set
 # CONFIG_INITRAMFS_DECOMPRESS_LZO is not set
-# CONFIG_RD_LZ4 is not set
+# CONFIG_INITRAMFS_DECOMPRESS_LZ4 is not set
 CONFIG_CC_OPTIMIZE_FOR_SIZE=y
 # CONFIG_FHANDLE is not set
 # CONFIG_AIO is not set
diff --git a/arch/mips/configs/bmips_stb_defconfig b/arch/mips/configs/bmips_stb_defconfig
index 44830de10527..b5fb138bf237 100644
--- a/arch/mips/configs/bmips_stb_defconfig
+++ b/arch/mips/configs/bmips_stb_defconfig
@@ -19,7 +19,7 @@ CONFIG_MIPS_O32_FP64_SUPPORT=y
 # CONFIG_INITRAMFS_DECOMPRESS_LZMA is not set
 CONFIG_INITRAMFS_DECOMPRESS_XZ=y
 # CONFIG_INITRAMFS_DECOMPRESS_LZO is not set
-# CONFIG_RD_LZ4 is not set
+# CONFIG_INITRAMFS_DECOMPRESS_LZ4 is not set
 CONFIG_PCI=y
 CONFIG_PCI_MSI=y
 CONFIG_PCIEASPM_POWERSAVE=y
diff --git a/arch/openrisc/configs/simple_smp_defconfig b/arch/openrisc/configs/simple_smp_defconfig
index 9f4bb9d940f0..5265f6f940a5 100644
--- a/arch/openrisc/configs/simple_smp_defconfig
+++ b/arch/openrisc/configs/simple_smp_defconfig
@@ -7,7 +7,7 @@ CONFIG_INITRAMFS=y
 # CONFIG_INITRAMFS_DECOMPRESS_LZMA is not set
 # CONFIG_INITRAMFS_DECOMPRESS_XZ is not set
 # CONFIG_INITRAMFS_DECOMPRESS_LZO is not set
-# CONFIG_RD_LZ4 is not set
+# CONFIG_INITRAMFS_DECOMPRESS_LZ4 is not set
 CONFIG_EXPERT=y
 # CONFIG_KALLSYMS is not set
 # CONFIG_EPOLL is not set
diff --git a/arch/powerpc/configs/44x/fsp2_defconfig b/arch/powerpc/configs/44x/fsp2_defconfig
index e5e4f6721728..34486aa5155f 100644
--- a/arch/powerpc/configs/44x/fsp2_defconfig
+++ b/arch/powerpc/configs/44x/fsp2_defconfig
@@ -12,7 +12,7 @@ CONFIG_INITRAMFS=y
 # CONFIG_INITRAMFS_DECOMPRESS_LZMA is not set
 # CONFIG_INITRAMFS_DECOMPRESS_XZ is not set
 # CONFIG_INITRAMFS_DECOMPRESS_LZO is not set
-# CONFIG_RD_LZ4 is not set
+# CONFIG_INITRAMFS_DECOMPRESS_LZ4 is not set
 CONFIG_KALLSYMS_ALL=y
 CONFIG_BPF_SYSCALL=y
 CONFIG_EXPERT=y
diff --git a/arch/powerpc/configs/skiroot_defconfig b/arch/powerpc/configs/skiroot_defconfig
index fc1a718af17a..d159882484f6 100644
--- a/arch/powerpc/configs/skiroot_defconfig
+++ b/arch/powerpc/configs/skiroot_defconfig
@@ -14,7 +14,7 @@ CONFIG_INITRAMFS=y
 # CONFIG_INITRAMFS_DECOMPRESS_BZIP2 is not set
 # CONFIG_INITRAMFS_DECOMPRESS_LZMA is not set
 # CONFIG_INITRAMFS_DECOMPRESS_LZO is not set
-# CONFIG_RD_LZ4 is not set
+# CONFIG_INITRAMFS_DECOMPRESS_LZ4 is not set
 CONFIG_CC_OPTIMIZE_FOR_SIZE=y
 CONFIG_EXPERT=y
 # CONFIG_SGETMASK_SYSCALL is not set
diff --git a/arch/riscv/configs/nommu_k210_defconfig b/arch/riscv/configs/nommu_k210_defconfig
index 7507045e9c4a..6e961256a941 100644
--- a/arch/riscv/configs/nommu_k210_defconfig
+++ b/arch/riscv/configs/nommu_k210_defconfig
@@ -6,7 +6,7 @@ CONFIG_INITRAMFS=y
 # CONFIG_INITRAMFS_DECOMPRESS_LZMA is not set
 # CONFIG_INITRAMFS_DECOMPRESS_XZ is not set
 # CONFIG_INITRAMFS_DECOMPRESS_LZO is not set
-# CONFIG_RD_LZ4 is not set
+# CONFIG_INITRAMFS_DECOMPRESS_LZ4 is not set
 # CONFIG_RD_ZSTD is not set
 CONFIG_CC_OPTIMIZE_FOR_SIZE=y
 # CONFIG_SYSFS_SYSCALL is not set
diff --git a/arch/riscv/configs/nommu_virt_defconfig b/arch/riscv/configs/nommu_virt_defconfig
index afa79217f06e..eb289c44dfc3 100644
--- a/arch/riscv/configs/nommu_virt_defconfig
+++ b/arch/riscv/configs/nommu_virt_defconfig
@@ -5,7 +5,7 @@ CONFIG_INITRAMFS=y
 # CONFIG_INITRAMFS_DECOMPRESS_LZMA is not set
 # CONFIG_INITRAMFS_DECOMPRESS_XZ is not set
 # CONFIG_INITRAMFS_DECOMPRESS_LZO is not set
-# CONFIG_RD_LZ4 is not set
+# CONFIG_INITRAMFS_DECOMPRESS_LZ4 is not set
 CONFIG_CC_OPTIMIZE_FOR_SIZE=y
 CONFIG_EXPERT=y
 # CONFIG_SYSFS_SYSCALL is not set
diff --git a/arch/xtensa/configs/cadence_csp_defconfig b/arch/xtensa/configs/cadence_csp_defconfig
index dad9383c6deb..26a4a9f3886a 100644
--- a/arch/xtensa/configs/cadence_csp_defconfig
+++ b/arch/xtensa/configs/cadence_csp_defconfig
@@ -18,7 +18,7 @@ CONFIG_INITRAMFS_SOURCE="$$KERNEL_INITRAMFS_SOURCE"
 # CONFIG_INITRAMFS_DECOMPRESS_LZMA is not set
 # CONFIG_INITRAMFS_DECOMPRESS_XZ is not set
 # CONFIG_INITRAMFS_DECOMPRESS_LZO is not set
-# CONFIG_RD_LZ4 is not set
+# CONFIG_INITRAMFS_DECOMPRESS_LZ4 is not set
 CONFIG_CC_OPTIMIZE_FOR_SIZE=y
 CONFIG_EXPERT=y
 CONFIG_PROFILING=y
diff --git a/arch/xtensa/configs/nommu_kc705_defconfig b/arch/xtensa/configs/nommu_kc705_defconfig
index 0a0e94ae7b1c..988998806661 100644
--- a/arch/xtensa/configs/nommu_kc705_defconfig
+++ b/arch/xtensa/configs/nommu_kc705_defconfig
@@ -19,7 +19,7 @@ CONFIG_INITRAMFS=y
 # CONFIG_INITRAMFS_DECOMPRESS_LZMA is not set
 # CONFIG_INITRAMFS_DECOMPRESS_XZ is not set
 # CONFIG_INITRAMFS_DECOMPRESS_LZO is not set
-# CONFIG_RD_LZ4 is not set
+# CONFIG_INITRAMFS_DECOMPRESS_LZ4 is not set
 CONFIG_EXPERT=y
 CONFIG_KALLSYMS_ALL=y
 CONFIG_PERF_EVENTS=y
diff --git a/usr/Kconfig b/usr/Kconfig
index 62c978018565..3a891a0c9ef4 100644
--- a/usr/Kconfig
+++ b/usr/Kconfig
@@ -92,7 +92,7 @@ config INITRAMFS_DECOMPRESS_LZO
 	  Support loading of a LZO encoded initial ramfs.
 	  If unsure, say N.
 
-config RD_LZ4
+config INITRAMFS_DECOMPRESS_LZ4
 	bool "Support initial ramfs compressed using LZ4"
 	default y
 	select DECOMPRESS_LZ4
@@ -195,7 +195,7 @@ config INITRAMFS_COMPRESSION_LZO
 
 config INITRAMFS_COMPRESSION_LZ4
 	bool "LZ4"
-	depends on RD_LZ4
+	depends on INITRAMFS_DECOMPRESS_LZ4
 	help
 	  It's compression ratio is the poorest amongst the choices. The kernel
 	  size is about 15% bigger than gzip; however its decompression speed
-- 
2.47.2

