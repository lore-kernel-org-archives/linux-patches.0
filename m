Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC584265CA2
	for <patches@lists.linux.dev>; Sun, 14 Sep 2025 03:51:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757821874; cv=none; b=dcDylhuREv7mjBCZ0EDkdfPFtry49uRWgtfasVOuXpu4wTOTESg9VBsoR0mPCmfxCYjwvd+btp5/WfrK/HuexZOo+JKq1/VPVKHgzSt0fTcEkxGzs/6Lz091xpJLLiQG7xtaO8wbesQ18mzVwl7oQj4dyhxdeUPP/jkSg2nddTo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757821874; c=relaxed/simple;
	bh=0pa06GJsqjKCCDz/UM3o5nwPqkgP4CqvzP324rR3v40=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JkDS61WvoHSorhkTMj9UDRM4XUsyIrh5P34v3hfMOSSGulQ6s0OsZOnNcADOgzFDxXA/mhaP1k9ZU1nyQMBiC13ZLZf6b99YydGqCB/shi40xOpsCL7W4/Ise0mPYXyQ5zaVeQu7tCyf1Hu1Xt8Lg5tE2WrPdHBlWW2binjowko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mHtLk7Cq; arc=none smtp.client-ip=209.85.218.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mHtLk7Cq"
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-b0aaa7ea90fso92709566b.1
        for <patches@lists.linux.dev>; Sat, 13 Sep 2025 20:51:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757821868; x=1758426668; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cgyNirakXvU+05rXEnyXXLzO67oYWYN1IcZHpjjqHUg=;
        b=mHtLk7CqPGiovHx3XNy1qynbjY+AFbHwDUuv768AhuHgOI0R2K79SvKDildoA0uRxG
         icYqQ7KXNtjZ8TtMTyT1QTYuNQDDBqljzYN/v8OsJLxarKiPz6y8jzWZNsUifG+zM3Y5
         tkS5DeFM8AuYG4xPXzsjAXcrX1gcocWYmXiemq+XYOPFS6V0l3vGQ+51uNm8ptnG3wyJ
         Rc5WmPwQ/QnKmxR5BsZRWq4JeD8jaLISsRFOfah+hLveNjTG4SbGzxKV/5OWmcRfc7nu
         eh0lmyotl1uh1GbuTXZaK3sljhbiEyDpWPL2fuikbPboRVUj+j3RJcWjuL5rMw08amQk
         KThA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757821868; x=1758426668;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cgyNirakXvU+05rXEnyXXLzO67oYWYN1IcZHpjjqHUg=;
        b=ZHVun8VEqs4XZcPs7VGchs7ogzMiSaW+aGBlt1qwCO+oHO6r/TsIjpfbPpTAxGqLEN
         yzVtEyIDi/kQaiYlU1lKXb21PA1w2Knxc67uDFmAPq/ZAaiBRsRRfksG6BxRq7cTNZxh
         L0I/M0RpnIij6UKCvN83DtdhPXTWTEveew7h/J46DEbnIi6XfzKG4AF3AsZFVb1pl6yG
         LpUcYwvAN09rJ55jXQg3vR2LFVVISAijRpIeeTJ3VIpQFtBT0GQwtrElhuhDkG0CnD94
         aBCR2kj6CbTfU0GUQSFtAZO66xpx4c6cZhMfpqQdClRodLuF0QUBtkGq8PxDxXe9jWHR
         t6HQ==
X-Forwarded-Encrypted: i=1; AJvYcCX1Gvqaekeo4g1JejZ7vjCqR9E2qSDfMWreBtseeloDbh69Rgtk571un+gjPzefVCTrevcbQd7a@lists.linux.dev
X-Gm-Message-State: AOJu0Yw98/oTy1r2qytLjyQSnj9iiZ5LVfX9kFGbyvhk2MIlfybjzuMX
	zSWvKCA4KUTF47WGVRlkZSf9KhFMwb8j2WfYD01B64iiYIlQe/X+bgUb
X-Gm-Gg: ASbGncsYjE1Q7+pt7gHzjbW4VEtjt5M7eGw7HRnffNSOx0WaVU4djfl0uBR07KOolY3
	twqmczzzJN/x2LDzDrIaytX5kq6mwVgyooREv5JSkOFtuQk12/DbJWqIQu3NPyg6hKzyFNnHCpf
	dKQECp+BE34oHjL0m+zRHoCtMFQ6K+VilttfxPf9DdMM0O6ko4f/3nZZL3Wp+8Dq4L1gRK65QM3
	EgTFPtBnBrDN2Gj2PqAXzK7noD0pt7t7+1eFplteAPaBQw5FMS1dLjrFvZCv6i4ZMULAKNH6EtI
	67iGrw2tx7ZfmmaF2yfHtJVHFLKVy5MR98PPi4bG2OQWk1C3S5J25/sxMRsDULlIOjCn5HiW47I
	pLMbY7RTqrQxpYDFRnTk=
X-Google-Smtp-Source: AGHT+IGYiK6likOM/TjE1BLl/jI3UX22nGT0EQIxF87CUWohx3tkGnMcAa8PzC4lwu+rbC2577QTfw==
X-Received: by 2002:a17:906:46c7:b0:b07:da17:79fd with SMTP id a640c23a62f3a-b07da178367mr507229866b.17.1757821868321;
        Sat, 13 Sep 2025 20:51:08 -0700 (PDT)
Received: from localhost ([212.73.77.104])
        by smtp.gmail.com with UTF8SMTPSA id a640c23a62f3a-b07b3347b6fsm679031866b.111.2025.09.13.20.51.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 13 Sep 2025 20:51:07 -0700 (PDT)
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
Subject: [PATCH RESEND 39/62] init: make console_on_rootfs static
Date: Sun, 14 Sep 2025 06:51:03 +0300
Message-ID: <20250914035103.3619203-1-safinaskar@gmail.com>
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
 include/linux/initrd.h | 2 --
 init/main.c            | 2 +-
 2 files changed, 1 insertion(+), 3 deletions(-)

diff --git a/include/linux/initrd.h b/include/linux/initrd.h
index 364b603215ac..55239701c4e0 100644
--- a/include/linux/initrd.h
+++ b/include/linux/initrd.h
@@ -23,6 +23,4 @@ extern unsigned long phys_external_initramfs_size;
 extern char __builtin_initramfs_start[];
 extern unsigned long __builtin_initramfs_size;
 
-void console_on_rootfs(void);
-
 #endif /* __LINUX_INITRD_H */
diff --git a/init/main.c b/init/main.c
index 58a7199c81f7..f119460bf8e1 100644
--- a/init/main.c
+++ b/init/main.c
@@ -1533,7 +1533,7 @@ static int __ref kernel_init(void *unused)
 }
 
 /* Open /dev/console, for stdin/stdout/stderr, this should never fail */
-void __init console_on_rootfs(void)
+static void __init console_on_rootfs(void)
 {
 	struct file *file = filp_open("/dev/console", O_RDWR, 0);
 
-- 
2.47.2

