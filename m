Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D532726738D
	for <patches@lists.linux.dev>; Sun, 14 Sep 2025 03:50:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757821838; cv=none; b=r+CQqiQlgnb563+HfLgPjud7QusN7ZY6CG776vO7Z5bxPBnLOojkrfOmuL56rZ/CtAyr8K1gC0PIi5YAp2Asp+qwco7mPSY/68EBEQbq03xjgRGQ1r+x1kq+8QTHXMGdlyMrC2gnHA/h8kJbuwyPoQob/oT1FZXhEj8w0IIGE8M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757821838; c=relaxed/simple;
	bh=UKYo3sZQHTOBTzj/ZrSKU3L73PiTPpOmU1LUHeX039A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UgHqHrklACbl9+4px1LnqvaUJP1miVP7yKcaVYfBwwFFc2MVQL8F9gKec/Bdi9Yv76LS5CoHFwaj3vjwG4ct7+7XXMPS+HiLQFNKjUIS9QerSs964glxPu8QuKF7cRBzVcEyy62ixEIafA5/7Ej6pZZVRdt5n81OQL7x+X3nxF0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jPhefUIY; arc=none smtp.client-ip=209.85.208.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jPhefUIY"
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-628f29d68ecso6259923a12.3
        for <patches@lists.linux.dev>; Sat, 13 Sep 2025 20:50:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757821833; x=1758426633; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xULsRy9EzPzDuVUBFXoTlnqFZHMdg+FSwp5f1Vonn0Q=;
        b=jPhefUIY1RDqWgc1k3TBipGKjv6iqU3aaIq5MRK3iQ6cES6whfEag6TiyhYHhDFREz
         6ZJhYR7C6P6OBaBYueCrbUpBbU3KYXXnGIh82zh1t5HJWUeYs6uu/uSd1RJuTUEGNSLs
         6I60wW5j1Hl/666TakFclh3gqqmGmmpwUV+jh9d7ccX9HQkaYkcGxXAOFlxXi2C3969G
         6sYYXbFNKZlTuJCSz2cxh/AW0MK/z1U23nYaNWzJJqRf2pM9sYN/WtiA0pYXDP+3bNyf
         CUfjeD1djGaftztDnESq60PNjcbV44TFNclJANOYV2hDu2Y8/l63yQlPZNQdxZv4xfT3
         /srw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757821833; x=1758426633;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xULsRy9EzPzDuVUBFXoTlnqFZHMdg+FSwp5f1Vonn0Q=;
        b=q1ZKIFQfE/5ZsKxkxt4Aw7mEa9ZGD9MBnUm2zXey9bPfhezLzBaqHU/eMb2vPwIcQf
         ukhDCk5MpBWdcsfyUQ9+8oaQhGmYOjQmZ+BD2b/gJht0OZhekOdYXxmDp0b86iJmrpzo
         9BbSafOwtkQ6zrX6OokeeQOv6IGwIBwUJuelooVA62qCK10dRSbXAIa0sVUyGbwFCvqR
         3mL5LC0RbSUsAUfgrnyaJCX/TYR9+tdaQ6YUPvibnkGkvEOY4YssK8rX6J1Xp/mLsRvJ
         2lmW9Y7mYgKqxxVYJdvirDUvWOZjyym/oSDSUx4+3o+th9MXmbgX2I/Sy46JPyycK136
         XBoQ==
X-Forwarded-Encrypted: i=1; AJvYcCWZBnfx9iheBQOkl2CR/Gg6AenIa30DCH4AijEMJqLUrzW9KUL+GgOUq/ES9+ngP4MaLmKaKlvx@lists.linux.dev
X-Gm-Message-State: AOJu0YxwEz17yMBpBGV6xXGrpoWBdciZ2aM+kRuazDntxiKZn2LepTY1
	tfROZekSa+V/4wge/Ca+PW71FDEr9pcw8krKyKQe+TSiAS4y7mbn14xg
X-Gm-Gg: ASbGncv5FTI3O1OQTTX+9wxVWlUiiOx30y2KFw8YjtK75YE0CeO1QeqxsHRGMiL0WOD
	/89QaTjHiomIaErtXXyXnvD1B3EOSrljyaNYIi/6zorhftQMgunLqaNVPAp9rZj/97oMSwGEQJ5
	ypph+x7g8EneX71og4Duq9r8wuSi4uNQw0tRoSXaJHGloSgGQhMiL98xN638/ygY19vxYSEA6cu
	Kbp6xgDWlNbVocfaLhfufUlY7XYtM6doiRkuT3v1R7L3R0alBzbmNcGqMnRZOsTCiyzlAq9YExZ
	PAaim4hc8MEjfV6LHqL/lvhckgvftQ1j9eglxtX3wNtMkT54fHXjA6Zfg/RVxy36wQfUkMaANuc
	9YgmgjVyCPkI6gyww1eF/VAQ4A/wlHA==
X-Google-Smtp-Source: AGHT+IHE3K7efxQ+hk8pVBE6YY31PD4G3LjwwPuEi1DqCDNI+Ud0foCSPIjpPnt40T661VaNMc1/Ow==
X-Received: by 2002:a17:907:3e8c:b0:b07:8836:dea9 with SMTP id a640c23a62f3a-b07c3819dc5mr855439466b.39.1757821832889;
        Sat, 13 Sep 2025 20:50:32 -0700 (PDT)
Received: from localhost ([212.73.77.104])
        by smtp.gmail.com with UTF8SMTPSA id a640c23a62f3a-b07b32dd3efsm668828766b.55.2025.09.13.20.50.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 13 Sep 2025 20:50:32 -0700 (PDT)
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
Subject: [PATCH RESEND 38/62] init: remove most headers from init/do_mounts.h
Date: Sun, 14 Sep 2025 06:50:27 +0300
Message-ID: <20250914035027.3609569-1-safinaskar@gmail.com>
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
 init/do_mounts.c |  2 ++
 init/do_mounts.h | 10 ----------
 2 files changed, 2 insertions(+), 10 deletions(-)

diff --git a/init/do_mounts.c b/init/do_mounts.c
index 7ec5ee5a5c19..5b55d0035e03 100644
--- a/init/do_mounts.c
+++ b/init/do_mounts.c
@@ -5,12 +5,14 @@
 #include <linux/fd.h>
 #include <linux/tty.h>
 #include <linux/suspend.h>
+#include <linux/blkdev.h>
 #include <linux/root_dev.h>
 #include <linux/security.h>
 #include <linux/delay.h>
 #include <linux/mount.h>
 #include <linux/device.h>
 #include <linux/init.h>
+#include <linux/init_syscalls.h>
 #include <linux/fs.h>
 #include <linux/initrd.h>
 #include <linux/async.h>
diff --git a/init/do_mounts.h b/init/do_mounts.h
index e225d594dd06..53e60add795a 100644
--- a/init/do_mounts.h
+++ b/init/do_mounts.h
@@ -1,14 +1,4 @@
 /* SPDX-License-Identifier: GPL-2.0 */
-#include <linux/kernel.h>
-#include <linux/blkdev.h>
-#include <linux/init.h>
-#include <linux/syscalls.h>
-#include <linux/unistd.h>
-#include <linux/slab.h>
-#include <linux/mount.h>
-#include <linux/major.h>
-#include <linux/root_dev.h>
-#include <linux/init_syscalls.h>
 #include <linux/task_work.h>
 #include <linux/file.h>
 
-- 
2.47.2

