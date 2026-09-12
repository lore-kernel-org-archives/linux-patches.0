Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1321373BE6;
	Sat, 12 Sep 2026 08:31:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789201872; cv=none; b=FXy9sFfYJP0zapE3L3rJRnwTmbM/5wGYl0/pNaE/66QWcfTaaZZHl/y/wRvJpiJvr4aIOq8tGsTVFz+lW1M2dlJfJQ3/aKE1XLmEI2DaAyYAOt974kEwvdoozVZhL9uiVpy/dPRikYZK49vwsIzyzkbQYdS2bRk52oKe3ed6KPU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789201872; c=relaxed/simple;
	bh=tKjwK2/FKePdceO2pJoyuyuQjg6Qdb2uHcZvULnasN4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IxsPjx0sUykuE0YwvMY4t1kYXrgcBNQk5P/F9+z5yukkzSX7m3UJspwpuX64mpkKUhaYP5Wwb18zdBFfqTHouV+Kj2L0uiupWx4dpJhkv2k+Qgwo4kZTT9DnCJR11+Xs8eYmZOygepeTHCxEd2uVUwrL/wgf/+9rvZXvgZAmEVM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jBtVU/Dm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jBtVU/Dm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC4D01F000FF;
	Sat, 12 Sep 2026 08:31:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789201871;
	bh=audzNQHMORiF2pf8DsVy03p7PqW/46WYBe876lmseTQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jBtVU/Dmy1uhV23XlVYQ4FdF8qeQ5hS9KFsEchLP7UcJ9FvAy+aOiw3LNW3jehHe0
	 sMrCSXymOJ4b59Cx6fMab92rDw1nRZudf1e2Va77umeaxMkUDqaFqzSouNCsjoHy8p
	 MD8guJlJgYTORvS8mU9hwzjPG2ISXdkDPKoLo+f4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1085/1815] arm64: dts: qcom: kaanapali: Fix swapped USB QMP PHY vdda-phy/vdda-pll supplies
Date: Sat, 12 Sep 2026 08:47:15 +0200
Message-ID: <20260912065714.493217230@linuxfoundation.org>
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

[ Upstream commit c1dfdea72a9f59b1bdad64b8ec9f918b6c1a721f ]

The QMP PHY expects the vdda-phy supply to be around 0.88V and the
vdda-pll supply to be 1.2V. But these two supplies are swapped for the
USB QMP PHYs on these boards, feeding 1.2V to vdda-phy and 0.88V to
vdda-pll.

Fix it by swapping the two supplies back.

Fixes: b2f036a67580 ("arm64: dts: qcom: kaanpaali: Add USB support for MTP platform")
Fixes: 01d15f5f6996 ("arm64: dts: qcom: kaanpaali: Add USB support for QRD platform")
Reported-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Assisted-by: Claude:opus-4-8
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260803-phy-supply-fix-v1-23-5880630cde3e@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/kaanapali-mtp.dts | 4 ++--
 arch/arm64/boot/dts/qcom/kaanapali-qrd.dts | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/kaanapali-mtp.dts b/arch/arm64/boot/dts/qcom/kaanapali-mtp.dts
index f9b5b5718b904..2c1ae40dc7ec9 100644
--- a/arch/arm64/boot/dts/qcom/kaanapali-mtp.dts
+++ b/arch/arm64/boot/dts/qcom/kaanapali-mtp.dts
@@ -1343,8 +1343,8 @@ &usb_hsphy {
 };
 
 &usb_dp_qmpphy {
-	vdda-phy-supply = <&vreg_l1d_1p2>;
-	vdda-pll-supply = <&vreg_l4f_0p8>;
+	vdda-phy-supply = <&vreg_l4f_0p8>;
+	vdda-pll-supply = <&vreg_l1d_1p2>;
 
 	status = "okay";
 };
diff --git a/arch/arm64/boot/dts/qcom/kaanapali-qrd.dts b/arch/arm64/boot/dts/qcom/kaanapali-qrd.dts
index 55d02219ef4e9..28779698221d2 100644
--- a/arch/arm64/boot/dts/qcom/kaanapali-qrd.dts
+++ b/arch/arm64/boot/dts/qcom/kaanapali-qrd.dts
@@ -838,8 +838,8 @@ &usb_hsphy {
 };
 
 &usb_dp_qmpphy {
-	vdda-phy-supply = <&vreg_l1d_1p2>;
-	vdda-pll-supply = <&vreg_l4f_0p8>;
+	vdda-phy-supply = <&vreg_l4f_0p8>;
+	vdda-pll-supply = <&vreg_l1d_1p2>;
 
 	status = "okay";
 };
-- 
2.53.0



