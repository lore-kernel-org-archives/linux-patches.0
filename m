Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E81EA72623
	for <patches@lists.linux.dev>; Sat, 13 Sep 2025 00:54:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757724857; cv=none; b=Z+ZuVhI0ujLCHPyk15674puiFaP4r2LCIRdc1xZNdd3IDly8lJ4PRLDPjORYXzAdTp0zsOajUR5yKhI0fVoGZOzmVdSF9Q0pqTbWyA93RrT38rgKfWDURTImAojEVdO7zQTR8CKbnU6T+6jT+B5YuzfvQXBCJvNJlpbaZ//O57w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757724857; c=relaxed/simple;
	bh=Jkxu5ZUI0H6ttWYEi4Z84BWe03GXjUbvUo6lUIoM5rY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QYCN8P0E9Y0Du7WPDn8liOdkC00snf5Da8uougHz4EixNa0W5qJMf1w71hfIcbrXsM/Mowe/EF3L2nN/dU+eCAJA+H1srYbR/kyLT/AHJOMZ2//b9ddgXLb0vMix5y7oLWoEb0+owB20ziN8MWZdj5KoGCPmDHL+SyvB6rtiR4U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cH8wUf7s; arc=none smtp.client-ip=209.85.208.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cH8wUf7s"
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-62f0411577aso368803a12.1
        for <patches@lists.linux.dev>; Fri, 12 Sep 2025 17:54:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757724853; x=1758329653; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HNaBVV0FpkKN0cdUwxCZ8fQss5eC0TEeX4co/5GJ2YQ=;
        b=cH8wUf7slB2TQ3AKjdbsWbVwUpo+C6QRxzq9+JVg+WgYKbozFIhrXBAfgPuJhgWr7/
         GgKKcHCyoCk6TLJ2os+HBKDM5+uqhvWHNyAHe5lQzEsEsNHoxHVMx4K6lJX65sSI58M7
         VVnqmp4AUQ1TqjbEepd3JaKSBL9GzK3y1C2eq1Y+ZDg9y82YTqHKSOOPepK5Fdbe8l67
         PQ3dpXjmHi65uekgBlc49K8cuo3wf79NqPhrAcAJDQ97ekvfMTh/b/bQo9ztlOSy+8Ly
         gZEirFKBPpYCTvd/DoHV6YUFwFDKKIKR+4CWHr7wRKT/XBSpfTGxI0WHHEonglIbii2g
         wSmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757724853; x=1758329653;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HNaBVV0FpkKN0cdUwxCZ8fQss5eC0TEeX4co/5GJ2YQ=;
        b=Z2mAA+3m2qbiQSFuKWdwbaHq4mZcBUTZ93Ee8OMww+wGv7EL18bJCH92mdHwiZHFjO
         RqqqKBNcO+NtqT9Cs5xap0KgBQg97MqBZvOU11EZtOAs9N0Whu9B1z4sLmK2nt8oMk1d
         /oXwOUpsAxvu5T6Cam5KB/MHIgUuN8g4z1DB7ig7N6uerd6CN7MhE+5rdu676vfTkA2T
         6k0jGEeFbOJzIpwes8l8LFCK+6qGtakfwuOiRY1K+u9jwQ5Vld/eSiBMIeuZHzTmau/X
         BbxCtEHlfPwRHiWILMY2oXIl667wxajb4gqyV4neCW9DNocQI9f0nLFEGh4EpEgGa90g
         mEhw==
X-Forwarded-Encrypted: i=1; AJvYcCX6XPNgX0l0x7LIrr/J9CgKT4SCOjASoK6DOmptJiHktFmv49eOlNQMHWosqjonhAWLqnvtaj6Q@lists.linux.dev
X-Gm-Message-State: AOJu0YyarRJ/KKIbhpRv7BmF80pKx6a+OH1gMRRXS1XfnjpeUyuBfgcq
	mSQFRJjE3EAnyo599IuC29jeRVJX6uIV4wuMep3DBTOvLJ5WS9rRR9RO
