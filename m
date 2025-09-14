Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04B9426B2A5
	for <patches@lists.linux.dev>; Sun, 14 Sep 2025 03:57:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757822233; cv=none; b=rqukLMOcmQk7xst9c6CrE36Zvk2VaD8Y6hNhl0m/FyGhTcSZqC/rn9vDFzOeNWcqV6uju5niBPCKrncNlSaChCsL2992FwvS9/1r0c8qFk79SMiRLzSHpFvcoDVcb9Aq4OpZ0PkhtObVVm+j854pYZTDU1Lq8q8ri0M7ShVYAq4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757822233; c=relaxed/simple;
	bh=6pXJgBOVmgKyryw3LURicaeyD0WS1HvzY8WG0GWatOA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XE+nDsnkON6jMLHfyQjn/rpBERVhRWW+tih9ujiOvUBuoG0CTKSz+i8x4cFZdNaXPsGUJJ8XzQ0HtxJUY2F9w2+Okn+/TyRq3R35T/sKrcHC+XmxATzCCK5h+4cjSFtBtIs2Kp5nWUAjWL2nK1Hifw6RWg1zROqxkGQ5MgYbQLM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GNtvl4qn; arc=none smtp.client-ip=209.85.218.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GNtvl4qn"
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-afcb7ae31caso554621366b.3
        for <patches@lists.linux.dev>; Sat, 13 Sep 2025 20:57:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757822228; x=1758427028; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Y7psSH4JIkuISYR7xy9RNjBVG2GzEUFc3+zgpdmbt9Y=;
        b=GNtvl4qn9Tj8pgOrj0TymALmjDd58mTy6YdfKroTUU6DcD0PUAPScVatavLnSPSrVs
         2Kf2gEofta+iW7fGcfgQ8ROBOgrKIuUivUKHaBTTUp1M8J8E2K2YamkzJlzmmU19xbZg
         yPhuOWRt6FR+lB5IckXXlcCHpX7DWSIqL9GM7wEpMWBFUuf8+dze4Qwak1iojkkiOrSp
         8hO9JJGRX5N4r9gkSc3e1Bgo1OF0HIQBwL6htO66JzIkayiQqmoUfvt9/fhL97mQgKd1
         QTEsPw8IJ97Y54I7mddZs/Eg3Y9cAIXoT3LcNIgQ4K7mh+DjXHSeKYVywoFUvvb56kpF
         NfUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757822228; x=1758427028;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Y7psSH4JIkuISYR7xy9RNjBVG2GzEUFc3+zgpdmbt9Y=;
        b=t57oXxGQvbuY7V0I7nPSxXO8URMnsjcjAQ0SoU5bRkE26XLRxfj0oyb3HcIJbgq779
         CYo9YAgCCX1gxD3RYsorQQyRXMBCq8CJtTdDcAz79DzpijOcgG3lRDBErJEoJG+279RG
         6AbrfFf3pmY0VDWmThO5aqCZrI3ni2B23JiO/5u6OXMK3Madm/uBU3tYXJS1tdwS1MSh
         uKcOs7501DrCmmn0lWNcbac3d4j98HZi6ZD8BlpXUnS2Fynqto1Im0PSkw9NnKprr5sf
         vxFOGlTOH7h+Vq4mrF9A+cK9s0hut9KqWjcD9/QhtDcLVOB82IpiTCJ6JOPRZpnj1EY2
         KOsQ==
X-Forwarded-Encrypted: i=1; AJvYcCX5fWcvVBVs1SsPMiXtg17D3pNQKMImhNpjuKscLLuuMThi7SYS0/BMzHGOXIIqdVcss+I6FaBO@lists.linux.dev
X-Gm-Message-State: AOJu0Yw5q+v859RPsMhwKn5TN906vY0GGOcFXCfqNwOidoWXef/uTgRI
	FLJ1uGBRdk4SBVviv8/CNoMb06TZQDfwKwcpoNfCtQBaM0bb5ZoULR3N
