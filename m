Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D1252737E7;
	Mon, 18 Aug 2025 18:57:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755543475; cv=none; b=AQBMKrWmgw2cZfnVwpOBwT912z0ssGZ0AGxqCkg5HF7EeHUJcPVVt/x3wZVyRoK9IpjMBnvpbPfj8uhKetpu8kSEXH1Hn+/yTl4znwkW9b2kmJhF7J0YpBtfxpiVXz/wKdIapV9wRBYEB0GAVDLMgJ/dp+4u6WMZIyPRTYtHVns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755543475; c=relaxed/simple;
	bh=FsJkJ+dK2Mbqz7R/o/xHg+jFYwje/hGODWlWxFEWQd0=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=WjB73c0RlaytIzFKlBU34TAWZGULTnU1mikamUo3jvlQ+QOnHELfVqjTZLAboYDNg30GOnughL6Ij3zBEWcSjIOMgm+shphaF/aXXLoLGdAz4TD+mDCfw4rjRBm52FvoBdjFj9fVB20EDi6Zgj+rRlHm6rdFhHCv1JOuBix8Hg0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pxfcfoHu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pxfcfoHu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09A1FC4CEED;
	Mon, 18 Aug 2025 18:57:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755543474;
	bh=FsJkJ+dK2Mbqz7R/o/xHg+jFYwje/hGODWlWxFEWQd0=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=pxfcfoHuvfdZOXGw6PaOpZbjt8DfpzAEDJed6zxAIM7/4qrqY57Ezp9XtDzvyQ8et
	 w7+KdLvIiw5mhThNnc6NlYOjhrQi4P0Te2QSH00ffH8OpUV6xoxRHlieMKkhZk9kv5
	 j/Tg/i+YNAkVd8Ne1LzfWiVcuvuXWdKsPfuw5laC2mxpnKbLdMjoj+5QPBevN4Ghht
	 TzTZkhisZtZfGu/vqY7oR50HWkm0d08NGid19K1h0gANHRszQTsPEJbwbXfyz5veEH
	 riiHG9jKCmH4ZYiwHs5fx+5hyDGxJHR9Tr5D2ORg/UjWja4vHP0oYqTUqfuLaFEfRe
	 MfmxcZMrrzz6A==
From: Nathan Chancellor <nathan@kernel.org>
Date: Mon, 18 Aug 2025 11:57:19 -0700
Subject: [PATCH 03/10] ARM: Clean up definition of ARM_HAS_GROUP_RELOCS
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250818-bump-min-llvm-ver-15-v1-3-c8b1d0f955e0@kernel.org>
References: <20250818-bump-min-llvm-ver-15-v1-0-c8b1d0f955e0@kernel.org>
In-Reply-To: <20250818-bump-min-llvm-ver-15-v1-0-c8b1d0f955e0@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Arnd Bergmann <arnd@arndb.de>, Kees Cook <kees@kernel.org>, 
 Nick Desaulniers <nick.desaulniers+lkml@gmail.com>, 
 Bill Wendling <morbo@google.com>, Justin Stitt <justinstitt@google.com>, 
 linux-kernel@vger.kernel.org, llvm@lists.linux.dev, patches@lists.linux.dev, 
 Nathan Chancellor <nathan@kernel.org>, Russell King <linux@armlinux.org.uk>, 
 Ard Biesheuvel <ardb@kernel.org>, linux-arm-kernel@lists.infradead.org
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1494; i=nathan@kernel.org;
 h=from:subject:message-id; bh=FsJkJ+dK2Mbqz7R/o/xHg+jFYwje/hGODWlWxFEWQd0=;
 b=owGbwMvMwCUmm602sfCA1DTG02pJDBmLyxce0nhsHlVV1TyzyTr6yp/Lrk7FnMIMqtktcXc8J
 qz8cmFiRykLgxgXg6yYIkv1Y9XjhoZzzjLeODUJZg4rE8gQBi5OAZhIyQyG/25nj3ry3GHaIv+Q
 9VPs++8y+dpN93bvsWpwCihZ1cWw7zQjw5ZTCW0cDjcSGue9WHn/6tv60u7lCxNKClVff7X98XA
 eJxcA
X-Developer-Key: i=nathan@kernel.org; a=openpgp;
 fpr=2437CB76E544CB6AB3D9DFD399739260CB6CB716

Now that the minimum supported version of LLVM for building the kernel
has been bumped to 15.0.0, the first depends line of
ARM_HAS_GROUP_RELOCS is always true, so it can be safely removed.
Combine the !COMPILE_TEST dependency into the 'def_bool' line and update
the comment as well.

Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
Cc: Russell King <linux@armlinux.org.uk>
Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org
---
 arch/arm/Kconfig | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index b1f3df39ed40..faf83015b961 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -166,15 +166,12 @@ config ARM
 	  <http://www.arm.linux.org.uk/>.
 
 config ARM_HAS_GROUP_RELOCS
-	def_bool y
-	depends on !LD_IS_LLD || LLD_VERSION >= 140000
-	depends on !COMPILE_TEST
+	def_bool !COMPILE_TEST
 	help
 	  Whether or not to use R_ARM_ALU_PC_Gn or R_ARM_LDR_PC_Gn group
-	  relocations, which have been around for a long time, but were not
-	  supported in LLD until version 14. The combined range is -/+ 256 MiB,
-	  which is usually sufficient, but not for allyesconfig, so we disable
-	  this feature when doing compile testing.
+	  relocations. The combined range is -/+ 256 MiB, which is usually
+	  sufficient, but not for allyesconfig, so we disable this feature
+	  when doing compile testing.
 
 config ARM_DMA_USE_IOMMU
 	bool

-- 
2.50.1

