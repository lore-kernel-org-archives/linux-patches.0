Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B3E0345EA7;
	Sat, 12 Sep 2026 16:57:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789232246; cv=none; b=nKV7lSvfNGbH55037IKaOt+IUkNmbUDd4te8j5L9q4bHn15uklGptmH7wAjdrmPqdkwi7IcYPZkIPQ5g5DJtnOrJKwcblf/5wbL+5KTzbsv4t0+0v3VpVrIQjzpHqBOYYx8niSWi4wJMU8NE596fVGV9m+PnJGCWDmVzSADyXTo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789232246; c=relaxed/simple;
	bh=3Bq5sc6KGSx16hmm20IoPq4xJ7+qIS//+YFfVpmRdtA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lUXpKaBpgHcpDdON0x/huWE/7D1+bqfRAZ08RZ4IJ6h+R9zIfDMuYCiovJooEiYaEJraOGMPLCmqxbY5HXUCcqKK80VW+usal7LvXyCDvEoqE+RWt7owiO/hEKU658YgI202h4WCX4Ra4LDLOUODzad+LSksD2bMselMLlZY1BY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qNOh37Wg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qNOh37Wg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 730821F000FF;
	Sat, 12 Sep 2026 16:57:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789232244;
	bh=ZGrPs2E1MgwvFtHONumZZ0jo6bxQJQ9nQOo0AvS6S80=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qNOh37WgV2PXmf13etMaukkmx71FCkb3Q2NP/Oxx+YqHaZ4us2dJvCXFyJ5GTKPjp
	 ppmcDmd7piwgqyjvqA0PA0iY9LlhA62tDhwfaFsqHY19+GatT2nRDPzH3m7wWLiZnF
	 bmy/rDA0tKB2RBNfS5ZtmMd3VaqQDFSPYN8hNfXI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Abel Vesa <abel.vesa@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1164/1191] arm64: dts: qcom: sm8550: Fix GIC_ITS range length
Date: Sat, 12 Sep 2026 09:04:52 +0200
Message-ID: <20260912065614.285706883@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>

[ Upstream commit 357c559e386705609b6b9dc0544c420e3f91f3a0 ]

Currently, the GITS_SGIR register is cut off. Fix it up.

Fixes: ffc50b2d3828 ("arm64: dts: qcom: Add base SM8550 dtsi")
Signed-off-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Reviewed-by: Abel Vesa <abel.vesa@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260317-topic-its_range_fixup-v1-4-49be8076adb1@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sm8550.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/sm8550.dtsi b/arch/arm64/boot/dts/qcom/sm8550.dtsi
index 99439d3f09737..aa9c25541e900 100644
--- a/arch/arm64/boot/dts/qcom/sm8550.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8550.dtsi
@@ -2470,7 +2470,7 @@ intc: interrupt-controller@17100000 {
 
 			gic_its: msi-controller@17140000 {
 				compatible = "arm,gic-v3-its";
-				reg = <0 0x17140000 0 0x20000>;
+				reg = <0 0x17140000 0 0x40000>;
 				msi-controller;
 				#msi-cells = <1>;
 			};
-- 
2.53.0



