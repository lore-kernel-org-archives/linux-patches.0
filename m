Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCF3F268FE4;
	Tue,  8 Apr 2025 12:20:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744114815; cv=none; b=NmetxCjAYyTymlJm+AZoP3sV+MIhJBUgy8z3uBg524pF86PIUapxFuf/OArCLdnWcDvLZ+kEurjrrh431woGmm7/f0iLuMA8n91c+Nb5EukQTJKkaH5T4OcounnIslnOg2785a2wWw7AH9d7Dx8E8tCO7UWD7mReFjNu+7pbB3k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744114815; c=relaxed/simple;
	bh=8ReOyN9TO7o7BRDtwtdU8SNaeqWvyJbcXTTjNtr+hCg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BKi0Hg7CN8JivJnfUOza2O81UFlY5VjLZjv2Fz57KE69PI/VRmAwrVXHj/H5f2/YMriweuoDjAhVuukKGdh3j6dASwpF7ibp+6FB+A8wvt28kvKnqhNqFq8UqmxVeVTSrU0+FOSLeItcINhc2uEJ20FfSmm0NwXzNb/W2tIwDU0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Bc5d4c8P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Bc5d4c8P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 419EFC4CEE5;
	Tue,  8 Apr 2025 12:20:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744114815;
	bh=8ReOyN9TO7o7BRDtwtdU8SNaeqWvyJbcXTTjNtr+hCg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Bc5d4c8PijHrA8H7UnzudUXpFLBSO1KMH3EjRy+SnTnEBemcpC20mAEInx0i0/Qvm
	 vDyySxzgJyiFOVXLJrMPuAkciV5gx73efZBdVqVtr6ay1Ydclzq62QEugp0fAxMlvi
	 f1owr/U0uobrcRNkywlFdioNzvxOxUPP6/QKOWTc=
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
Subject: [PATCH 6.13 244/499] arch/powerpc: drop GENERIC_PTDUMP from mpc885_ads_defconfig
Date: Tue,  8 Apr 2025 12:47:36 +0200
Message-ID: <20250408104857.300931462@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104851.256868745@linuxfoundation.org>
References: <20250408104851.256868745@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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



