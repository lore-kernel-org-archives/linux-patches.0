Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 765AB4F93DF;
	Thu, 17 Sep 2026 17:40:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789666823; cv=none; b=l+xsmS0dQRo0lkugoinrpVOlVLhmlqZLIVjkQw6CV3Aq4CruJUCCX5LSqzetuElOXBFI0jgk/B5V6yhOXWO5rtWTLcOpc8ljcMCEyCQyP6eNjbxxuHYI4CDqsJ349euaDMXTIDekJDcvi9yUMSkRA+AM0lqLgLVFy5UCXHo8OI4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789666823; c=relaxed/simple;
	bh=sqVcBUiJMm2K3WmFMrgc3JTVLMRfLlWRlYFcH6C3Zpo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LSAjgZE2Q+FOyjrah3cu0f3JLP4lnvxX0eJST893tow3PxF2O8UfakcajXtFyDr4zBK54sdY3P9Em51soq4qsf0mtlOdrYbjc+m0C6C2AkOmKD4jD2x6/HTpaQnyb7s0LlM/uMzeffL7FW/8MFjVeFobC42F+zOZWsCSuTd/Jyk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RauK8E7v; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RauK8E7v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CC861F00893;
	Thu, 17 Sep 2026 17:40:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789666822;
	bh=2TmvKQAFVcAbWmxo/8ottNX4QZe/EcfYInaqFOtumrk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RauK8E7viZoovoC9nbtJqRWbHR8lDSsHU6BMPKWeP0LOev1NKJlQqgk1ME5n/c62J
	 rAuFD6drxleMXCuXZpBpgkbfEZNljoUzLb/TY2QyesLjnv8J91av3lY5PAjTMTpfyd
	 M7UL/xQ04yGvT66qk+WJml9UOCz0YRyOQbPmdPEo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1135/1250] Revert "arm64: dts: qcom: sm8750: Fix the PCIe iommu-map entries"
Date: Thu, 17 Sep 2026 16:15:30 +0100
Message-ID: <20260917151623.012603192@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

This reverts commit fc2980ea692027f529afb7b127157d45650d6c6e.

Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sm8750.dtsi | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sm8750.dtsi b/arch/arm64/boot/dts/qcom/sm8750.dtsi
index c6f4a43ff133e..b714207e4c158 100644
--- a/arch/arm64/boot/dts/qcom/sm8750.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8750.dtsi
@@ -3393,8 +3393,8 @@ &mc_virt SLAVE_EBI1 QCOM_ICC_TAG_ALWAYS>,
 			interconnect-names = "pcie-mem",
 					     "cpu-pcie";
 
-			iommu-map = <0x0   &apps_smmu 0x1400 0x0 0x1>,
-				    <0x100 &apps_smmu 0x1401 0x0 0x1>;
+			iommu-map = <0x0   &apps_smmu 0x1400 0x1>,
+				    <0x100 &apps_smmu 0x1401 0x1>;
 
 			resets = <&gcc GCC_PCIE_0_BCR>;
 			reset-names = "pci";
-- 
2.53.0



