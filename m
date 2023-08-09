Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D66F14A8D
	for <patches@lists.linux.dev>; Wed,  9 Aug 2023 10:53:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13AC8C433C8;
	Wed,  9 Aug 2023 10:53:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691578382;
	bh=alakJBZQ3AwMnpt3BwoXQ8OMGlD9120zm4jmMTh174E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bqNJ3If9pxthppIM7vopAvdgqwjZTZQx18YdA6s8GdRzvv1KwMVcu0u7ccsE8V2cH
	 no9WflW1KtprHLRJh33ODRneECj22CgZwWNIKTKKidPVp3JN7qGQOB0+Xs84CRqLRT
	 OPufY/OVjHiVlFv+uvDZcp13pXRldyWA02Yclk38=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tim Harvey <tharvey@gateworks.com>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 010/127] arm64: dts: imx8mm-venice-gw7904: disable disp_blk_ctrl
Date: Wed,  9 Aug 2023 12:39:57 +0200
Message-ID: <20230809103636.976556917@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230809103636.615294317@linuxfoundation.org>
References: <20230809103636.615294317@linuxfoundation.org>
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

[ Upstream commit f7a0b57524cf811ac06257a5099f1b7c19ee7310 ]

The GW7904 does not connect the VDD_MIPI power rails thus MIPI is
disabled. However we must also disable disp_blk_ctrl as it uses the
pgc_mipi power domain and without it being disabled imx8m-blk-ctrl will
fail to probe:
imx8m-blk-ctrl 32e28000.blk-ctrl: error -ETIMEDOUT: failed to attach
power domain "mipi-dsi"
imx8m-blk-ctrl: probe of 32e28000.blk-ctrl failed with error -110

Fixes: b999bdaf0597 ("arm64: dts: imx: Add i.mx8mm Gateworks gw7904 dts support")
Signed-off-by: Tim Harvey <tharvey@gateworks.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/imx8mm-venice-gw7904.dts | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm64/boot/dts/freescale/imx8mm-venice-gw7904.dts b/arch/arm64/boot/dts/freescale/imx8mm-venice-gw7904.dts
index a67771d021464..46a07dfc0086c 100644
--- a/arch/arm64/boot/dts/freescale/imx8mm-venice-gw7904.dts
+++ b/arch/arm64/boot/dts/freescale/imx8mm-venice-gw7904.dts
@@ -617,6 +617,10 @@
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



