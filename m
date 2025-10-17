Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D70C030CD9F
	for <patches@lists.linux.dev>; Fri, 17 Oct 2025 06:10:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760681436; cv=none; b=apaPRC65rFCWtHRuGKlC6OZxGg320rIklowOCD5jN2L0ofSjyjnUdMcyJqeaPvWxaBu4x66XlwyH9CTtOwMc7D6NJ2qLcRXG79CVYQvQoRbbZ9iSXXV7jOx3lZpIIdzf+ZFFGVAVWGYBVQG2ZmbLuYNbdGPvX+d5yM+s5Z/GqW4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760681436; c=relaxed/simple;
	bh=xFurCGxlKeC/tk9lJqwt+qhC4G1oERsMk1YgSqg0z4M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=czc0DpTpLI3hgkG0PMXR0QCuAcuUqAKgLdP0MFvkMaqDWURWOfIuRmSI5aEUHU8iSl5y2T6JPQBERu1O5Vu7rfh7BO8diy2PwuiSEswzFspmYxPgLZw0/JSKvHPJWTo00+P/y/dfiRdBLmajNr0Ns/NahdDZNulgqkbY4Vq5KPY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Shn9IcRx; arc=none smtp.client-ip=209.85.221.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Shn9IcRx"
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-42701b29a7eso646348f8f.0
        for <patches@lists.linux.dev>; Thu, 16 Oct 2025 23:10:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760681432; x=1761286232; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fApFH3gxVydnn6o27DJgEciM38Nk8T7NkdtS/0xgRng=;
        b=Shn9IcRxbw0tOeu0fedvOZf4sKCVgHMqF6xBX4HiAQyrPDV8qSSWROWpjWuBFLI/ju
         dqOeiqgb1mPFdJ9ly40tPApV03VpvGIWVxN1q6EoXUD3HLPJ/GIQtnI1Yr272N+cTeLH
         ixWZeDfaBqwhaheuSY7E2P78NHXgfvhslA5gjgF1otPIcAiTrnbvodSQtx0/kvpYIi4I
         pNqjNsnHVGlNyh1fsbhb7Mst0gyGjCV8fUIM+QLU9U8jaGcTtcjAPlEBurj2ypy40XA6
         +btyw6Bc8qCaLk3dd0+TG7OMVXklkA0Us7GPP25cJVCB2zx3YDpFqkayPkxKaCTpme6l
         yeUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760681432; x=1761286232;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fApFH3gxVydnn6o27DJgEciM38Nk8T7NkdtS/0xgRng=;
        b=vYdV0CYm+icrus1rlG6F1+Uzih/I2BlIF4Ew3lQ0mCp7Hoexqjs5eTdk6KvTEs1uXX
         PXroQdKbcuc1tmxXGDYNDOTBijI42g3LCrgQIqVm28/Qsj8fV6MUosoihBkqN2PdgTxQ
         Q7Xx8HXPLFWApugZJ7n34hjTJdkTikeBQc7PhJ7DFxoa90W2r4dhrkgqMevyTVjJvJvM
         dAkIzwpUFky+LvqJn8Kdgj/bXSxqzXMGlvNNw68kCk1pm3qD5Bik9nRzy8+BD4+tXV1t
         pmmjMrpkEt4BrVKpraxFYy05zMe8bboeth7OuHF79JTf0LcXZuY64Mgu2WFlp6EACnsw
         VUHw==
X-Forwarded-Encrypted: i=1; AJvYcCWL7hGFphdxHlw2+OnoIaKwbI/k0DJFLfgNEsUuCMRwCGcav3p2ptIkQMY7SlhvY9Oxt0l+vs+9@lists.linux.dev
X-Gm-Message-State: AOJu0YwCc8DJXEm6XpwB+sbDZ8iFRpGl5bd9HxMFqWdsio1CDfdq9fgK
	ee+KBtN+ESnbH6DPxISnS6aNGhUFu8yG14StDUqZrwapjTXQVkQirxna
X-Gm-Gg: ASbGncs/CZ/9AMDHemuQDZMI47CJhvrZRypfIrQ4qYMBIM9VBkB8cx4yD7qcQjixa8F
	9ymhrkn09/NmlYpNe7js3iTLWBBXuago1UG0k/X20mDYovbHZ8aHfoIkphHfV63sH/RGPHpX6YB
	PimXjNpXdDe8RhhWm/vxoznOceNEl0tQizTVTA9iT/PYgb5B6JWJK0pJGrmV0wEWSKjr2uQSOJw
	X7vzVK8/10K1B+llzQJA4LuTaPe1MQbYGzY7U129qyQ2TWVtXFy7ay59r9P+jCmSxekzDoGpUOl
	sUDaoH6bk1KMbbt5Gs+vOjB9rz5uNlz4Z8fu+mN1IMYOnrtlm4NiXILMgq42DQo3QNqMSewfD4Q
	4STUe3fhMsNW4ikvzy0dBYLIGLNZJ3zubOrmu0dLCfJRnLRO3Uu2alC7lhsGQ3EL3/YfOp/Te1Y
	RI
X-Google-Smtp-Source: AGHT+IH347DjV12fYF0hhdy1vww1ouDPmUAfsNrazlguHL6g+y9YN/2fKxqG5dPAECrqaSU8hvDOLQ==
X-Received: by 2002:a05:6000:4210:b0:426:d30a:88b0 with SMTP id ffacd0b85a97d-426fb8b7cb2mr4254322f8f.22.1760681432093;
        Thu, 16 Oct 2025 23:10:32 -0700 (PDT)
