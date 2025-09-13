Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F23A6A8D2
	for <patches@lists.linux.dev>; Sat, 13 Sep 2025 00:42:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757724137; cv=none; b=APL9akhZEG1JuNQwIk5/KQKH59S8tcrzXcYKPDKHl9wCYj8blntpMcxv8nReFBnaYhYmlkyn7Dwejp0e2dWjAtHdvKMVYEDWcHkXDoMpDawnrdhk1Pzur4YaZ6z0tLJc6HzUxYha4ezkJgpsMS9gg1jg0uqebi8yzOgsl5gwHj0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757724137; c=relaxed/simple;
	bh=e1WCcnLcnFd6vSa9GXhjG8apiPFNDP8cBSBGKhm1A0M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GHtcd1hHxsA04AEn+YGk4xnq9Cq2yagnsy74MIZwQBsHrP8zNS82t+ACB4+Ca6KQMg3qYLnjVoijFU9x6eMtazCQRcnOnIW8K/QJhTXFMm5kJBrYvFhvPbMDToILCuQmPxMQMEdY4h2iEQoH2FKO2BTk+EeSDil8+V04E+OYSDw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mmntSwgh; arc=none smtp.client-ip=209.85.208.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mmntSwgh"
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-62ed68313b6so2375544a12.3
        for <patches@lists.linux.dev>; Fri, 12 Sep 2025 17:42:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757724133; x=1758328933; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Iq4EBZrV1lfKd4Zb7NXCMDMChiW0nY1yh2iMeYqfP7Y=;
        b=mmntSwghVGc1lxlVVOvssJlhFv5WaOHCx3NAuJae41GOBrJHHiEO+v0jpoNGB958Tx
         H0ddP5O0wayg3EBFvUJBNqkDiJa/w2lJqzZxSuBm9m6wQJnhG9qFMDE0v+EBCGwLyxoK
         sK07kVmbftcbhnSvJJVhrT+w9OlYftmO67wCrUHm9F5Ifrtqr0ZrAZwHVNa24R59SF7l
         xNyBWdybRD+i6bNPwnOPhPmdkyexodAnzpJyRb2VDgUUQGbFhopWWoDn644r/PTEe5SP
         ghfgfglP5vREMHPXEL71+qLQ2frIhEHmFsU2FojOfVEgJ7rOf2rqHUTQDtzT8pqpBUMM
         j/6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757724133; x=1758328933;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Iq4EBZrV1lfKd4Zb7NXCMDMChiW0nY1yh2iMeYqfP7Y=;
        b=p52PrBfW1qfJSC+9XZgaBkHtBiuBvpqEywBhAhQeoORV/7eZTXcsR3aFsNg8F+8eqD
         JKNOr/yG5iqUO2zIAdsdzkN2UtRKi7NWCOCd/PBM4FN3fL26BK7E4be/87UVNZT4VYYG
         knO3WgZGp25U1X/2eda9wU5wN8AkXGGM4vl7jUt+cblUKG2q7NYJDVaFC8bpFQ/jxjqA
         eKXmcEorar1prmRpS03/z6X+VuYKhJwTG/pos3zBuaRfI/9sqrZFmIzecBGm7rSTu90g
         0MpzIdF4wylj6iM0D/IzBz/LhcvT4kwncIM0dh54sWxluQKV5pj8Wgsag/cslLNxi6u3
         rfJg==
X-Forwarded-Encrypted: i=1; AJvYcCVn735E4LJRPtB0hXLYG02UQCTPDDiWvGaF4XaNvb3haYoZMHlvdziHZGIw8foe2UVUtZTPmuLK@lists.linux.dev
X-Gm-Message-State: AOJu0Yy+Hc9tDheuU1HdQ/gbhsaQ3ctfhA+P1RQqtHi5p3W87IEKzTWR
	JDQa8d3FNS0FYZcTZ306S//qZMi4ZfTf31eTiohO07G75Ih9OXOLM8/1
