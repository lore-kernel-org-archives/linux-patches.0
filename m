Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B34E437F729;
	Sat, 12 Sep 2026 07:10:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789197048; cv=none; b=D+Zu7IACqdAON/rRelsRTZUttjDyRDhZTtIGTViIGy3k0ZyNFebUfxclEyYpQr+M8Y4zX8CVB46y9KMPkyQvA+NTT7R2AqiE+Na81yr4ocDGXXYeD+wh6vBFnsYclW52uT5OTs8H7+pHxsxq2WA8N+d0T7GvjWrZ7H8C2Juu1Q4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789197048; c=relaxed/simple;
	bh=N1DLbBrBLQbTD9rkij29PfZQZA7iYI9c338UO/IQNWk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VcWWmxuQRVSCGYwE2bnNuqzLo3unRNMczLVBnWG9az/yEjQl229ctbu5/V1RCzpknU9+zE+9S76/UNPFe+/HKQrUFkKbDQtu5V8VTwLHEOlQveF+LZKW/YLc2DrxeaEoiT+5UoSUv/cAesjKcOufEKyD2WxzLfs2fRZRs3U5OGo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qyi0Bguo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qyi0Bguo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B70891F000FF;
	Sat, 12 Sep 2026 07:10:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789197047;
	bh=yLJTBmnjkCh6+r+oaSLpQbLFYnzc5+YhCpJTsu0W5Hs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qyi0BguoQwCOSeCiHDlYTftt9vNT2ixFwazDZgbJ/uCM9zs0DphgXi/7CNtrrjViV
	 2spG8nfFJXfiVWsFoxu/5dwzuR2Xq2lOrBbBdtbp8FwM3lz4IE/++NVoqI9wM+Uyth
	 ySu6Os33ZpWsi/wu1kTOuDZSy2u2Jyl4VbTOVd1I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Frank Li <Frank.Li@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0088/1815] arm64: dts: imx8mp-frdm: Add missing HDMI DDC pinctrl
Date: Sat, 12 Sep 2026 08:30:38 +0200
Message-ID: <20260912065651.072579910@linuxfoundation.org>
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

From: Philipp Zabel <p.zabel@pengutronix.de>

[ Upstream commit c33b03ac7ff7ca0267ae7a4284a2b9258483614d ]

Configure HDMI DDC SCL/SDA pins to support reading EDID.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
Fixes: 95d7d7d2ad27 ("arm64: dts: imx8mp-frdm: add sd, ethernet, wifi, usb and hdmi support")
Signed-off-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/imx8mp-frdm.dts | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/boot/dts/freescale/imx8mp-frdm.dts b/arch/arm64/boot/dts/freescale/imx8mp-frdm.dts
index 5fb9714215bfe..f43330d1ff8b6 100644
--- a/arch/arm64/boot/dts/freescale/imx8mp-frdm.dts
+++ b/arch/arm64/boot/dts/freescale/imx8mp-frdm.dts
@@ -562,6 +562,8 @@ MX8MP_IOMUXC_SAI1_RXD0__GPIO4_IO02		0x10
 
 	pinctrl_hdmi: hdmigrp {
 		fsl,pins = <
+			MX8MP_IOMUXC_HDMI_DDC_SCL__HDMIMIX_HDMI_SCL	0x1c2
+			MX8MP_IOMUXC_HDMI_DDC_SDA__HDMIMIX_HDMI_SDA	0x1c2
 			MX8MP_IOMUXC_HDMI_CEC__HDMIMIX_HDMI_CEC		0x10
 		>;
 	};
-- 
2.53.0



