Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74CC0136672
	for <patches@lists.linux.dev>; Sat, 13 Sep 2025 00:53:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757724792; cv=none; b=GsPGblltMogNY9D5oUD9dSvCHQFD9hx2M1ImA2jqaRXGVugIdwNJeyU4LkRX0RtbUuxPD9xLrhdt5Y6jc34SKE8zg9gpyT5UR8OsXEgXUW3s++1vObQnd0A/+q6P3A0+gjZRMrvr1+va9pTkER1YoqH2FuQsG6iGkEtnKLHIfzY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757724792; c=relaxed/simple;
	bh=x5NNVyIF1R5eB/2ANpkfxinDkMZ4lHIXMUphyEE4B54=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M9UW7n3OvxtWikFUrjrYODmMdXcaWvLaBzoEJgTjoM9zxigEJSW9ZIdUdAeMke5IzXcebEOghF6qi9Z39xE8bxZc+HLBCRsbWJTPLV3k7vrm7bJYx3f8jqDY0e4uCm+7kKtHd7cKVPDCPf//pOwmd3KgRg5kRX4nEtKjlNKg6Vw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BU2wEN4k; arc=none smtp.client-ip=209.85.218.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BU2wEN4k"
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-afcb7ae31caso434689466b.3
        for <patches@lists.linux.dev>; Fri, 12 Sep 2025 17:53:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757724788; x=1758329588; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qPSAK5Fj4YQSUyCSJit30V41XYzOMHEP2qtV3SbNp88=;
        b=BU2wEN4kzVbIG8NtGbFdkswSRDOFAn7HclnqbweQZchSQSzFteGt972mPXGkcpq8vP
         7lxoGH3nUo5V3hZUBM/UpgT4fNdmxnj0QQtBvnLBls4d+6J+dKBD0d6Sycfqy1Wmq1fo
         AhcjtCp5Ra5Pv57pUUxYn2lr/+mauMUZ/yJmWmzf8CXt5wqLXUC5kTxOmC4xouaIizom
         GKoDTEm4C1tdteMZJIogzX9llOTnoeiiv09fqLda62g1AhVdHU5sFvYe5hWyCdhHJbZd
         K4rTxcXnWCMsWiaz7FcZNrtnL3wGDz2czcKrS3wYbkLY9/SXQCFIlbpS2/gGenLupXfs
         K6Aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757724788; x=1758329588;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qPSAK5Fj4YQSUyCSJit30V41XYzOMHEP2qtV3SbNp88=;
        b=IhBQBExh/gjqBwjUmGdvbDRrhDj2raHW1bYiNYndeBVvhEWZWhG77XYMT4+WjWYwIx
         LyCCBnfBPYC+LjG9/UPNrH8dy8xveIgZqnTpEXbNf0KopvTAKO0tYDldq/bafYyADuI7
         mV/BHkMMOGB8TfwWeoZZCowHNmDpoezVZLbFu30nhh4qrB5P6hmIWfs6pL1DJgc3fxIE
         5KARbQ3avY0zWs3vDKPjBCGvtOGi0it8E1fdUbsTpTcCRW7OXGItwumPZRpDnPIA6NRT
         t9nJxTy7OCCbXszmttMLPQ+57VmVClUbFFQhWCzKQP/0ubcfwn3/IV0+I1otG3WDiT3H
         1fxA==
X-Forwarded-Encrypted: i=1; AJvYcCW1uCu59d6t8lobdSZNmOAW5yllo+O4tYmxmL7JC6t0HPyKO1gJIzwmUcB2UnSQfFeGrhgno+2m@lists.linux.dev
X-Gm-Message-State: AOJu0YxoGVYXalHEIJfUHaxvVYvx/R+dCnPSL/NjumJ5ov7S6CjKq11A
	I4G1rRNlZPGrAgNbD2HyVYjWAt1/qz25tVHEsKPjtpXkD62dXlFZ75ho
X-Gm-Gg: ASbGncuzZtP7fStUQhG8VjxqXoVELyC4wDM4Je+XFEksS54PXdBlhLIW9G52VcJebIe
	++uaf5Z0f6d7IN7H/Su/8H3L7snDu+UKgVADqdRqLd04zCxDPssYAjrIa49F4Q+EwQWtKXl5lDw
	u99WHbeuloLbySn9TdyCl7qYDklavZkUKGLrB+nmC6+0UlJKge6+apigBS1J0w8CUmWjSiBbW5Q
	YXYe3gEkVDq1doXsRBTj6BEdFVLvdYPQbNVMjW+U9Zru9FsS6qBgJsDAhr9woToOc/g/y19iU6M
	+kV/mgqUt9AAJoVOnrrWugGFezOF8p/UIQM0y65okStNuu1X2wA51qq5H3O5sOphgcNiRby9AXF
	w6buyDF6n4UplDNqoX5h6PR6fnnIUEw==
