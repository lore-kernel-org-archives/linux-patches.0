Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 293351494D9;
	Tue, 23 Apr 2024 21:44:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713908676; cv=none; b=GamoPL994PWAhEr01gXfnXshk98x8ZtmkR7FFh8UNTKJ6v07vfBCJZNX1IgMzBN0fMoee+JKHvLXpL6LaNAlsNXcZwmYefU0QDDRJwNClPFeoIqHqHvtQQZSeAGqJVJvT4Kmrf6YnHRvbTBh+nOzj2uWcVae+uweBKFtFcv7cLw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713908676; c=relaxed/simple;
	bh=YfU7xWPWklg95w4P1DBz1aelgb8qons2zJxYTNdLXzc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dmw68BlRwWkBQxd+26tb/6dqDPXldaKdiJhsmb62VwuumSCXhzSRJspata9c3MF/mjEbBeuxJZYPUs4Ut/4bhaQm7nqdkh+uxCnGv0rdj7XXf/D9YZwPzbq6HqTzFfRKxKAVLaeNUfWmObkphpwp4SmKjbxiMukzCq9GwWsg07E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L5uzfaE7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L5uzfaE7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F130BC3277B;
	Tue, 23 Apr 2024 21:44:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713908676;
	bh=YfU7xWPWklg95w4P1DBz1aelgb8qons2zJxYTNdLXzc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L5uzfaE7mf18Nt/7gzk4ZGiBqCVORDgeVAoeCyJT24SbOMbWIvW3hdVDuvq4D2ULW
	 Xmrw6b5M6qFXKW8bc/FCIKWgezxDkESQJyP/pA+MVlos3yWgwrPTMbY1LYBJZ8C0LQ
	 5QTZNolvEO2WR1ricW+Jn3wF8L66LiEDSPY4zlnQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ard Biesheuvel <ardb@kernel.org>,
	Ingo Molnar <mingo@kernel.org>
Subject: [PATCH 6.1 017/141] x86/boot: Drop redundant code setting the root device
Date: Tue, 23 Apr 2024 14:38:05 -0700
Message-ID: <20240423213853.893815246@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240423213853.356988651@linuxfoundation.org>
References: <20240423213853.356988651@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ard Biesheuvel <ardb@kernel.org>

[ Commit 7448e8e5d15a3c4df649bf6d6d460f78396f7e1e upstream ]

The root device defaults to 0,0 and is no longer configurable at build
time [0], so there is no need for the build tool to ever write to this
field.

[0] 079f85e624189292 ("x86, build: Do not set the root_dev field in bzImage")

This change has no impact on the resulting bzImage binary.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Link: https://lore.kernel.org/r/20230912090051.4014114-23-ardb@google.com
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/boot/header.S      |    2 +-
 arch/x86/boot/tools/build.c |    7 -------
 2 files changed, 1 insertion(+), 8 deletions(-)

--- a/arch/x86/boot/header.S
+++ b/arch/x86/boot/header.S
@@ -235,7 +235,7 @@ root_flags:	.word ROOT_RDONLY
 syssize:	.long 0			/* Filled in by build.c */
 ram_size:	.word 0			/* Obsolete */
 vid_mode:	.word SVGA_MODE
-root_dev:	.word 0			/* Filled in by build.c */
+root_dev:	.word 0			/* Default to major/minor 0/0 */
 boot_flag:	.word 0xAA55
 
 	# offset 512, entry point
--- a/arch/x86/boot/tools/build.c
+++ b/arch/x86/boot/tools/build.c
@@ -40,10 +40,6 @@ typedef unsigned char  u8;
 typedef unsigned short u16;
 typedef unsigned int   u32;
 
-#define DEFAULT_MAJOR_ROOT 0
-#define DEFAULT_MINOR_ROOT 0
-#define DEFAULT_ROOT_DEV (DEFAULT_MAJOR_ROOT << 8 | DEFAULT_MINOR_ROOT)
-
 /* Minimal number of setup sectors */
 #define SETUP_SECT_MIN 5
 #define SETUP_SECT_MAX 64
@@ -399,9 +395,6 @@ int main(int argc, char ** argv)
 
 	update_pecoff_setup_and_reloc(i);
 
-	/* Set the default root device */
-	put_unaligned_le16(DEFAULT_ROOT_DEV, &buf[508]);
-
 	/* Open and stat the kernel file */
 	fd = open(argv[2], O_RDONLY);
 	if (fd < 0)


