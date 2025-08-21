Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41F8B2D7DCF;
	Thu, 21 Aug 2025 21:16:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755810963; cv=none; b=ujC/1SASnpUTvcwyFJdx/VF1sdjieCr87uIdJ19BIiRgVC7GHi4Ay0Oe4jWiWBX6om1iHUVTTN6tVg/cpeOGKVjk8TvmxfZQ8GDSfXBZkyraQwuZpY1OdXBmeZTNRrvBErLTNDOpdNB15H74JLzwIUw7LPpvr2d4BriapHuZD4A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755810963; c=relaxed/simple;
	bh=7CiDzOmiuSVjS8lOEl7Pi4ckMf1acrF1U6d8qioo+Vg=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=hseCooTyWklZMkbiufMJ8nsL6Ibc59n7fKmbKwxmgRl+YqP/0kX0MBkHcCG18W2wNKnbAtxgBHPtAb8dC4/Y/51aLKpGuNQ7VHi6vPbFjuMa2c6zgT1heA3km4VfDDYKGoO23RmBXaPpadC8KitDK2XxXQ7327ulpTOTBA5KRP8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HXBiLczj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HXBiLczj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47012C4AF0D;
	Thu, 21 Aug 2025 21:16:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755810962;
	bh=7CiDzOmiuSVjS8lOEl7Pi4ckMf1acrF1U6d8qioo+Vg=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=HXBiLczjaeUeNSpkYM98BJ5W2kwcQy/QP2xsz/ayEUXJNaIDObI/8mLoaAbd7vyKQ
	 qNDWMFZUQ9/Xd1WfYbKBAuWfFJhymBx/63CqFwDTcBng3VrzfUjEMSPrYanx3tSEI1
	 YgGYsRhSW8DxDCBrIDmS79dC+f907Gojl83qLX/2CzIuXplbE5dJc1PORbBKhThJVQ
	 PNtPjf87diIINFAG8vTcmZ7Xt1gvIrDg1H3IpHiYrubdjIaO6//EaGBzH9yGf/yEQ3
	 /7MJmbUMbjDAKW7MkKAA8neDCdmQtk35c1bwnpFYBz4IrUzUdFcHN4kj5XeexBgr8y
	 phmv+PUlADBgA==
From: Nathan Chancellor <nathan@kernel.org>
Date: Thu, 21 Aug 2025 14:15:40 -0700
Subject: [PATCH v2 03/12] ARM: Clean up definition of ARM_HAS_GROUP_RELOCS
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250821-bump-min-llvm-ver-15-v2-3-635f3294e5f0@kernel.org>
References: <20250821-bump-min-llvm-ver-15-v2-0-635f3294e5f0@kernel.org>
In-Reply-To: <20250821-bump-min-llvm-ver-15-v2-0-635f3294e5f0@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, Kees Cook <kees@kernel.org>, 
 Nick Desaulniers <nick.desaulniers+lkml@gmail.com>, 
 Bill Wendling <morbo@google.com>, Justin Stitt <justinstitt@google.com>, 
 llvm@lists.linux.dev, patches@lists.linux.dev, 
 Nathan Chancellor <nathan@kernel.org>, Russell King <linux@armlinux.org.uk>, 
 Ard Biesheuvel <ardb@kernel.org>, linux-arm-kernel@lists.infradead.org
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1536; i=nathan@kernel.org;
 h=from:subject:message-id; bh=7CiDzOmiuSVjS8lOEl7Pi4ckMf1acrF1U6d8qioo+Vg=;
 b=owGbwMvMwCUmm602sfCA1DTG02pJDBnLe5oUZicnzd4+QThQ+9wcffWTvR1uBbqai87HRis+L
 SrYKWLTUcrCIMbFICumyFL9WPW4oeGcs4w3Tk2CmcPKBDKEgYtTACaSq8jwP7hK74Jc5rw9hwzP
 L8j9vNH4zpY9evr3vyvceW+9SyOy6yTDX9mWbr7obQ/nrth3JmtBxM/oGdPXXT/TNCs7rjTJQ19
 cgw8A
X-Developer-Key: i=nathan@kernel.org; a=openpgp;
 fpr=2437CB76E544CB6AB3D9DFD399739260CB6CB716

Now that the minimum supported version of LLVM for building the kernel
has been bumped to 15.0.0, the first depends line of
ARM_HAS_GROUP_RELOCS is always true, so it can be safely removed.
Combine the !COMPILE_TEST dependency into the 'def_bool' line and update
the comment as well.

Reviewed-by: Kees Cook <kees@kernel.org>
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

