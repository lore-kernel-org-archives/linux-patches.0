Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024384;
	b=IJSDDM+q9Ja9/ba0Uou3yRB+Tl1NPCsiY6z1jBRb+kiT9ChXzBgQT94mqRBCPcU+cbSa
	 BX0g1NP3c86+IMUnG6FDg5Jq5gHL/hZi+NIQNoAuzC9GmcsG2QVVRPcsfG6C4bAinBUk1
	 M2ynFum7iju6NgWATQ19vdlheUPdrMmg7ZmJnlhx+zOCpC5qs5ZWRkYC5hmSez8n7qWH+
	 jliwd11N67QkDYNTJ/dI3uNVFk/YUE7dMni0G2g0MUeYp8I3yK4+ZaHi55iPgIjd24PAN
	 QwLCjhsA/C5t/MBbqQhX2hcnB1Wckik8jCDD4xHDOWQIqKgGg+LZa3hRnuMkPEe27Fg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024384;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/wnBcFi5UdHGRvqtB8jY+vSb8DC2SRrRFj+YS9plVZY=;
	b=gogDaRisA0g9lmXpB5FprMFjejy20AxdJwIXvYYpUYc4bGod4e8hMsJFQ2+opPTPeMaf
	 nhiFtQbpoMBImtIpjUVaF+llpDsfSKfjrQdC3Y6fDyUmKDOv8qAJfECJf9SF444rR+4wf
	 8DpSsdbcEwQyzVryRbzpJzWhCxqus01VXPxGbTxv4F7ppc3HsYSndZLuibVVft3EgBgJA
	 YPuOCOyWQ0i2phLyD9iTUi83xK/e711RxtPBSaslnnVViHiF/Q+oVQdSxZnoIbqs9JVRU
	 L80XR4m0j33DA6GdbTgObQXNSWMM87vtttII6a0rmTR6vbLlHIbLcEMAhTIWEbGh6bw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TEUairvp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 158D7606A32A;
	Wed, 18 Nov 2026 17:53:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TEUairvp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 214F31F000C4;
	Wed, 18 Nov 2026 17:53:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024383;
	bh=/wnBcFi5UdHGRvqtB8jY+vSb8DC2SRrRFj+YS9plVZY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TEUairvpkSFguYjRPxqam4Nz6cABRXNHfBkORRcO1DKMOLIiKHIYc5zYFK981oc53
	 ttnUufqGAmrQzQ6I5xrzajj8UIYhj4MnSK5rk8xXymlsKZiCfZ49P0T/zJM6jbRGGQ
	 biyXATMh9dWRxyBXS92lFDX8THvbGGo/mqCHZack=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0707/2151] ASoC: rt5660: return cache sync errors from resume
Date: Wed, 18 Nov 2026 15:40:42 +0100
Message-ID: <20261118150147.631870931@linuxfoundation.org>
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

[ Upstream commit 70fe8997b03078ff8253d985a161fef310f7c346 ]

rt5660_resume() restores cached registers during component resume but
discards the regcache_sync() result and returns success. A failed replay
can therefore leave the hardware register state stale without reaching
the component error reporting path.

Return the cache synchronization result. The ASoC component wrapper
reports a negative callback result and retains the established
best-effort resume state, so this adds observability without introducing
rollback or retry semantics.

The power-off resume delay remains ordered before the cache replay.

The issue was found by a tool we developed.

Fixes: 2b26dd4c1fc5 ("ASoC: rt5660: add rt5660 codec driver")
Assisted-by: gpt 5
Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Link: https://patch.msgid.link/20260902013256.93072-14-pengpeng@iscas.ac.cn
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/rt5660.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/sound/soc/codecs/rt5660.c b/sound/soc/codecs/rt5660.c
index 44c3a3b92f98f..0111a497b32e4 100644
--- a/sound/soc/codecs/rt5660.c
+++ b/sound/soc/codecs/rt5660.c
@@ -1147,9 +1147,7 @@ static int rt5660_resume(struct snd_soc_component *component)
 		msleep(350);
 
 	regcache_cache_only(rt5660->regmap, false);
-	regcache_sync(rt5660->regmap);
-
-	return 0;
+	return regcache_sync(rt5660->regmap);
 }
 #else
 #define rt5660_suspend NULL
-- 
2.53.0



