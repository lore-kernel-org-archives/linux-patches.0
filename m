Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FE7315E5DC
	for <patches@lists.linux.dev>; Sat, 13 Sep 2025 01:04:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757725449; cv=none; b=IEZLBFspKsfSrzKND+MHqZiZeKiP+Gg6o7s0lFTlNzKbrE3SuyXWU7byEagDB2Mv8srp9bf9eN4MA/WE72nR6q0QmAUdlPAsPvqv9yV3zDdv7DMI0VEKzGMXIUMZt+gkRrE+UvF0I/ov534R3KUXNEdFiQhJd+xV/pkoplH2s8s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757725449; c=relaxed/simple;
	bh=XdKFLt7HKTWqlTaryS+0sdRR6IIe2s8E5XqHxfJZ80U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o/gjk6nK8dGBPT9nIt/5aRUAyn+aNC/LokkSwtEadopJynyzynvmP7cZATtK4dx+3c6WIQf5GbpoNDqYHwzw9q/IlV0vGyupdt8GWKLffEvbRiUVWf6i8z64m9tSgVjCQy7x9JVQMDkbNwSGEuSqSayJod75nqfhIqkcukS2bCc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TEkNrGaz; arc=none smtp.client-ip=209.85.208.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TEkNrGaz"
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-620724883e6so4851768a12.2
        for <patches@lists.linux.dev>; Fri, 12 Sep 2025 18:04:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757725444; x=1758330244; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QP3KPO8+P4bejD4XvvOjfSlYK9K4kJKcAHCDef6XF+Q=;
        b=TEkNrGazN143hJ1bnePsbTkq3zSC8nu1M8ftrsDpjEzQSI0uwgcgVfaW4ytAI9kkph
         vBNU0qdfbzBpJ7Nj1eryLWBrXUBLX2Z9sGzlJ2KDBjS/LF/Gw6YneU8B67yaCuW2f31r
         peBG1aDqSb1m8dKuAjDDLHpK9dVW60Stds/dfj1JU2Z7b5xznK+ASXz5IVEBIMOK4I+I
         P1ScLYEytEsHjlLR2/8syOStmTY7SYZZ+E/V+yZtrrsLLMxJOC8/iG/81d7+uvWz0Prp
         vrZzW65Wx8v+2g2CaRS53EafX4EZ4Mwhs/PB2py0LyDCcci8Tq8qbTW4m6I94StoHByB
         qfYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757725444; x=1758330244;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QP3KPO8+P4bejD4XvvOjfSlYK9K4kJKcAHCDef6XF+Q=;
        b=ocftZ1xxSLjt9SrpY97zy/g26eUy3YYzPN9ww/ktfFAPPSZKFJ62UrcSVeJD3zOO3y
         45ioIb1X0Vxcrwl9IC3xUssuyMSkWawsCl53B2NFrTVLEO6HyPctSxjNd3H57NVAvtOD
         srMWxXKJTaZ/ycr4g5ej9IiL5fGMLCD/mictHP7Ea2AhCjJD9rt2mHFGve/JWKRPEa/F
         o8KuPPW6n8FWyi8tYryZNx6lluewYhAl3FQa5CmUABqQMgXb/OHnuv4FkxDTfE32Cvhl
         ndlwV6ZrAvZxHQVw1T46c4tbE567dPyqDodIi+3vf5fOtZslb4F4sYuI5k9pNtg5c4yE
         gqPg==
X-Forwarded-Encrypted: i=1; AJvYcCV1r8hw6HvRmjRRBdHLg4PnDskOl2OSUmM2AUuY5pGBkgfGD8sHEuWAYqkpDJYNMzzu/1uO1CNM@lists.linux.dev
X-Gm-Message-State: AOJu0YxmcctfjK5OO0VvzfONcvUYJtASYGjbJBy3BwLfTX3LwFcwEvO0
	fZu5dCwSdvj1Fct2I4rc2KKnUJyrIszAsaRJx009QM3vXH2ncRlf21ql