X-Google-Smtp-Source: AGHT+IFLH7pCvIgBYHEI5BCYMw7iR++gatKVbesXKTxSAgJfhChwCe/V59YIUp3mRnJ55soXUGFMnw==
X-Received: by 2002:a17:907:da4:b0:b04:2cc2:e49c with SMTP id a640c23a62f3a-b07c35bbcbbmr535243766b.19.1757724787764;
        Fri, 12 Sep 2025 17:53:07 -0700 (PDT)
Received: from localhost ([212.73.77.104])
        by smtp.gmail.com with UTF8SMTPSA id a640c23a62f3a-b07b32f22e8sm477916866b.87.2025.09.12.17.53.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Sep 2025 17:53:07 -0700 (PDT)
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
Subject: [PATCH RESEND 12/62] init: remove /proc/sys/kernel/real-root-dev
Date: Sat, 13 Sep 2025 00:37:51 +0000
Message-ID: <20250913003842.41944-13-safinaskar@gmail.com>
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

It was used for initrd support, which was removed in previous
commits

Signed-off-by: Askar Safin <safinaskar@gmail.com>
---
 Documentation/admin-guide/sysctl/kernel.rst |  6 ------
 include/uapi/linux/sysctl.h                 |  1 -
 init/do_mounts_initrd.c                     | 20 --------------------
 3 files changed, 27 deletions(-)

diff --git a/Documentation/admin-guide/sysctl/kernel.rst b/Documentation/admin-guide/sysctl/kernel.rst
index 8b49eab937d0..cc958c228bc2 100644
--- a/Documentation/admin-guide/sysctl/kernel.rst
+++ b/Documentation/admin-guide/sysctl/kernel.rst
@@ -1215,12 +1215,6 @@ that support this feature.
 ==  ===========================================================================
 
 
-real-root-dev
-=============
-
-See Documentation/admin-guide/initrd.rst.
-
-
 reboot-cmd (SPARC only)
 =======================
 
diff --git a/include/uapi/linux/sysctl.h b/include/uapi/linux/sysctl.h
index 63d1464cb71c..1c7fe0f4dca4 100644
--- a/include/uapi/linux/sysctl.h
+++ b/include/uapi/linux/sysctl.h
@@ -92,7 +92,6 @@ enum
 	KERN_DOMAINNAME=8,	/* string: domainname */
 
 	KERN_PANIC=15,		/* int: panic timeout */
-	KERN_REALROOTDEV=16,	/* real root device to mount after initrd */
 
 	KERN_SPARC_REBOOT=21,	/* reboot command on Sparc */
 	KERN_CTLALTDEL=22,	/* int: allow ctl-alt-del to reboot */
diff --git a/init/do_mounts_initrd.c b/init/do_mounts_initrd.c
index bec1c5d684a3..d5264e9a52e0 100644
--- a/init/do_mounts_initrd.c
+++ b/init/do_mounts_initrd.c
@@ -14,30 +14,10 @@
 
 unsigned long initrd_start, initrd_end;
 int initrd_below_start_ok;
-static unsigned int real_root_dev;	/* do_proc_dointvec cannot handle kdev_t */
 
 phys_addr_t phys_initrd_start __initdata;
 unsigned long phys_initrd_size __initdata;
 
-#ifdef CONFIG_SYSCTL
-static const struct ctl_table kern_do_mounts_initrd_table[] = {
-	{
-		.procname       = "real-root-dev",
-		.data           = &real_root_dev,
-		.maxlen         = sizeof(int),
-		.mode           = 0644,
-		.proc_handler   = proc_dointvec,
-	},
-};
-
-static __init int kernel_do_mounts_initrd_sysctls_init(void)
-{
-	register_sysctl_init("kernel", kern_do_mounts_initrd_table);
-	return 0;
-}
-late_initcall(kernel_do_mounts_initrd_sysctls_init);
-#endif /* CONFIG_SYSCTL */
-
 static int __init early_initrdmem(char *p)
 {
 	phys_addr_t start;
-- 
2.47.2

