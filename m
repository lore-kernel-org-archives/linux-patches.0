Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A9371A9B46;
	Mon, 13 Oct 2025 15:25:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760369156; cv=none; b=KzzIL0OJv65/Lvoy2T1wNRtpXEv21Rhk5AEcu5PVQ8Tz46+mH3pyjuhavZ39aeGzMLyZA+qa6ZQXixCG7Fc/v7dmS/BScXByUDIjtvOyeXwfBLdC3LQ009A1OHQSBPjAx5B95B35kZ7HTi8IeGDKeEy6STj86PKhGWYKhMU7pn0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760369156; c=relaxed/simple;
	bh=HW18WppH+Peqr2fj51Hmi7I2FNKvcIf+NZDnS+WAT6o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uixnkQuJdoPQTzXTzYOBUHpKxkA7fE6aJblyXiGT1NdKQHT76YZaUeomgxeOPx2rRTWUZCYNsfwX0rSSIBZxi3NJ91eJjEnZdcea4dEO8RYSDnb9HDVqOdCciLZKR4i/KqKNrw1dfzw6/PgCi9lweXc6omIkf60Y8ylcGJGdXFQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=up5ARrDM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="up5ARrDM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C224C4CEE7;
	Mon, 13 Oct 2025 15:25:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760369156;
	bh=HW18WppH+Peqr2fj51Hmi7I2FNKvcIf+NZDnS+WAT6o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=up5ARrDMWLYUbTFutWuc/4UFc+K7+jGquWmJmdFRBinHJwbTwVYykEDJ0i2TwHnRP
	 arXlMLa8bXDSCN1PX/w5MVV4xmM42bQYVgbO7ELS3kTiFvS41LrMTk0/5zUPpp3k8C
	 RmQMuSiOoWyfemvl8+Tv0K6Dvketpq6VC3uLVKPQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 147/563] arm64: dts: mediatek: mt6795-xperia-m5: Fix mmc0 latch-ck value
Date: Mon, 13 Oct 2025 16:40:08 +0200
Message-ID: <20251013144416.616661223@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>

[ Upstream commit 236681fb64102f25ed11df55999e6985c1bc2f7d ]

Change the latch-ck value from 0x14 to 4: as only bits [0-3] are
actually used, the final value that gets written to the register
field for DAT_LATCH_CK_SEL is just 0x4.

This also fixes dtbs_check warnings.

Fixes: 5a65dcccf483 ("arm64: dts: mediatek: mt6795-xperia-m5: Add eMMC, MicroSD slot, SDIO")
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Link: https://lore.kernel.org/r/20250724083914.61351-21-angelogioacchino.delregno@collabora.com
Signed-off-by: Matthias Brugger <matthias.bgg@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/mediatek/mt6795-sony-xperia-m5.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/mediatek/mt6795-sony-xperia-m5.dts b/arch/arm64/boot/dts/mediatek/mt6795-sony-xperia-m5.dts
index 91de920c22457..03cc48321a3f4 100644
--- a/arch/arm64/boot/dts/mediatek/mt6795-sony-xperia-m5.dts
+++ b/arch/arm64/boot/dts/mediatek/mt6795-sony-xperia-m5.dts
@@ -212,7 +212,7 @@ proximity@48 {
 
 &mmc0 {
 	/* eMMC controller */
-	mediatek,latch-ck = <0x14>; /* hs400 */
+	mediatek,latch-ck = <4>; /* hs400 */
 	mediatek,hs200-cmd-int-delay = <1>;
 	mediatek,hs400-cmd-int-delay = <1>;
 	mediatek,hs400-ds-dly3 = <0x1a>;
-- 
2.51.0



