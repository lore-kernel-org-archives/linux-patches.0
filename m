Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D0FF36405A;
	Wed, 20 May 2026 17:40:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779298847; cv=none; b=THBLz1Q3HoNcrgH98d3TQhT8KXhpMP7AbbW9bw3aY3L/MLFUXlatnGWwRCuFlHRTOYvpxUzVGJkBS2RuaEMSPtlFI/8ORsv7lQ5uMOTVAMze9xb8V8ixci/al9TjUny8v+j1nCdGrCfMBxmhtACklYXQ/NV2BqvYaWBOyRSzNKk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779298847; c=relaxed/simple;
	bh=slvV0bt/5np5UZ0+H6P1J0u9p/a4a1QoMnFFPAjA9WQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ev1tS940hYl7f36rxqc5+RDGhJLNtqAZJC9g2TJbEJtQc4bElUSmnKq5tQVhMYDSqmFvVq0z/BrtVCuHyJEcYNSrhuR99W8f2pehGzUm+a+MuCpDvNyWr9hyTYr4A8fLXgJngMLpfS06f+kZ62K+Glpj1XbqxuKzPxMC+H4Mah4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Up1bCEcT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Up1bCEcT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 730611F000E9;
	Wed, 20 May 2026 17:40:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779298845;
	bh=g4RCnInt5g7ZK0Iaj7IA3orr1p4QtOM5riUM1rugHmk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Up1bCEcTjxoqQokqAIQNU9mSSOJ22RKa/xXQiWuqpJkpWNKn7iXL9jSKojNIvplK9
	 QAoGXPxCcMZI83jbAcwh94sgkO3VrcKIrL17e/Ct0SJlFYmS6cFDzNVkJ9LGSy+1LF
	 ZJG73hYYoAaqUczGPNmq3WtRVKSCfl6RcI2GhcHM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Val Packett <val@packett.cool>,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 565/957] dt-bindings: clock: qcom,gcc-sc8180x: Add missing GDSCs
Date: Wed, 20 May 2026 18:17:28 +0200
Message-ID: <20260520162146.783255982@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Val Packett <val@packett.cool>

[ Upstream commit 76404ffbf07f28a5ec04748e18fce3dac2e78ef6 ]

There are 5 more GDSCs that we were ignoring and not putting to sleep,
which are listed in downstream DTS. Add them.

Signed-off-by: Val Packett <val@packett.cool>
Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260312112321.370983-2-val@packett.cool
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Stable-dep-of: 3565741eb985 ("clk: qcom: gcc-sc8180x: Add missing GDSCs")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/dt-bindings/clock/qcom,gcc-sc8180x.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/include/dt-bindings/clock/qcom,gcc-sc8180x.h b/include/dt-bindings/clock/qcom,gcc-sc8180x.h
index b9d8438a15ffb..9ed7b794aacc4 100644
--- a/include/dt-bindings/clock/qcom,gcc-sc8180x.h
+++ b/include/dt-bindings/clock/qcom,gcc-sc8180x.h
@@ -322,5 +322,10 @@
 #define USB30_MP_GDSC						8
 #define USB30_PRIM_GDSC						9
 #define USB30_SEC_GDSC						10
+#define HLOS1_VOTE_MMNOC_MMU_TBU_HF0_GDSC		11
+#define HLOS1_VOTE_MMNOC_MMU_TBU_HF1_GDSC		12
+#define HLOS1_VOTE_MMNOC_MMU_TBU_SF_GDSC		13
+#define HLOS1_VOTE_TURING_MMU_TBU0_GDSC			14
+#define HLOS1_VOTE_TURING_MMU_TBU1_GDSC			15
 
 #endif
-- 
2.53.0



