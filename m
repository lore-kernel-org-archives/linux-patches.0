Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF6EA1E7669;
	Tue, 15 Oct 2024 12:06:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728993986; cv=none; b=X6PBa3b+6x7+JWMZULnlyPMA06BhCrdCNkIoVbyREdZtYsh8ECE09/En1PIf6omIzGOZDB9Fg5uCKiMUNtkq3G4Lh2WiAm0ZUvj5mHo1IQyJuiqIq+RX4C5Fb27mwSOpuCuB9egnlggvH9rCwN1bl5XyqYnXYEh9CsnCxYB90t8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728993986; c=relaxed/simple;
	bh=Z8BC9TKy9P8LBKXn9EvykSLhYCTAj6V5Evw8EYgjVGE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QnPVhVrSLYcn+4gqFTRtXFd+OYBprKPrWG/ALT+YIUF71HFejOI/gxpqCawSBL37OjWg7L/xFRJiD1P1jTFzJGnkStf5dl4faKE8Epp9l2jPGCno/aB+PXA3zeWY1oHH2GVryhUz8PXwLrheu7yWh5ZHVCLHTgn92Qx8G2K4yMA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b/f1Pw/s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b/f1Pw/s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31764C4CEC6;
	Tue, 15 Oct 2024 12:06:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728993986;
	bh=Z8BC9TKy9P8LBKXn9EvykSLhYCTAj6V5Evw8EYgjVGE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b/f1Pw/sfRtLXIYuC9Y9jjFDj9D1kJvUiM52ftfdPILlYV5KotbpFsUEaLbiykmDb
	 DMCuOpadb5+/jwhlZE9DfiiKBjkFmtNWAGdT6M7IRwMx6NxdJYpeIfuYhbdsLrYM1+
	 ZC5ZfaxVNxJEQMntC572GhPOxAsBlhY8LfgUsEpk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Satya Priya Kakitapalli <quic_skakitap@quicinc.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 573/691] dt-bindings: clock: qcom: Add GPLL9 support on gcc-sc8180x
Date: Tue, 15 Oct 2024 13:28:41 +0200
Message-ID: <20241015112503.085171252@linuxfoundation.org>
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

From: Satya Priya Kakitapalli <quic_skakitap@quicinc.com>

[ Upstream commit 648b4bde0aca2980ebc0b90cdfbb80d222370c3d ]

Add the missing GPLL9 which is required for the gcc sdcc2 clock.

Fixes: 0fadcdfdcf57 ("dt-bindings: clock: Add SC8180x GCC binding")
Cc: stable@vger.kernel.org
Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Satya Priya Kakitapalli <quic_skakitap@quicinc.com>
Link: https://lore.kernel.org/r/20240812-gcc-sc8180x-fixes-v2-2-8b3eaa5fb856@quicinc.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/dt-bindings/clock/qcom,gcc-sc8180x.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/dt-bindings/clock/qcom,gcc-sc8180x.h b/include/dt-bindings/clock/qcom,gcc-sc8180x.h
index 90c6e021a0356..2569f874fe13c 100644
--- a/include/dt-bindings/clock/qcom,gcc-sc8180x.h
+++ b/include/dt-bindings/clock/qcom,gcc-sc8180x.h
@@ -248,6 +248,7 @@
 #define GCC_USB3_SEC_CLKREF_CLK					238
 #define GCC_UFS_MEM_CLKREF_EN					239
 #define GCC_UFS_CARD_CLKREF_EN					240
+#define GPLL9							241
 
 #define GCC_EMAC_BCR						0
 #define GCC_GPU_BCR						1
-- 
2.43.0



