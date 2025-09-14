Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 935CF26F2AB
	for <patches@lists.linux.dev>; Sun, 14 Sep 2025 03:57:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757822269; cv=none; b=ioPgtIhITR8eOaReekGqfL2rjE7aZv5ScgtbOn1pwZbajVsO2wlghVoUjfOO0DXmmvxppReu4sPdI5Qftw5oLM3URhbdYYoPFprRBkRLeVTxVpbVer4PMcgwW8tsoLWTAMzaqTqb+FjGMnX+LqhsmsvGtf9vY3GVWS25S6sDJB8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757822269; c=relaxed/simple;
	bh=oKU/He6fgnkGxFwiXzfMSQvpywViA2YaDdh3D2HgJ0I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CB74WzChtR5g4mNRNiYRM9KLv5baWz3nCQo0XfVcI2sqefM8lTfYOLeRfr5CsGUUY+AgqBz9uJRzuhHil+drIkf9x9BF+070SOz96YayUbLNlb/HA9Oy4/S7a50rXFV0nNDa5PVNYGudW/ocTWwsyXSrybjntj/esxGY1kG8+os=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PayVvKuJ; arc=none smtp.client-ip=209.85.208.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PayVvKuJ"
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-62105d21297so6255885a12.0
        for <patches@lists.linux.dev>; Sat, 13 Sep 2025 20:57:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757822264; x=1758427064; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dLgSWRUhBJ+Eb73oE0EhwiwscJ+skfUSjN5GwJ3O/gU=;
        b=PayVvKuJJkg+VXWO4V9Ph0iH4pDX06nrVcoNvSI2wdK3RFkCH0J9Y0sohpM3AJa3x3
         p9UEDT7vhRk2TyNF3j0Old+KF687XVlYkMraYVkk2fhJDhkpl5mBWthPxanCxgM8a+4g
         YbHPQgSHAGZRoH/+kb1u7MJR5kw9HNDvSOTCi5cISSWe1pSRUPwjPdgZrou3OULw48bn
         aDuaqEkgiXazX4owNtKSAAB08Okc2Z2fe/uuLOAwLlvM0N9DQwMmrANXgYNJ5R32Ipcy
         M9xZf4UOcvZm08aav5z0Gw/ZtGfPQJFT0HeDhpwiWzw64MOl+jmH7x6/+Vu2tn5/d74l
         5GdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757822264; x=1758427064;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dLgSWRUhBJ+Eb73oE0EhwiwscJ+skfUSjN5GwJ3O/gU=;
        b=szsuJ/mYiNybcC3s36RDEqfIaYfJqg73sqOcbG8HklF0nL2lNbptRo1X+3XHus4f03
         2JZp2toc+CxGHZ6Zm3T0rHOBvMHwH8kfC7ycwk2TsP7U+huKW//OfCaUzDpIOwX3F7k9
         c1CnRJzmIdDjl1uhiQWcS5fRf2aY5Yzm790a/usAPgedWSpcPHV3OG3xz1Yo75oS5gqc
         jb+ms/Ma571cfqku37L3HQE57It8UCUbp9bWmOYVK1viEpaqH0q+t+y9T/LfrnT1gHLJ
         m+j5RXdRZW5AMjkxe6Xzne5/fhQZab34GtqdbjBqpmdBqrPtsc9V0yGkcu1232qT3lP+
         sIlw==
X-Forwarded-Encrypted: i=1; AJvYcCWQZ1+expqneedYAAAddyykwa+7bVYosK5yRHFQaMXrBM8q4/OwJ9zQ+y/jvjJ9up8hRZhWiq6w@lists.linux.dev
X-Gm-Message-State: AOJu0YzFpn4JmVz7mDPP8G/jNkL3ylJZMZ85Eifycv6exBpcyjiVh/GP
	Gg6bFslIiuhZ7uy9lCoEYpqvwBRH7h7V2sVGYe7+VKq/hURLjZeZunzb
X-Gm-Gg: ASbGnctX+KdIKD50Ge5YjpUtWqweFIKO6Bs1EazP2OGvXDGc0J7u4/+FCtWKcmZpPBh
	zTMzS12ADIR7eF388eKhYaqANUeyI91Uv9ZY2NrDZN9UTDO7dLA05DXVo5rtBFKYv3/PTzTwIuh
	7DTnAgAdAsPgPOHJd1WsHEWvQ+zEWGKYWJIUk5i7XTYhEslewru1uZI/Z5DtQTBVgmKBPz2SG+A
	G60S2iwLpyfRyafIqMkrhPcv01MMWjulCDXrRnve9DGWxnbUOgZ/y8Zi5AhNkHjyRqJ7pWVzs7B
	KjIJdunQE1Oq2KxptmHjmTaaNVK6zY5MfYy1GDVoIbpm+rsj3++4Tl8EtZHq7CUs+vIPVl1gYi0
	5wAkSIRKyInkiMN6L1QkMBThxTZ77fg==
X-Google-Smtp-Source: AGHT+IGOdPvfXOVddm8G6LJhfH2nNJDoTTLKR/3NE7kowNRoQPIuzhxmV+feQvXrrMYzfjsz5Ubcxg==
X-Received: by 2002:a17:906:a84d:b0:b07:cf04:8a43 with SMTP id a640c23a62f3a-b07cf049441mr520202566b.41.1757822263792;
        Sat, 13 Sep 2025 20:57:43 -0700 (PDT)
Received: from localhost ([212.73.77.104])
        by smtp.gmail.com with UTF8SMTPSA id a640c23a62f3a-b07b31287cesm676665366b.30.2025.09.13.20.57.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 13 Sep 2025 20:57:43 -0700 (PDT)
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
Subject: [PATCH RESEND 50/62] init: rename ramdisk_command_access to initramfs_command_access
Date: Sun, 14 Sep 2025 06:57:38 +0300
Message-ID: <20250914035738.3741007-1-safinaskar@gmail.com>
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
 init/main.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/init/main.c b/init/main.c
index cbebd64f523c..a42f1f0fce84 100644
--- a/init/main.c
+++ b/init/main.c
@@ -1587,11 +1587,11 @@ static noinline void __init kernel_init_freeable(void)
 	 * check if there is an early userspace init.  If yes, let it do all
 	 * the work
 	 */
-	int ramdisk_command_access;
-	ramdisk_command_access = init_eaccess(initramfs_execute_command);
-	if (ramdisk_command_access != 0) {
+	int initramfs_command_access;
+	initramfs_command_access = init_eaccess(initramfs_execute_command);
+	if (initramfs_command_access != 0) {
 		pr_warn("check access for rdinit=%s failed: %i, ignoring\n",
-			initramfs_execute_command, ramdisk_command_access);
+			initramfs_execute_command, initramfs_command_access);
 		initramfs_execute_command = NULL;
 		prepare_namespace();
 	}
-- 
2.47.2

