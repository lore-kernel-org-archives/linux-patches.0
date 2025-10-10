Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62DF42C11EB
	for <patches@lists.linux.dev>; Fri, 10 Oct 2025 09:43:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760089399; cv=none; b=oVsNGnsHfUYB1sRTyCgq9RXjXhnsNHVEbqRC57yOVvwp8mgpcfL8nRzHfjMHOeeasSAcaXWXcIn5PAuC1ryrkdRwmgWHidp4sYl+ml+4MtISVY2N0avSRujxXc6VXN7A8YS2oY8KqTLDbxyGvXK4UL1HpAk2yyWVxz1Z2Ybxm5g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760089399; c=relaxed/simple;
	bh=tfJwv3nqlpDtjcN28xzwLtu0Ad/Qk3DuNUw19bGFdw0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t+Oektmq9FmFvImxzDK2pNW/j9m+ih9tlE3bredpjjklydvbXkY7SH7BCpUQYox8V37p/2k18xo9y/OTq4IEPiILk4LIe+TVQLtDii4yTv2YzHWvDhQZMOOj100KT7dNDG4dNPLxtbN1g0Gyqftq/J7WeQ17P9V7uRDH/Sj5U3c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VRl6xh8a; arc=none smtp.client-ip=209.85.221.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VRl6xh8a"
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-3f2ae6fadb4so2166174f8f.1
        for <patches@lists.linux.dev>; Fri, 10 Oct 2025 02:43:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760089394; x=1760694194; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kmHzldTWpRVGaYiRV7mqVTmbw8wTd7DjVDHFKbOWCEM=;
        b=VRl6xh8avIZLuHTfzhhKqqJSjUGCDW06DMC2KvOwMmJMv/jEDd8Jzj7aLXyBiZp0fA
         5tWLSTxzumrxofjAuouwAx0pqrFE9kqjtwTS9NhC3IEgoJhAa85uMvqurCTZkgqRXSxw
         76STppNQnMUK39f4jenB2QR2aZoeCEp066AxjguBzLlYepnylbOUcrtyOQ1+gWLoSZgk
         JcYMNRfDhtxirWtQCjhienblB58UNdDZ0ApOffQTFEkswpe3f57ODu9a4xuAFBVTqQiB
         hd6XSj4ttKgyA7/Vlz7tUi7R6pmpu06YMT2p4PjzBx2BsuMan+yb/VD4kFcBwM8OSPja
         yhRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760089394; x=1760694194;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kmHzldTWpRVGaYiRV7mqVTmbw8wTd7DjVDHFKbOWCEM=;
        b=tSjv98+L73x7H7i8OsbSPcniBVQfW4b8BUvBaD1fnqi6u8DEaS4MJNu/QZdePCFwZj
         82ibMg92lR4A8qINnwAsKHntkhZDiRAJ4EkQpr/IsWam6eMn70x3iTxJjvIBPvVsSCIX
         AZ8cgiCmE/0lHVwfQ8qmvwKK5F2YX/ZMJGy6TLbskOr+IATM2YXAF/AbTAqahzwtOUWl
         OUhMIbj5Zyh/bwHel4I8XDnIESSrispj9fIYM69dNgo1ms1vyHZ1QORD2h8JpqJmN/RU
         WSG7l1l6KggkUdhMtKbKhaq9jWHM3gMGC4WS4nbBMSX7r3vydsPIOSKsiLmEyMT/wluq
         G/4A==
X-Forwarded-Encrypted: i=1; AJvYcCUMagwlKggGTOcgcnWB32q3SUoqekYQYfCYHyEjthtXOAeLo4Cj6uZkvfUS5X0+m3RKD8Qy1qvo@lists.linux.dev
X-Gm-Message-State: AOJu0YxRGsas5UtF/xZGuLkCHee+qJGfOWyjh2Ukt4sS5vJX/SU1M4c/
	Goe05ZeL/Mb24rHG8UbVp6aufX9rwBLuOSlxXK1C7+0qNUA5HtmA4Z1o
X-Gm-Gg: ASbGnctc+zGGI96VOV2wkWgO9Q8+m5w8C6sSmwOrt1t9E8nJG9W9QXA5rmbMCgalLpz
	9HYgYozHxI1JN8u4MD/1vHBMogPd4PCjnF4wqJyFYb6WeUWDW7pLXhkQ9QuukIAcPt9P05vMSkB
	sfU62/8j5WKHutsBE4/W6R9upLs2NfKDE1CLrdDRlfOc2mN7QDY+TFQZIGn/o9vpD5nDMRAK/R5
	Khbw7VQMEXVrjxDsWoLd/g5V5//QFp3GP5QhMzoKeppVPIvGohdywosBGEE15EaenkGbcDTa6N0
	i5NsdiSczyqd8XK2UQEaOd33376JrHPZSEQto65y8rBPKgmurKoIFSLk2N5TEQe98N1MxdPB0nq
	5RS0rtE86cjoFozSbphXexteEF9aC0ExYZGsmf/dbVJSeB7gR
X-Google-Smtp-Source: AGHT+IF9s+/76+HLGw2mLZk76tGq6/V4j0p5f2hCMj0ootyyX2pqmy4ieClzRxxY9elYI46O7lbdMg==
X-Received: by 2002:a05:6000:2dc8:b0:425:6866:6a9e with SMTP id ffacd0b85a97d-4265ef6e5c2mr4984366f8f.0.1760089393527;
        Fri, 10 Oct 2025 02:43:13 -0700 (PDT)
Received: from localhost ([212.73.77.104])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-426ce5e8309sm3283123f8f.50.2025.10.10.02.43.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 10 Oct 2025 02:43:13 -0700 (PDT)
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
Subject: [PATCH v2 3/3] init: remove /proc/sys/kernel/real-root-dev
Date: Fri, 10 Oct 2025 09:40:47 +0000
Message-ID: <20251010094047.3111495-4-safinaskar@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251010094047.3111495-1-safinaskar@gmail.com>
References: <20251010094047.3111495-1-safinaskar@gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

It is not used anymore

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
index d4f5f4c60a22..fb0c9d3b722f 100644
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

