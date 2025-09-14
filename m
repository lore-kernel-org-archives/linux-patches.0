Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF1BB268C73
	for <patches@lists.linux.dev>; Sun, 14 Sep 2025 03:54:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757822053; cv=none; b=u0eKtTeZcbeXW5nDuyhVVtiVpB9pd2Gm/VH/+LQta/sioa9/ZgJs0XQWkWNrfXsxPweOIBq1B4QNDJBEDJZJFEoP3RauLbmPmLj8bi9QnGB52MpMb824au3EYGy0XrrZUBr3n3j+mWdII118WVUqAJKiuv58opC2V4EN7BJPQLE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757822053; c=relaxed/simple;
	bh=E3G8T/3zLMm3x5kad8USEbJCkxfjt487WTCm3NfxUQM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WHE88A4baxXREE7zPpmJ3rPPuv6/Z8Hyq45eY/XeDKAbhf6/kMRqCS8ijJZu/O1D7xBwyHVvGaf61UZCfWjS67cIdqrb5kTVzOFirUKiv+MeJWYG5/+CFr4dy4QTcJYPmrfZ2vrUthhDQcyFBu/5ikDpR7iD/keDDl+NIN64jvg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SoM5F09v; arc=none smtp.client-ip=209.85.218.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SoM5F09v"
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-b03fa5c5a89so475276966b.2
        for <patches@lists.linux.dev>; Sat, 13 Sep 2025 20:54:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757822048; x=1758426848; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=U0YiDU4Bzw7IKNW2/fgCfvKW6iRx1DQ4l7Ssn455PQA=;
        b=SoM5F09v4YlMQE9Bx98uPE9YLCBrlmLQV/JgNq3vNMqRiGg/Oi6N6Kd13oA6ag/AGQ
         Nvp+7CnkGrt6odN+yUcPUwINR9fF3D7PVSgCbI/YodZfOIQRgTHXydUl6c+GKVPWBP4X
         2Zi6nXv4cYo1oQRdPLEuZsimRWK8v0fUG6dpNgNhNHiqnwIKUbUksLi5JqFIHR02PksF
         ECx075KTHgKhOxzsx7REONC8haoVeSkIjU13mzI7hdvxoI9hJX1XOftIqK7bX3A7+A/T
         FGKhwai8mxWHEp7h+VK3cRnsGVuccxGViH6hpMCnPO1Vo880weaCY2QtHvNxTByB0Qk2
         bmTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757822048; x=1758426848;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=U0YiDU4Bzw7IKNW2/fgCfvKW6iRx1DQ4l7Ssn455PQA=;
        b=bVOjObtmcCtrm1zj8Rexg2bYcoFrbO7bsoBkOh9ZBJwnSx4sYRCCutf37fljj3YRxk
         G3J4Sy9zhc06hVJvWKyhSDE6iImXKkABzM+QUC76KdDJOpswOXbBjDdgCt/fUFRC/N/Y
         6qidyBxVCb46pezvXpIhK34EbI7qfnhFbFstGSWB2EukThRaRctDX/ahq/2Hh7amNDuG
         SaM0A9Snnt8O2+QNfcXOLybPfDRo9TDLbrHeSDbDgBUqeKLO8tlSUFwDgLtdlMQccWTA
         jT0S0SdOBO5Y9S4QGb73w+UBqEZL8g9m6a9Gk35SMS9JJagpp93nN+z8zEV6ZdFEM2r/
         LzXQ==
X-Forwarded-Encrypted: i=1; AJvYcCVY0gwrZ9mfwhl3OGZsOnpc9jCz49Qz8fV3PV9ocotjyVm1mlOfVl9UHj9i6HO+x18WjKJA2yBr@lists.linux.dev
X-Gm-Message-State: AOJu0YyHirdnJsLhEWvnRjYKL/l+uvaPJe8iCWDtQKsQu00I4sR1o5kL
	3y68vvQBCxakiv8FDWO8fyX48vuiUH7iZSe/jEZlmoH4XAVMGJ2EF/db
X-Gm-Gg: ASbGnctMApWWjtzdblr1BJPc2l8yYsZyRZMAFxEP10kusPIG3VHwcrIQOTo6r3Rs+IN
	HSjk6BqaQ2tiToqshvlfBIwDyqtK4AUortgFuLRt/Rb3t50kOXWrWwgh3qSfeU5Ufe/SLOVCAk1
	6KP3FukdEuyBqcJ5L7oCKNJkkNlp5Ui4a642pXvpNSjuibTmnEecFTmu2CdMFTpHQVnJNcWjqF8
	5YUNxQd98ETfXqv2sR3fnApEqUXb4hWqbOgMiv+nHvyrHNg9mdZhAXlwdV7rQN86Rici4iFfG5i
	gDepYqT3SYEJhYoit4Jy0nPagsgTduvECsye7kd4R14483ixGNqxkFxgYdWOwAAboWRUrs5p77l
	o+D0bSis9ruLgKWrJnOexxHg7UdRxZQ==
X-Google-Smtp-Source: AGHT+IEVLkeZlLSkzoTpPLzlBRvNTQ9m/bl133jXYp2zZldNvB+tlYKH8pXYzZ5ISfOO2+UjGM6RFg==
X-Received: by 2002:a17:907:e8d:b0:b0e:3d88:27fd with SMTP id a640c23a62f3a-b0e3d97e027mr75192266b.8.1757822048020;
        Sat, 13 Sep 2025 20:54:08 -0700 (PDT)
Received: from localhost ([212.73.77.104])
        by smtp.gmail.com with UTF8SMTPSA id a640c23a62f3a-b07da7a8918sm303079766b.56.2025.09.13.20.54.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 13 Sep 2025 20:54:07 -0700 (PDT)
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
Subject: [PATCH RESEND 44/62] doc: kernel-parameters: remove [RAM] from reserve_mem=
Date: Sun, 14 Sep 2025 06:54:02 +0300
Message-ID: <20250914035402.3670906-1-safinaskar@gmail.com>
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

This parameter has nothing to do with ramdisk

Signed-off-by: Askar Safin <safinaskar@gmail.com>
---
 Documentation/admin-guide/kernel-parameters.txt | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index a259f2bdba0f..0805d3ebc75a 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -6277,8 +6277,7 @@
 			them.  If <base> is less than 0x10000, the region
 			is assumed to be I/O ports; otherwise it is memory.
 
-	reserve_mem=	[RAM]
-			Format: nn[KMG]:<align>:<label>
+	reserve_mem=	Format: nn[KMG]:<align>:<label>
 			Reserve physical memory and label it with a name that
 			other subsystems can use to access it. This is typically
 			used for systems that do not wipe the RAM, and this command
-- 
2.47.2

