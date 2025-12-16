Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3864134F250;
	Tue, 16 Dec 2025 12:13:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765887230; cv=none; b=CpzGwM3nNdoARDDzuGJRlTAqokgNFInEQfKALItLH7DGnSD4hkoaVtKuqoi6uWzkdLR1q+XgD8BEin/1Kd+1aitzLhha6FT/5DO6sMAIlfUVRlQbrwzQNxxYAH2y5R0pFp1fcd7ad1G3C02u9w4dxGixKALmJQorNiGnAR+6cxs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765887230; c=relaxed/simple;
	bh=2cKg9UzWQrMZNNNkf7vewopmQWuGXo3QIXdRXuVEkrk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hWDI52SOGn++Bm/5Bt4dSuZgWvYZGQG2/cJqV+9jRKUhjPBeh9/lwZzgPbg9itkD/HQ9omnOjz+kal+vUZXCvLoAYw+X7GGGKU4HqaqvnAHai9T9zUeLXVUMCnh48RQdH+rA6sC/S9ooy+N6Y/UszXuzzETsaT9Eql6UV64TU6g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2vSGNLQ5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2vSGNLQ5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7A90C4CEF1;
	Tue, 16 Dec 2025 12:13:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765887230;
	bh=2cKg9UzWQrMZNNNkf7vewopmQWuGXo3QIXdRXuVEkrk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2vSGNLQ5fiStXe43qgk2iJxNknWRnhRfAa3abPjZKNlbk7URkjXsOQPHyff2Ud97m
	 xUPZQMze/CZxd5A9bpsIETxqhtcyNmIANb0viRSnMWLxvpLxOP9imlWFlQGHMrd/XZ
	 aq3kkuGgoOmDfKN5pN2MvfgJ7IGVKShdOIiuedF4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Georgi Djakov <djakov@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 166/614] arm64: dts: qcom: msm8996: add interconnect paths to USB2 controller
Date: Tue, 16 Dec 2025 12:08:53 +0100
Message-ID: <20251216111407.350581024@linuxfoundation.org>
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
index c75b522f6eba6..33608b1d7d060 100644
--- a/arch/arm64/boot/dts/qcom/msm8996.dtsi
+++ b/arch/arm64/boot/dts/qcom/msm8996.dtsi
@@ -3496,6 +3496,9 @@ usb2: usb@76f8800 {
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



