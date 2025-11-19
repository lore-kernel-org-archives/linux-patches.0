Received: from mail-lf1-f43.google.com (mail-lf1-f43.google.com [209.85.167.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 112982ED159
	for <patches@lists.linux.dev>; Wed, 19 Nov 2025 22:26:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763591220; cv=none; b=I4pk5nMAMj0w8Exa/wYlnIrp2wYno1NttWUrHzQdWulc1rtpSvc9t0jwK0KIdMs78Md1BH3WP79jtc0mGV6pTLaBSN+vIvNlDao4gL1ekFmFwDELKy+shXpxTCQvbKncnS7OGJp3VBlkpBll3NhjKOCkfAkE42qZaXfMNhQ7r0U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763591220; c=relaxed/simple;
	bh=qOnnawt4egcjVD3EMm4ADkZ2z7Vo9vrDOjzvgdq3kes=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EeBurcFnV3v08ev3CAhDhWnL//5U5/Wlg3OM7upqz+9o0/+OJXfs1g0Sr1aj6O7s0CwBecTfvrziQA0zfgxQiciHtMFhnHbz41RZPXmyfXCcuCNNHUUX1f7OJW86UsWqGzfPEsoBmzcdOv4aJP6qVHwvr65y9aTrTrQ1wrpcxzU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nfH9ILH/; arc=none smtp.client-ip=209.85.167.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nfH9ILH/"
Received: by mail-lf1-f43.google.com with SMTP id 2adb3069b0e04-5957f617ff0so215754e87.2
        for <patches@lists.linux.dev>; Wed, 19 Nov 2025 14:26:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763591216; x=1764196016; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IBHV1EUw0WBXSKlFcI/NhGu5XRuHQn0XLzAOgD+DTYU=;
        b=nfH9ILH/7y47zKqSAH02FSC22l+FBG5LSBN8WenDziDfEAJYiiJq3PWtaCtMM/BMm+
         BIvhm5IRYmHD+Cm5t5X0cvYiIxoFGXpj8J2YVBKjdKHkCZI4TzGpjEm/fUIxF/AjTvcU
         X1UpPRZiMyzfooPtYZRftOmdoWxOkGFdjH8ldYr5n8+UrDHqYUXt7A3yno8aBx5yI0EK
         Pod0uZrIkyxb7ExOUgkTXj/NZSnsO/2zlh7rCetGUhCgsVpyBKNhYZStG+on0EEzdKjt
         q8g+KaFCqcigutbJ1nKJn+hjhrQTTdr7BQ2+1aBhozQ69DPeBHwtTRJveV4xjQmI7C5I
         02Gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763591216; x=1764196016;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=IBHV1EUw0WBXSKlFcI/NhGu5XRuHQn0XLzAOgD+DTYU=;
        b=mVmdEkOP/X4tGwhPr1nrIS5axLnDgcgt5Dsxt1nvC2BcVZ5NJnIj1gyoUmZuGb6SMu
         7jALsYJ1VlHIx2+kEiE8Y8EzvqggG063YtWu0vecDY1sf95PfuOgw1R90lCZF3G4oDNR
         qWo/iG0Pal+MJU1VFZ+NgAyTbpPIoGVokQs0cZf0ooXj0MSxMndS2CQAGqaQ3B883n2I
         95MKkmKD0Sr4kae+7VDqDVUxu12V8rS33JkLdjqV8+SMDnlmLIe4vRL2zaS6LDDZnMDr
         JO/2bvPz3g4oWHmg2UNY/SXIdxOu/A7sVoYFRkWgLpzWM0xatXYNrhmf4+PmIcSfdypw
         CrBA==
X-Forwarded-Encrypted: i=1; AJvYcCWLnxFW8VfTdekFQg6llFvDR0VizBRXO2izWVN79lwQ0U9GW7aVDks0ybUGHC16r/GkSwk6GkrX@lists.linux.dev
X-Gm-Message-State: AOJu0YxVyrhUml/RDYomDPFkTl+V3BxFJNIQf0C6ahhZsMdrQxsjN5pk
	v+UKBBGlqpHkGUIkL9jV9cikLDV/XBcCulH90avvQzgCdMxsXOI7fRHipY8Tnw==
X-Gm-Gg: ASbGncvt+IEZVHu8vWuxxov72vC7Hfwy9LHL8u/f2Jq2toeyHW1THAwWCbhyaSgBSoO
	Wju3uAykZPcYkwLsyBdwXGmbxYgyeS0Fe9eWIF/uZvOaUV69w94LPlStRKx6S5v+v4C9pvHu3+i
	bfKcOrRgY4cvuERBhY6CgfsFzlDM1hgi6ezMEcorODfdEiYaGHBFqnoeAM+sVtaoV8HxlHzbq2t
	5PFLnUwl9k73gYhQh0fcg0cFTY8eK9Ee1yybWT/tvnYKPj45APka3mbenfa5P+sOufSm4FrhcnG
	/IPu4jK5EqhEOkzqywndB9BMpxBmOiZQI//Wt+RSr+AqYBiUxCogUxx8L4jUesM6KuB8dBJelV8
	TWXuDmBcedNO4lAqdZ/MTbXZSGKsjdX00jqW/30gXhR7rCruPGq/OSgfXxzgoNYVVGZtmxCVjv6
	yUqzRBpyT0
X-Google-Smtp-Source: AGHT+IFgA9RKL+uFTnctiFZKqulaPxewVQd+eAgCSkyCWbVEq5Iah76Q4RixKmx92rXz16tT6l4F2g==
X-Received: by 2002:a05:6512:3d08:b0:594:25e6:8a3a with SMTP id 2adb3069b0e04-5969e2e74d7mr178185e87.20.1763591216022;
        Wed, 19 Nov 2025 14:26:56 -0800 (PST)
Received: from localhost ([109.167.240.218])
        by smtp.gmail.com with UTF8SMTPSA id 2adb3069b0e04-5969db8989csm168021e87.39.2025.11.19.14.26.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 19 Nov 2025 14:26:54 -0800 (PST)
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
Subject: [PATCH v4 3/3] init: remove /proc/sys/kernel/real-root-dev
Date: Wed, 19 Nov 2025 22:24:07 +0000
Message-ID: <20251119222407.3333257-4-safinaskar@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251119222407.3333257-1-safinaskar@gmail.com>
References: <20251119222407.3333257-1-safinaskar@gmail.com>
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
index fe335dbc95e0..892e69ab41c4 100644
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

