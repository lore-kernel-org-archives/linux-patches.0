Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017210;
	b=N3i/DzVIARbyK17iIX7+plGqkyp+FBxFu6Er911l1v8a6QJpEXMAXk+mCopKn/8TytfE
	 LUL0AAHVRKi9Nh1t91nMkTcTKrNU7RfHDXzgFlbbULkg9NWJbTRzpWiW8DLv5ZYb5SXl+
	 C4i67ZNbXko7qOGMzG+NLroMkmvYZ7eaFtNK5J3seF8c/4IUKsCGIz34thpUN0Io2oQAB
	 Zk4QnJl+Z8t0xVLCMV20QgImA+3CvqdvnI3gXO22FCyglRZNthq5mHpBAxFfIdWKREf4V
	 AYrdc5viTdy6mCDDLqxsYCkNJ9eM94Vu97oDYla6ykYC4dn4oe5fwwSkF/g1yFJ6NKw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017210;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/HvlmrsxfklZmX8zMbTRZcFkqXar0FrKum/14VJlFyk=;
	b=1eg2eqJQniNWpk9JTxb6SrAfw0lS8HWmUBWMXwbArpXCVgIV2u9yJih5U8XdtccZMhNf
	 2rw2g44YuJpD4pGjsOzgPAwHKZTADbrxP9z+Rk8p1NvVkkpp7AnRM8pwlhKuib/UtVogc
	 IMHZXG0bXd3cBkOKotd1zok5ABMdjEj1YsXS0TdyUF65dcCcfhs+VXSqwQYNd88WjU1Og
	 eaqhOFWIvebGmtN5KWON3T0MYG95370HsMtIluTd81wiN4OLqDc7O6VRTvxFwGWyOJWah
	 vRZTGZ2b/7jIONtB3sNA4zuIaxwcrlOzkkjQ+4vmazECc+wccXDRnQ9xUIFJfzJ0lhQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kpmvLwy6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEFED606A31C;
	Wed, 18 Nov 2026 15:53:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kpmvLwy6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA3881F000C4;
	Wed, 18 Nov 2026 15:53:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017210;
	bh=/HvlmrsxfklZmX8zMbTRZcFkqXar0FrKum/14VJlFyk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kpmvLwy6caxmdvJsbhBasUvP7J1zWgIWNCvLZBcYWn3ideiEDj4JCJgsd7+EoQimD
	 5OgArGsuV8m5M1XuacoqZqsXMWvYOSL+IrE3DsCLKPtZ3b8PvJiO6zsj7k9RuDdfs8
	 xBnQnF+k5IN59KmmxwFagOFhTuCyzteKwUWdRkIs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0803/2651] ASoC: rt5665: return cache sync errors from resume
Date: Wed, 18 Nov 2026 15:34:03 +0100
Message-ID: <20261118150316.786199740@linuxfoundation.org>
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
index 1d987472ba42f..6e4967ed12c34 100644
--- a/sound/soc/codecs/rt5665.c
+++ b/sound/soc/codecs/rt5665.c
@@ -4388,9 +4388,7 @@ static int rt5665_resume(struct snd_soc_component *component)
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



