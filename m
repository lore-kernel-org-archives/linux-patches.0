Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57D392580F9
	for <patches@lists.linux.dev>; Sun, 14 Sep 2025 04:19:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757823572; cv=none; b=C32bI/fSNmlxsUOg9+Q9pyLtPbeFmngZ1Av2EC48FPVnhPl+Id4GKe++pbcSwqJ5Vocv1X6vekBvPsWZroFr/54IDdWxjzL+eZfXiIz/1IPu3BJ9E4Wzpiw07SyA+t9FGc1I6qkciCZxxdtihzLLE8IaHzSeRilCSSXaGWMtrgg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757823572; c=relaxed/simple;
	bh=nKH8BykbZ/NG2ohjRy0QYNVXxhFKK6pBLbFy0ufJ1Dk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dZ8Pb7w3X97Q1h4A8tJb9eGdurrtyZVZRlHUDyllFuclje6nOZSJSn52tjA+dcOB51Xj13s/g4JY3Xe0uRhgBxRw0BqxNIdYxOMrFwWiGb39ocFGeE9jOPYS6vB9xdeoXHkqX+5zFe3Hdg0gPVkIk6Uw2omAPodpRVZa2EBAbqA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XH9MNpQd; arc=none smtp.client-ip=209.85.218.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XH9MNpQd"
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-b04b55d5a2cso549146566b.2
        for <patches@lists.linux.dev>; Sat, 13 Sep 2025 21:19:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757823569; x=1758428369; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LXtvCmrZRR9OgP0sG11mqG9m/nOQIjqm8VdJ9uLACjc=;
        b=XH9MNpQdxM3IOqbiHfJwhN8TGWQW4cxHi1rTA6uWA40Pc660O/mbkTtBVhK96uCgZo
         W/lYBm78nmRHbPlHwOxKUm3WLfZxsYsLPyquBfPTPaorUqXgQPzESkmc7wJ08pJi/C4e
         STP/kqCCXRMG9Cdt2j/jSOTBZMmz2O13rYg9fJige4HbmEx8uHim91bIiVVn4mzIOjzG
         eRLbbm/5wZyQFbX0NsuaLgIp36wbMcORVMQrqCIzAZ/KnVJLB/uP0kGbig0rjBdFD5w0
         HV8rDdB96N1AIvMFjEbXeGTutFkUwr+yDVICL+zunu3qv+GupCZcCowCHNKye01+pujk
         Kzyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757823569; x=1758428369;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LXtvCmrZRR9OgP0sG11mqG9m/nOQIjqm8VdJ9uLACjc=;
        b=dIYpHMq/IOR9i9XaHO6aDXMWUUlF38NBRxA2tgAqxBBrRYH/dg4hPMQwFgt5+HyfMd
         FCxttBvu021aHSenDqNQdzSeLh3yYyVjpfIlEBGZI4pjWP0o+Qm9f2/DsLMC3k596elY
         W5IpUJE1iD3/ENCKXZ4fa8rzFXrWA7XWFLoYihKdlQ5Sm/dCJt67QhMDytDfsZly6C5o
         gtYQRQiMXeWLOHKa4lM3USPX/5s6AsgAGO+RMz9giA1ljs+ASEGSMGs6RSYhdcywW1ej
         xBD8m9XuD35foFGuX0q15vZx64K/1B6GfYTVYNdtvtxhngXAFP8GgfzG7XvcyrsgiJ11
         +H8A==
X-Forwarded-Encrypted: i=1; AJvYcCUOqp8Go6vlrPEyUhfvXgSOKP3Q6RttaaXjvf8MZn8f9mu9BRaRsP+VtY3GOwpF3KXmOn5INoQu@lists.linux.dev
X-Gm-Message-State: AOJu0YxE0qVWGDdA9u68UG2wAIsIWeumX++1vAMcSBS5ymD8qDBBxFQR
	3fb9zVPWnnTN6ZmNQXeVzXRDkVPhvn+Ex9ILF3zA4157jgtj4/AQc4lQ
