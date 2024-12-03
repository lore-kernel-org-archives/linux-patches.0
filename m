Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C773B1F9EC0;
	Tue,  3 Dec 2024 15:42:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733240561; cv=none; b=iIL5qLxrAqMYnMslSwXZiNP+17UWoicDarHnKuuSi0+LqmIj9moWFscqWsG9D/PfxGWwpORpoERNUAOldwcLgknhFmz48Wv6nLonhjzcRrvLX2tCs/3DAfwUGnKMdm1RoXg33ctsf+y6qe0/1Gtnzwg4KpsxZ7Yd8QJOAO91DQ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733240561; c=relaxed/simple;
	bh=FLEGIasZzVnuLS5kPS69c+qPjFla9LHj9NYanyHdAE0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B3cEnooQGeYlLRgsC9m60aHXw7ubUZGdmlAD6CMcUR5wWtQyltaFdSPOeSeSUPJd7PRsg3fhyOzpsw1cAvolKx2uwHB+Ozzi4Ipm6qRDrkYs9rmmQnfIIDhjdn9zfP+ln9xiR7XE8eop/anbfUICRez+bozSJJkkxFxLsK81Zng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MFANM83C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MFANM83C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35771C4CECF;
	Tue,  3 Dec 2024 15:42:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733240561;
	bh=FLEGIasZzVnuLS5kPS69c+qPjFla9LHj9NYanyHdAE0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MFANM83CHXFioYIAA2LxjcALuyW+2rvPegquQf64h37tE7mVlGXLkmZAHAyajAhdz
	 zEV6yYLA7RCGPdllBUBpYeGrHbfLrX+1qrYsuLBPW+82DcqvNOQu9tV+BGxsdnPKgN
	 yH4mFN0whfouCnTxImeM0XRn4LpPvdsVw9ddVqx0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Daolong Zhu <jg_daolongzhu@mediatek.corp-partner.google.com>,
	Hsin-Te Yuan <yuanhsinte@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 141/826] arm64: dts: mt8183: fennel: add i2c2s i2c-scl-internal-delay-ns
Date: Tue,  3 Dec 2024 15:37:48 +0100
Message-ID: <20241203144749.247626789@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daolong Zhu <jg_daolongzhu@mediatek.corp-partner.google.com>

[ Upstream commit c802db127dfb9602aaa9338e433c0553d34f1a9c ]

Add i2c2's i2c-scl-internal-delay-ns.

Fixes: 6cd7fdc8c530 ("arm64: dts: mt8183: Add kukui-jacuzzi-fennel board")
Reviewed-by: Matthias Brugger <matthias.bgg@gmail.com>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Daolong Zhu <jg_daolongzhu@mediatek.corp-partner.google.com>
Signed-off-by: Hsin-Te Yuan <yuanhsinte@chromium.org>
Reviewed-by:
Link: https://lore.kernel.org/r/20241025-i2c-delay-v2-1-9be1bcaf35e0@chromium.org
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/mediatek/mt8183-kukui-jacuzzi-fennel.dtsi | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm64/boot/dts/mediatek/mt8183-kukui-jacuzzi-fennel.dtsi b/arch/arm64/boot/dts/mediatek/mt8183-kukui-jacuzzi-fennel.dtsi
index bbe6c338f465e..f9c1ec366b266 100644
--- a/arch/arm64/boot/dts/mediatek/mt8183-kukui-jacuzzi-fennel.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt8183-kukui-jacuzzi-fennel.dtsi
@@ -25,3 +25,6 @@ trackpad@2c {
 	};
 };
 
+&i2c2 {
+	i2c-scl-internal-delay-ns = <21500>;
+};
-- 
2.43.0



