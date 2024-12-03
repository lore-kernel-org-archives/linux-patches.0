Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DEF01F7584;
	Tue,  3 Dec 2024 15:45:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733240752; cv=none; b=Fu6rdl1Yfud17lXqsm41LJaxbXjr+jgrjVG3EssVOxTTJ2qkO5ZKBz2EsjnIhKvxc7yiu9VQqr/gcag282C066YRWBheTverlzORzgSbzzxJSBS1VGYSI5j81gxcY7jTKEzpWKCXu36cHj4CbxjnPGfNuIDppRjeNRg5075f3UM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733240752; c=relaxed/simple;
	bh=Y4wuMa4pk9UEivDBUoPpME4AzypUk+WKj/pJfOMnbzE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bRwsYCwcqbSYebxJbP9mgfJmyWDVnOkZRk8MUgeyQHsB8/N/jC7o0e1IHIEPHIS8zpbJUwRmlxcWtcztDa4pkWLzlzhkpN8PEqbuhajLc38dtLyv1gJVxLCmy7QwifNRsHbnh3rADJLnIPc9To6EemM6pWiThjM6N8SV7yIu3jQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZIpmiCji; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZIpmiCji"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D92DAC4CECF;
	Tue,  3 Dec 2024 15:45:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733240752;
	bh=Y4wuMa4pk9UEivDBUoPpME4AzypUk+WKj/pJfOMnbzE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZIpmiCjiwLwlDyRIiVJR62+aTpPgFw/h414YW8G+OpJD06sOCdCeh71G9SC8tPow/
	 Yo65WtCII7/heVCSGfDNOZRE8ikTYNM+OrWH330fsHJx6hSSU6Q6/FgOqAkVH1wNzj
	 Mieu3GF/0ZIOI8Ywe10/A2TleF9BR3Xc+/g7z37U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Vijendar Mukunda <Vijendar.Mukunda@amd.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 224/826] ASoC: amd: acp: fix for inconsistent indenting
Date: Tue,  3 Dec 2024 15:39:11 +0100
Message-ID: <20241203144752.477559592@linuxfoundation.org>
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

From: Vijendar Mukunda <Vijendar.Mukunda@amd.com>

[ Upstream commit 914219d74931211e719907e0eed03d8133f8b1b7 ]

Fix below Smatch static checker warning:

sound/soc/amd/acp/acp-sdw-sof-mach.c:365 sof_card_dai_links_create()
warn: inconsistent indenting

Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Closes: https://lore.kernel.org/all/a201e871-375e-43eb-960d-5c048956c2ff@amd.com/T/
Fixes: 6d8348ddc56e ("ASoC: amd: acp: refactor SoundWire machine driver code")
Signed-off-by: Vijendar Mukunda <Vijendar.Mukunda@amd.com>
Link: https://patch.msgid.link/20241007085321.3991149-2-Vijendar.Mukunda@amd.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/amd/acp/acp-sdw-sof-mach.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/amd/acp/acp-sdw-sof-mach.c b/sound/soc/amd/acp/acp-sdw-sof-mach.c
index 306854fb08e3d..acab2675d1f5c 100644
--- a/sound/soc/amd/acp/acp-sdw-sof-mach.c
+++ b/sound/soc/amd/acp/acp-sdw-sof-mach.c
@@ -362,7 +362,7 @@ static int sof_card_dai_links_create(struct snd_soc_card *card)
 	dai_links = devm_kcalloc(dev, num_links, sizeof(*dai_links), GFP_KERNEL);
 	if (!dai_links) {
 		ret = -ENOMEM;
-	goto err_end;
+		goto err_end;
 	}
 
 	card->codec_conf = codec_conf;
-- 
2.43.0



