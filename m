Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 615FF38DF9
	for <patches@lists.linux.dev>; Sun, 14 Sep 2025 03:56:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757822196; cv=none; b=jeWYxuUFsUWRyrEwiJKlinUZ3/DCiXemIdRExBCCpbWKab082/aJ/ICwKTZI2urbrz7LgTUUo3p2N63o3pge2C8rJtuKJsR7m9olh2LLHHAfKrWjIZfGJqeIz9aJt1FneAEt1m3ZKS99iwMJd3s5gPEpHg5iE1iYcA+c5P8ys+Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757822196; c=relaxed/simple;
	bh=Z/NLntZrolo0ykWAS3sXBn6sCvdr4Jv7RqhYT4lljv8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UlPjeTxEtiVYBD1aBq+SsQc1psRm/z59sc4F2l3Spd2lRHDrvlmhzGXeHg81G0FpfjMm2QcqqRvIYEpBiK0gGMdrT/syTPM8KuIXaYnemCqGFqWBUIun1jS34v89WzE5yOGBQJ0SFyMxcdeHQOtXSep9UBI4WFAtbpQYOt27qUs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=I32KzUGb; arc=none smtp.client-ip=209.85.208.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="I32KzUGb"
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-62f0411577aso1757495a12.1
        for <patches@lists.linux.dev>; Sat, 13 Sep 2025 20:56:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757822193; x=1758426993; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ukssGXUYVXOD0e/noqLCBxDtEOgQieVYL/7Zl394zX0=;
        b=I32KzUGbMVT876REPQiziW/xe7Xso2UGrCK3k7IhiQt4TnoWcN3KlGQU9YlmEWbCPn
         alI6Bq6kDqyy08hl85NdV26IHCCAl4IE45KiYtSzbY0q66UrFXoytLKwddT+QO3WdEIM
         tggon54kPfATYD/vNybhmAC/M1a7D9VxJrRSRAaRS3Fdf6edt00uy1DLF+cj3dinTghC
         NhOcmoGmvoOyUfLL3QB3ZVzdHHHsxrylwybUYpT0UySUqqYBegpFdnUiZZ3QmQ6BHYh1
         P0EFqUdqZ45NULHRMy7R+UNtGREpKvPAYIdM5Y8P6F0Cf3qMbw427NZzoYYGfgSWKMeu
         dG/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757822193; x=1758426993;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ukssGXUYVXOD0e/noqLCBxDtEOgQieVYL/7Zl394zX0=;
        b=Ktb0MOfoaonrEUiKIMiYumwE2h1poghLQP315jxHTU3X2taEoU9qlt/P/XDYEkaOsv
         S4m59/3CIRG1b8BVPO/b1h+SzGsYENDElfs6IQUagix9XWziJqgzGHcvU3tGXdPrSi+/
         B/HT0uiAfjIBhIBF3iyeDxLbUGdpxzPH5kPysFAPtEfcoUsjvf52qG+a8e0rhvULnqxv
         TZASjV5p3lIKSSqee8VlbJuXj9JyCziU1t9Go2mbCaYb3gWr6pJHbBAExgXAVR2TtQ7y
         OqptPV/RPV3o4wBfCJUaeGPyyFmfokmEjBijVrs6MPWc3lNgaiIE4bFTQoEECOQTITuR
         lb3w==
X-Forwarded-Encrypted: i=1; AJvYcCUu7P5gCvr7BTWzFZh55b1wq3hfcvN5y/XJjuJOVW/QbmPDHG+e8xYOEwLVmKOM0REhK97KtOPZ@lists.linux.dev
X-Gm-Message-State: AOJu0YwenRGiXO+3jmDlq+6iyW8mDj4rBdo+wzNf921/SgC+aUH2WE3w
	9EWmapWfYGT+xqPrgjedfif7r1Qs6GD2hZ4H5JXnTErc77Az63pDmzg9
X-Gm-Gg: ASbGnctM8xK1832teAN/PyQkGTYFT+lJ9fZVtDL+ZUiFxQmAcylRBoxHc3L6BIOni8Q
	lpKTAfaNSqaHqKQOKB5oxIeZ+MQQjDWIQXtpnQbnR2eMHusWsDBijtu0heQTum9Hf7Y62FQ2Iv2
	Fe6O0VPFPqqsGzUP8TucXVba/FNHflNHxk7wDGzlIKb5tSZYQgEtxbYy6c1t9Fyu54LdlFhxjJk
	PgLsmA2nAIcXDXQ/tLsZIflXeDJJs2+m2SXHjNULCoJvLZg1IWJ7FWA6+PQJ5mEWxWkJ5KoKxGp
	kTuppcXOJfdtnnu+nxjtlOegvv12v/ZAOf9L/zs4KO7mVR01fGzLvNEl4nJydBH1MiibFf++Xu+
	IO69o+IfLvZf9Hfztc4k=
X-Google-Smtp-Source: AGHT+IEh42ac6WqH282xp0DieWYXKfg+ycti4urbWWAb1GXqLLNoKNDdAlfHKjc5T4lrTIZzL6YLwA==
X-Received: by 2002:a05:6402:2815:b0:61c:e1d6:6bf6 with SMTP id 4fb4d7f45d1cf-62ed80fd3fdmr8226990a12.7.1757822192729;
        Sat, 13 Sep 2025 20:56:32 -0700 (PDT)
Received: from localhost ([212.73.77.104])
        by smtp.gmail.com with UTF8SMTPSA id 4fb4d7f45d1cf-62ec33ad2d6sm6510443a12.18.2025.09.13.20.56.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 13 Sep 2025 20:56:32 -0700 (PDT)
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
Subject: [PATCH RESEND 48/62] init: fix comment
Date: Sun, 14 Sep 2025 06:56:26 +0300
Message-ID: <20250914035626.3718268-1-safinaskar@gmail.com>
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

Make #endif match #ifdef

Signed-off-by: Askar Safin <safinaskar@gmail.com>
---
 init/initramfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/init/initramfs.c b/init/initramfs.c
index cf19b7c0c358..30e94ebf4902 100644
--- a/init/initramfs.c
+++ b/init/initramfs.c
@@ -717,7 +717,7 @@ static inline bool kexec_free_initrd(void)
 {
 	return false;
 }
-#endif /* CONFIG_KEXEC_CORE */
+#endif /* CONFIG_CRASH_RESERVE */
 
 static void __init do_populate_rootfs(void *unused, async_cookie_t cookie)
 {
-- 
2.47.2

