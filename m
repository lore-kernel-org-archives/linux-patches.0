Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98902311945;
	Mon, 13 Oct 2025 15:09:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760368156; cv=none; b=QZq7zXh7Y4N0dgtoO9V93zh6xZ2XW99lWsgbzs488G/lTP8h0cAxZKj4QiZL7YFs/QAQ9GALOCXwrQe80stV3wcp+yuvtzcZodu5GeQBD/wszSWmyMGRp4V8SP3bsAGrQDphtcErcBMHXSyeb8jIG3L4u5GZyz39qMW3yuXpAps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760368156; c=relaxed/simple;
	bh=smb+RFPi/FeScm3PVew3d/HLSUxLkE/lEJ1PyfnakK8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YcDkXblZED9pW5MWglMtuHw15KpF/G48gBIKN+F9tSMlF1BbN/BiB9Nba8LPZTeldYhqiuOIEZ1uD0RGwm2CA8fT1tT61kS1X2EihO5dmY7kYQlZzYlDXUQ0iaseYQFyXZa0fystzjzW9KyuBfqcPU9rXYQ526taLNVEVPmBU94=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aURPHdti; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aURPHdti"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CC45C4CEE7;
	Mon, 13 Oct 2025 15:09:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760368156;
	bh=smb+RFPi/FeScm3PVew3d/HLSUxLkE/lEJ1PyfnakK8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aURPHdtio2vQskIKxL4viH+Z5a2LygXwcJ7Jc04eCjngShUUhFyGKwuJBW8RN7Nno
	 uBM/IqGA0P25myQXpOhjkRYpkZkhf4H/HdpsRToULM69OH0Po5bAhdzsuz0Grrpj3f
	 DJLwdPsdLnvpkjQmH/UArYusDKIEeP399YEOZreo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 062/262] arm64: dts: mediatek: mt6795-xperia-m5: Fix mmc0 latch-ck value
Date: Mon, 13 Oct 2025 16:43:24 +0200
Message-ID: <20251013144328.361568268@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144326.116493600@linuxfoundation.org>
References: <20251013144326.116493600@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



