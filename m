Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E7053F86FB;
	Wed, 20 May 2026 18:12:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779300726; cv=none; b=KmvN09jl/dP+C52jMlYN5fqucYyI0rtiIJcMJowqTHAH1L16VAnGDX/jRVM2La6psqNlidrUJTMGRN5DwRbd1xXokO+poqpp1JIvWsvR/SrUDlR1AEl+TQTKSjUWWneut4z5kiTft6hj2/WoU8cijEnEdTSIzUvTHz8XMC7+fXw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779300726; c=relaxed/simple;
	bh=8CDxzGNpRBYBTKqj6wGpMm5YguJ0ESJ6CfB5AWvxZr8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BySLAXbvL6znER/gbecWq2+XiIo4ioub4q3nJ7VZ6KK3AMB78xASxDiRd6mgdpIDEJfJEpP/rdEOCp1ppdxWQw/4SQqfabNdM8f1jgq+A7s6EWtALQKlOGnepziuoNZiG1MrpgYkaNLF2vjEQHBtEpgn51enaKFoBKQWX0PGSh8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=APhIiSjf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="APhIiSjf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A52781F000E9;
	Wed, 20 May 2026 18:12:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779300725;
	bh=sqC55/Ol1iX0U7qatJH4p4tTNg1unzFViyKqKRmd/AA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=APhIiSjfC9VXD52DtVJU8itg2IEfShjBvtn40+JYXpopApEJYfkQEIOMDLYMC7fh1
	 s2+uXKWz5plm6qyDd/VtmF/yObY6P9mVft+198h1aPENvGGg0r8BM06dvQ2fx40Jq6
	 M9zTsEEveroBaOSNK1x1N4wS+0D9aqboRZF5BRgI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Abel Vesa <abel.vesa@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 283/666] arm64: dts: qcom: sm8450: Fix GIC_ITS range length
Date: Wed, 20 May 2026 18:18:14 +0200
Message-ID: <20260520162117.349626990@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162111.222830634@linuxfoundation.org>
References: <20260520162111.222830634@linuxfoundation.org>
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

From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>

[ Upstream commit 14044fa192c50265bc1f636108371044bbdcf7b7 ]

Currently, the GITS_SGIR register is cut off. Fix it up.

Fixes: fc8b0b9b630d ("arm64: dts: qcom: sm8450 add ITS device tree node")
Signed-off-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Reviewed-by: Abel Vesa <abel.vesa@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260317-topic-its_range_fixup-v1-3-49be8076adb1@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sm8450.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/sm8450.dtsi b/arch/arm64/boot/dts/qcom/sm8450.dtsi
index 58ed68f534e50..cfa880c577a40 100644
--- a/arch/arm64/boot/dts/qcom/sm8450.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8450.dtsi
@@ -4274,7 +4274,7 @@ intc: interrupt-controller@17100000 {
 
 			gic_its: msi-controller@17140000 {
 				compatible = "arm,gic-v3-its";
-				reg = <0x0 0x17140000 0x0 0x20000>;
+				reg = <0x0 0x17140000 0x0 0x40000>;
 				msi-controller;
 				#msi-cells = <1>;
 			};
-- 
2.53.0



