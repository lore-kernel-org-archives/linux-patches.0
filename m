Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED6DC3659E5;
	Tue, 16 Dec 2025 12:11:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765887073; cv=none; b=FMzDd2vYdzNxOAsBs9NNY/uSJTCfP6jBlsfJX7yDfGIlqdkgxDTTrXo+nZMdqs5D55MjJi8zIp1lZktxV1rEep8zlzuuQEx+p3viaHggLIc16BmsIVKJkZrB8D4fVDfnIlb0zw9xM0Mniz5p3FPaH8YTeBiiVOBLWfQ9ecgtuMs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765887073; c=relaxed/simple;
	bh=X2Rp/aknV+weuF4FuvRRvlnnKJwwHOmO+N3ucfa+YZw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WS+mlW5kqPh2yvlvB0Ra0eQkCnQ5zSoaZE6y5ii6wHbrvxvctjx0N4l2VN58DvEA65FWIwgpeQpsyFD4hQcy4GlpmuySmOa6kOSRkNyn/93qIdevZlsMzv5AQjfYFjGYvzCdIQYRBbeb9tSoGPqUB1nod9SU0JBa9y+eMAaForw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G6xRAdiz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G6xRAdiz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52674C4CEF1;
	Tue, 16 Dec 2025 12:11:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765887072;
	bh=X2Rp/aknV+weuF4FuvRRvlnnKJwwHOmO+N3ucfa+YZw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G6xRAdizZhnH0QlQroWArGcvkaxAFLlXludA1UPrfiQv0OzzbhG/agTxVyQAD1Ook
	 Ut/ebuBR75lMJi09cpc6mZX4/jKQfsVCKGFxMWOrjc5Q9cSMEzS2d9FpVwUyv0FAnr
	 qdDdAJSlvhm+fbTCTSv8QoW2ezL1aMbtraPbmAG4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 118/614] arm64: dts: qcom: sm8650: set ufs as dma coherent
Date: Tue, 16 Dec 2025 12:08:05 +0100
Message-ID: <20251216111405.612887894@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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

From: Neil Armstrong <neil.armstrong@linaro.org>

[ Upstream commit c2703c90161b45bca5b65f362adbae02ed71fcc1 ]

The UFS device is ovbiously dma coherent like the other IOMMU devices
like usb, mmc, ... let's fix this by adding the flag.

To be sure an extensive test has been performed to be sure it's
safe, as downstream uses this flag for UFS as well.

As an experiment, I checked how the dma-coherent could impact
the UFS bandwidth, and it happens the max bandwidth on cached
write is slighly highter (up to 10%) while using less cpu time
since cache sync/flush is skipped.

Fixes: 10e024671295 ("arm64: dts: qcom: sm8650: add interconnect dependent device nodes")
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20251007-topic-sm8650-upstream-ufs-dma-coherent-v1-1-f3cfeaee04ce@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sm8650.dtsi | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/sm8650.dtsi b/arch/arm64/boot/dts/qcom/sm8650.dtsi
index ebf1971b1bfbe..3b03c13539386 100644
--- a/arch/arm64/boot/dts/qcom/sm8650.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8650.dtsi
@@ -3988,6 +3988,8 @@ &mc_virt SLAVE_EBI1 QCOM_ICC_TAG_ALWAYS>,
 
 			iommus = <&apps_smmu 0x60 0>;
 
+			dma-coherent;
+
 			lanes-per-direction = <2>;
 			qcom,ice = <&ice>;
 
-- 
2.51.0



