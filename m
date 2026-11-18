Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055363;
	b=4LQu3lcs2WSQrrheEmkbJKIxDJnFsuxe0Ja0dD8QpdElYivywh6DUt0ili7P14wbyPtA
	 +HNmdK5rVCoR3zlfArWCGA58axQpIipHUc+uIHWS5+niPoRhEl/9wUgZcTLkWU5DZ9W3I
	 1v18SeQkm8wzLEwgv/Bx398tEQtunA36MDq+R7/OYCbS2Y9pDY7VkIbEw5Ph4dkQnENSM
	 P3n+3d5pPiTMynFtL/k4bdgd7HmUu6J3nYfkqNYSevqgv4sAkSmkVbJDiw6T/dOjJAFvB
	 GWm8gGweBdTLQHrJBwq8W115v+Mc5B6rekviaFbDzF4sdpdQBAesHQirEeqbWnbDKYg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055363;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=dtDIYB2qIdFBtQXZ9x5o0PM4swFMVsdkf+Ev2OmG2R4=;
	b=lGf0MFNEWOTKi/EqPNRoRVTGR9CD637qCnyosXZRSUPYEZxujH917xdAxyK0ohi0g0N6
	 YDj7GHuhMbPmwkHJ0DEg+0pHX4gEwEsN/GUBJBnPUUHB02SWgG4tU6q4eywMnCkdUbsc4
	 u7UZqZGGrs31Ns5b2gxXYKflcPwzwRiCNwT1HxbbJgmpUFbX0NMvV06dAXyl4DgYGyols
	 VlzyDLGRbOgUPVLDidxRPYhFKDANVGpoEY+36wYu18xZSWBwrptfGEcyQhsvsU4r2hdV5
	 0hK5nkZI7SMCiLnfG/VVPIpfIau/EMVtNw1wTSSfcNumUWkb0Ar54u9Zs7JbhbfwGmw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cAre0IuO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 380BE60A2618;
	Thu, 19 Nov 2026 02:29:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cAre0IuO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 922E91F000C7;
	Thu, 19 Nov 2026 02:29:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795055363;
	bh=dtDIYB2qIdFBtQXZ9x5o0PM4swFMVsdkf+Ev2OmG2R4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cAre0IuOutgorOqrmKyKWVJCdNP1qsfOC5YevXwQBn2G6PqCLlfGYUuytAFtt/p7d
	 YQmPyue1LUc8PW+YdulRgWZmgIUyMa/2XxM1GNTWkKAozX9ybxicKPgu99sd0GiH6a
	 4yECBiNwf7t1KPdQWrj0SRVyocpTLjIyUtC+zca4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1605/2214] ASoC: rt5665: return cache sync errors from resume
Date: Wed, 18 Nov 2026 15:54:41 +0100
Message-ID: <20261118150116.158544598@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 5e00aca0c418a..fb9ef278f1953 100644
--- a/sound/soc/codecs/rt5665.c
+++ b/sound/soc/codecs/rt5665.c
@@ -4491,9 +4491,7 @@ static int rt5665_resume(struct snd_soc_component *component)
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



