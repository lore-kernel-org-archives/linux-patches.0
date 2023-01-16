Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0CFD33EC
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 15:56:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4727AC433F0;
	Mon, 16 Jan 2023 15:56:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673884589;
	bh=bvwb+TfdFqzrZlYaGhhtHqOkFZItse3P8vMMxYXsjmw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u6aLZFkPGrxxi2cwkDNK2srZ4YUZidpUs6dcf0oXt6GASHGzdlkJUnz1+tkqyUHAY
	 CbsXEvfKqKE+kk6Q3cciKiWexrAKDYLTkWS+voDiV4oc7o38OheQSLSq8kqCt/GQEd
	 9ODIqlV4yDrQim7pKbbh9+c2+XD44Q32vd0VgCTY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zenghui Yu <yuzenghui@huawei.com>,
	Mark Brown <broonie@kernel.org>,
	Will Deacon <will@kernel.org>
Subject: [PATCH 6.1 063/183] arm64: ptrace: Use ARM64_SME to guard the SME register enumerations
Date: Mon, 16 Jan 2023 16:49:46 +0100
Message-Id: <20230116154806.016941838@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154803.321528435@linuxfoundation.org>
References: <20230116154803.321528435@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Zenghui Yu <yuzenghui@huawei.com>

commit eb9a85261e297292c4cc44b628c1373c996cedc2 upstream.

We currently guard REGSET_{SSVE, ZA} using ARM64_SVE for no good reason.
Both enumerations would be pointless without ARM64_SME and create two empty
entries in aarch64_regsets[] which would then become part of a process's
native regset view (they should be ignored though).

Switch to use ARM64_SME instead.

Fixes: e12310a0d30f ("arm64/sme: Implement ptrace support for streaming mode SVE registers")
Signed-off-by: Zenghui Yu <yuzenghui@huawei.com>
Reviewed-by: Mark Brown <broonie@kernel.org>
Link: https://lore.kernel.org/r/20221214135943.379-1-yuzenghui@huawei.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kernel/ptrace.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm64/kernel/ptrace.c
+++ b/arch/arm64/kernel/ptrace.c
@@ -1364,7 +1364,7 @@ enum aarch64_regset {
 #ifdef CONFIG_ARM64_SVE
 	REGSET_SVE,
 #endif
-#ifdef CONFIG_ARM64_SVE
+#ifdef CONFIG_ARM64_SME
 	REGSET_SSVE,
 	REGSET_ZA,
 #endif


