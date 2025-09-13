Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0B071891AB
	for <patches@lists.linux.dev>; Sat, 13 Sep 2025 01:08:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757725711; cv=none; b=ZIG+7qLh97tTxlluf0baylW6dbCIrQZJy85xOddPCe9aayMqjrsvRXV8b92su34SypcUWPWk/FgDKFtjjM/EVf1mIwD2o5fkR7481urPTnAzh+oqa7Y+9bVql5Ixjt3tYveVF7g4yCrA7BSjT9l7DDr5vN1vKprtkqidrAyFTok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757725711; c=relaxed/simple;
	bh=gH7Rddwu9MUu/+t3B7A94tjqEJhL770gz/5Md0mQZOk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rojh4ts563D0zzoiZbvD2lBP99Mfukl99+lkYig8FWSb2Xv4Azi7CrJ86463oXez+s39pDaN/tU6hP8E1ppztBAniyKaUpmkfAi2bfkaPT8SVjRxFyjAig5elM5m+sq3h0vd9UL0RFYiJDbNI26Tp7X5N3/Pk7IRNXHCKJCMq5Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PJyeizMF; arc=none smtp.client-ip=209.85.208.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PJyeizMF"
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-6228de280ccso4872647a12.3
        for <patches@lists.linux.dev>; Fri, 12 Sep 2025 18:08:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757725706; x=1758330506; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=076xoEVbaVUh2WXJ09mT2DE1QkI5WvxeMmJOzlrP1Zs=;
        b=PJyeizMFr/2MFiuo31bg9mYkGOXf1RWPfAX2wL0humtSBc4Gyijv/qkZ+qD2kMvSna
         wD8O4oH0hREuZYtJNlfPg4pcLHtJNZViHcMDAblaku3D8NIuP4tNtaLgknp0e4ynbqx+
         BhCTzkCrzc5vLRJ3izQ76UhdVCjQCKKjiQ9cbHTDCPOw5hX7g/KJ/Ux54BaLM/shLJYr
         +jzy4+81sE+2uZl6nsPdxzLpOIranHkzW3JE8vhzvZWslu5qnmtgeia8fkCWTeBTqHQc
         GoTzrAqldHuG1WAlh1ABgqHr4VfGaLLxcdW0+lun9AGb3/uhkap3aJJDksz10FE/o+2h
         jsLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757725706; x=1758330506;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=076xoEVbaVUh2WXJ09mT2DE1QkI5WvxeMmJOzlrP1Zs=;
        b=sos2IvHtI7KnwrgJ5wonoVh1xNifL42Pi6Kr4NbEByGDcuiOOOWgFA18OMJgmqWPTb
         0gjC3pyG3gRDJrOc4G+1rJt/Wzo/5SX6JKPGN8sOneoNeMUbaL6WjEa3YRumd+UQmmQz
         GkQmKNp7V08vLMahawLd+qCycNygxJzyYBFycFsw+zAl+q9v4D8twvLCj1/WFlABmr86
         GTg+abCaJTA1wV5hjZtpJLR4Ulhg/kn8habaOEngK+Oeu4zVBWCcVA2d0pFQhTQjXWkY
         EEv1SqcoIejYKwP6SjUBAtkd9RaKnLPaImJzRh3XfrFWJpXaAGS15zuLm0WvCyaQtycH
         rosw==
X-Forwarded-Encrypted: i=1; AJvYcCVrypu6F0iokSO1Ezhm/W7uzmwqzZo/og4goMCSWmPKxJeBAz4lDc9lkHP4tgWUFkvaCnSHAqC0@lists.linux.dev
X-Gm-Message-State: AOJu0YxIInSp2ilIij9m0OGpn8eAF77pnrrn0S54fWnLJLAeqjIBtKuW
	7B56aLAYDx7TOH80llwWp0qnyveoSztj7FRodAafoOyGtAQY5R483xX5
X-Gm-Gg: ASbGnctB22xmR1v0YHvmY/kvYkM5Cu+zs98xq5h8Jse7zdBm7mWVQiEMpjoW89pk37L
	si1k9ho6E+k6o7ywwO6fWXlVAX5VNmlFSJOUI9rVZhK9FcVE7ohAfaz9hGCXPSGeK86ixPVCNw1
	med5z93+0XL1XA6r7wif0IBCZDtv5JU8Ejfr4zeHNOkb3s4wGJCM2iKWJ+DUeZrYQ/cc5vNFrHa
	8GKmVldUaXM0ky30Wy67CxtNEMGZgge/PnxU+6EDxrQF+lcKqbOLcUGI4mbzxS3DbD+xMdzvl4x
	P8j2tGr2NjRZ4dazkmXNFoiTPKlDpD3Ta0a1h7DKYDGVbrmq2pv8nRQY/ZFPvF8XszNVbbMm+tT
	jH4xNiCE3/rBk85EIWmh0X1u+l3bJTA==
X-Google-Smtp-Source: AGHT+IGdk3XVuMADNouJH/aBQO3dgisawWr0ra1gK5dmtwng/BJ+8DUWD+mdbhpnTmhbFrSAIQbncg==
X-Received: by 2002:a05:6402:26d0:b0:62e:e5b3:6388 with SMTP id 4fb4d7f45d1cf-62ee5b367b9mr3462166a12.19.1757725706048;
        Fri, 12 Sep 2025 18:08:26 -0700 (PDT)
Received: from localhost ([212.73.77.104])
        by smtp.gmail.com with UTF8SMTPSA id 4fb4d7f45d1cf-62eff1a5c6esm720024a12.50.2025.09.12.18.08.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Sep 2025 18:08:24 -0700 (PDT)
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
Subject: [PATCH RESEND 26/62] init: move phys_external_initramfs_{start,size} to init/initramfs.c
Date: Sat, 13 Sep 2025 00:38:05 +0000
Message-ID: <20250913003842.41944-27-safinaskar@gmail.com>
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

Move definitions of phys_external_initramfs_start and
phys_external_initramfs_size to init/initramfs.c

Signed-off-by: Askar Safin <safinaskar@gmail.com>
---
 init/do_mounts_initrd.c | 3 ---
 init/initramfs.c        | 3 +++
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/init/do_mounts_initrd.c b/init/do_mounts_initrd.c
index 444182a76999..06be76aa602c 100644
--- a/init/do_mounts_initrd.c
+++ b/init/do_mounts_initrd.c
@@ -15,9 +15,6 @@
 unsigned long initrd_start, initrd_end;
 int initrd_below_start_ok;
 
-phys_addr_t phys_external_initramfs_start __initdata;
-unsigned long phys_external_initramfs_size __initdata;
-
 static int __init early_initrdmem(char *p)
 {
 	phys_addr_t start;
diff --git a/init/initramfs.c b/init/initramfs.c
index 6abe0a3ca4ce..5242d851e839 100644
--- a/init/initramfs.c
+++ b/init/initramfs.c
@@ -600,6 +600,9 @@ __setup("initramfs_async=", initramfs_async_setup);
 #include <linux/initrd.h>
 #include <linux/kexec.h>
 
+phys_addr_t phys_external_initramfs_start __initdata;
+unsigned long phys_external_initramfs_size __initdata;
+
 static BIN_ATTR(initrd, 0440, sysfs_bin_attr_simple_read, NULL, 0);
 
 void __init reserve_initrd_mem(void)
-- 
2.47.2

