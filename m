Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5314B18E377
	for <patches@lists.linux.dev>; Sat, 13 Sep 2025 01:09:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757725776; cv=none; b=nP0+JJ2FNaoDQREr1Lgte5LxQwbPRm80V0Q28x1qxWw9tG/Ef5YiMwWb1Lsdns8tCMmLvhzUGS80mwpm9hJsTsniz8Wn8dAY0R8vmPJmf+zIaTfPGWlrK4atdHg2N8QizfJ3LK161q5pprVA5dFPGwN83opjWRZyttBKj+25Sdw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757725776; c=relaxed/simple;
	bh=OB8rvKJ/i9Py5pg6KTYPvKorTOVHkmUl23UIALP6A5M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D4Ab/yULS0qEvTkSkp9VWkUcO9qBNfnAp4Y+YoC66agBHjUdCjbJ++y9zb+EjNF5HTJSffNGGcRfzPN03MGgcoL0WyOS2uyybycDGgWxlrmi176ypZIKnmyvuC8eAxKcOq2wQnM2ulGePuyh8DBHjlQmh2RFYYmGL93IAWrCZhI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JNHgwDOx; arc=none smtp.client-ip=209.85.218.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JNHgwDOx"
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-b07ba1c3df4so345545766b.3
        for <patches@lists.linux.dev>; Fri, 12 Sep 2025 18:09:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757725772; x=1758330572; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2pGfjPJCmTgFBTQIPRnE53dxXo3SbfDBvMh6uq5akyU=;
        b=JNHgwDOxXuANJM51xIfYasFiKh+5I1hgBvh83lDIeSgFrSx+mBCTqjDRaSYkqs6ZO+
         WP1xjPG+KTHAjvZvW2uw3EZN+CsvSooxEKn6hk7BhQKS78eaxQZhKKCtIer06C1wWmep
         UUqaSJChsuNNZMgf7Sa6xUiFAQ5HcolxNmzpsvCCht3uN6xrmOeOBPPH2eaBmCVFd9z7
         XcyPn3epOjFr7MljIV1/S7KJVzKuPqMWuLlBopg0ep1mmdKs7mpUvmP8AKCLtQDdX379
         RbLFAmUZS7kF3r63zlUxWUTBaifCj0SMWbeMJixTu47huqO5Z3bucoFOpwf8mVYAuzfh
         fFew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757725772; x=1758330572;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2pGfjPJCmTgFBTQIPRnE53dxXo3SbfDBvMh6uq5akyU=;
        b=bvriFehcRTQcHgLuSuGhzgk3cCzKPGKepEwwDt1Ci5E+w8eMcLrjgNXVZS9wBuZgW4
         TIxUcizVBoWRTetAEJLrhFkG/nivLJexUZMqd5bqLnM4dekkd6ZhBeh8r7npKPmP/tqA
         Wa6Dzc98piC/mrAFNsoiJKC3jP6HWPqeOzb3or9mV3zeXNBm4aaQEXFA9H5m/Qz1YDyB
         fBfX6K2jUGMg/BtOLfSFbRnqzejuh9MdXkYQANndieKstZWePaJG9O5UrpM4ssB5HV++
         +T88i6Sslj2eoU3nRTvIr8tai5KtZbMxW2FAXY7kheYb3HErEHGniHv0U8iR74bpjLRa
         mYCQ==
X-Forwarded-Encrypted: i=1; AJvYcCWccOrdl3HiOSCrhnnbt3bZvCInBSmEvVuXfoDQ90BLB5CbG2xx9l4pX0uWB/14Pi2NB/NaLRwC@lists.linux.dev
X-Gm-Message-State: AOJu0YyGvH9pf8Nd55bM+ICiaeBukfnkjtdWY9INkzPQZcqFEdTQZUzO
	W/9PLat1t1zHLAKNjBL2Aiw8SeYfRELSl3gnaC3/IBiEPfS6qv7s90J8
X-Gm-Gg: ASbGncuetQk9BjhzQnJI3Av9OEhFK+fBrpRifUWUoBNn9Obpd22ykwJFF1rH7aK11+b
	866D4wImPBEjnC8If4+2Ppiy+5nxCO4aohev6/ygF1kjuRTtjUIUo9rvGbhY4SxikRdwib3KIt/
	fD+/v+rzTeIWUHcx+Os0dStVRmb+Vjjp3cXLHtt/z26+0LaOvtUf3lxlQ4KnjSAVpiFzM++KuVf
	OprckOcP5ohfYUHFlISNb86VpmPIQlFsZzd69taR5lDNJxRATHN0HKBt9QF7PruW351G/yMgp0c
	aOomnKyzqUY13XjNUd1fLuOm+LuUDxtNm7HMsUzM/8SKvm/5WRey1NWu4FjzUf7+0MjM/ibLH1F
	3w+JAzZJnEji68OlPC2w=
X-Google-Smtp-Source: AGHT+IHrHcZIQpP/M06nOcq3Snl8FXkxUTmgmKKbhKMXWfrO9iWe4P5Ilwjf7ocqvFrLGTk9+k818w==
X-Received: by 2002:a17:907:3d0c:b0:b04:250d:ee7 with SMTP id a640c23a62f3a-b07c37dca1emr487688066b.31.1757725771595;
        Fri, 12 Sep 2025 18:09:31 -0700 (PDT)
Received: from localhost ([212.73.77.104])
        by smtp.gmail.com with UTF8SMTPSA id a640c23a62f3a-b07da7a8918sm104574066b.56.2025.09.12.18.09.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Sep 2025 18:09:31 -0700 (PDT)
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
Subject: [PATCH RESEND 27/62] init: alpha: remove "extern unsigned long initrd_start, initrd_end"
Date: Sat, 13 Sep 2025 00:38:06 +0000
Message-ID: <20250913003842.41944-28-safinaskar@gmail.com>
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

These variables already declared in <linux/initrd.h>, which is
included

Signed-off-by: Askar Safin <safinaskar@gmail.com>
---
 arch/alpha/kernel/core_irongate.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/alpha/kernel/core_irongate.c b/arch/alpha/kernel/core_irongate.c
index 05dc4c1b9074..3411564144ae 100644
--- a/arch/alpha/kernel/core_irongate.c
+++ b/arch/alpha/kernel/core_irongate.c
@@ -225,8 +225,6 @@ albacore_init_arch(void)
 	alpha_mv.min_mem_address = pci_mem;
 	if (memtop > pci_mem) {
 #ifdef CONFIG_BLK_DEV_INITRD
-		extern unsigned long initrd_start, initrd_end;
-
 		/* Move the initrd out of the way. */
 		if (initrd_end && __pa(initrd_end) > pci_mem) {
 			unsigned long size;
-- 
2.47.2

