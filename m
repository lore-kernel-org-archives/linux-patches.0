Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E6B2341048;
	Tue, 16 Dec 2025 11:20:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765884040; cv=none; b=L9/G4TnhZRa9gNTrG7uA4VXMViUxOCmwWoClvWFnz2ULQG1o9mLRAiFq8UfHFIc1cIFbRCBrKy8n9UvUCQ1al9vsGrpZOA9LzRhM/xiJYzKz0kFY1JuPFkf46Xkcld8DlG57md8HsuLm8QTP5AMoZLPk8hCHtJlsCFeQBSGuHDc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765884040; c=relaxed/simple;
	bh=4dZRL/SsFjM/OLLdIo8sNixgt4QqN9FWx8I/w7UA4Qk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bA42BIjO6j9l8+hdhofqRgF/kUY8dCCmfDVtAROwT8Z6BF31QxCRlIlUnqexATB9+vEkgPnWlWZCVFI9fxGQ+zK+018OobiA5Eu2qnpZnRhDzMzJFZmMvrHbC7dCs2Uw7G5CgrKXjYR3VaaidpBXcLYxRyv/9QHZtQrX88eXcJU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1xbCF1AY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1xbCF1AY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9721C4CEF1;
	Tue, 16 Dec 2025 11:20:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765884040;
	bh=4dZRL/SsFjM/OLLdIo8sNixgt4QqN9FWx8I/w7UA4Qk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1xbCF1AY8PBcvvG0F5juAZ72fTpSK7jLqRovLjsG6CfobdN3FxMmNWGxbAf/0mIxl
	 vbaTdnFEYxrm9dwnEcgJYIVSA3+TxCucGCxjHCc+viAssJthEGIQDgbHnyWcpNFxpy
	 SdE5Ryt6GPMiwhxCBV9FwXPiUIys7y01P78G7jz8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 075/354] arm64: dts: qcom: sm8650: set ufs as dma coherent
Date: Tue, 16 Dec 2025 12:10:42 +0100
Message-ID: <20251216111323.640954690@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111320.896758933@linuxfoundation.org>
References: <20251216111320.896758933@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index bd91624bd3bfc..6763c750f6801 100644
--- a/arch/arm64/boot/dts/qcom/sm8650.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8650.dtsi
@@ -2590,6 +2590,8 @@ &mc_virt SLAVE_EBI1 QCOM_ICC_TAG_ALWAYS>,
 
 			iommus = <&apps_smmu 0x60 0>;
 
+			dma-coherent;
+
 			lanes-per-direction = <2>;
 			qcom,ice = <&ice>;
 
-- 
2.51.0



