Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BFFC15C82
	for <patches@lists.linux.dev>; Mon,  5 Dec 2022 19:17:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0EE1C433C1;
	Mon,  5 Dec 2022 19:17:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1670267832;
	bh=+BNRaD0xwtaBsJKRGjoiMqb5s2JYGtHlbf91q7NJndw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E8NKTKkUsimOTNkGJuqfpZjZgiI2lWuZzKa6/FReI9K6UkpmKdCk+uIOo25FCS19+
	 KjBNqdzD2Q3Rp8vVnFgXRpZKgyxSNhzHFxfymBrY+vPjgunPVHGr8b5iTS2ZKxyFJ3
	 e6WxhIW1YFFZEplT7eQ54K6nJaOLTaNePKEWoOY8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 67/77] ASoC: ops: Fix bounds check for _sx controls
Date: Mon,  5 Dec 2022 20:09:58 +0100
Message-Id: <20221205190803.234766154@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221205190800.868551051@linuxfoundation.org>
References: <20221205190800.868551051@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Mark Brown <broonie@kernel.org>

[ Upstream commit 698813ba8c580efb356ace8dbf55f61dac6063a8 ]

For _sx controls the semantics of the max field is not the usual one, max
is the number of steps rather than the maximum value. This means that our
check in snd_soc_put_volsw_sx() needs to just check against the maximum
value.

Fixes: 4f1e50d6a9cf9c1b ("ASoC: ops: Reject out of bounds values in snd_soc_put_volsw_sx()")
Signed-off-by: Mark Brown <broonie@kernel.org>
Link: https://lore.kernel.org/r/20220511134137.169575-1-broonie@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/soc-ops.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/soc-ops.c b/sound/soc/soc-ops.c
index 81c9ecfa7c7f..b734bf911470 100644
--- a/sound/soc/soc-ops.c
+++ b/sound/soc/soc-ops.c
@@ -450,7 +450,7 @@ int snd_soc_put_volsw_sx(struct snd_kcontrol *kcontrol,
 	val = ucontrol->value.integer.value[0];
 	if (mc->platform_max && val > mc->platform_max)
 		return -EINVAL;
-	if (val > max - min)
+	if (val > max)
 		return -EINVAL;
 	if (val < 0)
 		return -EINVAL;
-- 
2.35.1