X-Gm-Gg: ASbGncvmClj5+AcK2J7Jz6X02XU4iHkEplHxFuPpltK5Oa7acusOIZipfHnQvcylDef
	UVm8ZjaABZQqRDSQRrEA6SlTslD9ERf+lvjmGxXbrNUdern466CUDAg1aKqg5ix0ZVygNQBMGdo
	r5AXJ9j6es4mf1LyavsvQuHKkp4tNYPysqgwM2flG04HhMwRu8wVgXKJplBCiUYcf0HdxIOtTdH
	WqkifuNd1MhAYDNcN1ywiAJYbb619o6hf+VbKFiumhLTFYGKpQokG9mLp+jgs7fzlS55GCfYdVN
	mqw2/su8Lmx9zSwqiUGPFikMe7RlwCJsExxY3HEJ7IdC27LA092xQnHr1tL0rN21LaL1s4JTqJ9
	FSGLlVxmeGcZRP6DxxeiBZ1rUVWQeEw==
X-Google-Smtp-Source: AGHT+IFRAhwUW5zsVWdQl7rom9u+xngcdJiQFGIxNb9yv6sUT2JdEwHxw5AIwBj5WkuunZa0hzcUAQ==
X-Received: by 2002:a17:907:7e8c:b0:b04:3513:5138 with SMTP id a640c23a62f3a-b07c37fca87mr474198766b.41.1757724853144;
        Fri, 12 Sep 2025 17:54:13 -0700 (PDT)
Received: from localhost ([212.73.77.104])
        by smtp.gmail.com with UTF8SMTPSA id a640c23a62f3a-b07b30da310sm465332066b.20.2025.09.12.17.54.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Sep 2025 17:54:12 -0700 (PDT)
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
Subject: [PATCH RESEND 13/62] ext2: remove ext2_image_size and associated code
Date: Sat, 13 Sep 2025 00:37:52 +0000
Message-ID: <20250913003842.41944-14-safinaskar@gmail.com>
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

It is not used anymore

Signed-off-by: Askar Safin <safinaskar@gmail.com>
---
 fs/ext2/ext2.h          |  9 ---------
 include/linux/ext2_fs.h | 13 -------------
 2 files changed, 22 deletions(-)

diff --git a/fs/ext2/ext2.h b/fs/ext2/ext2.h
index cf97b76e9fd3..d623a14040d9 100644
--- a/fs/ext2/ext2.h
+++ b/fs/ext2/ext2.h
@@ -608,15 +608,6 @@ struct ext2_dir_entry_2 {
 					 ~EXT2_DIR_ROUND)
 #define EXT2_MAX_REC_LEN		((1<<16)-1)
 
-static inline void verify_offsets(void)
-{
-#define A(x,y) BUILD_BUG_ON(x != offsetof(struct ext2_super_block, y));
-	A(EXT2_SB_MAGIC_OFFSET, s_magic);
-	A(EXT2_SB_BLOCKS_OFFSET, s_blocks_count);
-	A(EXT2_SB_BSIZE_OFFSET, s_log_block_size);
-#undef A
-}
-
 /*
  * ext2 mount options
  */
diff --git a/include/linux/ext2_fs.h b/include/linux/ext2_fs.h
index 1fef88569037..e5ebe6cdf06c 100644
--- a/include/linux/ext2_fs.h
+++ b/include/linux/ext2_fs.h
@@ -27,17 +27,4 @@
  */
 #define EXT2_LINK_MAX		32000
 
-#define EXT2_SB_MAGIC_OFFSET	0x38
-#define EXT2_SB_BLOCKS_OFFSET	0x04
-#define EXT2_SB_BSIZE_OFFSET	0x18
-
-static inline u64 ext2_image_size(void *ext2_sb)
-{
-	__u8 *p = ext2_sb;
-	if (*(__le16 *)(p + EXT2_SB_MAGIC_OFFSET) != cpu_to_le16(EXT2_SUPER_MAGIC))
-		return 0;
-	return (u64)le32_to_cpup((__le32 *)(p + EXT2_SB_BLOCKS_OFFSET)) <<
-		le32_to_cpup((__le32 *)(p + EXT2_SB_BSIZE_OFFSET));
-}
-
 #endif	/* _LINUX_EXT2_FS_H */
-- 
2.47.2

