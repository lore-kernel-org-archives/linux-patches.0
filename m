Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FC3526B2D2
	for <patches@lists.linux.dev>; Sun, 14 Sep 2025 03:59:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757822375; cv=none; b=YSycIUiy7epBzXVjCE5r/v+gfg65Cty2XL1R33I8brBYa3QMIDqRG9YAk37KRUTSUILTFPIlMvSB9JZBov9uias9HWJ7mPJ67acN5Rd/uDAk79+ZjSaqyOVDhzRWpRjkOmBCE+Jz57m8EaO8kJNABbGe3DiOfGlnDGxEJjBNOoI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757822375; c=relaxed/simple;
	bh=dWOevKs33KVPp7BfwW01lTdoAaIwqA9A0zVQ5+zAb7o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QsIPvQ9Xg2v8RLE4OxtRR/UGaLQpksHhBJcE0/BlUtpb3pjSjUJrLPXd5SEYPC4XFXGu4i+5O4+LXqx/nCkZk6f6Pz+pHvs95PKyXcrkbtyx87agt5kdAeH6wygSpttyXh3I7sAv0W/IBj0zKijLoTKeCvCrDTQ5q8qovJs2JDk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fe+ny9To; arc=none smtp.client-ip=209.85.218.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fe+ny9To"
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-b0787fa12e2so446783366b.2
        for <patches@lists.linux.dev>; Sat, 13 Sep 2025 20:59:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757822372; x=1758427172; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=O9abWz0+AALTE1DyE86pUo1tihrL6Hn8wt7mMTmG960=;
        b=fe+ny9ToGnApEpgI0Bn9xFgiqiC7djZ79HeDaGN+MwgWGJYsrozbsipIst4BXuXXHn
         +nOTZFvTHaElWh0ukt6R0zHg5HRFJ3aEO6xCg158/49XVyDb6Xox4LweXxnJy+FCtsQo
         2y+gJOtmmFGXlUSAAjVMT6V6qhXzPqG2NtDdyCPPSU4MJMYhJKCmF6iY1HO8fnYoaprc
         55+z2JuErsQLWR0BuEgzdw+gBwnMw8WxR+qRZ2zY8kGULG50Mazn+rSsNERYB/hi8b6w
         6wWqaa2iu2WnS8LjdwOmcTLrLldc8x3K2yAhVgsbby3ghObSKgOK7kOAgrsk1+iPelmb
         NEpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757822372; x=1758427172;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=O9abWz0+AALTE1DyE86pUo1tihrL6Hn8wt7mMTmG960=;
        b=vMIsiQqO8c0XOy5z4mZrCBSuOo3MnZQVGtTWrMGAiS/aqBZ86mtf9x3J0hnhcB4pe+
         wdBWBFMCgSPY9aLOFM+ceZy/VuxpbRHMkPKPKpZ7n9NFM6aDwccYBTrckVyhlMEm0577
         Tx/smN6sD5EzbuxFIyD5xb9hiPi1OWhIIlJ1CzcL0JJkbnDKrfG8inVPCSd4SpuYIsKx
         lq4m63YL0lgfPbUaCsuA9nnBOmayCbpXTMDZdgQ6nMQ4FoBoemDdI909gtVeSZ6mtF81
         aDqf1b7BciNJkTmYdEflpWo4d+Jpr53U69+ELYu4yMH0NAKIUid/GetDh8Kd1yFNb6Tt
         k9iA==
X-Forwarded-Encrypted: i=1; AJvYcCVnAQ26xmLi7695T+jbZcAC5bpasklBoJpqUszt6ePGpJ75epiXhUWPkVeurY5XFZuBRGphffqv@lists.linux.dev
X-Gm-Message-State: AOJu0Yy0INUIK5MXSqeRxuKajtI8GTxBxg6qHn8GvDR6iZQo0N3a+JRC
	Y3LtKtdiEBI3HZnL9XP0Wjx0RW4SLFw6iP+Ga677+d242N9nDvEqf01m
X-Gm-Gg: ASbGnctrwe6mO6Kvjf2KgaeN34voXvMfq9CXQljpkmDF6fwax0AxpJ++1FGNZJ2xuHU
	pbNH2Jr39f99KU0ydhuaMrWuhuKQ4wdyFTpr+cD50RbxF0iNyzbyzSEc+j4qc15x4z6nJ6nJj9t
	JRVbJCGztkeGbxvCgzZudYxJffXTYA+f4jYgHHAK7RZ69vjMG86ybDHLapGZGRK/+wDjKIFYlMj
	lVHTrRmdhw9sVKOTmrWBoavis/vD+i3rd6hF6M+pXpRWFCyK+0A9mTI6pZJ5/U5aZlMEh6Ml60h
	fy4eYkXaxi5o/YxSdY7co6GnPh2eYoqHaxz3RdmxpBSg3FsXVXpegCeZDQ/nuZ2VkUu5lDQ2lAe
	aJH9S9d35GUj3rbVT6J8=
X-Google-Smtp-Source: AGHT+IHIaNmlQUOqaI2XvHaD2x2sJJCA+iwXMxeIqgPaozK4MzRrxS2gXxwIxVkINaRf0GrOSh3U1Q==
X-Received: by 2002:a17:907:3ea6:b0:b09:48c6:b7ad with SMTP id a640c23a62f3a-b0948c6c6a4mr387666066b.57.1757822371514;
        Sat, 13 Sep 2025 20:59:31 -0700 (PDT)
Received: from localhost ([212.73.77.104])
        by smtp.gmail.com with UTF8SMTPSA id a640c23a62f3a-b07de03d93csm287001766b.12.2025.09.13.20.59.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 13 Sep 2025 20:59:31 -0700 (PDT)
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
Subject: [PATCH RESEND 53/62] init: rename kexec_free_initrd to kexec_free_initramfs
Date: Sun, 14 Sep 2025 06:59:26 +0300
Message-ID: <20250914035926.3770703-1-safinaskar@gmail.com>
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
 init/initramfs.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/init/initramfs.c b/init/initramfs.c
index 40c8e4b05886..d52314b17c25 100644
--- a/init/initramfs.c
+++ b/init/initramfs.c
@@ -690,7 +690,7 @@ void __weak __init free_initramfs_mem(unsigned long start, unsigned long end)
 }
 
 #ifdef CONFIG_CRASH_RESERVE
-static bool __init kexec_free_initrd(void)
+static bool __init kexec_free_initramfs(void)
 {
 	unsigned long crashk_start = (unsigned long)__va(crashk_res.start);
 	unsigned long crashk_end   = (unsigned long)__va(crashk_res.end);
@@ -713,7 +713,7 @@ static bool __init kexec_free_initrd(void)
 	return true;
 }
 #else
-static inline bool kexec_free_initrd(void)
+static inline bool kexec_free_initramfs(void)
 {
 	return false;
 }
@@ -743,7 +743,7 @@ static void __init do_populate_rootfs(void *unused, async_cookie_t cookie)
 	 * If the initrd region is overlapped with crashkernel reserved region,
 	 * free only memory that is not part of crashkernel region.
 	 */
-	if (!retain_initramfs && virt_external_initramfs_start && !kexec_free_initrd()) {
+	if (!retain_initramfs && virt_external_initramfs_start && !kexec_free_initramfs()) {
 		free_initramfs_mem(virt_external_initramfs_start, virt_external_initramfs_end);
 	} else if (retain_initramfs && virt_external_initramfs_start) {
 		bin_attr_initrd.size = virt_external_initramfs_end - virt_external_initramfs_start;
-- 
2.47.2

