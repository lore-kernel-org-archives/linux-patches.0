Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41836341069;
	Tue, 16 Dec 2025 11:22:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765884127; cv=none; b=SfgAc8fer/PvqNu6a+2pLesQaXB+VFATq9qkndvtpbYx5rOsaTCvMO7qI2ML9YulwRGxUdUU2f2BlkSCNZP4uAypo45RWDlL/t9BcU+CFpGWqOythKFv/LPOVThLTDjtAfgZLGl5XAdJ1xY+9xXqwqXmhnclH6LVlNC038moD1c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765884127; c=relaxed/simple;
	bh=IT/z3bc3Z9z4S4KLm082v3ab4J/LVhn/L2DphjBDZRQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gXVPobNhYKVmq9OWdSPyVqTdNjW4ywba3l0S8ej+ifq5siCsJU0XGZ9a+McHN0ujGI875qG3vmMS/yzUzXO7KVriKqRiunoBNKAVskEihouDYfC0E35dkQpC+3CS/K/pQWAY9v0XhwIgN7MKe2GngcuaLjvXK2+b1/5jFdpkynQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vGIgVBKp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vGIgVBKp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACD32C4CEF1;
	Tue, 16 Dec 2025 11:22:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765884127;
	bh=IT/z3bc3Z9z4S4KLm082v3ab4J/LVhn/L2DphjBDZRQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vGIgVBKp05wXmF10DT2Bzcej7sQD3hv0UaQMRyBM3ZFSUttSHNxk3a01WdNkrmFHK
	 gXJfAzOpbEu9XY08y03L+wWlzuJDLqNfsP+j5wMwmzk73Nltp479kMWEX37EgXgU0d
	 7lCWO6ZDQ14ZmdgBFPjicYrP5s3qcyLC1vHREzcM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Georgi Djakov <djakov@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 098/354] arm64: dts: qcom: msm8996: add interconnect paths to USB2 controller
Date: Tue, 16 Dec 2025 12:11:05 +0100
Message-ID: <20251216111324.471946454@linuxfoundation.org>
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
index 0a8884145865d..932994f65b250 100644
--- a/arch/arm64/boot/dts/qcom/msm8996.dtsi
+++ b/arch/arm64/boot/dts/qcom/msm8996.dtsi
@@ -3449,6 +3449,9 @@ usb2: usb@76f8800 {
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



