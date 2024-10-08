Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B915C1DFE32;
	Tue,  8 Oct 2024 13:28:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728394112; cv=none; b=SoG8Q3bLHpVUu+8hoab7N13FvQ/y6VHBzStFHhKF4LFDDmt7k3WhO3M+OmIVo+TVXPZbq1vyI8zvU0ciTWQRw+GypqTTU8Mzz2GzdYLQgdI5CuiGT7PD2F7upSQi7G5d558vss8GDV9GZrERF28uz4Lcbv1f22+hR3uu45KUPrY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728394112; c=relaxed/simple;
	bh=alofqcfIuQ1Jn6dKRRkpil+c/ljgCasJxelqi4D9L7g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q/13MBu2xdhg+TDKBKfbfs7KPzytFUtAknWvLodhdqAoUU4/8wKYmodZmRl4+ZNdg+zxZtdLggflGIaQayfuDqVl66XaHB+ewM1yiNESrh6vNxSuEC5f3B0UwzoRpma6cBTDVefIUeS55FsBVuqrIEtEtgidsGQj9h4kBvdDXkY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EK7s2YN0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EK7s2YN0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25ACDC4CECC;
	Tue,  8 Oct 2024 13:28:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728394112;
	bh=alofqcfIuQ1Jn6dKRRkpil+c/ljgCasJxelqi4D9L7g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EK7s2YN02zxvRIspbGUzzx5Rg8HMhyVbJ9zciWRsn+Pm1S2JxYK410b72Oedh+hdZ
	 tWCuVCqEhZmGLLG434piBtWM5+m7aBqhpEO92FCKft9bGwlD7FLXDk4BBVM41PgyFO
	 gWHfF0C9dK+1v0ebDLNamtbTH1inHOn2b7B/ybrc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 351/386] dt-bindings: clock: qcom: Add missing UFS QREF clocks
Date: Tue,  8 Oct 2024 14:09:56 +0200
Message-ID: <20241008115643.194977682@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115629.309157387@linuxfoundation.org>
References: <20241008115629.309157387@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



