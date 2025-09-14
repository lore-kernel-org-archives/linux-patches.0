Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1A2C26FA57
	for <patches@lists.linux.dev>; Sun, 14 Sep 2025 03:58:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757822341; cv=none; b=og22PufDYNDl29tt+X8htRIctJHXqMaEMzbFDsVIKjz+AZ++GQS3+6qBdsNn8pqklkliCdZMFP6zvtQ7nTYJm3cfzM3ZS3bgA82HpEGXSkbQfjPqzxgp4gjp/W2ZV76NH0by7dp+5S2iugHyuQ35hOmjn2yu30ZaAlVBGedHcuA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757822341; c=relaxed/simple;
	bh=wnloEZCAdLMdrfx5MH3Z2R6wkZPYS7ZaUTzWldA8TL8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iTAYuUUP69iEBeRChl0uonMtoMbeZtAOmJwzCMEeIZvwOPa8TV9+x7sR1GWQEBV48cIU3vyVa0nU0yH4lP1e+BnLjeOQ6G5gsS15+MuLtlmjXS04EivS7Tp/mmoMrc7nO/cFszvDqZiCXpNWIb/x42uTSlzQdtXvsqnwZhXPcbs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=J2FyfPmP; arc=none smtp.client-ip=209.85.208.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="J2FyfPmP"
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-62f1987d53aso719608a12.0
        for <patches@lists.linux.dev>; Sat, 13 Sep 2025 20:58:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757822336; x=1758427136; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8LDuJwsx1JnhEieEawhozXv7eEPm7AwX4v3UgIhLgCc=;
        b=J2FyfPmPF3aohvBF3cgfKjlGQP23PVnFT8+NAj8XkmKZGCgfWlUorOglLuWH1QSV9z
         T9N0ZOdSrW8/1OJM55a/SEIXAsblkUVp/E/ZtQhPEMaU6Gm4SxnVhYMTYZMrx4d5OpQz
         03GtcMZCKNUSYA5WmGn1/JZCNDXUlDTPRtoSnTvNJp+lfxivBZpslvgiyChiwTD/yq2k
         MO5oGCJYCeAhEo+2ttZMjI6NOW4lPZExGwq5i4JKqvkNLmQor1yr7T5FF5xeb1eBKyIQ
         +FH0TweNPjeTmDbX9k44RwNAdo/yTAd++MENPV8jY7aeqSkUBx3N8ETzU0I5UdLoY63X
         NNcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757822336; x=1758427136;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8LDuJwsx1JnhEieEawhozXv7eEPm7AwX4v3UgIhLgCc=;
        b=QB9D6jAOQb8usXPD1zZ6FtX+FN4C6z1rGvQvUfOSapMUFrGQEql2WbRhDR3z2sz1gO
         6wbClsl5iz0paAqBMKkYi0Bxob8bpHS3/rFXBa02uukin5nKwXzQay5wfuOaaodqGilR
         uJ5UgjyZC3aQhtFSx3+gggN4TGGQ12E+VH624/dk8gvA36xRN0rQU+BC7Y/1kPnh5ydp
         fk5Uz/tJYI5Ru7koYPGvjUBE6vzzL3TXn/nKBeyYy0BBcSJ6PWi3XmQRG4x83TSuMGVk
         VTbd58BBPtz1cAHLsMgebqPICGFnljJJuwzxt76iGMlgCAqKlR5d7GFFnaOK+2JhdO4U
         C6KQ==
X-Forwarded-Encrypted: i=1; AJvYcCV49Jl3zxBw1MyKsHlyIDPHnnURTRGrfzihRJQePJHk6fG3re/wC38iHJCAUO+rnEIEB1CCUMNB@lists.linux.dev
X-Gm-Message-State: AOJu0YynExEI/CfYsxZm9LnfVGNOVwNVcWIE+oJK/OXHgABjPD9ZDeAh
	3T/0DYMjyNIHaoTVRoARdGcYH/zgV0atS1Bn8hqXlWMPl7wtPcDzbDRE
