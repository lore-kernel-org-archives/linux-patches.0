Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795060838;
	b=ii9a/AqlvwU4XF8CrYghwWCrFKpYpkFME5Q4i7Qa8Lfly3/wSuKwrQxgpyjY/D7c6/yb
	 /+LKd6IvXmaLvIuEun3UzJS1BmDCuhc7IZvY8dGuLQILhHCDu5biw3dux1GGHz7A9jypN
	 pSFjhLxL8inuDJdCTxfMulkFWZqeyDzA8CrCyz/JlHialMiWb5cGsPgdVeMKdw8rv8Gbh
	 gq6pU91KS7qjYK4xRMvigbnkqok0DFI+GMW1/NbQ3zEjvV+VtI3W9TsartyzZKHubYwZW
	 W9+rXXkjsLRHX+nfvUIvOXcD1C+gYyYLSe4k5uXTperR68mTAgW3pcFWi/RwsilixDQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795060838;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zrCWPWlzy6QnRT/tkN1XhMELtfzDDUMfvJWB8UGFIV0=;
	b=Nuch+KC9LAEThjwhTK3n+9HB3NLQlYRjczAoo1q04fJX5wJZxYXjJWf7SKiYlsUK1RH/
	 1aOlShlu9xg7d7PQpr9lTnjLhSBYevlZoQTJ5+82VNwDozt7QAHFg72eBubB5y9KPVqDz
	 jlxsPhHkfKA4PurbuKASYCkJ7L6NzPY2Xj/mgrLVhYRvwnIFIgFuVi2w0FSO1LITvFoQL
	 E76JneMfWS1O3GfPjCxDbCm2MliWt9/cI1ENXZKn0dTgvyMPpiS025JVSkCc99cK+85+P
	 ih4uCIJfP13MiUtsI3grRFfYCpDG0XMd58qXwTmPSxqfzSz1bouP7y3wIl/74JnnSlQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RbEEarzH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5DAF606A320;
	Thu, 19 Nov 2026 04:00:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RbEEarzH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E091A1F000C4;
	Thu, 19 Nov 2026 04:00:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795060838;
	bh=zrCWPWlzy6QnRT/tkN1XhMELtfzDDUMfvJWB8UGFIV0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RbEEarzH3C5DcD9+w5o/VW07dQZdzGCXXeEjblEelfx5RBZFFGzbYQQYQgKtCfY2F
	 xBmVJA8771DMmKPpU4z5Phvp1Ot2sbtsr+Ip+Z4y3oPgwaBxsYRHhgjrrGPf6+1vFa
	 YnNNntNBiMIp72JSXAiuBsicmARaotJsBQllETok=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1343/1848] ASoC: ak4642: return cache sync errors from resume
Date: Wed, 18 Nov 2026 15:56:21 +0100
Message-ID: <20261118150015.903929304@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

[ Upstream commit 7142c34ed92fddca7038787b8695d22c661dc6ec ]

ak4642_resume() restores cached registers during component resume but
discards the regcache_sync() result and returns success. A failed replay
can therefore leave the hardware register state stale without reaching
the component error reporting path.

Return the cache synchronization result. The ASoC component wrapper
reports a negative callback result and retains the established
best-effort resume state, so this adds observability without introducing
rollback or retry semantics.

The successful resume path is unchanged.

The issue was found by a tool we developed.

Fixes: a3a83d9a7cb0 ("ASoC: Add ak4642/ak4643 codec support")
Assisted-by: gpt 5
Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Link: https://patch.msgid.link/20260902013256.93072-3-pengpeng@iscas.ac.cn
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/ak4642.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/sound/soc/codecs/ak4642.c b/sound/soc/codecs/ak4642.c
index 3532370255140..2ae562c8142af 100644
--- a/sound/soc/codecs/ak4642.c
+++ b/sound/soc/codecs/ak4642.c
@@ -533,8 +533,7 @@ static int ak4642_resume(struct snd_soc_component *component)
 	struct regmap *regmap = dev_get_regmap(component->dev, NULL);
 
 	regcache_cache_only(regmap, false);
-	regcache_sync(regmap);
-	return 0;
+	return regcache_sync(regmap);
 }
 static int ak4642_probe(struct snd_soc_component *component)
 {
-- 
2.53.0



