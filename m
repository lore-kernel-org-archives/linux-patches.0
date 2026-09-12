Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 417F0432304;
	Sat, 12 Sep 2026 10:42:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789209760; cv=none; b=cpneFbt8F2h40Rfv2lBr+MG+pj+38zp5hY7w7EP+iE7rpJDG1LbMnpDiV2Tl+EEUTaAGA7D1cey3X/PeAloXD0CaWeeDjCCrjHuILU6Rs3tK2okPnEI76Nsy4HCHN8i7TGcU5SFlFUvf6oGqnxvgkqCR/pPk4cApoLm72wiYFiY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789209760; c=relaxed/simple;
	bh=g6PgE9Tu+H6MO3DielnYjqeVod/a/Y8ppaND8MSKj/E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QgPi4ProO2Htz6/byd7wcNpbLnAv2sbWHUPrfV4RZ2sNlbLsCaAGlZZzjsB3BXAywNKfuUjI9tvPdOeJshme7wNZ2gkG8b3frLI7h3dlk26ztM1Y+rPi/Kv1YlurEAXmIW4F5m9oGmbRmzLyIBe0DcUldCciuyAZUaHWqUEG4Wk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xAcQQ0sk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xAcQQ0sk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BE481F00893;
	Sat, 12 Sep 2026 10:42:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789209755;
	bh=6DkprZIpePdq9bCW4pYXIUdqw+FfFDsaufrfaq3Iouo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xAcQQ0skihTcqvVWYGycnpI2mAmXjS+86lYAwCsMB5mL9McFmHcafDzr/Beqbsnz0
	 m5SFXT01s/LmPBIMrglEIGbvADPsswcRAbX4sAjyiB/SX4g8DB3uTkpCWfM6vBr844
	 avOxKfjRyK5ByFI/QiMrnOz0O/0+Cnjgr3aAxfWk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0887/1518] arm64: dts: qcom: sar2130p: Fix swapped USB QMP PHY vdda-phy/vdda-pll supplies
Date: Sat, 12 Sep 2026 08:50:56 +0200
Message-ID: <20260912065643.514438029@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

From: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>

[ Upstream commit 9d883d21fc12c873eee2f864f706c38a289bef59 ]

The QMP PHY expects the vdda-phy supply to be around 0.88V and the
vdda-pll supply to be 1.2V. But these two supplies are swapped for the
USB QMP PHY on this board, feeding 1.2V to vdda-phy and 0.9V to
vdda-pll.

Fix it by swapping the two supplies back.

Fixes: 6339e41fa39b ("arm64: dts: qcom: sar2130p: add QAR2130P board file")
Reported-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Assisted-by: Claude:opus-4-8
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260803-phy-supply-fix-v1-22-5880630cde3e@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sar2130p-qar2130p.dts | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sar2130p-qar2130p.dts b/arch/arm64/boot/dts/qcom/sar2130p-qar2130p.dts
index 74778a5b19ba6..80428c0b3b4e6 100644
--- a/arch/arm64/boot/dts/qcom/sar2130p-qar2130p.dts
+++ b/arch/arm64/boot/dts/qcom/sar2130p-qar2130p.dts
@@ -551,8 +551,8 @@ &usb_1_hsphy {
 };
 
 &usb_dp_qmpphy {
-	vdda-phy-supply = <&vreg_l3a_1p2>;
-	vdda-pll-supply = <&vreg_l1a_0p91>;
+	vdda-phy-supply = <&vreg_l1a_0p91>;
+	vdda-pll-supply = <&vreg_l3a_1p2>;
 
 	status = "okay";
 };
-- 
2.53.0