X-Gm-Gg: ASbGncvigS/XWvRoOFmSq7YUkpmrIxvxUbcGNQUJ4yzdljBOXf8cAij8h7gLAvY2g62
	zaWiEG02rrAGFL/T1ggRL9MKusTizNFPHjt+i7/NWJEyLWMKbXc1k98T8KbgGknrjuIWzUmRvuI
	PdMKpWNeA0cFUuA3v6ilAKoy7Nl2LjIKF33G99OCd+jtckyblKPiuJ+j0Gd77RODJAWDKSNLvKp
	kSvqVr2sMU/aANsykP2WPdTTY6izWtw48EXrR9vglzx7zhGKIujSvJpmCc/4WuGPEVBWb/xovoA
	fZDLIXBSzSPf32ymdo1eT7eOEBdRFM9E3tXUhe+OEOMUyz4sCnTZpNsCcB4Evla/9wctk3Wvdqy
	xoJfRBe9tfrjG6GThIGjxSDuOjOZM1g==
X-Google-Smtp-Source: AGHT+IHNLaKXJiC+zXQ2uAPY4azg+7W3/1g8JczFufMn8mQqgVOZ73ifHuYY/OKrygFTvfUSeCcOcw==
X-Received: by 2002:a17:907:3e90:b0:afe:cbee:7660 with SMTP id a640c23a62f3a-b07c34d63c8mr797483566b.21.1757822335865;
        Sat, 13 Sep 2025 20:58:55 -0700 (PDT)
Received: from localhost ([212.73.77.104])
        by smtp.gmail.com with UTF8SMTPSA id a640c23a62f3a-b0cf2112639sm91581266b.104.2025.09.13.20.58.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 13 Sep 2025 20:58:55 -0700 (PDT)
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
Subject: [PATCH RESEND 52/62] init: rename do_retain_initrd to retain_initramfs
Date: Sun, 14 Sep 2025 06:58:50 +0300
Message-ID: <20250914035850.3762697-1-safinaskar@gmail.com>
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
 init/initramfs.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/init/initramfs.c b/init/initramfs.c
index 30e94ebf4902..40c8e4b05886 100644
--- a/init/initramfs.c
+++ b/init/initramfs.c
@@ -570,13 +570,13 @@ char * __init unpack_to_rootfs(char *buf, unsigned long len)
 	return message;
 }
 
-static int __initdata do_retain_initrd;
+static int __initdata retain_initramfs;
 
 static int __init retain_initrd_param(char *str)
 {
 	if (*str)
 		return 0;
-	do_retain_initrd = 1;
+	retain_initramfs = 1;
 	return 1;
 }
 __setup("retain_initrd", retain_initrd_param);
@@ -584,7 +584,7 @@ __setup("retain_initrd", retain_initrd_param);
 #ifdef CONFIG_ARCH_HAS_KEEPINITRD
 static int __init keepinitrd_setup(char *__unused)
 {
-	do_retain_initrd = 1;
+	retain_initramfs = 1;
 	return 1;
 }
 __setup("keepinitrd", keepinitrd_setup);
@@ -743,9 +743,9 @@ static void __init do_populate_rootfs(void *unused, async_cookie_t cookie)
 	 * If the initrd region is overlapped with crashkernel reserved region,
 	 * free only memory that is not part of crashkernel region.
 	 */
-	if (!do_retain_initrd && virt_external_initramfs_start && !kexec_free_initrd()) {
+	if (!retain_initramfs && virt_external_initramfs_start && !kexec_free_initrd()) {
 		free_initramfs_mem(virt_external_initramfs_start, virt_external_initramfs_end);
-	} else if (do_retain_initrd && virt_external_initramfs_start) {
+	} else if (retain_initramfs && virt_external_initramfs_start) {
 		bin_attr_initrd.size = virt_external_initramfs_end - virt_external_initramfs_start;
 		bin_attr_initrd.private = (void *)virt_external_initramfs_start;
 		if (sysfs_create_bin_file(firmware_kobj, &bin_attr_initrd))
-- 
2.47.2

