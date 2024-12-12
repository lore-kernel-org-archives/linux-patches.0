Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94D79222D63;
	Thu, 12 Dec 2024 15:57:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734019045; cv=none; b=nk+ba7WyF/vQmXps4HhRtBlm4sZRou7BfR5IGO3iBCOlXoXPs4c6HLmleQ1QLGPsCb1XZ7T4sUaoV6Gdt4U32VUGEEK/qeFcH0iurQ/hDxIHjOi3Nx/Jubg2Mtob6CdYYid+au94Fkr9zqi0rnH3e/knRKRDwpnoFoyMuv0sWzo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734019045; c=relaxed/simple;
	bh=kqrW0as3BP4ZS1ptnZ+wLHE2mu69cgdnwvQIB3hlLY4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AYW6yJHuD6O+jSATDg0e789dRy6+if/tCOGCeGdGCoazQWf8RvZ+5Tc1Tyv23nukcx2TyfDQWEOmXAXeWsot1hv2sz9IY6br29Z+Ru8MFjVmWsP/T9loDVBh6Zhjfmlvt0BxjZQTSnwtbJMzr6HYnoatDS8K9i0ZMnT6gF1eUyg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fJkcQL7u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fJkcQL7u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4D2AC4CED0;
	Thu, 12 Dec 2024 15:57:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734019045;
	bh=kqrW0as3BP4ZS1ptnZ+wLHE2mu69cgdnwvQIB3hlLY4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fJkcQL7uC+JBrLLr+pTMq5SwxJo99aHITbLahUi7jcEn45C9t8arVA5vUC4SOa4wN
	 ueYkyiMaflVrJE8tiBsEZJJJ7KgSVDJhOIAcUk1aPPAm+Fpz4eNRuo2RyBdk7PDS5d
	 jaiKgHxE7MpHicL19VzrLyYEcr0WYLw0w5tyvHek=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen-Yu Tsai <wenst@chromium.org>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 103/772] arm64: dts: mediatek: mt8173-elm-hana: Add vdd-supply to second source trackpad
Date: Thu, 12 Dec 2024 15:50:48 +0100
Message-ID: <20241212144354.196108039@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chen-Yu Tsai <wenst@chromium.org>

[ Upstream commit f766fae08f6a2eaeb45d8d2c053724c91526835c ]

The Hana device has a second source option trackpad, but it is missing
its regulator supply. It only works because the regulator is marked as
always-on.

Add the regulator supply, but leave out the post-power-on delay. Instead,
document the post-power-on delay along with the reason for not adding
it in a comment.

Fixes: 689b937bedde ("arm64: dts: mediatek: add mt8173 elm and hana board")
Signed-off-by: Chen-Yu Tsai <wenst@chromium.org>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Link: https://lore.kernel.org/r/20241018082001.1296963-1-wenst@chromium.org
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/mediatek/mt8173-elm-hana.dtsi | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/arm64/boot/dts/mediatek/mt8173-elm-hana.dtsi b/arch/arm64/boot/dts/mediatek/mt8173-elm-hana.dtsi
index bdcd35cecad90..fd6230352f4fd 100644
--- a/arch/arm64/boot/dts/mediatek/mt8173-elm-hana.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt8173-elm-hana.dtsi
@@ -43,6 +43,14 @@ trackpad2: trackpad@2c {
 		interrupts = <117 IRQ_TYPE_LEVEL_LOW>;
 		reg = <0x2c>;
 		hid-descr-addr = <0x0020>;
+		/*
+		 * The trackpad needs a post-power-on delay of 100ms,
+		 * but at time of writing, the power supply for it on
+		 * this board is always on. The delay is therefore not
+		 * added to avoid impacting the readiness of the
+		 * trackpad.
+		 */
+		vdd-supply = <&mt6397_vgp6_reg>;
 		wakeup-source;
 	};
 };
-- 
2.43.0



