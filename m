Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E6503E47B
	for <patches@lists.linux.dev>; Sat, 13 Sep 2025 01:18:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757726309; cv=none; b=L/10LAsk/jVvyYpWO9Sx4xGKtxC5wZShHn6RHvDeZ/DpyQBl+hO7Vy8WucIWndgIAAqiCjVNMrQp+lMwGC/qiEYzdGkndtpMXh4jrQKXNlMqf/dbXuQLn7bxgoGhmeGnmpqft/8p+6gBqa9+qs7PtIi6OHjUsIEJenKxLW09+pQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757726309; c=relaxed/simple;
	bh=gqqGfNEIy1h395KAAal0EqVTqfHBZvgS53UXMAzAIg4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CaelP9VFiGA9s0GzRml1aK3w4MQqL70ts2ifLZcqWrYUwLP8vT99C4MyCau6cAAtQckrX8XfeFI95p4zQe+8g8mbe6+uCq+qJmzpdjvPyWvfhnhfTFg3k9SsjfMlIr6/R12mrqg+NkfjCroc+p9Qp1CcUWHo84X+TzpHx2QxxTc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UFfTKPZQ; arc=none smtp.client-ip=209.85.218.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UFfTKPZQ"
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-b042cc3954fso453278966b.0
        for <patches@lists.linux.dev>; Fri, 12 Sep 2025 18:18:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757726305; x=1758331105; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=azZv/jvf6IRhG0wveCq5ECQcNHAHnPNLNif/IfsLlkA=;
        b=UFfTKPZQESinNVZm1tat/s2RYLPBVVW0S8HQDThbLMufi+GemEu9G5nOm2Zefuk2Qt
         cgxGSz4fTY9Ap0UjTQH8j4pDj95k3x4eoBHBt2wVK54ZdjnwprWfcImdDPKb1ZMWac/F
         OU4qGF2O8TK+86yhM/yief54r7xpz7zz/EMSNd6/j4wIfzb6Mb2xxmgJHDQnHoKbGEzd
         5o12V3R77/ct/rty3KoFrPvv0hw6BClbGbpqcCEBPLxpcwp3UUQo3OVN6Y8scnMv382e
         2/38GQhkADPRJ+X+NEfdNjxdc/Bzq9RMFbza4Rxv2ab8GcDkt7nOL6m6kCu7uaa8pXyp
         9ZaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757726305; x=1758331105;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=azZv/jvf6IRhG0wveCq5ECQcNHAHnPNLNif/IfsLlkA=;
        b=A0sH+7GT/8OG3ugmrt1nWNmuSEQQVVfQRF0HRYDQ48T6cUJiEoNS1LPQtTCewBzPkt
         HAx+lS/HZTsAlfMfbWqzld3gOwnzKmqhggrNut/1oxqyQVfGbxIcUBXHdxyJYGq+C1+Q
         hncZNwoojuCw91cYkxCwtq969TruvxiZPnwUNFOZ/Jm5ZceavNJFE5bFDnAG/UxbV7Aj
         WynaPVzDfAf1Vguq94M6j1RugWHlH14ier4jC68c3kDR/3XGxKQvgBDwV/00EN57BIgk
         QOSY9oADUAB9tXe//bdm+N56iVkgR4U2S3bOwcCuTK3DEP6CORPUgzSfBf5uhSyEf126
         FdHw==
X-Forwarded-Encrypted: i=1; AJvYcCXr9+cdp9CHVP6EZEEfKvNWa86ZAjbhVMHSZNmHgFhCEqC2+4P8mnYr5C0XbC+h7vVGXuQbJTnV@lists.linux.dev
X-Gm-Message-State: AOJu0YzyJUjSozLQ4XberNai9F0ZX90K7mr5mCaQH2pPQfYQTOydWIGp
	BdhBhugCwBZZd6nE84dV46B4jKYyE2aspkF+cqn2Kotw5XSc6oNJJwfI
X-Gm-Gg: ASbGncvxisT9Ow5eibplzuJ0P71OxNdXJIeoOjyM1rUxnSi/p6RzADu+Krn/I0K9C94
	BM+rW8co7Oou4xm8ZAtq/zD9UznZNSskal3Q9GJPEGWP6VzGYco2MGKD5aNv5Et3kU4kmOvkZ0W
	d9nLgDTVc8709IbU7C8PCAhEkN8lcjoK378FjIIkcIUd1sBmFoYUABcO+muIj+rd9nFTEviAzYy
	hNb5dRwHSJa1rIVy2ixCultHaGISATt3ZGNZq+dAswX5F2enVTJDUE6tU4ZJlxNUWZtudU2wIrP
	Q21VX/FAONii9g1tstyPOVTLYa12Ng3fSlXyBwZh5YHL4H7U0mthhLgSojru7h79OFF8Hu29Ynp
	KqfvYqwvX8q2HddTb+d0=
X-Google-Smtp-Source: AGHT+IExQyu+Z7m4GD3MP2gVTN78xlktku98kUsQddou1aWuxY/hOtzAat6yYKAto7vnFggGkvcCIA==
X-Received: by 2002:a17:907:3f18:b0:b04:45e1:5929 with SMTP id a640c23a62f3a-b07c35cd746mr507554266b.28.1757726304508;
        Fri, 12 Sep 2025 18:18:24 -0700 (PDT)
Received: from localhost ([212.73.77.104])
        by smtp.gmail.com with UTF8SMTPSA id a640c23a62f3a-b07b32dd309sm475244766b.53.2025.09.12.18.18.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Sep 2025 18:18:24 -0700 (PDT)
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
Subject: [PATCH RESEND 35/62] init: make mount_root_generic static
Date: Sat, 13 Sep 2025 00:38:14 +0000
Message-ID: <20250913003842.41944-36-safinaskar@gmail.com>
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
 init/do_mounts.c | 2 +-
 init/do_mounts.h | 1 -
 2 files changed, 1 insertion(+), 2 deletions(-)

diff --git a/init/do_mounts.c b/init/do_mounts.c
index 60ba8a633d32..c722351c991f 100644
--- a/init/do_mounts.c
+++ b/init/do_mounts.c
@@ -174,7 +174,7 @@ static int __init do_mount_root(const char *name, const char *fs,
 	return ret;
 }
 
-void __init mount_root_generic(char *name, char *pretty_name, int flags)
+static void __init mount_root_generic(char *name, char *pretty_name, int flags)
 {
 	struct page *page = alloc_page(GFP_KERNEL);
 	char *fs_names = page_address(page);
diff --git a/init/do_mounts.h b/init/do_mounts.h
index f3df9d697304..f291c30f7407 100644
--- a/init/do_mounts.h
+++ b/init/do_mounts.h
@@ -12,7 +12,6 @@
 #include <linux/task_work.h>
 #include <linux/file.h>
 
-void  mount_root_generic(char *name, char *pretty_name, int flags);
 void  mount_root(char *root_device_name);
 extern int root_mountflags;
 
-- 
2.47.2

