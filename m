Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5776230F818
	for <patches@lists.linux.dev>; Fri, 17 Oct 2025 06:11:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760681484; cv=none; b=O6FKo1dVHFzkjM7yYLD9xfxnMf40CQappwzY2Gv/UFlEGTifWdGLf5mN8Tg90K9T5XPqRFXAcNmFKZPoG9VmMJ/maL2WljzyfG9V9UkdX/WDMQBxYoh6/UKp1A+T7I/MWQV/Sa0AlM4ghj2+Fr10sqTWFCof5NalW6gFhSlgisw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760681484; c=relaxed/simple;
	bh=ulNxyjs+7P2Oi91QTv8ZCqiBF+ih61EgQsdAC1fi7Y0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CsG5eODaBxvB56ENmIOg/pkLETZoP9hgN4dvswbUekyHMRfR0KGIebAIob85EWZgLOfi3PmZe21pR9GqvLh0c/Lwn0oWdDNYrADhJZ7SpLfI4agBxuYsMPAhtTcBvPUnM8R7qXy2k6Ago8eB5HT4zk39bFZ4siaIMSTL9RzMvrE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Up1kYFXe; arc=none smtp.client-ip=209.85.221.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Up1kYFXe"
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-3ee12807d97so1430270f8f.0
        for <patches@lists.linux.dev>; Thu, 16 Oct 2025 23:11:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760681481; x=1761286281; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OqXHg8fIVhNftDZOE9plbEgrQCbIv7x8GRINtPvlAdM=;
        b=Up1kYFXeFUU6Yre5Ubf4u3MZeSYpS2YflR6JJN6Isi4KKqRdxq96vz6F9w/qz6P5AV
         hwJrlMEctw2SquBvXLWqsVHUTYPTtkK6zfwAip11dDmmMYdKnVZ/YwTewzYmnQvZyKYy
         R9FWomyhvjXXJ4vU/E2LM0tjWbRRloLfz8dhWPGgK7Olo5RpIX01/wfKLhaIHWZX+gsJ
         cJ6aRgqkrT4lrK7qewctFLatHvFBOdgbzeQvHszykFI2R0xMWbmMcCxZGpkQvbMHCdcp
         6QdOwQjRiZ6Gr6syRKBkgbaelFMgH87hBZz2C142Kz81zxTh2Ye9H0klmHwkQ4XDtmPw
         fV4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760681481; x=1761286281;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OqXHg8fIVhNftDZOE9plbEgrQCbIv7x8GRINtPvlAdM=;
        b=uH63+vKkyn+DVlUlsREUjaz5hBnOY9HbWjKYcVLSc3FAp1Mh/JgkFGzIrBUiwcSi07
         z9cMMez9kdnmhCaoHpCnKpf6leHjZEaycg3/a+VmtXjZ5gW92tuFdYeXdO0mdqTOPC23
         KXGC+uSibnj6Z0F9WlMsAhz9eV3duMnQrLfjDUJ9AZo/1R9SXkbBY7PJcStE7Ymn8EdC
         boLyz4i9voH18V8qPfYablgU12X0AJmHDpGbax2T18TROMUFiC2RXk7RSKNpXPOyk1fa
         d6/f+sNEsfjMvJ1AZVD8yc0SUR/O4dyR8+ijmTcFYR+HzbOuhO4HXzeNAf433W2ykK/3
         kjcQ==
X-Forwarded-Encrypted: i=1; AJvYcCU0wdmlIlGJjOd5A6PYPL6uIk/djoPcNo52l6lR8k/yxXCLa0Y7gHSMdgzAJLoxH/mkdsXTmAcY@lists.linux.dev
X-Gm-Message-State: AOJu0YwxeEWz4WVy3AJWSEqReTmcAsQFa1lh667t/rGctucBk9PRKz9U
	/UaaY7Nf+CohQ1WI2Q3jBpDzt8jdNQEgab/0j+ARgs7IiO9kRDsIyORF
X-Gm-Gg: ASbGnctuoEfehA+ibIIrY0yAZGRraXw0YMcFUpsaO4fYg4i2ZPEptUz8a7wzH8Sznqf
	qrrxoozEW1/cTOgFl0zz5P83Monb/kb4VsEK4A23iFAs/i+F0Rcg1pZEXclNKmgQUXHFR8HFYHb
	XG8GRQd4Xly2qb41H7difmYsJn13aUeQFSl70ArOJmZaQc7BY65A80XLE5Jg7YuEXXLURyPiP7R
	+JqEw4qNJmeP2+Lvh1kl4aHVyODmIAR45FFI+zWuTUSYZZ0esKUYJk1AlMNYjh8MJtCHjVMVvFh
	0wazqaGOgiZrMX4U5a4vS6sE68LrfgwxRwhLdz65IHxtSon7LzgcNltZBKqw90khFM5IFvZH6f9
	2XA18PRWwG2MEWpHBMB1I3P6tmWgMgcpCYmXUPIkZiKLzWfZ10elZOjEt+0pTVIICWGE+YTeJMI
	7Mphde4wfgvhY=
X-Google-Smtp-Source: AGHT+IG9nFyXU6/YzYNrNEKOmFbcI73aJtoTWz3HhvfOqLzAHFD1KIWSe0W31I+6MYQb5EK9zvZOHQ==
X-Received: by 2002:a05:6000:2507:b0:425:737a:4804 with SMTP id ffacd0b85a97d-42704d4422dmr1625416f8f.4.1760681480389;
        Thu, 16 Oct 2025 23:11:20 -0700 (PDT)
Received: from localhost ([212.73.77.104])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-426ff84cbb7sm7231059f8f.23.2025.10.16.23.11.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Oct 2025 23:11:19 -0700 (PDT)
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
Subject: [PATCH v3 3/3] init: remove /proc/sys/kernel/real-root-dev
Date: Fri, 17 Oct 2025 06:09:56 +0000
Message-ID: <20251017060956.1151347-4-safinaskar@gmail.com>
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

It is not used anymore.

Signed-off-by: Askar Safin <safinaskar@gmail.com>
---
 Documentation/admin-guide/sysctl/kernel.rst |  6 ------
 include/uapi/linux/sysctl.h                 |  1 -
 init/do_mounts_initrd.c                     | 20 --------------------
 3 files changed, 27 deletions(-)

diff --git a/Documentation/admin-guide/sysctl/kernel.rst b/Documentation/admin-guide/sysctl/kernel.rst
index f3ee807b5d8b..218265babaf9 100644
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
index bf381aa0400f..82613a3be756 100644
--- a/init/do_mounts_initrd.c
+++ b/init/do_mounts_initrd.c
@@ -8,31 +8,11 @@
 
 unsigned long initrd_start, initrd_end;
 int initrd_below_start_ok;
-static unsigned int real_root_dev;	/* do_proc_dointvec cannot handle kdev_t */
 static int __initdata mount_initrd = 1;
 
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
 static int __init no_initrd(char *str)
 {
 	pr_warn("noinitrd option is deprecated and will be removed soon\n");
-- 
2.47.3

