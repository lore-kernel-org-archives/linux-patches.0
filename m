Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015685;
	b=43KaxnaDQORhcWUPDtr0rVxZTpi/z1aRd7lo+Ho8kMiAMjFUc3wfa1kDfAyIJGVckaVM
	 JvnCbgqDkJvAkC0viDTHx/V1Jjmx1eYyurgc/1WO8R21+YtMmHLeGNpDCrj4EPymgM7Ml
	 rhXVfwbWtts4eATXdxuTWyWED8+AJmGx4w7ZF2ixa0QKOyxo9WZcNh8fciU5ChAvNWsXX
	 PQzFIjQTDcRBvRG0fiGIp9HPUyhVQfAgOKluTTEdltb1AOVgY0noYGIQiKDRmIElcyOcI
	 QHTacdCoIUEmu2JSaay9xJ4Xkqe6JnniosCZT9E95wEhegtXqAJ7ZH4nu8dCh8wD+uA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015685;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=8iUVpRljTGLwxSL5UPlqfQcT4Avcuxqt0okydbAp0MU=;
	b=3uv86zEk/eMkEwas8nHSAe8kmKwGIMKVYCJhMG0/k9hkoIKGxi4oB16+RlBpz94dJaYz
	 Nh4Z6Jm0eXG4gyblRialpSMcGeI+j3tuQiCARF5PieEFmMSvQRhNPJvNl2L5xDzmt1yWI
	 aI89RhSSAgdv4/jFmIw6KKi7ALTer2JPY05DwWAmgfewdIOT/XdkFJveIoKIGRMnb0WJV
	 R7ZYplCO9lhzbeLIqQ+y/iQt0U99L69nz98fTk2WfQGvPhcbqc9Z241WrvdvdEEUIRdiT
	 Hv+1V2Bno2M7ueSLPjRCxGgnpfQFf6oeYIXBlITEWt2aB/saufTkdbN86UysluCGo1w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wF+vUoIg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEA2E606A32A;
	Wed, 18 Nov 2026 15:28:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wF+vUoIg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF3D31F000C4;
	Wed, 18 Nov 2026 15:28:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795015684;
	bh=8iUVpRljTGLwxSL5UPlqfQcT4Avcuxqt0okydbAp0MU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wF+vUoIgqNpj0Nfb4pF6Q6DUtcSnN8QiVI053ebxshPRnff6IHKGcbFk/rgQBtCHl
	 V4Z9NZmhcH2Te6tk1zkeGr5228G7bhlzFd1W1SNmJuArAMijdK2lpkbq8Hw+F/+nkq
	 MP+3Q6Iq5K3ZTvB6GOBAQ5c1Kxk1Lyeb4zupRafE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <hppiscas@163.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0262/2651] ASoC: fs210x: report register restore errors
Date: Wed, 18 Nov 2026 15:25:02 +0100
Message-ID: <20261118150257.331419314@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pengpeng Hou <hppiscas@163.com>

[ Upstream commit aa7d985d85529049fc8c39c168b300f59de4fdf8 ]

fs210x_init_chip() marks the register cache dirty and replays it after
reset and scene setup, but ignores a replay failure and publishes
is_inited. Its resume caller already returns the helper status.

Keep is_inited clear and return a cache replay failure so the ASoC
component wrapper can report the incomplete restoration.

The issue was found by our static-analysis tool and manually reviewed.

Fixes: 756117701779 ("ASoC: codecs: Add FourSemi FS2104/5S audio amplifier driver")
Assisted-by: gpt 5
Signed-off-by: Pengpeng Hou <hppiscas@163.com>
Link: https://patch.msgid.link/20260906034217.85696-5-hppiscas@163.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/fs210x.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/sound/soc/codecs/fs210x.c b/sound/soc/codecs/fs210x.c
index 510cbeea5b62a..316f3fe80d931 100644
--- a/sound/soc/codecs/fs210x.c
+++ b/sound/soc/codecs/fs210x.c
@@ -610,8 +610,9 @@ static int fs210x_init_chip(struct fs210x_priv *fs210x)
 	if (!ret) {
 		regcache_cache_only(fs210x->regmap, false);
 		regcache_mark_dirty(fs210x->regmap);
-		regcache_sync(fs210x->regmap);
-		fs210x->is_inited = true;
+		ret = regcache_sync(fs210x->regmap);
+		if (!ret)
+			fs210x->is_inited = true;
 	}
 
 	return ret;
-- 
2.53.0



