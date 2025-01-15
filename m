Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 543A918952C;
	Wed, 15 Jan 2025 10:53:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736938410; cv=none; b=cT9pRTin12zPy0dAiveg94eJa+QJb7LjQvuD5OM2MBA+RvkDCBSFmNxaxCHU8aLXMFHR6No166Q3ejOkXF8WVEIhyrTELXFr+Z5IIxMSZ18Aw23FgkqrnmXAsYgJ3f4qm6GNlH6unwBABKjcaiJoiVGlQfatGcvBmsY/1qWSSxk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736938410; c=relaxed/simple;
	bh=CqzuPQegzPc+hoyTYKzdm/njAfdW5ls22CI+2LAGkT4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AxyPxq9TxEB9BU2wGpAZ9YsZWVSkLffDGb4uGpm2F8FOibkorZDJGOaWch5dY7jBcL0SEbR9Q6ofk2lEsbyol+g0OAsziY1M6xeSEgvEwDVg6PdVnGwb7psrMcQc9Boe6y4YHiNFUe74+E/XfB0Tzy7SpZ35CFfxUn9dtZfbBjI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2A7WKGlT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2A7WKGlT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2405C4CEDF;
	Wed, 15 Jan 2025 10:53:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736938410;
	bh=CqzuPQegzPc+hoyTYKzdm/njAfdW5ls22CI+2LAGkT4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2A7WKGlTo9RMw36+iP8MxA/OxX0uvHSe5ApMfJNda83tmrSo38VkOaN7YUCyV8vza
	 s+jdRdHpPHxXdCll3Ta2wOyLsRQ7CmJctY/8wWIejsVZLMwY8HAx/de1wMPnRD2OGs
	 wa9Hukp9QXFhdwl4xIIYn3XSsd9eOoVqu/Mx83/4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wei Fang <wei.fang@nxp.com>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 175/189] arm64: dts: imx95: correct the address length of netcmix_blk_ctrl
Date: Wed, 15 Jan 2025 11:37:51 +0100
Message-ID: <20250115103613.386532590@linuxfoundation.org>
X-Mailer: git-send-email 2.48.0
In-Reply-To: <20250115103606.357764746@linuxfoundation.org>
References: <20250115103606.357764746@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wei Fang <wei.fang@nxp.com>

[ Upstream commit c5b8d2c370842e3f9a15655893d8c597e2d981d9 ]

The netc_blk_ctrl is controlled by the imx95-blk-ctl clock driver and
provides relevant clock configurations for NETC, SAI and MQS. Its address
length should be 8 bytes instead of 0x1000.

Fixes: 7764fef26ea9 ("arm64: dts: imx95: Add NETCMIX block control support")
Signed-off-by: Wei Fang <wei.fang@nxp.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/imx95.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/freescale/imx95.dtsi b/arch/arm64/boot/dts/freescale/imx95.dtsi
index 03661e76550f..40cbb071f265 100644
--- a/arch/arm64/boot/dts/freescale/imx95.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx95.dtsi
@@ -1609,7 +1609,7 @@
 
 		netcmix_blk_ctrl: syscon@4c810000 {
 			compatible = "nxp,imx95-netcmix-blk-ctrl", "syscon";
-			reg = <0x0 0x4c810000 0x0 0x10000>;
+			reg = <0x0 0x4c810000 0x0 0x8>;
 			#clock-cells = <1>;
 			clocks = <&scmi_clk IMX95_CLK_BUSNETCMIX>;
 			assigned-clocks = <&scmi_clk IMX95_CLK_BUSNETCMIX>;
-- 
2.39.5



