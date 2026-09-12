Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BFC3381B0F;
	Sat, 12 Sep 2026 08:31:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789201897; cv=none; b=RUSJ69kehTORHUSpTr3vNtzNKTvDte0eUkJxcME6/ZRn3vBbJj3dnRBT3cFrHov5OFgmUK1Bnc2l+ZKiSwzwp/ogmclV4M5IO6zh/kA6bRj79Pqc3W9PkOSfms2rgP7IKLTQTmQAuyU0/NKnsQ4A8P6k7Pyp/reAODQQhkmskxA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789201897; c=relaxed/simple;
	bh=LPFnZG4IFP6wR3KCGrV7M17upt8yvxKx6gMu+ZSwRVg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P1rn3HQyN2aXqSlS4nH4h5b5q9UckJa8lZ2/0skSuyW0kAw6jsd+2iKOrG9cWrih4M39JOsvidRLtQEv0eQ7y2UvjSMBBQW4cAtld8BsPWXqg/YtckljgrK7JvFpoc+i43tk4UzPJnZmpWkDmApeJhMJfPpsIein58JjO9BWmrE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f4OJ90zz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f4OJ90zz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B24D51F000FF;
	Sat, 12 Sep 2026 08:31:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789201896;
	bh=NHFnBm3u1lqSdMSeNgmtABFBEecR54wZZZTdO0nug6A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=f4OJ90zzdebtC+zQ/Kqco5dU42bhhzZg183CpSppeaU1iT4w/UUJuvaXIXOrQ47Oj
	 DbNTm028rdc6As9dYIZ1ZplEIPwPQsHjTzVqPTNi6F/ivpfbBk+hd8r5pjDb4H3Tnt
	 suhABM6R1glJIbyDnPYssO6zJRJ4k4nNP999RsrM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1089/1815] arm64: dts: qcom: sa8155p-adp: Fix swapped USB and UFS QMP PHY vdda-phy/vdda-pll supplies
Date: Sat, 12 Sep 2026 08:47:19 +0200
Message-ID: <20260912065714.586063800@linuxfoundation.org>
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

[ Upstream commit 3b50c16faa8452fd7ff021919c669c7b38227ca4 ]

The QMP PHY expects the vdda-phy supply to be around 0.88V and the
vdda-pll supply to be 1.2V. But these two supplies are swapped for the
USB and UFS QMP PHYs on this board, feeding 1.2V to vdda-phy and 0.9V to
vdda-pll.

Fix it by swapping the two supplies back.

Fixes: 12dd4ebda47a ("arm64: dts: qcom: Fix usb entries for SA8155p adp board")
Fixes: 5b85e8f2225c ("arm64: dts: qcom: sa8155p-adp: Add base dts file")
Reported-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Assisted-by: Claude:opus-4-8
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260803-phy-supply-fix-v1-27-5880630cde3e@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sa8155p-adp.dts | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sa8155p-adp.dts b/arch/arm64/boot/dts/qcom/sa8155p-adp.dts
index 388d5ecee9497..3e22ee8b50924 100644
--- a/arch/arm64/boot/dts/qcom/sa8155p-adp.dts
+++ b/arch/arm64/boot/dts/qcom/sa8155p-adp.dts
@@ -428,8 +428,8 @@ &ufs_mem_hc {
 &ufs_mem_phy {
 	status = "okay";
 
-	vdda-phy-supply = <&vreg_l8c_1p2>;
-	vdda-pll-supply = <&vreg_l5a_0p88>;
+	vdda-phy-supply = <&vreg_l5a_0p88>;
+	vdda-pll-supply = <&vreg_l8c_1p2>;
 };
 
 &usb_1 {
@@ -474,8 +474,8 @@ &usb_2_hsphy {
 
 &usb_2_qmpphy {
 	status = "okay";
-	vdda-phy-supply = <&vreg_l8c_1p2>;
-	vdda-pll-supply = <&vdda_usb_ss_dp_core_1>;
+	vdda-phy-supply = <&vdda_usb_ss_dp_core_1>;
+	vdda-pll-supply = <&vreg_l8c_1p2>;
 };
 
 &pcie0 {
-- 
2.53.0



