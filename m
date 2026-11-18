Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795029693;
	b=CfCmGA4jhnPIWXA70zfzYt4r2HaHYwnProYA52Qoom3EYAhzEC5nhFazWm1YDOX9D/eb
	 tPsa0+es2Ju2nqvX6prTlqzBnICctgKeCe/HkKvxAyPl6f5C/YVwGw/GIv1hArrf+6DFR
	 E1136uAWSS1E24ZlgsG8hgQb+ib+wxuCVJMQ9RVsnIdLgnrIsHZOcHcGLYioCUDPRD2BH
	 EFb2r6ZH6ohpDgVGEQUrqJTOMvDjib/n9Pydt9BOK13MsK9YtcxH/x0/VUZ7mq7iFQEXI
	 hzwk96G9ooW3ymU9M05DJE2KPQk+zT/sGrWIfYgm4EZXPvFw0Ixkqdwf251y3O9Sdhg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795029693;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ZSkBwEfEMsOjTk6Kp+sEF6hqafqNVptmsWEu03w274I=;
	b=RaBgrC/EAFOj5cd2Soiqf41vkTEx2TqsOWBP2DDdPyTVg1NyuQeTpHE+FXqzKkEFcDyp
	 whZFiCibe7qFexuddjSqn5ujE6gXJUmneNnlvnaWf/OhxH7pwH3Y7GM2Ewq/NZNIgILvP
	 eqQhlhE9cWg1R1gJzowh6Alrdosx7Hp4o+GCG0IZZ3m5X2ktG98FF6O3uTkUxnSUy4SA9
	 Uzz7WjmiAJcXycsK04CTNT32axajB0hJ6N+Tnop+pC4WpgzkZALbDdckwIQ3WOd40lxDc
	 cOLXQl2QOIbwvl6Df5fDWqv1YdxTAGcRf5bu404BO8onhyOBMiA7wcbS26EqKiS8V0g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sju4CYof;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1674606A31C;
	Wed, 18 Nov 2026 19:21:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sju4CYof
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C6421F000C4;
	Wed, 18 Nov 2026 19:21:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795029692;
	bh=ZSkBwEfEMsOjTk6Kp+sEF6hqafqNVptmsWEu03w274I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sju4CYofU3tC032BYOjt7DIfjNvvMR8uhC4Sz09Kcnei/vqWdtQovPu41YUDy59sW
	 kui/TiTNvHEOCr5KRMBSCyUEcHpfnkd8c7JbbuFw2rygYxAxQH6iyMzPyZtD6S/0ak
	 63OsyOgqFMdnU554KaZTOHdlqu0NPWvshWnIMAPs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Icenowy Zheng <zhengxingda@iscas.ac.cn>,
	Chen-Yu Tsai <wenst@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0423/1756] arm64: dts: mediatek: mt8173: Fix MFG_ASYNC power domain clock
Date: Wed, 18 Nov 2026 15:42:30 +0100
Message-ID: <20261118150025.601954642@linuxfoundation.org>
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

From: Chen-Yu Tsai <wenst@chromium.org>

[ Upstream commit c9b3c82c9f1f86cdb2449d47e4ca66a19159ee12 ]

The MFG_ASYNC domain, which is likely associated to the whole MFG block,
currently specifies clk26m as its domain clock. This is bogus, since the
clock is an external crystal with no controls. Also, the MFG block has
a independent CLK_TOP_AXI_MFG_IN_SEL clock, which according to the block
diagram, gates access to the hardware registers. Having this one as the
domain clock makes much more sense. This also fixes access to the MFGTOP
registers.

Change the MFG_ASYNC domain clock to CLK_TOP_AXI_MFG_IN_SEL.

Fixes: 8b6562644df9 ("arm64: dts: mediatek: Add mt8173 power domain controller")
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Tested-by: Icenowy Zheng <zhengxingda@iscas.ac.cn>
Signed-off-by: Chen-Yu Tsai <wenst@chromium.org>
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/mediatek/mt8173.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/mediatek/mt8173.dtsi b/arch/arm64/boot/dts/mediatek/mt8173.dtsi
index f49ec74959060..4fcd3e6c5f076 100644
--- a/arch/arm64/boot/dts/mediatek/mt8173.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt8173.dtsi
@@ -497,7 +497,7 @@ power-domain@MT8173_POWER_DOMAIN_USB {
 				};
 				mfg_async: power-domain@MT8173_POWER_DOMAIN_MFG_ASYNC {
 					reg = <MT8173_POWER_DOMAIN_MFG_ASYNC>;
-					clocks = <&clk26m>;
+					clocks = <&topckgen CLK_TOP_AXI_MFG_IN_SEL>;
 					clock-names = "mfg";
 					#address-cells = <1>;
 					#size-cells = <0>;
-- 
2.53.0



