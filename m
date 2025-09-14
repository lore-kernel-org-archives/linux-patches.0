Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDF6E246797
	for <patches@lists.linux.dev>; Sun, 14 Sep 2025 03:43:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757821426; cv=none; b=oHZfRLPqpJ/IpQrZpZih6eRkNqBxtjhUd2r7RbqsNvFEdcTEWhHDT8UO/vtCrOXjP9Ffc++YE3/Mn7XbGN1FFl6XubnV9eLK++lkCAxQ/JZDj6WiameuJYdP8ovgukT0NrJPFoewaitTA6l1r4YeHesWjZGANkdXYcCcrdDV22g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757821426; c=relaxed/simple;
	bh=Rey/ebl7WFu2BHJpZO0tlGb9Yvux/yHNtNSpgXJUf3k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YyLexTSkvGkJo3wPN4RcdD6/AAhwevEOzhZ+gtdRY1O1it1W5xYS9ipxKPeYcijps/h9Ov/TWHtgwX0IMv0NqvvjQa7atrF2GnpYEEkSdxzsIpdGteljcQLvguVSJaV0uST4GnLuNXbn3HWLnN8UnWlsmRmnq49+0p8kvS0cxUc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YnBj0IKX; arc=none smtp.client-ip=209.85.208.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YnBj0IKX"
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-62f24b7be4fso693064a12.0
        for <patches@lists.linux.dev>; Sat, 13 Sep 2025 20:43:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757821422; x=1758426222; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Edp+OfqM1e00xcpSWGvAGWC/LGQGu+BMiq7TC0KqX/w=;
        b=YnBj0IKXzuP08PFY3RZUPkLtWttjqUAxxh/n5CAkVmqUoW6h9SHlvyybBMgW1kQDxP
         a5z78lm28HvMwrGINFHSYur0c6ZGy6H5VtHa2ogROORUkUtlYQy0vUoHgf8GifYmggDk
         9gwci6toZXI69wipqMHH8zgDtJwmyc7fY6hSfMFtCEbc7HA470HwIraRphmbJaX8qX4G
         lmHFzGVGF4ulniXlbGy7/ITs5r9t+JGJz2QP3MUI7VeS3cN3xFEcCpPRLSN3XzgxPcyS
         JHla3AWbQXkaAVzZui1k42wIJUabh7KR/cgHdeB7/1/Lhrk7fHpmcI55jJPfksjDWd7o
         DfSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757821422; x=1758426222;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Edp+OfqM1e00xcpSWGvAGWC/LGQGu+BMiq7TC0KqX/w=;
        b=fGkhyDq6nk+auNrQGccE6ENhNE7dail1SqWBWUi446CsF64gjPZ2wglIrjV935flkG
         Wg34CW9BML3YM/zcSYRCIMX9445Ka47pOy+6xJH0VXMnseEFV9zSAot6qAjaeznkvDcY
         FOAOJAXKxg2R9tTbWjZBx4fmz0FvmSCjjZ87c7RlPvauG8+s8w1zr1+FFNfc0yTzfKFn
         imH17KGHuYL9xGCBw/vPIw/zT5HFKLlTbjRO+xvYGihoOeoqvsgFwcNVmDVdYuL8R5NB
         /XCb3TXGQgeKjUJPSCbjWAojiXBwqjpy1lTVL9ljvnuExUVenMX00qws8DtztmSGyNzH
         ouPg==
X-Forwarded-Encrypted: i=1; AJvYcCUe9sr1m7BCXdedfd4yOiCS6QcD0MpomVY2yZlr7Ow/VE2i7+PpnJWt090SYllXqJn7ZFXpq9XB@lists.linux.dev
X-Gm-Message-State: AOJu0YzTQlsTvhWHQKwBlrfYeQPoBgaRWgYmN+fZHNtt/nvxbYBMY7rd
	MmJ2tbgmCLDUzqaV0LgOLXyV0Mshgo0LensB3ryp89cALbRzt/1bNuSu
X-Gm-Gg: ASbGncttN9wQnuv5wtiK35o2Cx1azquOu6DdhzWg2I/JNAV4C0jCOFz5NJB3AcZuNJa
	lc1Ei851LkqnB15TH3nWqXQHmtClWZy1rxuqoq+Ee7mqm5atcSmuYtnJu1Vy0Y3g6BZzP8SX1zo
	Bjh39JNZ4tIx5T1uoJn80BGLY2ZlrIKNgk86HWI5e6IlZq9MNyQcUSyP2SVD8rH7FFzckcuwFZS
	qKgA4Po0CbrEdE4WKEVL7BqwhJwtukzU2BIQShBf6n+PQ7I+gshlZ2ZfUphFjN00xQnzbr/rlBP
	vfyKS5QQPxt+bfP44QHuzVDvnDkjt0vB7Fp1Jh6A1YMOrVN+Bft9AL1kqRX58TVAPjnlMhYTYdX
	ADYccJloOkeiaAj2O/aY=
X-Google-Smtp-Source: AGHT+IET6lw3qY9XyvNvb3pybcnRN4nnQ2bci5TeiF0EBvfDGIL/USbY9x3ZkIUotRlW6z+hFZZ7Dw==
X-Received: by 2002:a17:907:72c9:b0:af9:6bfb:58b7 with SMTP id a640c23a62f3a-b07c354e9b4mr721980466b.5.1757821422077;
        Sat, 13 Sep 2025 20:43:42 -0700 (PDT)
Received: from localhost ([212.73.77.104])
        by smtp.gmail.com with UTF8SMTPSA id a640c23a62f3a-b07d2870da1sm345137366b.13.2025.09.13.20.43.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 13 Sep 2025 20:43:40 -0700 (PDT)
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
Subject: [PATCH RESEND 37/62] init: remove root_mountflags from init/do_mounts.h
Date: Sun, 14 Sep 2025 06:43:35 +0300
Message-ID: <20250914034335.3506706-1-safinaskar@gmail.com>
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

It is already declared in include/linux/kernel.h

Signed-off-by: Askar Safin <safinaskar@gmail.com>
---
 init/do_mounts.h | 2 --
 1 file changed, 2 deletions(-)

diff --git a/init/do_mounts.h b/init/do_mounts.h
index 90422fb07c02..e225d594dd06 100644
--- a/init/do_mounts.h
+++ b/init/do_mounts.h
@@ -12,8 +12,6 @@
 #include <linux/task_work.h>
 #include <linux/file.h>
 
-extern int root_mountflags;
-
 /* Ensure that async file closing finished to prevent spurious errors. */
 static inline void init_flush_fput(void)
 {
-- 
2.47.2

