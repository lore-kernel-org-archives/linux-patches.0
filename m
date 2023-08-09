Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48A39125D5
	for <patches@lists.linux.dev>; Wed,  9 Aug 2023 10:44:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2436C433C9;
	Wed,  9 Aug 2023 10:44:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691577898;
	bh=1rkQX5lhEFSUurPfbpiqpu3sgvQc6cshAdfE1M4feso=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QXlP9/x2dUwpHCBH5Dpcirb4ab1RCxGGJ6kF9+LADYGOrxbHU9E62QeZ71+QLHnW1
	 oD2eZzwnkQL4buKPPTn2HI8Xt4aznuemdzlTcAu7gC1/T/ogG3Hg/8OPAzh2qHokua
	 13hlDYSC5fpOagLKgTMaTZeJ557YxTIBWF9brt7o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tim Harvey <tharvey@gateworks.com>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 006/165] arm64: dts: imx8mm-venice-gw7903: disable disp_blk_ctrl
Date: Wed,  9 Aug 2023 12:38:57 +0200
Message-ID: <20230809103642.966660364@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230809103642.720851262@linuxfoundation.org>
References: <20230809103642.720851262@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Tim Harvey <tharvey@gateworks.com>

[ Upstream commit 3e7d3c5e13b05dda9db92d98803a626378e75438 ]

The GW7903 does not connect the VDD_MIPI power rails thus MIPI is
disabled. However we must also disable disp_blk_ctrl as it uses the
pgc_mipi power domain and without it being disabled imx8m-blk-ctrl will
fail to probe:
imx8m-blk-ctrl 32e28000.blk-ctrl: error -ETIMEDOUT: failed to attach power domain "mipi-dsi"
imx8m-blk-ctrl: probe of 32e28000.blk-ctrl failed with error -110

Fixes: a72ba91e5bc7 ("arm64: dts: imx: Add i.mx8mm Gateworks gw7903 dts support")
Signed-off-by: Tim Harvey <tharvey@gateworks.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/imx8mm-venice-gw7903.dts | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm64/boot/dts/freescale/imx8mm-venice-gw7903.dts b/arch/arm64/boot/dts/freescale/imx8mm-venice-gw7903.dts
index 363020a08c9b8..4660d086cb099 100644
--- a/arch/arm64/boot/dts/freescale/imx8mm-venice-gw7903.dts
+++ b/arch/arm64/boot/dts/freescale/imx8mm-venice-gw7903.dts
@@ -567,6 +567,10 @@
 	status = "okay";
 };
 
+&disp_blk_ctrl {
+	status = "disabled";
+};
+
 &pgc_mipi {
 	status = "disabled";
 };
-- 
2.40.1



