Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0D9E34CFDE;
	Wed, 30 Sep 2026 18:07:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790791625; cv=none; b=tGvV8LQ4hIgAA3nC5kb3ILDJkEDAsUXnvR84dbC51jlAMUJo8JVZHHpE2gotRu/PXWqdFTDF3KSOfWVyIWepO9GHU/jOE/mSQ56F93iO5M3fOiwjKOVXb1T3YWK0re1VzqU093ZQY/WhXYJXw7wra9ts3AdjXHTzkY2WKWa/h4k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790791625; c=relaxed/simple;
	bh=ePnhOrmt++cANKPL621ZeiINrTnBwFO6rtK5Y7MbOiw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TeU0R0K+6xVGAt/aFEWw7HNRhqCSrtQl7tR/D0OIsTpMHN1qsvBaE9Rk6EAduPX0FyGL1g4F2OSdbiIOs0YpP78eMqFQn4Fvnhq0+1eY2/+Wzb6IhMtsipzd/THPr1Q9RkdqomspsqudXd8fCfJ3K3NfmUU/0cIZeeRuX2E2J+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mJMHzgGo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mJMHzgGo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 002401F000FF;
	Wed, 30 Sep 2026 18:07:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790791624;
	bh=mAHQY4dJGMMjQeR8vDipBdgAdAUEnqDRJzVWH8J/0vo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mJMHzgGofUYMkOwAdp63OjrCgqWbiqpIE8gnZpA0/twQvMQkrHwhojesX15xRQ0R5
	 7l7fleDbzHMgnfccl1hJe27Owa3dSmJpj0qx3nPKmNGdbWL77QkWvARJKvOo8Vragk
	 FE2Ne9b+0ieeYJrHEaH/dPTF8fUKuFmddXPCSFqg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"hpp.iscas" <hppiscas@163.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 323/752] ASoC: bcm: bcm63xx: Publish the OF module aliases
Date: Wed, 30 Sep 2026 17:23:13 +0200
Message-ID: <20260930152405.285933130@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: hpp.iscas <hppiscas@163.com>

[ Upstream commit 32689f0fc54fd801f1cd11637666e534984cb04a ]

The BCM63xx I2S platform driver matches brcm,bcm63xx-i2s using
snd_soc_bcm_audio_match. With SND_BCM63XX_I2S_WHISTLER=m, the platform
bus emits an OF modalias but snd-soc-63xx does not publish that table.

Export the existing OF IDs for module autoloading. The PCM companion
and the probe path remain unchanged.

Fixes: 88eb404ccc3e ("ASoC: brcm: Add DSL/PON SoC audio driver")
Signed-off-by: hpp.iscas <hppiscas@163.com>
Link: https://patch.msgid.link/20260905133103.63432-1-hppiscas@163.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/bcm/bcm63xx-i2s-whistler.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/soc/bcm/bcm63xx-i2s-whistler.c b/sound/soc/bcm/bcm63xx-i2s-whistler.c
index 527caf430715b..a515be2c0db14 100644
--- a/sound/soc/bcm/bcm63xx-i2s-whistler.c
+++ b/sound/soc/bcm/bcm63xx-i2s-whistler.c
@@ -299,6 +299,7 @@ static const struct of_device_id snd_soc_bcm_audio_match[] = {
 	{.compatible = "brcm,bcm63xx-i2s"},
 	{ }
 };
+MODULE_DEVICE_TABLE(of, snd_soc_bcm_audio_match);
 #endif
 
 static struct platform_driver bcm63xx_i2s_driver = {
-- 
2.53.0



