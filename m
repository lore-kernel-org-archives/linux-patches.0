Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B99AF3FC5A1;
	Wed, 20 May 2026 18:41:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779302499; cv=none; b=o/IHYcs0adVtmTerUgxjoS/900NxzrDvYKin5S7B7uPrJGTxqnEgkb3ESrmFS50vb/IoxRnXIeTfd7czliBhLy4R7fjK1aFbCNYtJbI5WWjUYqH1wVheOfOKgOy7aIDtXv+fjKDpBK+G4Dal5mv5AuB2VMsu4nSm4+GYAJabxog=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779302499; c=relaxed/simple;
	bh=buML967NwLWEpt2aHs2RDhL6NSv5tjrfr4tjTsUgIgs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FQkY5BNrdSQg40ZrqS7L8tLr5zChuIssegsl1v4pKyXSJ8mEBjS4PKNGdjJk1O9tewgP249WkYmvzgVzoPwHVF+oK2NGdglmOBTU39b6yzrxy+o/fmmR6mUlTunG6iiDAfYQKpJ/e8GZxqatZpz1260eS3rU/Eeo+DZ0c4G5Kt0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N5hXBXLP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N5hXBXLP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 321451F000E9;
	Wed, 20 May 2026 18:41:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779302498;
	bh=CwV+BGt7ObdXF+vJVmnjbpO3bAIRH5yxtpjl2ZkeLLs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=N5hXBXLPgDzQjSPXaZyBBLWzsM7V+Fvjt8DdgaYY6YKv9kQM4QuTJPOOEKArQXnLz
	 OCOTpe+urWMowlvVLYAaUmRLe/uOViO5RXQsWxAMgYmG5pDbcy2EIJ+tUKKxJKI64F
	 GEWlW3KK5Ysuqv/BvdaGQkh3aZtmisCXdBEm38f8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Taniya Das <taniya.das@oss.qualcomm.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	Val Packett <val@packett.cool>
Subject: [PATCH 6.6 289/508] dt-bindings: clock: qcom,dispcc-sc7180: Define MDSS resets
Date: Wed, 20 May 2026 18:21:52 +0200
Message-ID: <20260520162104.905416674@linuxfoundation.org>
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

From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>

[ Upstream commit fc6e29d42872680dca017f2e5169eefe971f8d89 ]

The MDSS resets have so far been left undescribed. Fix that.

Fixes: 75616da71291 ("dt-bindings: clock: Introduce QCOM sc7180 display clock bindings")
Signed-off-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Reviewed-by: Taniya Das <taniya.das@oss.qualcomm.com>
Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Tested-by: Val Packett <val@packett.cool> # sc7180-ecs-liva-qc710
Link: https://lore.kernel.org/r/20260120-topic-7180_dispcc_bcr-v1-1-0b1b442156c3@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Stable-dep-of: b0bc6011c549 ("clk: qcom: dispcc-sc7180: Add missing MDSS resets")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/dt-bindings/clock/qcom,dispcc-sc7180.h | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/include/dt-bindings/clock/qcom,dispcc-sc7180.h b/include/dt-bindings/clock/qcom,dispcc-sc7180.h
index b9b51617a335d..0705103060748 100644
--- a/include/dt-bindings/clock/qcom,dispcc-sc7180.h
+++ b/include/dt-bindings/clock/qcom,dispcc-sc7180.h
@@ -6,6 +6,7 @@
 #ifndef _DT_BINDINGS_CLK_QCOM_DISP_CC_SC7180_H
 #define _DT_BINDINGS_CLK_QCOM_DISP_CC_SC7180_H
 
+/* Clocks */
 #define DISP_CC_PLL0				0
 #define DISP_CC_PLL0_OUT_EVEN			1
 #define DISP_CC_MDSS_AHB_CLK			2
@@ -40,7 +41,11 @@
 #define DISP_CC_MDSS_VSYNC_CLK_SRC		31
 #define DISP_CC_XO_CLK				32
 
-/* DISP_CC GDSCR */
+/* Resets */
+#define DISP_CC_MDSS_CORE_BCR			0
+#define DISP_CC_MDSS_RSCC_BCR			1
+
+/* GDSCs */
 #define MDSS_GDSC				0
 
 #endif
-- 
2.53.0



