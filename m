Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E8A43A9017;
	Sat, 12 Sep 2026 08:31:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789201902; cv=none; b=RnxYXFGteWQ5FWj/9XjIvu3IgWmz+QSqZA3+HcV6r2WBH9kaSC0wIavhiog3QYKoYiT3z0YXexg418mrYIfS6WkmGt74ZLpnn8WF8wNqy43NFq3iHsVITgAJIVzDBCvyxvQDCgB8AieY8IfVx+ugCIz7omgLJ76Vl5qxLOorvPM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789201902; c=relaxed/simple;
	bh=brSiYexrwXzXs1piLjLDlNrKs+/3u/UjAYoXEvRJt+I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M2ZGp0Ajo7gpAOCYEo4bRmbqyOp/dZ9r4suFaMgTZ2siJoAnAyyaC43UshqZq5v+sFU4xpAaWjxIVuyQ+YEEaPuaAoZ8YwMBnLk1/6sKbjRjrkoLZXAoX4BfOU/f/BNZ27Bdz1UTU3BetKtl6HIkHis3Y/DG+KhvRVAkIND1TiM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AIEM7q1G; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AIEM7q1G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82B9C1F000FF;
	Sat, 12 Sep 2026 08:31:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789201901;
	bh=BhWo5YMJBKzRKB1/3hvjuCv+GSCjYn57olxsLXJUJD4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AIEM7q1GXXFTWaFHAxo3Qf52QEHq5mFhIHeFWOnvXRKtDIa0Q6or4p7mx0+oGzVUU
	 TiICoJJfipnELMgEN6XQSMDTs0RZ/l3zpKh7PtGahT+1pVxklqpnnUY2ex7+Qed/3P
	 srt5qvD0wqDHIBQTIu87sMfREHKiHNn7LAdmIZAc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1090/1815] arm64: dts: qcom: talos-evk: Fix swapped USB QMP PHY vdda-phy/vdda-pll supplies
Date: Sat, 12 Sep 2026 08:47:20 +0200
Message-ID: <20260912065714.609243863@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>

[ Upstream commit b426fedcef8c277574bd7beed0ae9d482c03605a ]

The QMP PHY expects the vdda-phy supply to be around 0.88V and the
vdda-pll supply to be 1.2V. But these two supplies are swapped for the
USB QMP PHY on this board, feeding 1.2V to vdda-phy and 0.9V to
vdda-pll.

Fix it by swapping the two supplies back.

Fixes: 0f9e6db8a223 ("arm64: dts: qcom: talos-evk: Add support for QCS615 talos evk board")
Reported-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Assisted-by: Claude:opus-4-8
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260803-phy-supply-fix-v1-28-5880630cde3e@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/talos-evk-som.dtsi | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/talos-evk-som.dtsi b/arch/arm64/boot/dts/qcom/talos-evk-som.dtsi
index 294354c034c37..6469c6fa9f634 100644
--- a/arch/arm64/boot/dts/qcom/talos-evk-som.dtsi
+++ b/arch/arm64/boot/dts/qcom/talos-evk-som.dtsi
@@ -589,8 +589,8 @@ &usb_qmpphy {
 };
 
 &usb_qmpphy_2 {
-	vdda-phy-supply = <&vreg_l11a>;
-	vdda-pll-supply = <&vreg_l5a>;
+	vdda-phy-supply = <&vreg_l5a>;
+	vdda-pll-supply = <&vreg_l11a>;
 
 	status = "okay";
 };
-- 
2.53.0



