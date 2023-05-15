Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19454FBE7
	for <patches@lists.linux.dev>; Mon, 15 May 2023 16:48:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72ADBC433D2;
	Mon, 15 May 2023 16:48:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684169299;
	bh=8e4YA33vgLUYXKPtW7j+Y7qdMP1hdQK6O3SG0vW0ssE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HSQiJMGmaaClxRhczrUYGkp8IvPWkQzacEdff9fOj7qtqO/pMMSMC7AZKbkTrl6Bh
	 Me64qes18XIGASDOBVqVz1RI8inPDqPEC2ih3LUBf+47Yr0O+x9uCxCp/VZTB5a04f
	 s5/jWCPciqi3HVYiidXWkXdF5LAzI1VRcFZboWbs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Neeraj Upadhyay <quic_neeraju@quicinc.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 015/246] arm64: Fix label placement in record_mmu_state()
Date: Mon, 15 May 2023 18:23:47 +0200
Message-Id: <20230515161723.069855342@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161722.610123835@linuxfoundation.org>
References: <20230515161722.610123835@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Neeraj Upadhyay <quic_neeraju@quicinc.com>

[ Upstream commit 4e8f6e44bce8da3b0e2df37b12839f4bc9c9cabe ]

Fix label so that pre_disable_mmu_workaround() is called
before clearing sctlr_el1.M.

Fixes: 2ced0f30a426 ("arm64: head: Switch endianness before populating the ID map")
Signed-off-by: Neeraj Upadhyay <quic_neeraju@quicinc.com>
Acked-by: Ard Biesheuvel <ardb@kernel.org>
Link: https://lore.kernel.org/r/20230425095700.22005-1-quic_neeraju@quicinc.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kernel/head.S | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kernel/head.S b/arch/arm64/kernel/head.S
index b98970907226b..e92caebff46a0 100644
--- a/arch/arm64/kernel/head.S
+++ b/arch/arm64/kernel/head.S
@@ -150,8 +150,8 @@ CPU_BE( tbz	x19, #SCTLR_ELx_EE_SHIFT, 1f	)
 	pre_disable_mmu_workaround
 	msr	sctlr_el2, x19
 	b	3f
-	pre_disable_mmu_workaround
-2:	msr	sctlr_el1, x19
+2:	pre_disable_mmu_workaround
+	msr	sctlr_el1, x19
 3:	isb
 	mov	x19, xzr
 	ret
-- 
2.39.2



