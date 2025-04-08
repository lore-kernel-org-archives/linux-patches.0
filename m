Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C93C126B0A7;
	Tue,  8 Apr 2025 11:29:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744111756; cv=none; b=AANcZNz365FvNJoiZEU09gI/tM727vJSweRLPFfI+pwsGeOAfQEl9hJtlssCHBcSx3u5QgAqR+oT30uzkPDnu2/Zh7ChEw/wj+/eUmVbc2Kvgc/SKgw8q4AOQxbMUrAm21QoC5mfarjxgiZyrjQjpH5/qFshSENpG57KK0bcIYA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744111756; c=relaxed/simple;
	bh=BSc+MomSRabDDojv8YUhieQQwPpqdXoGLNCMB9PdM6A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Cf7Cn4jy95Ej9lE8qjXr7h32y/SOLDUTm/qrF37tKUKucnWVPEJnzJJUgkEy32fyioT7ZCrDZN+ylMVS8p6fUtLt2EYCW8+GY2NBcYoOsfPb3NTx85GanqzvJaGWIsAGyAnhDWSrGXv8TpIjC8U9ZH8bUiXXiTePcWt68TL7Ih4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IRhpcagp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IRhpcagp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32563C4CEE5;
	Tue,  8 Apr 2025 11:29:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744111756;
	bh=BSc+MomSRabDDojv8YUhieQQwPpqdXoGLNCMB9PdM6A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IRhpcagpKQtpGsBSyc8TahY94jeYIDqwkfTlwaZuyEBKe/o0XoMSHeicjMF0ReCEZ
	 9dG+z2lR++tOlFDq22+/F60VdcjpukPso9J9xUwbinYHYeOwf+/qAr6DVhAb4+2KOU
	 yaqR5tkHGicDTDR1aStQYqfxhAuFdfyUQ3b2lIU8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Ingo Molnar <mingo@redhat.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Marc Zyngier <maz@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Steven Price <steven.price@arm.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Will Deacon <will@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 511/731] arch/powerpc: drop GENERIC_PTDUMP from mpc885_ads_defconfig
Date: Tue,  8 Apr 2025 12:46:48 +0200
Message-ID: <20250408104926.162437687@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anshuman Khandual <anshuman.khandual@arm.com>

[ Upstream commit 2c5e6ac2db64ace51f66a9f3b3b3ab9553d748e8 ]

GENERIC_PTDUMP gets selected on powerpc explicitly and hence can be
dropped off from mpc885_ads_defconfig.  Replace with CONFIG_PTDUMP_DEBUGFS
instead.

Link: https://lkml.kernel.org/r/20250226122404.1927473-3-anshuman.khandual@arm.com
Fixes: e084728393a5 ("powerpc/ptdump: Convert powerpc to GENERIC_PTDUMP")
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
Suggested-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Reviewed-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Steven Price <steven.price@arm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/configs/mpc885_ads_defconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/configs/mpc885_ads_defconfig b/arch/powerpc/configs/mpc885_ads_defconfig
index 77306be62e9ee..129355f87f80f 100644
--- a/arch/powerpc/configs/mpc885_ads_defconfig
+++ b/arch/powerpc/configs/mpc885_ads_defconfig
@@ -78,4 +78,4 @@ CONFIG_DEBUG_VM_PGTABLE=y
 CONFIG_DETECT_HUNG_TASK=y
 CONFIG_BDI_SWITCH=y
 CONFIG_PPC_EARLY_DEBUG=y
-CONFIG_GENERIC_PTDUMP=y
+CONFIG_PTDUMP_DEBUGFS=y
-- 
2.39.5



