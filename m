Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4122319E98C
	for <patches@lists.linux.dev>; Sat, 13 Sep 2025 01:17:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757726242; cv=none; b=JVYziDNSD2ev4X8aO8xwpbMMr4Tsx3fuBHlzdDDus/gsKw1A62PoBHWymmgU45Qile5Of1UbsdWS3YNGnPw6jKje17mdKKd/IOYHvJTK6BWrFFuQF/568SyhWMeZhqjPS1a0aL1blmZc5we+CN0QqZjvxViBbglAq7c6o/NiEH0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757726242; c=relaxed/simple;
	bh=oyncyjaLrzPFmjkp22Lh+fbFcypfHWy3Ry54UY3bgvQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HYmJfc+jXVJ40WLM0JcDj/RflapYNPjQ6FngwpyEElfFoMPZMKGiR/OdNKZb84+fe9Qh8vAuIXLUDub3FXZw7xJW0eG6jY3HDDFjO6i5cqWOhIn8le1w04YkaCw7I9XRlXgW+UdtXoL5Jv4o9AvpHuYDCZheH+rNVwEFcLcrodA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QMUYk7lG; arc=none smtp.client-ip=209.85.218.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QMUYk7lG"
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-b0787fc3008so355049466b.3
        for <patches@lists.linux.dev>; Fri, 12 Sep 2025 18:17:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757726239; x=1758331039; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lOKK4KIFki64V1O84ArLWA6Jx4UbLCdmK3IY8vRFz3o=;
        b=QMUYk7lGtsZXevu6tpmwNTNkEhiI3s1Rv4CfIaDKtgkUB5oAsNUaTdlaTbRTdUofP0
         uuxZ5k8d3lFaYneuCOiiUh8us4NhkCdu+wt1APqF/uyQIZnudekBetaHwfMjKUNjrGAV
         dY35tm1sEdNs8pLr5iIpBu8OlS7dYTfmlIQQgAKoKyIXsx6LE5/KWsymQculM/5zgpFD
         YU+H9EC7wwQHp2tIcrNuoWlCoZj8ql2Gn86nygDdFKyCspzIbrsODdQBSAICyp2rZmAg
         pFaxl8ILCiISijLkGtLHx147BRWiYtOIk/HEjng0RFzHENe62Z932ammUA9tgJYCsDsg
         mtCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757726239; x=1758331039;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lOKK4KIFki64V1O84ArLWA6Jx4UbLCdmK3IY8vRFz3o=;
        b=xHAbF2fDSPR5mF8xvN/b2+Fbu+vsGW46HPO28CHSFiE3QrVfpwoTI/Nw+ZzDIDIm9n
         b3fB0nDkXqU57KmXYaIW1b/aYeHfTn3REzIpN9RCYnsl1LIYULjhBA6Y4YYV6z3FbJkL
         NjenYa3GSFjUinToKOcCONqFVI9pQ4xE7ab9qwWUUmi3nylWrtNuNxbMYkJUGA8JIPzc
         bWI+ZGU9uPXNfmmynQwqk2ROamYYAb86u4XVrPd3faNEXLWlGO9gTedIDKNLwCNqUIRF
         Ex4/bpgg7jdynF1goIaZIl4wl9Gm6NV1e1Ku8bak5UqzYQc0VMhJpi+reCDvo8ti7zs5
         xzsQ==
X-Forwarded-Encrypted: i=1; AJvYcCXHnKUu+Szx9D7s8jVXSO/TrZuzW4gwT/dXE6rk1Nsnhc3GfAxFh3yxUZlYkodM86TZYTtVYit0@lists.linux.dev
X-Gm-Message-State: AOJu0YzG+fUgL9N0SbyDYco+vV4kDrIq1iul/4lpmcVzQDaK3hR19bDJ
	FKSKpvYVLBhqiu/PbtosMaKrD5XT2JinayjT/IrKSrvlgbz2+ljs2JXi
X-Gm-Gg: ASbGncvFFZjEfKiW4hmlcw0A3IuqcknSk5IB1f9lclQWx+GvPZnxpnOojSaECIvsXgq
	2xi7Cw3dVTF080gY/BubuPNG3YddbNUEYRONXh4iFdGjEC4UF34Sfu3dR6e9QmmXJkl3u1BdZnU
	NHg/tU0f6+64/HkdK7qFdOGoYVbiboi4Npx+B1kJtynTRtgGlggmrVQ1OOv1pSuzm+eW91XCwVa
	X/YJNKGdzUv6aqa8coapx0u/s8GMA4otGjeo3WLwHH5wV6NQU0aQ6HEgGLyg2xVZxF9MhM3xIpe
	u48ax/JC349fiDeoEvVzNs9xh+X5JKX6DKbyCDZBfcUSqFVwjzullJOttDk7hqWcNmUpFFMekoR
	c9eT7ZJhSvKUIXzxpwqk=
X-Google-Smtp-Source: AGHT+IGWcEC7VhNjJKZzReFkWP7F1gkqH4tvvChKQBMnzdm+44287e9kqOEvM9aYYFOmJE4OYY5/Qw==
X-Received: by 2002:a17:906:4788:b0:b04:b435:fc6b with SMTP id a640c23a62f3a-b07c3a79fefmr497358466b.60.1757726238469;
        Fri, 12 Sep 2025 18:17:18 -0700 (PDT)
Received: from localhost ([212.73.77.104])
        by smtp.gmail.com with UTF8SMTPSA id 4fb4d7f45d1cf-62ec33ae181sm4478774a12.22.2025.09.12.18.17.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Sep 2025 18:17:17 -0700 (PDT)
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
Subject: [PATCH RESEND 34/62] init: inline create_dev into the only caller
Date: Sat, 13 Sep 2025 00:38:13 +0000
Message-ID: <20250913003842.41944-35-safinaskar@gmail.com>
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
 init/do_mounts.c | 5 ++++-
 init/do_mounts.h | 6 ------
 2 files changed, 4 insertions(+), 7 deletions(-)

diff --git a/init/do_mounts.c b/init/do_mounts.c
index 5c407ca54063..60ba8a633d32 100644
--- a/init/do_mounts.c
+++ b/init/do_mounts.c
@@ -366,7 +366,10 @@ static int __init mount_nodev_root(char *root_device_name)
 #ifdef CONFIG_BLOCK
 static void __init mount_block_root(char *root_device_name)
 {
-	int err = create_dev("/dev/root", ROOT_DEV);
+	int err;
+
+	init_unlink("/dev/root");
+	err = init_mknod("/dev/root", S_IFBLK | 0600, new_encode_dev(ROOT_DEV));
 
 	if (err < 0)
 		pr_emerg("Failed to create /dev/root: %d\n", err);
diff --git a/init/do_mounts.h b/init/do_mounts.h
index 6c7a535e71ce..f3df9d697304 100644
--- a/init/do_mounts.h
+++ b/init/do_mounts.h
@@ -16,12 +16,6 @@ void  mount_root_generic(char *name, char *pretty_name, int flags);
 void  mount_root(char *root_device_name);
 extern int root_mountflags;
 
-static inline __init int create_dev(char *name, dev_t dev)
-{
-	init_unlink(name);
-	return init_mknod(name, S_IFBLK | 0600, new_encode_dev(dev));
-}
-
 /* Ensure that async file closing finished to prevent spurious errors. */
 static inline void init_flush_fput(void)
 {
-- 
2.47.2

