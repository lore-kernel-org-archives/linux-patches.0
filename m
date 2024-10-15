Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D7321C57B1;
	Tue, 15 Oct 2024 12:06:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728993983; cv=none; b=LK8SvqHBGQlIoTJiiIboduK/agIby9HZDD46kD5RiPSm1yZCxe7t1GGJMh0m2H1xn7U/aY1NbVzgnxo7EbxdrfoaDcyN0hYMuSSYvb3vmQ7Jp6Di14DFnLj+pC9SOSbZaJw2WZ/zYllVVe1pqmNRYx832Kd8GsMl0p5EthX0RCU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728993983; c=relaxed/simple;
	bh=Utmqsa7KhkOQJdv4LQyDb8kIDkW0DxtI4YBrr8FVcak=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TaZZQsY0z3q5leNWw60lELNC6hyYPxtBc3T7plDQCjZnOln/+i1/Z5uAryUH01WWspF3SWONvhfHQ8mj+9cil9metjaO4Vyv637EQqlmVAqq7dobqr/18kQLymsY9f+QZ4H5jru+vIHw+EzRTAyiQNNEWmOJyE618AOJQ6IpzZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bjf7BoRW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bjf7BoRW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF13DC4CEC6;
	Tue, 15 Oct 2024 12:06:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728993983;
	bh=Utmqsa7KhkOQJdv4LQyDb8kIDkW0DxtI4YBrr8FVcak=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bjf7BoRWIBzN2OQMRytp5AfFVgUFT2F/NBvA0C+OB7Q+UYc00XPf4U3F5KIqfeBpA
	 DkMS3HdzstXi86IZMHTTKZXdbJtwOKKwnj02YwRKqvmwD6IV65u2JjtG8PmUFlu2uA
	 N5Flbcwaw1J7gpann02OdWmpVInoi0KwWDul9Plk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 572/691] dt-bindings: clock: qcom: Add missing UFS QREF clocks
Date: Tue, 15 Oct 2024 13:28:40 +0200
Message-ID: <20241015112503.046349826@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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



