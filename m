Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6358223DD4;
	Sat, 12 Sep 2026 08:30:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789201811; cv=none; b=ipxge3EpXHuPBhtlxL2B2q1HweqX7gH5HQLQLEDc7H/lOwTR6HkN5nFF7OMPLNrTxxgRIkQc52/BM7xebCigDYiM/LbDFzA/HVwrzuaMmGNKSJRKjJx+GqMUiNpv5aUsfnODER140lo+BxwJU9r3O3Mz4GsDdF/DVTp1I23jqYk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789201811; c=relaxed/simple;
	bh=CC4bJ2vt1fSGyrCAU8dX/+DU1ksgEBW5fag+6udL5hY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jSE7Lr0QRzjAo06/icXuonk+oUnTQRfYPFGSfl+saycPlwlIbZlVDME1HWH1fM+nfcRcOuprFmlLsy+3sJx+kwXRA3iFXKzh8q3UPmu9NSHlrNpwbBWm8925d/lE65nhqKR8OHbqMWNbsFIQ6QiX++wvSkmGJJ9lEYBmKYgUItw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZJhv4ZHD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZJhv4ZHD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 619531F000FF;
	Sat, 12 Sep 2026 08:30:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789201810;
	bh=ooMgYIua3FfpkLKx8ERnz+wTkkf9WKURHXsxjMFxMGw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZJhv4ZHDxJzWksVmQqS9nLLVqWMTqATl8Z5jJTrCAKZSbsI4LOagT+iDUyf+x4mIH
	 d9xkmh3TVrEyzznjtW8TZZnJQJIyjucFXPT0m3Kxnv4Rfg3zpZeqIHSWgBaTXCz/xH
	 KE4SUGP+YXTGmnxSqAwGV0vrQ5K2cV3P72E+3o6s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1073/1815] arm64: dts: qcom: qcs8550-aim300: Fix swapped USB QMP PHY vdda-phy/vdda-pll supplies
Date: Sat, 12 Sep 2026 08:47:03 +0200
Message-ID: <20260912065714.211930437@linuxfoundation.org>
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

[ Upstream commit c0ea3b6339881c2a5fff0830557b1279d9681036 ]

The QMP PHY expects the vdda-phy supply to be around 0.88V and the
vdda-pll supply to be 1.2V. But these two supplies are swapped for the
USB QMP PHY on this board, feeding 1.2V to vdda-phy and 0.88V to
vdda-pll.

Fix it by swapping the two supplies back.

Fixes: 0b12da4e28d8 ("arm64: dts: qcom: add base AIM300 dtsi")
Reported-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Assisted-by: Claude:opus-4-8
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260803-phy-supply-fix-v1-11-5880630cde3e@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/qcs8550-aim300.dtsi | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/qcs8550-aim300.dtsi b/arch/arm64/boot/dts/qcom/qcs8550-aim300.dtsi
index e6ebb643203b6..ae301d78e0710 100644
--- a/arch/arm64/boot/dts/qcom/qcs8550-aim300.dtsi
+++ b/arch/arm64/boot/dts/qcom/qcs8550-aim300.dtsi
@@ -412,8 +412,8 @@ &usb_1_hsphy {
 };
 
 &usb_dp_qmpphy {
-	vdda-phy-supply = <&vreg_l3e_1p2>;
-	vdda-pll-supply = <&vreg_l3f_0p88>;
+	vdda-phy-supply = <&vreg_l3f_0p88>;
+	vdda-pll-supply = <&vreg_l3e_1p2>;
 };
 
 &xo_board {
-- 
2.53.0



