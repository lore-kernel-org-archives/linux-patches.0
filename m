Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024470;
	b=QEwnngwVNBb3aH41tA+aZXdGEofPjTKOB+5tBkfxPELtNBtpvkQTPwg1p1n2mrUki7xG
	 e94S88pWCOiP6AZ68NAEbxeQ4hWnNz2aWBb4dUkxDly1QaI7k8a3tyqfjCP+HWrsltNyO
	 FftlvjWvww93g7d+ilXBAE1rXIsDlrrY+yX3Ti0IPBdDO/3yGnZy/Wom0F08awSqmoEmg
	 c3URxIKUT/xughpFJAGtl6KlKtw35Pg+lol3Vtfxs16HT96ljQBH0Cvh3s0zwziZS8eRo
	 zNtTufaq06oprTQUb0fMRog5wDqf1qedqf07c9CuPzZre4QDQfBg2+99Hh5NiWCrgkg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024470;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xGIHYgdWGe4MKePr5FJAc5/RLHSClbgdLHkjVaVtCcQ=;
	b=KpTnOTFuXt90FkA1kTgIn3Wap9cOwPTYS/4Pg+EKO3a0jL65v4SJFuRdTadi8cUI9Odl
	 5o98c4FNcw3o2eRfo9V64XWqm5wwOuRjpwWmdByaKYX0y5BC87i9ZyoPit4Ko9ZMwSexk
	 hxEnhgorUF8tsyrRvF9cjy4jWF20cy9CgR5XZpRTSvRn48j89W2EwOiF05FJpAMLgipGP
	 RQhGC+qHzmo30MwB/xi7WIFXsSvZBDF79QZMy9dPmNJzcaQO5ST8/lUHwRQNZeKHEXds8
	 ys/BNH8VQiVjyC4pcgRh0QtKaGUw1s0AgpKuSgana/bIAHhj5dU4sJG5zx/Wuin7iww==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="IQKypL/W";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 971AA606A33E;
	Wed, 18 Nov 2026 17:54:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IQKypL/W
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B018A1F000CC;
	Wed, 18 Nov 2026 17:54:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024470;
	bh=xGIHYgdWGe4MKePr5FJAc5/RLHSClbgdLHkjVaVtCcQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IQKypL/Wo4zZdu/WR6OpHRTMQ0k6MAwc6VXnw9xkPhGslDhVsWdJ20wdn4GDBb8Ur
	 +f7IC5Ff0qBuG0upguopcaRzcB3hfK/PnWKfsyf87xy9/lLcvtwz5QZLF5Dx+zKXQG
	 aIl3WaIpfTRGYL9Z7Rws/0jpMCTJaszjjLWARHDw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0697/2151] ASoC: es8316: return cache sync errors from resume
Date: Wed, 18 Nov 2026 15:40:32 +0100
Message-ID: <20261118150147.163340395@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

[ Upstream commit 243d0c47e57a6af89d95aa451ef5fbf453983b1c ]

es8316_resume() restores cached registers during component resume but
discards the regcache_sync() result and returns success. A failed replay
can therefore leave the hardware register state stale without reaching
the component error reporting path.

Return the cache synchronization result. The ASoC component wrapper
reports a negative callback result and retains the established
best-effort resume state, so this adds observability without introducing
rollback or retry semantics.

The successful resume path is unchanged.

The issue was found by a tool we developed.

Fixes: 4bac47a7b2f9 ("ASoC: codecs: add suspend and resume for ES8316")
Assisted-by: gpt 5
Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Link: https://patch.msgid.link/20260902013256.93072-4-pengpeng@iscas.ac.cn
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/es8316.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/sound/soc/codecs/es8316.c b/sound/soc/codecs/es8316.c
index e7bd561a8f40d..61414bebe3d15 100644
--- a/sound/soc/codecs/es8316.c
+++ b/sound/soc/codecs/es8316.c
@@ -808,9 +808,7 @@ static int es8316_resume(struct snd_soc_component *component)
 	struct es8316_priv *es8316 = snd_soc_component_get_drvdata(component);
 
 	regcache_cache_only(es8316->regmap, false);
-	regcache_sync(es8316->regmap);
-
-	return 0;
+	return regcache_sync(es8316->regmap);
 }
 
 static int es8316_suspend(struct snd_soc_component *component)
-- 
2.53.0



