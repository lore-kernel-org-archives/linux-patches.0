Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AFDE3A4526;
	Wed, 20 May 2026 16:49:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779295757; cv=none; b=r6zuiBceLHbyWrqx8rUvTGsMo8vHEjRCluEVeHkeGspFkVqnJG/Kp9JXIdzM07TBn3REA0g9mYorzkqTmvZeI0VftlLOQ1RadIMQeGpbcqsJz/KwZ+7qARhgGnLioxWYoT89xcab8bmmpOuoPwr3Utg2noRd+zcaUIVBdDxosDU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779295757; c=relaxed/simple;
	bh=/jCplC8oKKKzOhpnzo86HEECaVbOeSXkfqq0xfNcMjk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YXGLHYp7p9y5fO5jyaT6oGUS6D9ZPJPS4iFI1WOvaA1DXKnWCVieWtSVf8CB6RsGb9w8eEEOjvpEJzmST2D/gWM9dDKvLh7O0B4sbQt2KS9puFE+7byt4ZvOanZc3EMjcKU7Vmn3flcUlB4CZNX2ElkjMRkM88uxgQQhWQ5DGGs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vPh6u72V; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vPh6u72V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 804D61F00894;
	Wed, 20 May 2026 16:49:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779295756;
	bh=yjyFUOpkXK5rpAf8o9VSNTJikFy0bhA2gC5j+LMd7dY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vPh6u72VSUDnC6kskZnLCjjNd41E9BDn/2RaToPk6Y0CowpZNq1OI+CDpK4WVR4gJ
	 1Ql/Ro6/UD2KckLA8/5XWsnSEkbeOP/jPC5rMSZSEP1MC24/pLoqxJwyF9tWt6H1iN
	 5skhl6Vd5r7+ql9KMA8KMQlGzpuLjX0iK/4cK2Uo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liu Ying <victor.liu@nxp.com>,
	Frank Li <Frank.Li@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0540/1146] arm64: dts: imx8mp-evk: Specify ADV7535 register addresses
Date: Wed, 20 May 2026 18:13:10 +0200
Message-ID: <20260520162200.403752149@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Liu Ying <victor.liu@nxp.com>

[ Upstream commit bfb91be0eba426913f2950ed8b3d963f0de53fcc ]

MIPI DSI to HDMI bridge ADV7535 CEC default register address is 0x3c
on an I2C bus.  And, OV5640 camera uses the same address on the same
I2C bus.  To resolve this conflict, use 0x3b as ADV7535 CEC register
address by specifying all ADV7535 register addresses.

Fixes: 6f6c18cba16f ("arm64: dts: imx8mp-evk: add camera ov5640 and related nodes")
Signed-off-by: Liu Ying <victor.liu@nxp.com>
Signed-off-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/imx8mp-evk.dts | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/freescale/imx8mp-evk.dts b/arch/arm64/boot/dts/freescale/imx8mp-evk.dts
index 31f03436137dc..f981504f019d1 100644
--- a/arch/arm64/boot/dts/freescale/imx8mp-evk.dts
+++ b/arch/arm64/boot/dts/freescale/imx8mp-evk.dts
@@ -595,7 +595,8 @@ ov5640_mipi_0_ep: endpoint {
 
 	hdmi@3d {
 		compatible = "adi,adv7535";
-		reg = <0x3d>;
+		reg = <0x3d>, <0x3f>, <0x3b>, <0x38>;
+		reg-names = "main", "edid", "cec", "packet";
 		interrupt-parent = <&gpio1>;
 		interrupts = <9 IRQ_TYPE_EDGE_FALLING>;
 		adi,dsi-lanes = <4>;
-- 
2.53.0



