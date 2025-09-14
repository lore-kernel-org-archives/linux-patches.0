Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65CB1267B01
	for <patches@lists.linux.dev>; Sun, 14 Sep 2025 03:53:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757822016; cv=none; b=sXHUeRGnHdZbVNBxHGf5gbqK2lD1/A4Y5POjFrZWFGjDQfCipTti49ObduVGxRp1vdXsqpsGFF1OooXYhUnz09vVF6ZVJ5GHRNcMNshUp7kH/n8l2kwXf8rgJM8Qxa0jUaljsOLjjaEYzlTmwGn8LJXv/sM/00E/86/O93tpmaw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757822016; c=relaxed/simple;
	bh=FZoweijhihxtu6HrPrxAC18gjv4DF8N0f7D122SferU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Thnbn/GuYzIgRWCtH/Sh2HD9UJqUfiL7pqsp5X+RbES14YYtuV3uljSu318rTAS5JzFZLd2OHQh6v1WAmF18PM9ZRqYeqmIvvNlNMGCLEmfbo9GPAUj8pL8itb+QAkhq57SPfhsaYPDUW088+e6e7fB2YTewZ7TneLg4hPnkAck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=U3oTpmna; arc=none smtp.client-ip=209.85.208.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="U3oTpmna"
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-628f29d68ecso6261611a12.3
        for <patches@lists.linux.dev>; Sat, 13 Sep 2025 20:53:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757822013; x=1758426813; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PB2E9PPBAv72v29AyxICCzYyZlb0WEV+ovfXoPOatKs=;
        b=U3oTpmnasehLq6F7cMy/uowT9mlOyNSqtg4gJmMaW4YjO5njphoeKZgUcxe67OrTZF
         YxlyQEdK6wL2bkUaI0s/NI49B3r6Q6wAM4gEVhe4uu4IJY3EymPUfUOVtYMLwOQZdw0K
         rniIhYIiFkWlIG8QheYvIHoRqhpulQkHWPcCgtpa5ilD/mMcJQ1gk8RKsff63WTgLtlt
         KLXgqlBrJ72T8BwI2+ZPVqjEFCzJ3unEPDc6sMxqdAx/StNgBuhTooA6dk1yQCRsYcLv
         idXC9cunFC5cK8ui5clkaYjrsx0PTohisuLG6+V3i2ZWtHq/JHRCV9u+kg+NmpWBMFtc
         gjJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757822013; x=1758426813;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PB2E9PPBAv72v29AyxICCzYyZlb0WEV+ovfXoPOatKs=;
        b=BzE8RoLTJR+hJ3jzsxnGr3X33cTg+8F17MxWeiRJFs9Jl9Z2empSLV+snDaS54TKOJ
         2XmUnIeg4I/CC0sYqWr9ft/XeiEBA4ZhVDWIZBMJ6y1PlveTiW00IsUKucacmdULy5mK
         NjAZuiEiQ81Z2BNA5VmSGvIi2s1I7zc8ed90FM1JW1PJbRb+5qu+GSoLVFI0EDEFYI3X
         9dqoooAnKnYfBa23gVwfD3ta4lY7Hk+tYdtWxxZ6sT76YwtU5joIekfmwEg3wMHrEwwn
         Mq6umh0kI5X43UneMwA181/1RXhNIrR49A0sGdZWqbAE+5lX+gNINiR3KxblpuCHQ/jc
         gl3w==
X-Forwarded-Encrypted: i=1; AJvYcCXClF4CNNnyMnl47ZFlIaHM56+kaS5cBX3uvVpAc9tylhRoqXQEWZSh3DzmzInicHm6kQolgMv6@lists.linux.dev
X-Gm-Message-State: AOJu0YwmGiXiSgVSj1mzP3UmXKB6b5nO6pI91570GV8EQmajSF6OlAX8
	sxmZqCagNymixKR5bjBcVV3sfr1sgq4FGQjmHBC7ksXBDBuBAw1uTFud
X-Gm-Gg: ASbGncscJXdkiKsk1r5FoUs46MnDJrIdKsjJO9D0Gx8YUxJf3c99Bk6Q7OXDauZS6EX
	ncW7ZAHeA7MZomlofTq7y/mwXWeBb8lZzwypkL9eWXG8XyIaf6NLV3O7WANhu1cYmgMlRSQS5p3
	Ybs7krHzuIC3JSjPQ0k5SxiU/Fp9qn8mzZfC5rpHz5kYsLIi9J3FWLWffKvUvEh9xTEDcBY1lp9
	68t+5z0eCwZ2VBvdamYX1f2674aPNGlyV++L8YBu+sypLO+QzoLJvrVoBjt58j92JtN8dosgMd7
	gSyByHrU6skfsW5Qq/rn/rDKDRI0A/lut5UBUywbhib8JieYBXYXOku/VQ15AGRDsOPuJG8dFbm
	r8IAyy6WYniNbQTAYYwBD3uazj6W5qg==
X-Google-Smtp-Source: AGHT+IGUQXhZVcMzH5x4qrxgNQpCZ4sYyZ3ugDsvfNumu2I8pECs9df4oC+H+CMnm997jPnr5crTug==
X-Received: by 2002:a05:6402:2111:b0:61d:2096:1e92 with SMTP id 4fb4d7f45d1cf-62ed82614c4mr7020136a12.15.1757822012514;
        Sat, 13 Sep 2025 20:53:32 -0700 (PDT)
Received: from localhost ([212.73.77.104])
        by smtp.gmail.com with UTF8SMTPSA id 4fb4d7f45d1cf-62ec33f3a5esm6570485a12.30.2025.09.13.20.53.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 13 Sep 2025 20:53:32 -0700 (PDT)
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
Subject: [PATCH RESEND 43/62] setsid: inline ksys_setsid into the only caller
Date: Sun, 14 Sep 2025 06:53:26 +0300
Message-ID: <20250914035326.3661003-1-safinaskar@gmail.com>
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
 include/linux/syscalls.h | 1 -
 kernel/sys.c             | 7 +------
 2 files changed, 1 insertion(+), 7 deletions(-)

diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index 77f45e5d4413..75e9ee03d19b 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -1231,7 +1231,6 @@ int ksys_fchown(unsigned int fd, uid_t user, gid_t group);
 ssize_t ksys_read(unsigned int fd, char __user *buf, size_t count);
 void ksys_sync(void);
 int ksys_unshare(unsigned long unshare_flags);
-int ksys_setsid(void);
 int ksys_sync_file_range(int fd, loff_t offset, loff_t nbytes,
 			 unsigned int flags);
 ssize_t ksys_pread64(unsigned int fd, char __user *buf, size_t count,
diff --git a/kernel/sys.c b/kernel/sys.c
index 1e28b40053ce..66e1e2dfd585 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -1265,7 +1265,7 @@ static void set_special_pids(struct pid **pids, struct pid *pid)
 		change_pid(pids, curr, PIDTYPE_PGID, pid);
 }
 
-int ksys_setsid(void)
+SYSCALL_DEFINE0(setsid)
 {
 	struct task_struct *group_leader = current->group_leader;
 	struct pid *sid = task_pid(group_leader);
@@ -1300,11 +1300,6 @@ int ksys_setsid(void)
 	return err;
 }
 
-SYSCALL_DEFINE0(setsid)
-{
-	return ksys_setsid();
-}
-
 DECLARE_RWSEM(uts_sem);
 
 #ifdef COMPAT_UTS_MACHINE
-- 
2.47.2

