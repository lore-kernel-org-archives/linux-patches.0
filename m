Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECB6E3CAE8D;
	Wed, 30 Sep 2026 19:09:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790795392; cv=none; b=qpeabYIORdlgGATAj+JVQIqNQ5FdgaRjuQTcARyoZWj1zPlW3thupDjQ2yBJ7lxcWpjr9tQrc1ndrz34LUG7nrokwGOxievlNJoPez1lhkYcVIfXsMtn+HUF5RsHOTZ9CAFf3Ap070t2XRBbVtotPyvQrmOFNxccS1YzEMIOikA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790795392; c=relaxed/simple;
	bh=PYrJi26Qm8Wzgj0VxKGVNzACWKuzCe8siIZAyLVJ330=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qu7dXEJOCmhSfWivTyf1Lo7Xb2GMk0KgJ55z/iyRHAKNq3gkMVm9TBnuhzXysoz9JaDS8TFc//NKUSINfgWtbnMumVB4ZqIuZxy5FeYUOdTOCpHU+w5sbr7QuHfKhgUPxMvwi7ppO1eI+3ek+e9vk73FulpIaMqlMj7gd5tZLgA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Cl8T/cNE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Cl8T/cNE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02A231F000FF;
	Wed, 30 Sep 2026 19:09:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790795390;
	bh=/VGjL0GYFjmlGuDQslKS6IzB+UWBDEOoDbf/ouZ/QEk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Cl8T/cNEs+nmc/ZbnYvbD1ca2sFP8XFk+RaW3JcAZrUACsIFB0rpFG64tekTLETZ9
	 TyiyARUisKXlljOAhp7f2wdLxLFSFlJdZ8FTwj9oXEemqlMLwNq8yuiwmuY4wU7u1T
	 89w1PAIXoOAUX7chgNIvQWEnaN680pnIvbjHY8VI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"hpp.iscas" <hppiscas@163.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0518/1193] ASoC: bcm: bcm63xx: Publish the OF module aliases
Date: Wed, 30 Sep 2026 17:20:02 +0200
Message-ID: <20260930152445.686071895@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index c64609718738b..a70c437afe246 100644
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



