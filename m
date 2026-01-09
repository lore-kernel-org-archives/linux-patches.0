Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 355BB32FA3D;
	Fri,  9 Jan 2026 11:54:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767959644; cv=none; b=IY2rtyLT/7b3dFD+9Gqmy010mDWlvb5cS4O2gJNh6gSxTqReiH1/v6jXBPUPNNWrzI9w9spolB+XrVHZE3sCYwRVRcj3OJtfNYmoMULGqXexmtSTn5/DeqXTGrsYil/hmmppELDM86JJvATF2ySQPc9AiotcTxRw/hi9AQrwIZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767959644; c=relaxed/simple;
	bh=t6lwURG1tp4QJuaNEfV7JngKIVZeaSXxZHALNvQ0R9s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NqJwD4WID7lw3ZpxAYFGmapOZL8VOYAg8wPWPZoMkaGL7iDZIta10DueflhYCl5tD2vIWQHURszsLpmMFmLM5Zuw+M/Ro/vEVJCTmQNrikQWyVCXMbTofUwbbPOII48wOA/u6FS9oTnvQRZgj/eBpLyEW+RZMdp9AFTWalyUbPs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NWiZBpwu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NWiZBpwu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B33B4C4CEF1;
	Fri,  9 Jan 2026 11:54:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767959644;
	bh=t6lwURG1tp4QJuaNEfV7JngKIVZeaSXxZHALNvQ0R9s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NWiZBpwu84zFWPySm2BMurzDivLn4K1EY8vSHEtMw9KuBfcvKpIcfZT+59GV8P6za
	 ii9a55YW178GmQkVd2OVRJ2FZFc9d8KwnwXKUS8RXQdhM8B0fFqGpxDLoI9xjOX/AU
	 7p6Gf7JEpDXTwnN9jrdcbcGHJRt69sC3qpsikJNI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Georgi Djakov <djakov@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 107/737] arm64: dts: qcom: msm8996: add interconnect paths to USB2 controller
Date: Fri,  9 Jan 2026 12:34:06 +0100
Message-ID: <20260109112138.027118056@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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

From: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>

[ Upstream commit 242f7558e7bf54cb63c06506f7b0630dd67d45a4 ]

Add the missing interconnects to the USB2 host. The Fixes tag points to
the commit which broke probing of the USB host on that platform.

Fixes: 130733a10079 ("interconnect: qcom: msm8996: Promote to core_initcall")
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Acked-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20251002-fix-msm8996-icc-v1-2-a36a05d1f869@oss.qualcomm.com
Signed-off-by: Georgi Djakov <djakov@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/msm8996.dtsi | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/msm8996.dtsi b/arch/arm64/boot/dts/qcom/msm8996.dtsi
index 70ef8c83e7b9f..473d72d2c7b1a 100644
--- a/arch/arm64/boot/dts/qcom/msm8996.dtsi
+++ b/arch/arm64/boot/dts/qcom/msm8996.dtsi
@@ -3432,6 +3432,9 @@ usb2: usb@76f8800 {
 					  <&gcc GCC_USB20_MASTER_CLK>;
 			assigned-clock-rates = <19200000>, <60000000>;
 
+			interconnects = <&pnoc MASTER_USB_HS &bimc SLAVE_EBI_CH0>,
+					<&bimc MASTER_AMPSS_M0 &pnoc SLAVE_USB_HS>;
+			interconnect-names = "usb-ddr", "apps-usb";
 			power-domains = <&gcc USB30_GDSC>;
 			qcom,select-utmi-as-pipe-clk;
 			status = "disabled";
-- 
2.51.0



