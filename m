Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45BB114AA9;
	Mon, 14 Oct 2024 15:26:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728919568; cv=none; b=gSWfhItB4l690rPOiIi0ruBazpcnpSj3hmJEXRn1NkQ4Vkj7rZ8Foao4R6AkfwG5JOQPtFLWK3tOUuVxxKWyAtNf1bGqwhsqQuMMGDlojs1Dk/tvLDhrD5PzXwnKLyLOohxNsndUHY/AfPfaBfdhX4/EwktnBvMdLqZpr756xUU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728919568; c=relaxed/simple;
	bh=ewCVjkQRPXJODpxwsi/Mp7y81EtkoQ6wjBSdUtu3NUQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i5KrmxWB2AqOFMykHmhuLtZ5zWl1RmEpEz2dDWC/t6oCHXAi1XOwoT2GLm7EltfCKvAAbPaVsi0hOlH0+xDgaYgaP7l7ULMqKjpmwZ4pZTGTJaK+333AgaBFIyExgorKtChPpp29z+tRCgy0CKKMdWiiHZfJg9mvsnO39zUKepA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vYdRC3j7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vYdRC3j7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA13FC4CEC3;
	Mon, 14 Oct 2024 15:26:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728919568;
	bh=ewCVjkQRPXJODpxwsi/Mp7y81EtkoQ6wjBSdUtu3NUQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vYdRC3j7oUIftU4PAiez6Ok/HVgAHdWC4ec8Xb4Yvd8RTfvnVW2f/3r58/r1yk2CS
	 8YHnZ4gHQBwttMPW3CapM59gGFrDnObicNxrv3gK4Ruqd55i55nZJXZcGLvm+bB5FY
	 miNovsfsPhUe578lKTa55lJWR4Gi5RvZ9ILcR/iI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 644/798] dt-bindings: clock: qcom: Add missing UFS QREF clocks
Date: Mon, 14 Oct 2024 16:19:58 +0200
Message-ID: <20241014141243.346824490@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

From: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>

[ Upstream commit 26447dad8119fd084d7c6f167c3026700b701666 ]

Add missing QREF clocks for UFS MEM and UFS CARD controllers.

Fixes: 0fadcdfdcf57 ("dt-bindings: clock: Add SC8180x GCC binding")
Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Link: https://lore.kernel.org/r/20240131-ufs-phy-clock-v3-3-58a49d2f4605@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Stable-dep-of: 648b4bde0aca ("dt-bindings: clock: qcom: Add GPLL9 support on gcc-sc8180x")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/dt-bindings/clock/qcom,gcc-sc8180x.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/dt-bindings/clock/qcom,gcc-sc8180x.h b/include/dt-bindings/clock/qcom,gcc-sc8180x.h
index e893415ae13d0..90c6e021a0356 100644
--- a/include/dt-bindings/clock/qcom,gcc-sc8180x.h
+++ b/include/dt-bindings/clock/qcom,gcc-sc8180x.h
@@ -246,6 +246,8 @@
 #define GCC_PCIE_3_CLKREF_CLK					236
 #define GCC_USB3_PRIM_CLKREF_CLK				237
 #define GCC_USB3_SEC_CLKREF_CLK					238
+#define GCC_UFS_MEM_CLKREF_EN					239
+#define GCC_UFS_CARD_CLKREF_EN					240
 
 #define GCC_EMAC_BCR						0
 #define GCC_GPU_BCR						1
-- 
2.43.0



