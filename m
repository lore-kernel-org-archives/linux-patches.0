Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795040149;
	b=RhN7yG0mJQvvxFAwDBMSiMeOEzffXHk0RXKD0xAE5XOmNMKvH4teirAFJwIqgGEvpO+i
	 0xQHAlqdDgXDjX7321IIAuD5wt+lPlHGDslwXNHLlNtHiu0boN3gmklevoRhy+GbloSKt
	 ACRdPwCAX4Y7Uko1Ja/cGoeJk2da0F283VVE+TwXtdOVuyRM580BJKc0O8m4D3q4hxqA4
	 aehqZlm8NUsjxx5K/QiCYjqeWQtQljo7UsFQ1Smrt3BdPXl6qCuu3RHDcnfmngEaHTEYB
	 gbzXj+AlXJw/ng9fyRfVORstEDF6AXikbtYbGawbiESjOdM0z1gavvZt3fnPcLqvWLg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795040149;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=JIIqRkWhaPf1LHlgCBjhEBUXwAByUA6HiXqB1vI7sDw=;
	b=4vfC8OKptsy9uU0OoCW+b7iZo0SD6zhuKblKjZQec3E5RKpvMw2+QSt1MWbET7ESvEPG
	 jpRxaquSAz6KK8Wz4RPvUYpCEmU6brNlEmxzvxcscYEAJ4JsGKbUbdxmhmab8vHSNsRlj
	 r6mHfwrhxSWv7uj+wwyosSwp7Q0a+K0JPu6dCmS/Vn5Gt7CQXX7ppqxdaSlyd8PFLcBBK
	 ul6m8o2k9B+mS3fQN9mtTO9OEotZgUPUplFpgeT6BamRt0iylhpIXP6p1Szp8D6IFdz96
	 Pq9HpjdfvPk1pAGwuRNg7niedgzMC7b3var54WVWqwBHlnBczfWvFwbF2A0fFEk9+3Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lh9iaLyO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF93F606A325;
	Wed, 18 Nov 2026 22:15:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lh9iaLyO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 498421F000C5;
	Wed, 18 Nov 2026 22:15:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795040148;
	bh=JIIqRkWhaPf1LHlgCBjhEBUXwAByUA6HiXqB1vI7sDw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lh9iaLyOTFFREQD61CwVgu5rZ78MTrj4jOp7bpqY7lvO8TDvYfne3Hj//XJH5Bw07
	 zhdkk0TOs00PyWMdqh3mEr5d/XUTU+ORcoaPgWjo9qysuEf+ClCZcWOnUG/XScVo/+
	 RnGq9cjts85bBeSg8o42yP57+tBL5UWGlXmnfWS4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2353/3318] ASoC: rt1308: return cache sync errors from resume
Date: Wed, 18 Nov 2026 15:49:35 +0100
Message-ID: <20261118150432.194273444@linuxfoundation.org>
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

[ Upstream commit 3db3289178b94056753f7a8c6ee4ab4b232ee6a5 ]

rt1308_resume() restores cached registers during component resume but
discards the regcache_sync() result and returns success. A failed replay
can therefore leave the hardware register state stale without reaching
the component error reporting path.

Return the cache synchronization result. The ASoC component wrapper
reports a negative callback result and retains the established
best-effort resume state, so this adds observability without introducing
rollback or retry semantics.

The successful resume path is unchanged.

The issue was found by a tool we developed.

Fixes: 2b9def8c0d92 ("ASoC: rt1308: Add RT1308 amplifier driver")
Assisted-by: gpt 5
Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Link: https://patch.msgid.link/20260902013256.93072-10-pengpeng@iscas.ac.cn
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/rt1308.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/sound/soc/codecs/rt1308.c b/sound/soc/codecs/rt1308.c
index 86afb429d4235..b3fc5a669f644 100644
--- a/sound/soc/codecs/rt1308.c
+++ b/sound/soc/codecs/rt1308.c
@@ -715,9 +715,7 @@ static int rt1308_resume(struct snd_soc_component *component)
 	struct rt1308_priv *rt1308 = snd_soc_component_get_drvdata(component);
 
 	regcache_cache_only(rt1308->regmap, false);
-	regcache_sync(rt1308->regmap);
-
-	return 0;
+	return regcache_sync(rt1308->regmap);
 }
 #else
 #define rt1308_suspend NULL
-- 
2.53.0