X-Gm-Gg: ASbGncuru/0totOLHcoZ1KSo7Z2BII8hdrsyaM/NIUN7ZHdYj33pKtlnEE/HLRSSXo4
	RvmD4435mf5Wrsj9dY50FzDfLUAJq/pi4atpoX/sa0yuobC3emJV4iOak1AmXEz2t8E/sGYSkCF
	xCbMGTC1wsK1CgW1bpmdHKW5AzI3IKjFZ1aw0hXeavxirap6tb9tq7iV/KC5s7b/WO07TGBRifO
	U67nqTO8mAeWXX4oaBDnZ1zy4RiuGlcWqVVqLUuULArw4s4b9hsn3HJreCq/3wFVCdgaW00tkhE
	2J/BcuQHDzrjH34oTK39z24v4uTu1XCAXJE5oJtNoSg4oMIqaJn7glACWE21iH7vo8FT6DXI2Rv
	K9UbNm92SHq5Veyj1qCprAq/5Lp5c3w==
X-Google-Smtp-Source: AGHT+IF5gJzNBXdtzBXv0OSH4ftjGJnmmybFv16rcAGk5hl57bAzoCs28S7e9w+ysKsSQWZRdIzUSQ==
X-Received: by 2002:a05:6402:3482:b0:61d:249a:43fe with SMTP id 4fb4d7f45d1cf-62ed82c5a43mr4352436a12.24.1757725443498;
        Fri, 12 Sep 2025 18:04:03 -0700 (PDT)
Received: from localhost ([212.73.77.104])
        by smtp.gmail.com with UTF8SMTPSA id 4fb4d7f45d1cf-62ec6b6cec5sm4014207a12.1.2025.09.12.18.03.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Sep 2025 18:04:02 -0700 (PDT)
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
Subject: [PATCH RESEND 22/62] doc: remove obsolete mentions of pivot_root
Date: Sat, 13 Sep 2025 00:38:01 +0000
Message-ID: <20250913003842.41944-23-safinaskar@gmail.com>
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

They refer to initrd, which was removed in previous commits

Signed-off-by: Askar Safin <safinaskar@gmail.com>
---
 Documentation/admin-guide/device-mapper/dm-init.rst | 4 ++--
 Documentation/arch/arm/ixp4xx.rst                   | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/Documentation/admin-guide/device-mapper/dm-init.rst b/Documentation/admin-guide/device-mapper/dm-init.rst
index 981d6a907699..586bb38d716b 100644
--- a/Documentation/admin-guide/device-mapper/dm-init.rst
+++ b/Documentation/admin-guide/device-mapper/dm-init.rst
@@ -5,8 +5,8 @@ Early creation of mapped devices
 It is possible to configure a device-mapper device to act as the root device for
 your system in two ways.
 
-The first is to build an initial ramdisk which boots to a minimal userspace
-which configures the device, then pivot_root(8) in to it.
+The first is to build initramfs which boots to a minimal userspace
+which configures the device, then switches to it.
 
 The second is to create one or more device-mappers using the module parameter
 "dm-mod.create=" through the kernel boot command line argument.
diff --git a/Documentation/arch/arm/ixp4xx.rst b/Documentation/arch/arm/ixp4xx.rst
index 17aafc610908..ac9cb28776c7 100644
--- a/Documentation/arch/arm/ixp4xx.rst
+++ b/Documentation/arch/arm/ixp4xx.rst
@@ -137,8 +137,8 @@ Intel IXDPG425 Development Platform
    added. One issue with this board is that the mini-PCI slots only
    have the 3.3v line connected, so you can't use a PCI to mini-PCI
    adapter with an E100 card. So to NFS root you need to use either
-   the CSR or a WiFi card and a ramdisk that BOOTPs and then does
-   a pivot_root to NFS.
+   the CSR or a WiFi card and initramfs that BOOTPs and then switches
+   to NFS.
 
 Motorola PrPMC1100 Processor Mezanine Card
 http://www.fountainsys.com
-- 
2.47.2

