Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048577;
	b=LQeFl7Z8hIZDQh6995AZLypRZq+HfidV8mV9dfbvGLiN16qGEIzO/Q+Vj/BcO7JGxbbw
	 UlpHqhuzUDZNhQlchYGoONsL/3EMG1vl0F9hy2L2fpt/XihnLSu6JUsF8+6Ace83cMAci
	 KSJkm9fwKdXBWp62HmAftyDaaPnaiYwsP0cMW0Q9zdnt5OY2dfIdaMVkQaSK9OZOxDl8u
	 UVUp08OZmll+bizCohKN6zYfvf0laj0mcMtvSxfOOBee4z2LXzHkosLhOoZxWxdcld7SU
	 pOjfnyKFjmhxcda5SvbiAGSBgi8Yglp0RvpHcF8KqlAyDu03FU1UiKJmqFXyurny1Vg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048577;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=BOXi5qnhvkWdzFEVGajxnXNYflDfCOAYqWGfxb+Hn3w=;
	b=GMV5q+cOUw8CrQ8sorjUw7HDlFVRmahmetup6j1NN482iXViw/t2tkvtH5plq2xCBvFA
	 vVyReS7zzzYdsBxe6pKVrn5C/hsSns6j2Zb2XCz/9xY4NMotMcyH3p78Gwp61uXUk1c0g
	 DPo5H46I2OYw1dQ4lQ/S+p/m2x+BpjT0PW6KWaeaJkfsKHLL0q2w/h6KAhfpcoKohAXeE
	 A97ur244RXYgRf2wb0az/HffsgHBbcvgBOSikxnXwW9M9MnInLYF7b/GnwYv6Z10iTrKw
	 NSVvBBldXhzrTccWBmDyKmEKDiBwnBoI32rFtUPSbiJNOoxOz5Q/xe+lH+X1OVBpphA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=td+al798;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6EED606A320;
	Thu, 19 Nov 2026 00:36:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=td+al798
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35C501F000C4;
	Thu, 19 Nov 2026 00:36:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048577;
	bh=BOXi5qnhvkWdzFEVGajxnXNYflDfCOAYqWGfxb+Hn3w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=td+al7987ChUzYF2vAXO76b+2tp/6rTMAH2ISwUGmBuEkCAp8WfMWnklCWVJIMgTW
	 mstB8SKZZYGIm0j2/jheHC5bv0BDvjunEqKEfF+J6BCKWsK4SNTxrvNmK+f7ApUDs/
	 oC87xoz7J/WNhqukoAY/DpkNf21twFrOy6ovRbtA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2045/2857] ASoC: es8316: return cache sync errors from resume
Date: Wed, 18 Nov 2026 15:51:19 +0100
Message-ID: <20261118150315.047461357@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index c4e4ab93fdb6d..3df9af9ff7051 100644
--- a/sound/soc/codecs/es8316.c
+++ b/sound/soc/codecs/es8316.c
@@ -777,9 +777,7 @@ static int es8316_resume(struct snd_soc_component *component)
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