X-Gm-Gg: ASbGncubTIuBVKgOUqFiixpce2+CsD78J6Nestwwlev+29CKH1CmtrhRfx4yP9MTU2n
	bJLQifdziDaGNfDAtrpmw9hKMe9GWgm/eu7qYBINMTDXuXxgdy3y1HKnefdOre/F0q+xctfOO2t
	2ZKLm8EfqS24BZJUTPuVYvCBf2HgzY9920ggC0kC3ZK6CFL7DYRFPxgqmcRsrfuycZBf4y/5ma0
	iNRk5279XWzkzEnMUcmfCf/zh1vSElqcoL/gcAExaPnHFpeglF+lLd7u9W2ywQBEJE1F1Yn3HMb
	0m6qlpA8EtUB2A5Xk5edNN6xPBroDMYWDwlLPB3HRcaLThC+iZIB3GZmmRMUGLQTEQbMk95pEA1
	YykjT8KFnWx+p9Cfmda4MIYUJna9PxQ==
X-Google-Smtp-Source: AGHT+IHHnPU+sOVT053l7deT3P8z3LJVFAOiksWjmZKd0Ub2gBIDgZK1/4gCPHfUrNaBqPQVOEAIKA==
X-Received: by 2002:a17:907:d16:b0:b04:6338:c936 with SMTP id a640c23a62f3a-b07c35b8e53mr876582466b.17.1757822228258;
        Sat, 13 Sep 2025 20:57:08 -0700 (PDT)
Received: from localhost ([212.73.77.104])
        by smtp.gmail.com with UTF8SMTPSA id a640c23a62f3a-b07b32f1e54sm673986866b.75.2025.09.13.20.57.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 13 Sep 2025 20:57:07 -0700 (PDT)
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
Subject: [PATCH RESEND 49/62] init: rename ramdisk_execute_command to initramfs_execute_command
Date: Sun, 14 Sep 2025 06:57:03 +0300
Message-ID: <20250914035703.3729713-1-safinaskar@gmail.com>
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
 init/main.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/init/main.c b/init/main.c
index 5186233c64fd..cbebd64f523c 100644
--- a/init/main.c
+++ b/init/main.c
@@ -160,7 +160,7 @@ static size_t initargs_offs;
 #endif
 
 static char *execute_command;
-static char *ramdisk_execute_command = "/init";
+static char *initramfs_execute_command = "/init";
 
 /*
  * Used to generate warnings if static_key manipulation functions are used
@@ -609,7 +609,7 @@ static int __init rdinit_setup(char *str)
 {
 	unsigned int i;
 
-	ramdisk_execute_command = str;
+	initramfs_execute_command = str;
 	/* See "auto" comment in init_setup */
 	for (i = 1; i < MAX_INIT_ARGS; i++)
 		argv_init[i] = NULL;
@@ -1491,12 +1491,12 @@ static int __ref kernel_init(void *unused)
 
 	do_sysctl_args();
 
-	if (ramdisk_execute_command) {
-		ret = run_init_process(ramdisk_execute_command);
+	if (initramfs_execute_command) {
+		ret = run_init_process(initramfs_execute_command);
 		if (!ret)
 			return 0;
 		pr_err("Failed to execute %s (error %d)\n",
-		       ramdisk_execute_command, ret);
+		       initramfs_execute_command, ret);
 	}
 
 	/*
@@ -1588,11 +1588,11 @@ static noinline void __init kernel_init_freeable(void)
 	 * the work
 	 */
 	int ramdisk_command_access;
-	ramdisk_command_access = init_eaccess(ramdisk_execute_command);
+	ramdisk_command_access = init_eaccess(initramfs_execute_command);
 	if (ramdisk_command_access != 0) {
 		pr_warn("check access for rdinit=%s failed: %i, ignoring\n",
-			ramdisk_execute_command, ramdisk_command_access);
-		ramdisk_execute_command = NULL;
+			initramfs_execute_command, ramdisk_command_access);
+		initramfs_execute_command = NULL;
 		prepare_namespace();
 	}
 
-- 
2.47.2