X-Gm-Gg: ASbGncsuzm0D+dzjht5kR8d1vbQQukL9FFykVxD96jmzdKnnSzkLqzlwDb/1qVHnNjp
	Uc5JH3zBDPq0KBF5cl2uKXr0+7Q8DVJMneIM0ecaX1yfBEBzhARHvxjdhDGbmhAND9wQ8XOJbJ4
	3kZEf9+5GNhcUJ97SYuzpZrqX8hbMDh/w6VcmKbmZZZtNw3BAFOF/qeTj3JkbN8CmRZHZvHm/Rt
	V4xXgAUsE9yBhMaWYWQEPY7nkV8qpcbGNwuUUl12YNkIkG+LTCynHmRMuI5Ufjwo9UunaruGm/Q
	7EDUNJ7ubUG8GEzFIIzzBbn/rtwBspmSmcbzqibMk+CV4h3oGk8rngbrTe47knIFxD/AIbjqwTx
	u1GuWVhVcPRJWsN5F7Ka0vZd6t4xbTA==
X-Google-Smtp-Source: AGHT+IF6mujdx9qWAhF6oXDc9ZfcQYBKEdRbKR8jum+cm7upWvg9UYWarRjAWufJtq6SFHzRS8+jpA==
X-Received: by 2002:a17:907:9809:b0:b04:25e6:2ddc with SMTP id a640c23a62f3a-b07c353a723mr763099266b.8.1757823568595;
        Sat, 13 Sep 2025 21:19:28 -0700 (PDT)
Received: from localhost ([212.73.77.104])
        by smtp.gmail.com with UTF8SMTPSA id a640c23a62f3a-b07c28f190fsm504796666b.39.2025.09.13.21.19.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 13 Sep 2025 21:19:28 -0700 (PDT)
From: Askar Safin <safinaskar@gmail.com>
To: safinaskar@gmail.com
Cc: akpm@linux-foundation.org,
	andy.shevchenko@gmail.com,
	axboe@kernel.dk,
	brauner@kernel.org,
	cyphar@cyphar.com,
	devicetree@vger.kernel.org,
	ecurtin@redhat.com,
	email2tema@gmail.com,
	graf@amazon.com,
	gregkh@linuxfoundation.org,
	hca@linux.ibm.com,
	hch@lst.de,
	hsiangkao@linux.alibaba.com,
	initramfs@vger.kernel.org,
	jack@suse.cz,
	julian.stecklina@cyberus-technology.de,
	kees@kernel.org,
	linux-acpi@vger.kernel.org,
	linux-alpha@vger.kernel.org,
	linux-api@vger.kernel.org,
	linux-arch@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-block@vger.kernel.org,
	linux-csky@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-efi@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-hexagon@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-m68k@lists.linux-m68k.org,
	linux-mips@vger.kernel.org,
	linux-openrisc@vger.kernel.org,
	linux-parisc@vger.kernel.org,
	linux-riscv@lists.infradead.org,
	linux-s390@vger.kernel.org,
	linux-sh@vger.kernel.org,
	linux-snps-arc@lists.infradead.org,
	linux-um@lists.infradead.org,
	linuxppc-dev@lists.ozlabs.org,
	loongarch@lists.linux.dev,
	mcgrof@kernel.org,
	mingo@redhat.com,
	monstr@monstr.eu,
	mzxreary@0pointer.de,
	patches@lists.linux.dev,
	rob@landley.net,
	sparclinux@vger.kernel.org,
	thomas.weissschuh@linutronix.de,
	thorsten.blum@linux.dev,
	torvalds@linux-foundation.org,
	tytso@mit.edu,
	viro@zeniv.linux.org.uk,
	x86@kernel.org
Subject: Re: [PATCH RESEND 00/62] initrd: remove classic initrd support
Date: Sun, 14 Sep 2025 07:19:23 +0300
Message-ID: <20250914041923.4119219-1-safinaskar@gmail.com>
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

Gmail banned me after first bunch of letters.
Just now I sent remaining letters.
So now the patchset is ready for review

-- 
Askar Safin
