Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 234154315A;
	Sun,  7 Sep 2025 20:37:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757277462; cv=none; b=Z/gBfrZT1KUeIvVFfO7V8nHaiimGcXSFLtojnwWe2guu+QIHvrJTjBgi15j0PZ14gmHYi0QtJIKuda5pB4xngJHSAVWsCoxdUKCTqNvQMoG2KHPelklO9ISxqegrByaM5IKtRf8ehmwO2iL5urSVlNqxY0vw6xBAKsC6LHIaPgI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757277462; c=relaxed/simple;
	bh=E5oaZD2wvApcimzuV3AaW5Avf1bvJ69EPvNG5UWeuzk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PaVM36Y8C03x0rG5Lb6hxAfjP4QbtjIx2BzCd9GaYjHZrN3fB7oFdzQUYO8xFrJpRLUxzEbkMfhtA/84ztJRC5TQLZCZV+1eUbXY6jY6cDWpZmOjWIPeGXxWbypg5+RPknAAyAJcADYA78vujaoxU8Rzqd14UJaNinbNibBhuiM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wQPyFxh5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wQPyFxh5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9914DC4CEF0;
	Sun,  7 Sep 2025 20:37:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757277462;
	bh=E5oaZD2wvApcimzuV3AaW5Avf1bvJ69EPvNG5UWeuzk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wQPyFxh5k/7DJ9YfhVYq6Z/2lGFArCbxsEG38eY3L+VObklHzLytAqFyLEZeeGENt
	 1TZi073EQFx9odbNC4uVP9NjFryTNZqScY76jCqOZDjAqRzFfhGVZF8VBQjzY/EQ4/
	 XmU6pWjhXQ2bxvsuITOiwFNfzjG2TW0HEM8gQwX4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thuan Nguyen <thuan.nguyen-hong@banvien.com.vn>,
	Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 005/183] ASoC: rsnd: tidyup direction name on rsnd_dai_connect()
Date: Sun,  7 Sep 2025 21:57:12 +0200
Message-ID: <20250907195615.928815554@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195615.802693401@linuxfoundation.org>
References: <20250907195615.802693401@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>

[ Upstream commit 8022629548949eb4d2e2207b893bfb6d486700cb ]

commit 2c6b6a3e8b93 ("ASoC: rsnd: use snd_pcm_direction_name()") uses
snd_pcm_direction_name() instead of original method to get string
"Playback" or "Capture". But io->substream might be NULL in this timing.
Let's re-use original method.

Fixes: 2c6b6a3e8b93 ("ASoC: rsnd: use snd_pcm_direction_name()")
Reported-by: Thuan Nguyen <thuan.nguyen-hong@banvien.com.vn>
Tested-by: Thuan Nguyen <thuan.nguyen-hong@banvien.com.vn>
Signed-off-by: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Message-ID: <87zfbmwq6v.wl-kuninori.morimoto.gx@renesas.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/renesas/rcar/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/renesas/rcar/core.c b/sound/soc/renesas/rcar/core.c
index a72f36d3ca2cd..4f4ed24cb3616 100644
--- a/sound/soc/renesas/rcar/core.c
+++ b/sound/soc/renesas/rcar/core.c
@@ -597,7 +597,7 @@ int rsnd_dai_connect(struct rsnd_mod *mod,
 
 	dev_dbg(dev, "%s is connected to io (%s)\n",
 		rsnd_mod_name(mod),
-		snd_pcm_direction_name(io->substream->stream));
+		rsnd_io_is_play(io) ? "Playback" : "Capture");
 
 	return 0;
 }
-- 
2.50.1



