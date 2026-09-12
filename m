Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB7B223BD06;
	Sat, 12 Sep 2026 14:52:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789224759; cv=none; b=BKtmx6X8bA+0+yCxGlTx4V0ibcEcmgq9E3NLPxU62pltKv56ly9i9kvBMP9UA4OUndT/R9cbrqVimSogzm6jNTNJQXHCQXmJJXIGSILW+lUqoydqw3qLnbXAlHiDOvZBQ2hHlPZO73TGMZZ3DBCp4oVEaPGFEN2tHwzwU/k5Yy0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789224759; c=relaxed/simple;
	bh=352pWrm85fVl2F6Qr6EcSrIrBWrbjgJRX40LRAhkwu0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oAYKp3imOCaewyxlMp28d7NLzmeR5zQI0pfLMhM/33ul7l3bql+e7imhk/MIh5VOWAKAZmpCb08xmLonoTBBeZ3IoI0OVONSy7Un9W0NsUJJQrKwkm2HL0Snz8IipOkx3E4065hYdft3xcbOvqJPg5A2ug3vkNJL1MOm+p9GhAc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ABhE00vu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ABhE00vu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D84A71F000FF;
	Sat, 12 Sep 2026 14:52:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789224758;
	bh=TP3BcN43afxbja3l6dU0m9CrqrieiIb+9cmVKSXdtac=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ABhE00vumBjkbX6GWhiQgIzBdUwcUp9O+uaRkVV4fOFgjgGLbnTKsws4Cxc10v1bD
	 sVF7fSihGN/6hBS3sheqXk6v0jtM7Fe7wRjJsalMaquUpjL2KYD0WbNNN22Qxtmu4f
	 qe7fPC2pQE50g4a5CeXEWcu7HQJWWwYOIVgOIFtI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
	Luca Weiss <luca.weiss@fairphone.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1060/1424] arm64: dts: qcom: sm7225-fairphone-fp4: Fix swapped USB QMP PHY vdda-phy/vdda-pll supplies
Date: Sat, 12 Sep 2026 08:58:12 +0200
Message-ID: <20260912065631.044315429@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

From: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>

[ Upstream commit a3b3a060b696d964c769a7d9dc5835c79e4fe964 ]

The QMP PHY expects the vdda-phy supply to be around 0.88V and the
vdda-pll supply to be 1.2V. But these two supplies are swapped for the
USB QMP PHY on this board, feeding 1.2V to vdda-phy and 0.9V to
vdda-pll.

Fix it by swapping the two supplies back.

Fixes: 4cbea668767d ("arm64: dts: qcom: sm7225: Add device tree for Fairphone 4")
Reported-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Assisted-by: Claude:opus-4-8
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
Reviewed-by: Luca Weiss <luca.weiss@fairphone.com>
Link: https://lore.kernel.org/r/20260803-phy-supply-fix-v1-14-5880630cde3e@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sm7225-fairphone-fp4.dts | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sm7225-fairphone-fp4.dts b/arch/arm64/boot/dts/qcom/sm7225-fairphone-fp4.dts
index d05e6f6cd1702..2c6f37864a5de 100644
--- a/arch/arm64/boot/dts/qcom/sm7225-fairphone-fp4.dts
+++ b/arch/arm64/boot/dts/qcom/sm7225-fairphone-fp4.dts
@@ -710,8 +710,8 @@ &usb_1_hsphy {
 };
 
 &usb_1_qmpphy {
-	vdda-phy-supply = <&vreg_l22a>;
-	vdda-pll-supply = <&vreg_l16a>;
+	vdda-phy-supply = <&vreg_l16a>;
+	vdda-pll-supply = <&vreg_l22a>;
 
 	status = "okay";
 };
-- 
2.53.0



