Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024784;
	b=Lsz4Yp6HtyGoRRE2EZL/qI8YEeqanFipyW7yF5smvmTHJI6GAzqasBxlFwOa9qCsaTYu
	 Y2t3z9NHZBoLD75TyU5nCMSr9XfDzMW89tPksrkcu419W0YSguXTj//Klug7sja/3LcKm
	 4JYuOrak44Rnn+5ZS0pEN0d2ZAeGV/P7yqSENt2tGiMasq1j+xUCpZzqVlFpQRn1tWhaw
	 OAIulsuTeXA7LCgWLGl4YybBpZT6lTOgSe+3fRshoMYdUx67OIT5JMzg0nJ3g+EdH4Gd8
	 kAANKb1v9Gb1yToEPGO2NiLzXiL0PBh0Oht5lHmCKxGosbRqcWrECnGDId2Fq3c+rnw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024784;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=KwqSKa+tEXHF/2htXWOb5pXWvO/cE/9sXstc8X6ZBx0=;
	b=M1B3247NY2kq3RB+iwQrdcRE5jYdnuILQ4jVzAJZ55AS/EqoII0NlkdORGX5EdykAHW5
	 2Akn7ba+zP/lYB+O94PWEGwxc2yrg0Q6k7lOZWUS65Ey5J+IghGSrQfRJJSMnckjGLUCk
	 HJht/1qT5Gzf9Qu9Ygmziem4jq4bE/QPKaKgOWvrRXGfF12ymfUSxZ/5ZF6NNw9TjEcxF
	 Hzm2lb4w+sqladWPsH6n6/cV8qlqcinBxBY1lEE6fNsIAo3D9ferOAAJPEZukWNYGLYZ0
	 nQC6ZHoQunZnEelMM+j26eG/YyHWM3kNPpAZpqc6nBAuKW+FlcjMCN53JyD9gfNANwg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=V980oSvV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8E3F606A325;
	Wed, 18 Nov 2026 17:59:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=V980oSvV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3ED01F000C6;
	Wed, 18 Nov 2026 17:59:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024784;
	bh=KwqSKa+tEXHF/2htXWOb5pXWvO/cE/9sXstc8X6ZBx0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=V980oSvVn9ggGS68D2dY5uJIUvxCJB1NQSLTVa5k87XOylhg3Zq9xZw33FM45qRuz
	 RATCbTqNHQCDcvObJ/V4odIewQ6ImnNppJgTMRslUJWkxsZIs7+XS5kJ+VQ5Tg4EYP
	 sbhV6+2Y6dhPCJyUAY1H3YLaINC/sv4ZYaHwnpSY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peng Fan <peng.fan@nxp.com>,
	Frank Li <Frank.Li@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0848/2151] arm64: dts: imx8qxp-mek: fix reserved memory node names for remoteproc
Date: Wed, 18 Nov 2026 15:43:03 +0100
Message-ID: <20261118150153.138613291@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peng Fan <peng.fan@nxp.com>

[ Upstream commit a9f3cf4354022ca0b4a0d12eab7af9858f71c9f7 ]

The imx_rproc driver uses node names to identify reserved memory regions.
It checks for "vdev0buffer" to skip mapping, "rsc-table" to locate the
resource table, and "vdev" prefix to filter vdev regions.

Rename the reserved memory nodes to use the expected names so the driver
can correctly identify and handle each region.

Fixes: 5fa302590f17 ("arm64: dts: imx8qxp-mek: add cm4 and related nodes")
Signed-off-by: Peng Fan <peng.fan@nxp.com>
Signed-off-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/imx8qxp-mek.dts | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/boot/dts/freescale/imx8qxp-mek.dts b/arch/arm64/boot/dts/freescale/imx8qxp-mek.dts
index eb86977040879..4279510fc5c3b 100644
--- a/arch/arm64/boot/dts/freescale/imx8qxp-mek.dts
+++ b/arch/arm64/boot/dts/freescale/imx8qxp-mek.dts
@@ -27,7 +27,7 @@ imx8x_cm4: imx8x-cm4 {
 		mboxes = <&lsio_mu5 0 1
 			  &lsio_mu5 1 1
 			  &lsio_mu5 3 1>;
-		memory-region = <&vdevbuffer>, <&vdev0vring0>, <&vdev0vring1>,
+		memory-region = <&vdev0buffer>, <&vdev0vring0>, <&vdev0vring1>,
 				<&vdev1vring0>, <&vdev1vring1>, <&rsc_table>;
 		power-domains = <&pd IMX_SC_R_M4_0_PID0>,
 				<&pd IMX_SC_R_M4_0_MU_1A>;
@@ -226,32 +226,32 @@ reserved-memory {
 		#size-cells = <2>;
 		ranges;
 
-		vdev0vring0: memory@90000000 {
+		vdev0vring0: vdev0vring0@90000000 {
 			reg = <0 0x90000000 0 0x8000>;
 			no-map;
 		};
 
-		vdev0vring1: memory@90008000 {
+		vdev0vring1: vdev0vring1@90008000 {
 			reg = <0 0x90008000 0 0x8000>;
 			no-map;
 		};
 
-		vdev1vring0: memory@90010000 {
+		vdev1vring0: vdev1vring0@90010000 {
 			reg = <0 0x90010000 0 0x8000>;
 			no-map;
 		};
 
-		vdev1vring1: memory@90018000 {
+		vdev1vring1: vdev1vring1@90018000 {
 			reg = <0 0x90018000 0 0x8000>;
 			no-map;
 		};
 
-		rsc_table: memory@900ff000 {
+		rsc_table: rsc-table@900ff000 {
 			reg = <0 0x900ff000 0 0x1000>;
 			no-map;
 		};
 
-		vdevbuffer: memory@90400000 {
+		vdev0buffer: vdev0buffer@90400000 {
 			compatible = "shared-dma-pool";
 			reg = <0 0x90400000 0 0x100000>;
 			no-map;
-- 
2.53.0



