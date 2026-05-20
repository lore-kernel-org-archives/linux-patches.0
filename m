Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23F7E3BED26;
	Wed, 20 May 2026 18:41:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779302468; cv=none; b=gBFttKxB1Trt64bpaH0XzUp97Nrj9HC/qfRKgBCg3M+UBlMbBp2QDxlmLw1YeikRwNvTfRk/7E+nHwwJXA8FfJ3cxyToWd3BZ/S5eB4U34v1Cwfx/Aig4OsfyNUW8vgQz8nkCv3OWogc2KDbdwBkrDhupZCbHcKUrwQgqn02V0E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779302468; c=relaxed/simple;
	bh=biteVKi/xpP4/wpFhU8q7z4tALxOHx2UdsD6r3DnGf0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kvKTahH9ELq3cKZBm1EOIT9fy9AQetAJH7eoHAjRSWK+ZgAhFb++Vr/U7HGrMbPK0Pde2vyrhV8i+ptGI3fPiVTqVI5KL+Xldx9f3Z6mTPMtO7wschVyot4l8sgp7SIz7kNjcT9ethdY+0GzMHyjp0s7S225t4PpTpL/Wcll5yw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TeTZRsvw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TeTZRsvw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8ACD61F000E9;
	Wed, 20 May 2026 18:41:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779302467;
	bh=RRsqsFwPVLfANjb4jb/fEfdy2qcgrRNRkiVRM0LCgkM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TeTZRsvwNk8eKZFR3xCB3DHPiMCk/gfwPcKNVkIkr5yEGWaDRdljXoUR6mNLBnLug
	 b88e+pAFlirt37OTnwiQ/I0TasWTSIYKgGLcGz+/kwMPT7mf13gw7L+/I++ZKZgVo4
	 VkxbDyRD8/JNxhkERwh4yPr7uyaW3Ny3Fs0Bt74E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Val Packett <val@packett.cool>,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 278/508] dt-bindings: clock: qcom,gcc-sc8180x: Add missing GDSCs
Date: Wed, 20 May 2026 18:21:41 +0200
Message-ID: <20260520162104.670284756@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162058.573354582@linuxfoundation.org>
References: <20260520162058.573354582@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 2569f874fe13c..be97a0ca2ade4 100644
--- a/include/dt-bindings/clock/qcom,gcc-sc8180x.h
+++ b/include/dt-bindings/clock/qcom,gcc-sc8180x.h
@@ -308,5 +308,10 @@
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