X-Gm-Gg: ASbGncsKcve9oLvbmT4HTMWi3qIQsaF/lrD7G9Y1nGLaCUbhBM9uoYWxG5dKkSGq4pX
	kKvHHFhgHfxOzrFeKPmW2u4GEuYKp7WwtnnrM4aPO/qxv1Rq9RmcoTeJm5+muNdslelC1CoHV6L
	hlDhOZ5Y1vwQ4aymK0IaKQIk87hSZwdIUoybdw3TRXOMPPVowYuUINrdpm4xmDtXzlyf4rfgprQ
	/WuIVEa5D5Ow8xREzOo8l4jYbMMWlsI+m+komyb6uLwmqAto8K3XJgr2X8jPsdhz+6c4XGqFhSo
	5F8QKoljhpcHAlCwpRGLSj53fNXRVidmn+xY5v2aR2Ta9kkmUDfYLLL3lasXiFzJBBBcEv4wWC6
	qyN71f+dnv/XBo++kUBs=
X-Google-Smtp-Source: AGHT+IF0YGOwgI/SiDLzLobCRbGCMEuk6UiMOqwXQtTxtsbaeH+eIG/iAAo9vQw+zhuCea49+yp7bA==
X-Received: by 2002:a17:907:2d2b:b0:afe:8761:e77a with SMTP id a640c23a62f3a-b07c35833dfmr474345066b.19.1757724132448;
        Fri, 12 Sep 2025 17:42:12 -0700 (PDT)
Received: from localhost ([212.73.77.104])
        by smtp.gmail.com with UTF8SMTPSA id a640c23a62f3a-b07b3128a5csm466901366b.37.2025.09.12.17.42.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Sep 2025 17:42:12 -0700 (PDT)
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
Subject: [PATCH RESEND 02/62] init: remove deprecated "prompt_ramdisk" command line parameter, which does nothing
Date: Sat, 13 Sep 2025 00:37:41 +0000
Message-ID: <20250913003842.41944-3-safinaskar@gmail.com>
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

This is preparation for initrd removal

Signed-off-by: Askar Safin <safinaskar@gmail.com>
---
 Documentation/admin-guide/kernel-parameters.txt | 2 --
 arch/arm/configs/neponset_defconfig             | 2 +-
 init/do_mounts_rd.c                             | 7 -------
 3 files changed, 1 insertion(+), 10 deletions(-)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index d3b05ce249ff..f940c1184912 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -5229,8 +5229,6 @@
 			Param: <number> - step/bucket size as a power of 2 for
 				statistical time based profiling.
 
-	prompt_ramdisk=	[RAM] [Deprecated]
-
 	prot_virt=	[S390] enable hosting protected virtual machines
 			isolated from the hypervisor (if hardware supports
 			that). If enabled, the default kernel base address
diff --git a/arch/arm/configs/neponset_defconfig b/arch/arm/configs/neponset_defconfig
index 16f7300239da..4d720001c12e 100644
--- a/arch/arm/configs/neponset_defconfig
+++ b/arch/arm/configs/neponset_defconfig
@@ -9,7 +9,7 @@ CONFIG_ASSABET_NEPONSET=y
 CONFIG_ZBOOT_ROM_TEXT=0x80000
 CONFIG_ZBOOT_ROM_BSS=0xc1000000
 CONFIG_ZBOOT_ROM=y
-CONFIG_CMDLINE="console=ttySA0,38400n8 cpufreq=221200 rw root=/dev/mtdblock2 mtdparts=sa1100:512K(boot),1M(kernel),2560K(initrd),4M(root) prompt_ramdisk=0 mem=32M noinitrd initrd=0xc0800000,3M"
+CONFIG_CMDLINE="console=ttySA0,38400n8 cpufreq=221200 rw root=/dev/mtdblock2 mtdparts=sa1100:512K(boot),1M(kernel),2560K(initrd),4M(root) mem=32M noinitrd initrd=0xc0800000,3M"
 CONFIG_FPE_NWFPE=y
 CONFIG_PM=y
 CONFIG_MODULES=y
diff --git a/init/do_mounts_rd.c b/init/do_mounts_rd.c
index ac021ae6e6fa..f7d53bc21e41 100644
--- a/init/do_mounts_rd.c
+++ b/init/do_mounts_rd.c
@@ -17,13 +17,6 @@
 static struct file *in_file, *out_file;
 static loff_t in_pos, out_pos;
 
-static int __init prompt_ramdisk(char *str)
-{
-	pr_warn("ignoring the deprecated prompt_ramdisk= option\n");
-	return 1;
-}
-__setup("prompt_ramdisk=", prompt_ramdisk);
-
 int __initdata rd_image_start;		/* starting block # of image */
 
 static int __init ramdisk_start_setup(char *str)
-- 
2.47.2