Received: from localhost ([212.73.77.104])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-426ce57d49bsm40185002f8f.10.2025.10.16.23.10.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Oct 2025 23:10:31 -0700 (PDT)
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
	Alexander Graf <graf@amazon.com>,
	Rob Landley <rob@landley.net>,
	Lennart Poettering <mzxreary@0pointer.de>,
	linux-arch@vger.kernel.org,
	linux-block@vger.kernel.org,
	initramfs@vger.kernel.org,
	linux-api@vger.kernel.org,
	linux-doc@vger.kernel.org,
	Michal Simek <monstr@monstr.eu>,
	Luis Chamberlain <mcgrof@kernel.org>,
	Kees Cook <kees@kernel.org>,
	Thorsten Blum <thorsten.blum@linux.dev>,
	Heiko Carstens <hca@linux.ibm.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Dave Young <dyoung@redhat.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Krzysztof Kozlowski <krzk@kernel.org>,
	Borislav Petkov <bp@alien8.de>,
	Jessica Clarke <jrtc27@jrtc27.com>,
	Nicolas Schichan <nschichan@freebox.fr>,
	David Disseldorp <ddiss@suse.de>,
	patches@lists.linux.dev
Subject: [PATCH v3 1/3] init: remove deprecated "load_ramdisk" and "prompt_ramdisk" command line parameters
Date: Fri, 17 Oct 2025 06:09:54 +0000
Message-ID: <20251017060956.1151347-2-safinaskar@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251017060956.1151347-1-safinaskar@gmail.com>
References: <20251017060956.1151347-1-safinaskar@gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

...which do nothing. They were deprecated (in documentation) in
6b99e6e6aa62 ("Documentation/admin-guide: blockdev/ramdisk: remove use of
"rdev"") in 2020 and in kernel messages in c8376994c86c ("initrd: remove
support for multiple floppies") in 2020.

Signed-off-by: Askar Safin <safinaskar@gmail.com>
---
 Documentation/admin-guide/kernel-parameters.txt | 4 ----
 arch/arm/configs/neponset_defconfig             | 2 +-
 init/do_mounts.c                                | 7 -------
 init/do_mounts_rd.c                             | 7 -------
 4 files changed, 1 insertion(+), 19 deletions(-)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index 6c42061ca20e..15af6933eab4 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -3319,8 +3319,6 @@
 			If there are multiple matching configurations changing
 			the same attribute, the last one is used.
 
-	load_ramdisk=	[RAM] [Deprecated]
-
 	lockd.nlm_grace_period=P  [NFS] Assign grace period.
 			Format: <integer>
 
@@ -5284,8 +5282,6 @@
 			Param: <number> - step/bucket size as a power of 2 for
 				statistical time based profiling.
 
-	prompt_ramdisk=	[RAM] [Deprecated]
-
 	prot_virt=	[S390] enable hosting protected virtual machines
 			isolated from the hypervisor (if hardware supports
 			that). If enabled, the default kernel base address
diff --git a/arch/arm/configs/neponset_defconfig b/arch/arm/configs/neponset_defconfig
index 2227f86100ad..4d720001c12e 100644
--- a/arch/arm/configs/neponset_defconfig
+++ b/arch/arm/configs/neponset_defconfig
@@ -9,7 +9,7 @@ CONFIG_ASSABET_NEPONSET=y
 CONFIG_ZBOOT_ROM_TEXT=0x80000
 CONFIG_ZBOOT_ROM_BSS=0xc1000000
 CONFIG_ZBOOT_ROM=y
-CONFIG_CMDLINE="console=ttySA0,38400n8 cpufreq=221200 rw root=/dev/mtdblock2 mtdparts=sa1100:512K(boot),1M(kernel),2560K(initrd),4M(root) load_ramdisk=1 prompt_ramdisk=0 mem=32M noinitrd initrd=0xc0800000,3M"
+CONFIG_CMDLINE="console=ttySA0,38400n8 cpufreq=221200 rw root=/dev/mtdblock2 mtdparts=sa1100:512K(boot),1M(kernel),2560K(initrd),4M(root) mem=32M noinitrd initrd=0xc0800000,3M"
 CONFIG_FPE_NWFPE=y
 CONFIG_PM=y
 CONFIG_MODULES=y
diff --git a/init/do_mounts.c b/init/do_mounts.c
index 6af29da8889e..0f2f44e6250c 100644
--- a/init/do_mounts.c
+++ b/init/do_mounts.c
@@ -34,13 +34,6 @@ static int root_wait;
 
 dev_t ROOT_DEV;
 
-static int __init load_ramdisk(char *str)
-{
-	pr_warn("ignoring the deprecated load_ramdisk= option\n");
-	return 1;
-}
-__setup("load_ramdisk=", load_ramdisk);
-
 static int __init readonly(char *str)
 {
 	if (*str)
diff --git a/init/do_mounts_rd.c b/init/do_mounts_rd.c
index 19d9f33dcacf..5311f2d7edc8 100644
--- a/init/do_mounts_rd.c
+++ b/init/do_mounts_rd.c
@@ -18,13 +18,6 @@
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
2.47.3

