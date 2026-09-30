Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 049EB50B8DA;
	Wed, 30 Sep 2026 16:20:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790785234; cv=none; b=NiTP3lKKsMNlTbPKa/4rOTSRjX8SfA1PzeYVAE+acQvdbJxuSdqzYDtvaAOXrHU7ttlIP6VnBJmkYPR8SSA2FMqk3teyG4YCwE6874KPBSah6U94KMUrGj0DJ9BuD9el3vOCwfflnUphsdGLKppNeBKX08MmNiTLENQvzy3cR5A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790785234; c=relaxed/simple;
	bh=VEYLwyYMoC5DaP9albsjiU5lxvjbPyAlCb1LYi+YMgA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dWe0ixGayvkG6mTmwl1WO9JTL4ctIcgUjOhV5jQrZOaBp6O3SmZZ8fV0Q19rYHWwelW05EpaL0QkxOzNwe00cY5te66RxSVyC2MEb5PtJBIWyDZuYF8lX0ua7/SKCNqGlFULs5AbR53Nx9BL2RwY3H+uyGXX687S9tqoWUrb9GI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bzXVqqux; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bzXVqqux"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47B011F00899;
	Wed, 30 Sep 2026 16:20:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790785228;
	bh=4dfacgnDoKI4ZeGUGQdZYbmjDkRRdZJhiwD0arzcXo4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bzXVqquxwMpMNMIJM6X0fqw8YWQo/aKYMNDTN8vC8czk4/jiKvNP1fdhs7PMsgMaq
	 pABHJD4IvGkMdNdDn8ZviXV1WG85rpqtlrGGVgtAkVTneNN2m+lW9FviHF9Ku+tJUY
	 mF7aaTb01cYdo8Aecr2lxk0qZuJxRZQDfEy7W91o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"hpp.iscas" <hppiscas@163.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 434/982] ASoC: bcm: bcm63xx: Publish the OF module aliases
Date: Wed, 30 Sep 2026 17:19:30 +0200
Message-ID: <20260930152426.118042347@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 2da1384ffe911..7ae46863d0070 100644
--- a/sound/soc/bcm/bcm63xx-i2s-whistler.c
+++ b/sound/soc/bcm/bcm63xx-i2s-whistler.c
@@ -300,6 +300,7 @@ static const struct of_device_id snd_soc_bcm_audio_match[] = {
 	{.compatible = "brcm,bcm63xx-i2s"},
 	{ }
 };
+MODULE_DEVICE_TABLE(of, snd_soc_bcm_audio_match);
 #endif
 
 static struct platform_driver bcm63xx_i2s_driver = {
-- 
2.53.0



