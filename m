Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795029109;
	b=zARnsAK/ITkWPABDKg3i+I1BBsCOS9JvH9lEvWqA0YWrmbCyBOJTXIHBFIvKjhVLC/92
	 yjs2zREDbhPO1tW5QxZP5/wKswXLbmJZPm2EtP85uq0dDldihWKIqBcPgDP7t6Eg4ZyE5
	 ipHbJstWt64Um1LQpwFT83iCJxj5suXDwBv0a+tG7gm4YUsFUjMN72M1V3cZFjI1Is4XI
	 GhewTrd+gpS4lm1pHaVG1hiprcrKCjwQ53dSyhoC000zpS95WxHD4idqE9Ym8T6fHUxeJ
	 9t9HPwyutgaUTsa8gPAsR4BAn+fHSFwCEzmNEBI5XqUb2rZyY83KzUToYLMVnuT/ViQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795029109;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=yR0S3wgSLeFDvwtnKtmlKekFToPOEkFtontRKu/vf6w=;
	b=M9wWqFimI9cfrDDus4HIGeAOcOECCy95QnZjXpl09v5Uw2KVsLtF0iOI7/ppQuSANB+J
	 r3Unag8l/ElwNVsfrBmOHmnoTafbRcjDXuby1mgcsS6VlOxbYbD/8pNoiApQbg0bwhzE4
	 purPFkfCZTgnRn2byUI0dvSRGOWaue0C9/2eI0vbKE7pB1CrnSXDmZRnQMRfF9MULai/i
	 O8riDcL8OPFDtQ+OA2gT55rLAfH+XXFHY8PFZd4Z/8douDMkw2/hUudE8UlXcV67lCezQ
	 BWKVRnpM2NFb9FmYRY5YVuAIkTjbqFGMwmImQwpluvUou1lmANhlaq0nO1TQe6MsDag==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="bCYDrrj/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F3D2606A31C;
	Wed, 18 Nov 2026 19:11:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bCYDrrj/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B42331F000C4;
	Wed, 18 Nov 2026 19:11:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795029109;
	bh=yR0S3wgSLeFDvwtnKtmlKekFToPOEkFtontRKu/vf6w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bCYDrrj/u7HqJA+nllrf0ql0hFonG4+pyEmv9GA9JjhMBnzXhlV/PD/7AB+lyDgYd
	 jz2Z4ZJQuVKTsXVHa/eLClwCnV5EqP/LleRc/rPKHin12IeGy+K27NoL8csNz4OgbO
	 /AZjgdQbtpvJIpIzp+3s6ZAP5P2hOwdtCre5r0kA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yemike Abhilash Chandra <y-abhilashchandra@ti.com>,
	Udit Kumar <u-kumar1@ti.com>,
	Nishanth Menon <nm@ti.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0233/1756] arm64: dts: ti: j722s-evm: Add MUX to control CSI2RX
Date: Wed, 18 Nov 2026 15:39:20 +0100
Message-ID: <20261118150017.535709430@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yemike Abhilash Chandra <y-abhilashchandra@ti.com>

[ Upstream commit 2e8861103a08e4220e99b673ab247aff108ddef5 ]

J722S EVM has the CSI2RX routed to a MIPI CSI connector and to 22-pin RPi
camera connector through an analog mux with GPIO control, model mux so
that an overlay can control the mux state according to connected cameras.

Signed-off-by: Yemike Abhilash Chandra <y-abhilashchandra@ti.com>
Reviewed-by: Udit Kumar <u-kumar1@ti.com>
Link: https://lore.kernel.org/r/20250509091911.2442934-3-y-abhilashchandra@ti.com
Signed-off-by: Nishanth Menon <nm@ti.com>
Stable-dep-of: 432bfc86fe62 ("arm64: dts: ti: k3-j722s-evm: Switch audio codec clock from audio_refclk1 to external clock")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/ti/k3-j722s-evm.dts | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/arch/arm64/boot/dts/ti/k3-j722s-evm.dts b/arch/arm64/boot/dts/ti/k3-j722s-evm.dts
index 4504912512b41..b8464082fa492 100644
--- a/arch/arm64/boot/dts/ti/k3-j722s-evm.dts
+++ b/arch/arm64/boot/dts/ti/k3-j722s-evm.dts
@@ -244,6 +244,20 @@ transceiver2: can-phy2 {
 		max-bitrate = <5000000>;
 		standby-gpios = <&exp1 17 GPIO_ACTIVE_HIGH>;
 	};
+
+	csi01_mux: mux-controller-0 {
+		compatible = "gpio-mux";
+		#mux-state-cells = <1>;
+		mux-gpios = <&exp1 6 GPIO_ACTIVE_HIGH>;
+		idle-state = <0>;
+	};
+
+	csi23_mux: mux-controller-1 {
+		compatible = "gpio-mux";
+		#mux-state-cells = <1>;
+		mux-gpios = <&exp1 7 GPIO_ACTIVE_HIGH>;
+		idle-state = <0>;
+	};
 };
 
 &main_pmx0 {
-- 
2.53.0



