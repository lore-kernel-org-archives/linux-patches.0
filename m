Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4261A4973B4;
	Thu, 17 Sep 2026 18:43:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789670581; cv=none; b=PJWezXphR4jgIXSfjlPmJtJvXJEgOkMvNWehd5ub8tnKiISTAyOfNPwXj3EMtfkv5eE8p4d7T9lL+vglMsKpU7GlLls0BtjCCLOtgUvhBqESZ7I2raH8HmQIkNaKPnOtXDWbC884xZV+P0KE9JInNGk1oORp2nSQpq5yXOw/LZY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789670581; c=relaxed/simple;
	bh=teNLgYSUBOAJVlcP3dEwELSNsfqdJuupcWeQW6q6thE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S2oEX2f7tNRjqQ20B6BTosq0i0FAbxX/wBKP/PEh/pmytWtNt+JjLZaLm9bY/kHrnYqdMf5dULj4ltwFnH+QWeyuK4Lt44F3HFIpKemxYIzGYZl6hrQb2nhJb2HC3LUWRTlhIn+D1uJ2LysuSYn3VhaY8aDfWelENEY6Rry7qn4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PK4dx7zv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PK4dx7zv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99DA61F000FF;
	Thu, 17 Sep 2026 18:42:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789670580;
	bh=BhCD/edN2CBvQLoTD24El1GY0AwtdPc9WKojuHwKfAg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PK4dx7zvGZ/sXDc4VpqjLegX7J0YWTs734zdveYNilg9fKF30NuHqv54D0M36Fmuy
	 h4+r3Fto2Vxtvw3+RRDQZjPfzLkIqivnvibBDMqSu6SBM0kh2Wx5jY1xc6Y4+VX8kU
	 rPekjMGqFcQL06wgnw9SjSc/N/1OtotjLWqGBU8c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"hpp.iscas" <hppiscas@163.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0706/1102] ASoC: bcm: bcm63xx: Publish the OF module aliases
Date: Thu, 17 Sep 2026 16:10:49 +0100
Message-ID: <20260917151558.043351883@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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
index c47ed1e6ea2b6..14d111fe29d83 100644
--- a/sound/soc/bcm/bcm63xx-i2s-whistler.c
+++ b/sound/soc/bcm/bcm63xx-i2s-whistler.c
@@ -285,6 +285,7 @@ static const struct of_device_id snd_soc_bcm_audio_match[] = {
 	{.compatible = "brcm,bcm63xx-i2s"},
 	{ }
 };
+MODULE_DEVICE_TABLE(of, snd_soc_bcm_audio_match);
 #endif
 
 static struct platform_driver bcm63xx_i2s_driver = {
-- 
2.53.0



