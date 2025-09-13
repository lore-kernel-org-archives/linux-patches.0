Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71F7313774D
	for <patches@lists.linux.dev>; Sat, 13 Sep 2025 00:49:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757724596; cv=none; b=f9v7Sy3SYSZke6wuflsi1VfGR0MubyUBcAQ0+aHG5YjaIvThwDtSDPw+eNAKtk7+rrmVHX6Ls2eAVTgG4xP7+5Wyp4unWL6hFcnkguNCE0KUBglIQdPvJyqRg0He28H+BE8tqJNNJXNk0aSztum2YUfBroyLLmXeBk0yFi22580=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757724596; c=relaxed/simple;
	bh=aIH0UEBp9jrH7zT+VD2BpCtGu5L0ukANS11y+zY/wiQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NZ9AaN3RIZi9krkFcuI2RhivqHKu8WxQ0KD/LyEDzAeLtzYBTg0jo9XeblkLPUwk41j/UsmfhYIzZToeK+T6xSMUl6AacmeroL4wDNMZUNkYG4MFxO7al+FhDVbNtM1nGLRXl/WSWIaCKsOu3I9TfWp0GZWCmpHyS62zdbX0jzA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=izSGQOQd; arc=none smtp.client-ip=209.85.208.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="izSGQOQd"
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-62f0411577aso364999a12.1
        for <patches@lists.linux.dev>; Fri, 12 Sep 2025 17:49:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757724592; x=1758329392; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=k6cH8q1TrVQNxjzjuQXybOp7uw+/s7mQTk4MQOvceKM=;
        b=izSGQOQdCZ7cbznz0tI4FfgOfIR25Y3QeszP2sJhL7MHlDes8BpOcSVWdApqOTACUa
         oWzFmnlWwZH3gGKh3mdcwzDPLnaUgwypMEHdOeAL7f/FCKftcE4qx/kxJH3R0YwCzNqT
         5PoNMgu8h0ppYzcaLAVmOsQ96Cwty4Rr6oEGzPmV6QIHb9mbiEkasFlq41K/e4nWlPFH
         ds21XKma6UbCue4oaZrE/1SM47SsEtD/5hwHkMpdfmCfBTX5CIp6hyf0GlStGkJVOJCA
         ukQuPQbJ5s+GAK4QqZyw916LxhUQVm65fzd7SY1ufyNbdbDaEBLnNQdVfmCbPu9pD9Gy
         +7LA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757724592; x=1758329392;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=k6cH8q1TrVQNxjzjuQXybOp7uw+/s7mQTk4MQOvceKM=;
        b=jX/OceUu0BS4dYYb4AkN7PSeN9/a21BYPUxk4EwRGLFIsjmgUShRgjfolZttXStlJb
         PQyEQ/6D5/TWlzLwyKRHIMuE9krPgF/RVlK/5olB/zmhqzPoe2fpC6cVYUCxoyEZOoFi
         bSf2ByHieQL1U9okebD3ZdhB97YZvZM6P1cK/KeOkTFUJAPhw7eClGp+cyDOIBE/HlMS
         Z9JSri93RTKQDn+fCcm0M4SZv4byP4VTmtOMOFIug86aw/KpVo8ovujoxbR5Id8fzcAJ
         xkKYkR7dJ5yF7Z/pdv8KDxa9SHXMVdQWTNniMXeAUCNnI0IAg1vh9Q6myhIPeKsDvwj0
         mYrg==
X-Forwarded-Encrypted: i=1; AJvYcCV2gQKrVFJBPtNzcDUU7StwFU2wbvQ0fb0uZEVm4njZDPtYQN/hbSrK+m2LfMs4ypKOsc8mHGlS@lists.linux.dev
X-Gm-Message-State: AOJu0YytW++Fa2NL4wK5+Ewby8IhEu5MC2ZYqPvS57CEdra37eWmc2uR
	PPCwTXWpkYdowU0yvSPD4Y75nNofbnIlNgbnC5gTyPBxEIqxU5qNcxNB
X-Gm-Gg: ASbGncsIURQpPpeD3TYRYrn2utar6YR1QfoRIVvUNd+fUTbVJf6xjSf93eqA9Dyucud
	EqrOhCVB8L5x40TBbT7HWPTrqga4yhLd7ngGCT9n0IEP3HpabNQj83zwNQAHrkBja8EgnSBTF6r
	BhOWtOaAwc+7frmt/093+dVroKR8jd3+GvAc2ARqXIrSALNydLPXCRq5B404QEvOxbPkejx+sZN
	p6BjTE23jgExmXzTBXc46o6EcKgD+GuyuNlX/qtXrxx5yw5ejLoKE3wOZ9pACPYfDEcbDa/x65q
	kXfoLfVrbtvRvNp0sATqDyW5Z6qEy8M/hm/GiK8I9P5GkbYg7UNtyZodxJXJIkaCwbqj7Ftlhfy
	UezqQx7KNVyNQVnKwPsUYwdplJt1kaw==
X-Google-Smtp-Source: AGHT+IFuaD6uE53o0kMUFqkBYFUIpIv4YZNYfnndGaXs7B0K4+B96SRU2dTVgEWhisS3xuLKgCtRtQ==
X-Received: by 2002:a05:6402:4316:b0:62e:df3b:79a6 with SMTP id 4fb4d7f45d1cf-62edf3b81cemr3814693a12.1.1757724591635;
        Fri, 12 Sep 2025 17:49:51 -0700 (PDT)
Received: from localhost ([212.73.77.104])
        by smtp.gmail.com with UTF8SMTPSA id 4fb4d7f45d1cf-62ec33f3b6csm4149162a12.32.2025.09.12.17.49.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Sep 2025 17:49:51 -0700 (PDT)
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
Subject: [PATCH RESEND 09/62] arm: init: document rd_start (in param_struct) as obsolete
Date: Sat, 13 Sep 2025 00:37:48 +0000
Message-ID: <20250913003842.41944-10-safinaskar@gmail.com>
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

It is unused now

Signed-off-by: Askar Safin <safinaskar@gmail.com>
---
 Documentation/arch/arm/setup.rst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/arch/arm/setup.rst b/Documentation/arch/arm/setup.rst
index be77d4b2aac1..01257f30d489 100644
--- a/Documentation/arch/arm/setup.rst
+++ b/Documentation/arch/arm/setup.rst
@@ -86,7 +86,7 @@ below:
    initial ramdisk.
 
  rd_start
-   Start address in sectors of the ramdisk image on a floppy disk.
+   This is now obsolete, and should not be used.
 
  system_rev
    system revision number.
-- 
2.47.2

