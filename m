Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9B9146AA82;
	Tue, 21 Jul 2026 15:40:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784648414; cv=none; b=F3n0ltEs47hyjWDekwJ0PW9SaM1DI++6DIFoScMvkNQp3PZH/Lflm3O6m7uPvyivsNgakf5Mv6Fy5TN8MMk3YkZmOiOF2AycG0eShosEqA6NBv6qa4H7xV6cZGtvYjVJoNCOMYe4zgLgfGYf8UZuxoIskTvVhJTRkP3s4A2viBQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784648414; c=relaxed/simple;
	bh=rQ4ILOxWvpP45V1EuZ5pvUyANQvX6noHKX/AudrLMec=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XRKsmjGOTzdUQDDD5F1o3nn48yQsVv6kXjob/g0Rg64XmP8l2CgWB3jRiIO0rNglbTsoUdMehj7W2loxJphgCzub7MsmOwWoPx2T5gCc3yR2CgyyBqtURLmDxFOnRADtKbP8Tx701Pix9FQLWIaywbUWtmmANff/IYm4AH/P/g8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rMHK+/Ig; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rMHK+/Ig"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C7721F000E9;
	Tue, 21 Jul 2026 15:40:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784648412;
	bh=SSwfVF8mpoZihYx/MhKKNyNDNOpCuAK64YqaAhzew1Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rMHK+/Igmfy/mHuEKNFIVoA/09RsZSAYj5GMDzwT4NUsl8Vop4AQrmWcew1SLSEcD
	 d2PkMu40QEzE5rcjgfmSy8gJmKK/MaJBsW6zv25mBRGv/ycs3yWBwp6U2DLhFYlh8O
	 bIoMebQArP7MkLOiPFDnTX9VAXapdKIx+sRKsPY8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abel Vesa <abel.vesa@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0191/2077] arm64: dts: qcom: glymur: Mark USB SS1 and SS2 as role-switch capable
Date: Tue, 21 Jul 2026 16:57:44 +0200
Message-ID: <20260721152557.189808453@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Abel Vesa <abel.vesa@oss.qualcomm.com>

[ Upstream commit 347fa2fa64e1cef0c7897522896c0c66e734c82b ]

Like USB SS0, the USB SS1 and SS2 controllers on Glymur also support
USB role switching.

Describe this by adding the 'usb-role-switch' property to both controllers.

Fixes: 4eee57dd4df9 ("arm64: dts: qcom: glymur: Add USB related nodes")
Signed-off-by: Abel Vesa <abel.vesa@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260415-dts-qcom-glymur-usb-role-switch-fix-v1-1-409e1a257f1f@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/glymur.dtsi | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/glymur.dtsi b/arch/arm64/boot/dts/qcom/glymur.dtsi
index 7283d45ca259a8..780708a9d8d45f 100644
--- a/arch/arm64/boot/dts/qcom/glymur.dtsi
+++ b/arch/arm64/boot/dts/qcom/glymur.dtsi
@@ -3920,6 +3920,8 @@ usb_1: usb@a800000 {
 			snps,dis_u2_susphy_quirk;
 			snps,dis_enblslpm_quirk;
 
+			usb-role-switch;
+
 			status = "disabled";
 
 			ports {
@@ -3993,6 +3995,8 @@ usb_2: usb@a000000 {
 			snps,dis_u2_susphy_quirk;
 			snps,dis_enblslpm_quirk;
 
+			usb-role-switch;
+
 			status = "disabled";
 
 			ports {
-- 
2.53.0



