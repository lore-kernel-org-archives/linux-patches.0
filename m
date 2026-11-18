Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795040154;
	b=kFzJaCj5KHEF2UunPdAvC5SIqKEB/9E3whuQ7n+4Bap/b7fl0i7QK1FmguRlla7hK98F
	 lvI8+0PHF5GHEtTDxmTW2T6CB+4yAX1AtEsB39wXDUjWhu5wk6x2JvrK17OQ0nb0yJ67t
	 ASL4c7stxRfio2qfvx0JMEEMbNajpzxmmJU+mbK95/Y+aR2EuD0D+sy9Dpa1Zx0IdHWn3
	 r71DJRf0ew9kN4OjFXptFspwiqy+LBVJszj9eJubF67WV2t/GTibn/dcIRpfpqrF9uz6E
	 IO70qmm5kOP8vUhyUpq4gG4kNuzvVTOmultaVMm1B2RbpHTz0MNz5SfjPmZS3uBHPdg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795040154;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=QeTObkvaS/DX09dowiqpCOlQ0BaIcZ3F2v77nW0/jcI=;
	b=s81cdRqPmxP47WIbNF3+Dl5x02/rZbyPc5waJQh7HGh0C+Xqzp1hgYTu5bjJQUjFDpJ0
	 tuNssPAitaY3UB3uUDhlFHXw+iiyeRMaNhnntn+Mvq5SrWY28ZH9dmE4OKn266gVwvYYi
	 17rpJMyiEwoU+ltAB96ueWNyPIwDVPy6EtaqNS+CmVS6RPZ2So/MtUHgxJ8nXs314GGFz
	 9wsDEmQ35BI/8jXmAjnMV2OnOFzxEhl3AupJ3YZKb86EbDVDz9385CvMeLOY4r9y5Amrx
	 2wQFD97j25B8gQO9nxK0Aqeo2zKX5ur+2pzSavKuVoLtg3qwWRU/HxmECCwlSvOnaMw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="h/56qd2m";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8895A606A31C;
	Wed, 18 Nov 2026 22:15:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=h/56qd2m
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E08AA1F000C4;
	Wed, 18 Nov 2026 22:15:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795040154;
	bh=QeTObkvaS/DX09dowiqpCOlQ0BaIcZ3F2v77nW0/jcI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=h/56qd2mDHsdPLeX9um0OfP1niUdYyNg7UogNbZumuwPhmr2+8GCZTenl3/6bCxgx
	 7Y+AP/Dp+TU02zpckOtzZqKVkvZfFajyb27wrP2CMjS5w8eky39QBF7zD/vTMMS3sB
	 EMM3ns61gbTBIRGsulQs8eILXvpp1QEe3NwAnTaU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2354/3318] ASoC: rt5616: return cache sync errors from resume
Date: Wed, 18 Nov 2026 15:49:36 +0100
Message-ID: <20261118150432.220870643@linuxfoundation.org>
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

[ Upstream commit 8fc9d353d5371a946d9a9952278b96c09070374c ]

rt5616_resume() restores cached registers during component resume but
discards the regcache_sync() result and returns success. A failed replay
can therefore leave the hardware register state stale without reaching
the component error reporting path.

Return the cache synchronization result. The ASoC component wrapper
reports a negative callback result and retains the established
best-effort resume state, so this adds observability without introducing
rollback or retry semantics.

The successful resume path is unchanged.

The issue was found by a tool we developed.

Fixes: b1d15059957d ("ASoC: rt5616: add rt5616 codec driver")
Assisted-by: gpt 5
Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Link: https://patch.msgid.link/20260902013256.93072-12-pengpeng@iscas.ac.cn
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/rt5616.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/sound/soc/codecs/rt5616.c b/sound/soc/codecs/rt5616.c
index c13108b51eaf6..6e5053575b043 100644
--- a/sound/soc/codecs/rt5616.c
+++ b/sound/soc/codecs/rt5616.c
@@ -1250,8 +1250,7 @@ static int rt5616_resume(struct snd_soc_component *component)
 	struct rt5616_priv *rt5616 = snd_soc_component_get_drvdata(component);
 
 	regcache_cache_only(rt5616->regmap, false);
-	regcache_sync(rt5616->regmap);
-	return 0;
+	return regcache_sync(rt5616->regmap);
 }
 #else
 #define rt5616_suspend NULL
-- 
2.53.0



