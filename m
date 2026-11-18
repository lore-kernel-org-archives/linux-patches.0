Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795040163;
	b=bKEoXoZDt3nL4GalDb5geK89WXvpjFrX0Lo5WNQJLYS20HKTpA0dpZzPsY2cnYxkAT0b
	 F2uy+irEaqMIpf67jjhgqmCydxNLXYMDBDSeIEuyNNH89nlwA1yetGyWDq5Z4LIX7Hur8
	 LCsqRUHdjmfKdpVuW8aKhZTxw4GHohYqqkjVohw9ZyTZZcNRT0JzF9iJtApXddzGg4vBq
	 V2ggFMRdCkk+v/CkI9AaGTbgeJNXIO+OYm/atzsh0tJxMXJ48q/fqAwB6naEsvFguCnJY
	 ZglZ14iiDOJNYhHyTfamB27qgotD/33qbT8Zm0nUE4ujx7h+rymp0u+ujTJNEfcCbTQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795040163;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=p+1mp03mq/eNXuAnBXKe6kAuaSfJbbl16e5gY5bbuKw=;
	b=TxQ9zhcBNz1JEMesj60IQ+Mbrmr9UvyWI8ZJy2Mxfk05SO0UM+TfpHA4E2BoiU1NO5tZ
	 3voLws8bx0IhdNKKfzEwLeV/I7lMRh4Sv9uI8VFjOxUorNbPSfp0hvne087ttz4FOWdfJ
	 4imKqAq4wJ7X9wTWRlrDGvb0rZqFSGXrRnKZHnAfcNrve2BuT3M/2M3iWMPaxn/bTjB9G
	 OoCRgvJ1BShPdx9z4WXRlbes61epNrMEYGpy0U71abfNYbJxSh55cmfPlGNRh2vZg0zLd
	 9837Kf8gPAItSFqLFXXuMZIoaMfrhrS4/lNTXlIuNLViq18rQXlY6vVzOnENuP7KjMg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="OfTJ/KMh";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 230F2606A31C;
	Wed, 18 Nov 2026 22:16:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OfTJ/KMh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F3921F000C4;
	Wed, 18 Nov 2026 22:16:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795040162;
	bh=p+1mp03mq/eNXuAnBXKe6kAuaSfJbbl16e5gY5bbuKw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OfTJ/KMhnXzS/+te715aecCHGFn3JXKVZtNavKmTP67xA3g9da0gG2TjIqhKsSC7R
	 /6e1WNwCh477D8fkw15Ld0ID/0j9d6ilpirIXM67EFQ22FezsHjoyxY6KxPgWdcRIi
	 bAnpWOCSNpz+XOLM/n2/0uXYHMjI15z+bOPE2zLI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2357/3318] ASoC: rt5665: return cache sync errors from resume
Date: Wed, 18 Nov 2026 15:49:39 +0100
Message-ID: <20261118150432.304277176@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

[ Upstream commit 9f2933d9a437302d5ae32eb9022efef049d8ab22 ]

rt5665_resume() restores cached registers during component resume but
discards the regcache_sync() result and returns success. A failed replay
can therefore leave the hardware register state stale without reaching
the component error reporting path.

Return the cache synchronization result. The ASoC component wrapper
reports a negative callback result and retains the established
best-effort resume state, so this adds observability without introducing
rollback or retry semantics.

The successful resume path is unchanged.

The issue was found by a tool we developed.

Fixes: 33ada14a26c8 ("ASoC: add rt5665 codec driver")
Assisted-by: gpt 5
Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Link: https://patch.msgid.link/20260902013256.93072-15-pengpeng@iscas.ac.cn
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/rt5665.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/sound/soc/codecs/rt5665.c b/sound/soc/codecs/rt5665.c
index 532d1d6958af3..2b85fa94be5db 100644
--- a/sound/soc/codecs/rt5665.c
+++ b/sound/soc/codecs/rt5665.c
@@ -4485,9 +4485,7 @@ static int rt5665_resume(struct snd_soc_component *component)
 	struct rt5665_priv *rt5665 = snd_soc_component_get_drvdata(component);
 
 	regcache_cache_only(rt5665->regmap, false);
-	regcache_sync(rt5665->regmap);
-
-	return 0;
+	return regcache_sync(rt5665->regmap);
 }
 #else
 #define rt5665_suspend NULL
-- 
2.53.0



