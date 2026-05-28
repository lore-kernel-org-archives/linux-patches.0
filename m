Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE4FC2F691F;
	Thu, 28 May 2026 20:08:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779998934; cv=none; b=A44wBl53qyMvCmQHH1+17ciNL0Upr/yfSrlNKVVSsTKGWYKbfWTBJKaNS/Y7sIapGDsO3kW97x7m0Ureo1/WS49oMfxmrRsWK+6Q6J1fQWvI/pXnIuYTV7dcDBpThBpUar9x0LZiliBF8JAH7Gd9p8ah710dEGi6NYAUQ/3d+j0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779998934; c=relaxed/simple;
	bh=jgdM9xjSmbEb3VU58SlZtqhe9myn0sNi2XIAXKWtVSw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lYawKYOGNcNakUP6l0pGXWq5VOZFXJvc3ydQcyjfF+4BGPDGUlx09K92gdDdbbWubrG4DaKDjTJkdsClk32VrPpyfcRWdwEw0GzFawlzk3tHnaLRT2N71oQj2Gkx+dfALhwTI3AZMoHyRPVVy1Utxh2+b5KXAXx/WpC0Gk9MCAg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ll1rkqt7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ll1rkqt7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED29B1F000E9;
	Thu, 28 May 2026 20:08:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779998933;
	bh=PyQxcfE2JABASy9sPdHMnHKu/l2oIUY7CqY63W1UXTc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ll1rkqt7R10jVnjDyrfA6dGPtP+7gzIFcks5DiWk4kYmlWyOBvtTDIz+PKA2aZt3F
	 GvfpR8oZq+867osb6wF7pivj2N7dXd+my5tpmY6pZ2DVJ5T8s0FxT1Z78nKIUOVsNv
	 xGwgic3S3fBGyGTMwpg+js8hVnxmFWLY4W2kUwa4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?C=C3=A1ssio=20Gabriel?= <cassiogabrielcontato@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 348/461] ASoC: amd: acp-sdw-legacy: check CPU DAI name before logging
Date: Thu, 28 May 2026 21:47:57 +0200
Message-ID: <20260528194657.456971818@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194646.819809818@linuxfoundation.org>
References: <20260528194646.819809818@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cássio Gabriel <cassiogabrielcontato@gmail.com>

[ Upstream commit 1afd8f06dcb1d561af3b239c5b14a88b87c13454 ]

devm_kasprintf() can fail and return NULL. The legacy AMD SoundWire
machine driver logs cpus->dai_name before checking the allocation result.

Move the debug print after the NULL check, matching the ordering used by
the SOF AMD SoundWire path after commit 5726b68473f7 ("ASoC: amd/sdw_utils:
avoid NULL deref when devm_kasprintf() fails").

Fixes: 2981d9b0789c ("ASoC: amd: acp: add soundwire machine driver for legacy stack")
Signed-off-by: Cássio Gabriel <cassiogabrielcontato@gmail.com>
Link: https://patch.msgid.link/20260511-asoc-amd-acp-sdw-legacy-dai-name-null-v1-1-dc6151b6da8a@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/amd/acp/acp-sdw-legacy-mach.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/amd/acp/acp-sdw-legacy-mach.c b/sound/soc/amd/acp/acp-sdw-legacy-mach.c
index a9c8d9545281e..ae9579c8511eb 100644
--- a/sound/soc/amd/acp/acp-sdw-legacy-mach.c
+++ b/sound/soc/amd/acp/acp-sdw-legacy-mach.c
@@ -260,9 +260,9 @@ static int create_sdw_dailink(struct snd_soc_card *card,
 			cpus->dai_name = devm_kasprintf(dev, GFP_KERNEL,
 							"SDW%d Pin%d",
 							link_num, cpu_pin_id);
-			dev_dbg(dev, "cpu->dai_name:%s\n", cpus->dai_name);
 			if (!cpus->dai_name)
 				return -ENOMEM;
+			dev_dbg(dev, "cpu->dai_name:%s\n", cpus->dai_name);
 
 			codec_maps[j].cpu = 0;
 			codec_maps[j].codec = j;
-- 
2.53.0



