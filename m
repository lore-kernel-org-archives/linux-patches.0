Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 599E218B461;
	Tue, 30 Jul 2024 16:06:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722355582; cv=none; b=ii2LhxAF4AI64PAl6PxWrDGbOxm6LnhGmK1FGEmekIhi0EY2w8oawYElvVWUzT6YCQow7auMjtcv/gMF5ss1J3pkFkGgmqgLkuLFEWOKE+NmL79EA+6Sz3Vd7f5g5Z8JsRbn7sfppdixrQxi3+vsQdwhY/AyUhtkTmvDCsJRV/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722355582; c=relaxed/simple;
	bh=yVd8P/zSl2CMb1mXy5E6//S0t05oCGKu90nh3cdN8CA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X0k5oTgAVUly11VhAZwp1LQjDUNMlqLRhn3wFBNaMi4kmjylkAg1K2bf8YoCaGAO48oI3IS+IFPOen3d1O7Pyz7knMLq5PR29RrnRp6Vc2qYC3aAB9glV4xbp8J2Wlk7mRJgn4bi3PKestZbnVJR1ZGJlI1SANwiM58Gna/PMF0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WBurYBD1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WBurYBD1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1828BC4AF0C;
	Tue, 30 Jul 2024 16:06:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722355581;
	bh=yVd8P/zSl2CMb1mXy5E6//S0t05oCGKu90nh3cdN8CA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WBurYBD1qKCFLju97SfKInPVZ2WSEazxbqm3UxdDmVDcjNg+bEkNkOqNeth8oGkAJ
	 b6hgFf/rWnX6XkOsxBqE60P0D6eauwHwUBdNA09jTGjExQ8LyJTY2DV8aVhAdFUXGL
	 Qt0VT3xSym9RKEQNGcUbx32K2qsFP0dtAJw25vHI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 071/568] arm64: dts: mediatek: mt8195: Fix GPU thermal zone name for SVS
Date: Tue, 30 Jul 2024 17:42:58 +0200
Message-ID: <20240730151642.635697565@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>

[ Upstream commit b2b6f2edb82a08abe8942535bc77da55a0f43e14 ]

This SoC has two GPU related thermal zones: the primary zone must be
called "gpu-thermal" for SVS to pick it up.

Fixes: 1e5b6725199f ("arm64: dts: mediatek: mt8195: Add AP domain thermal zones")
Link: https://lore.kernel.org/r/20240410083002.1357857-2-angelogioacchino.delregno@collabora.com
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/mediatek/mt8195.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/mediatek/mt8195.dtsi b/arch/arm64/boot/dts/mediatek/mt8195.dtsi
index 2bb9d9aa65fed..20e6d90cc4118 100644
--- a/arch/arm64/boot/dts/mediatek/mt8195.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt8195.dtsi
@@ -3395,7 +3395,7 @@ vpu1_crit: trip-crit {
 			};
 		};
 
-		gpu0-thermal {
+		gpu-thermal {
 			polling-delay = <1000>;
 			polling-delay-passive = <250>;
 			thermal-sensors = <&lvts_ap MT8195_AP_GPU0>;
-- 
2.43.0



