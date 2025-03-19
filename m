Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6838C1DDA36;
	Wed, 19 Mar 2025 14:36:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742394973; cv=none; b=Rf2ldbcXTiEbv9qUvxZjW7ud1H9KCTZVdioDaKJoFODh+W2obM2FXwRvghT+4jYS0MMUuvZ5kL4TbQ/ixiDry5URs5Iw6kslP9rDm4Yo6jFOJ4DRYOGtfxUfw347nXzCXRI4/HzLbddsientffRzUbAGv6F8GIlGx89Ig0vpzsE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742394973; c=relaxed/simple;
	bh=y73YJ8nipcP0kEh9N60Duj7mTaYNHA8Tpo1CX+h0ePE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V2TKIRbSAkgrW/nfhiDT/5tlbFz2Bcg0gvR1POpb0BGSxHaSuBg84eTrTjryKQcHKEEhG6Z30tP5+L3bNbMQGe2/55Y6J51d4ONUlhIqU1xBI1ZpBlBqavRs8GVbCjb6LX2eaqsSWiiEbZz+t+EYbPYsSWZTnhFy++4BfnTGkQE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AvVOFWRO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AvVOFWRO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FFB7C4CEEC;
	Wed, 19 Mar 2025 14:36:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742394973;
	bh=y73YJ8nipcP0kEh9N60Duj7mTaYNHA8Tpo1CX+h0ePE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AvVOFWRONFY2+R3qsPNqRh+VlPxYOYrlQa7pJ/62xrLXyZI1K1TNgbUJYZegnKOJX
	 p/Z70mgPU6FFa8MLv2DfuDzTFmJu8mm/7fdMGI6ruPfJs36OHoyav4/Yk/5kuPd2oD
	 aKuunJiq5jOZOAoGhwnFUeaA+w/+lwQZolVrUPG8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 209/241] ASoC: cs42l43: Fix maximum ADC Volume
Date: Wed, 19 Mar 2025 07:31:19 -0700
Message-ID: <20250319143032.918247388@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143027.685727358@linuxfoundation.org>
References: <20250319143027.685727358@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Charles Keepax <ckeepax@opensource.cirrus.com>

[ Upstream commit e26f1cfeac6712516bfeed80890da664f4f2e88a ]

The range of ADC volume is -1 -> 3 (-6 to 18dB) so the number of levels
should actually be 4.

Fixes: fc918cbe874e ("ASoC: cs42l43: Add support for the cs42l43")
Signed-off-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://patch.msgid.link/20250306133254.1861046-1-ckeepax@opensource.cirrus.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/cs42l43.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/codecs/cs42l43.c b/sound/soc/codecs/cs42l43.c
index 83c21c17fb80b..b1969536862ba 100644
--- a/sound/soc/codecs/cs42l43.c
+++ b/sound/soc/codecs/cs42l43.c
@@ -1146,7 +1146,7 @@ static const struct snd_kcontrol_new cs42l43_controls[] = {
 
 	SOC_DOUBLE_R_SX_TLV("ADC Volume", CS42L43_ADC_B_CTRL1, CS42L43_ADC_B_CTRL2,
 			    CS42L43_ADC_PGA_GAIN_SHIFT,
-			    0xF, 5, cs42l43_adc_tlv),
+			    0xF, 4, cs42l43_adc_tlv),
 
 	SOC_DOUBLE("PDM1 Invert Switch", CS42L43_DMIC_PDM_CTRL,
 		   CS42L43_PDM1L_INV_SHIFT, CS42L43_PDM1R_INV_SHIFT, 1, 0),
-- 
2.39.5



