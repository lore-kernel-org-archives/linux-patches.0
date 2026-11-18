Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048769;
	b=dthnKX6hIVnXREIQJW4LTv2RMKWvSLhU7+S569yDIB8iD+hkq6bgrKYqAfakpZY+MWZz
	 dfoiJILV7qUtGxyY2zbSzwVJHWvObuFWkj7ZAOKNSIa6S1+jf92jD7OSQjgYcpgEMJ8D7
	 dvjl5kEdxBU6Eo5hZlT+2YkDhwhkkJJK+N9FfO1fOtaH+g/P+4oEAoexfM2UUlCtchK4b
	 VULvB06FG+tiCsxHqF6xcsubdCBv0nMRFe7ATQZhMzi1EbBog3TkT4F0vVT7G8BM5KA//
	 4e/J3XzGBYFy6i3WEpQXDgaX58hVW90t7tjGPKeEgHB4p6qc8aFEuk/dM606BBZd6jA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048769;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=NKNSNaG0X3a8mGBVuRKUKlJ9mpsYepMY44/Vnts9koM=;
	b=DoG34VCM9uvZ2hdH7OXorL21ah9RFbWnlhAl9y2sWs+NF+/cpGT7EkaqDWzBxZ5E0c67
	 gjVve9KrYH7hOXaE6cRRXXxQj4G83xwY29bQJ1lIS8FajnE/HlaghdXMg4mAFjFsXVmHU
	 QlMshO5/YYEGWKtGiuAueFB0eVo0JDm+pV6otS8JC+u1bdOzOWrE3FO2X8n30JW8nfilu
	 +6fFvxy5P4qHe+RuwWBL8gGVXcwWZfyfa9BNJGRf95E0BqcZyiGCiUf6qJWBcMNGEpRHo
	 a+QT9GBVzjdUgvJseOXKkcySWPycErzRcqJWg77RJEYO+o8ZvsL9Mk+ABV04/6098Bw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zdFLm1j1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD40B606A320;
	Thu, 19 Nov 2026 00:39:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zdFLm1j1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AAF51F000C4;
	Thu, 19 Nov 2026 00:39:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048769;
	bh=NKNSNaG0X3a8mGBVuRKUKlJ9mpsYepMY44/Vnts9koM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zdFLm1j1SkMzLncy5icCXAETG8lbIGNAs5JlCaOmLr3guhoap6ZL2rFNVGUkgOntJ
	 cy0eIBMLG+Ey7+LoWDrZdCiU1FSVOPcCgF8AkRo1bMRBm0UlKqtGyqEetg51GNgMP3
	 jPjTDb0XoPRGG/qe1n/rXj8YajZpcRFXx7J0iCJE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2112/2857] ASoC: mediatek: mt8192: Handle regcache_sync() failure in runtime resume
Date: Wed, 18 Nov 2026 15:52:26 +0100
Message-ID: <20261118150317.453767477@linuxfoundation.org>
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

From: bui duc phuc <phucduc.bui@gmail.com>

[ Upstream commit d9e264741b041fc9dffc555bc1ab68708658cefd ]

Currently, the return value of regcache_sync() in
mt8192_afe_runtime_resume() is ignored. If regcache_sync() fails, the
function continues execution with clocks enabled and regcache out of sync.

Fix this by checking the return value of regcache_sync(). On failure,
restore regcache to cache-only mode and disable the clocks enabled
earlier in the function.

Fixes: 125ab5d588b0 ("ASoC: mediatek: mt8192: add platform driver")
Signed-off-by: bui duc phuc <phucduc.bui@gmail.com>
Link: https://patch.msgid.link/20260918133912.133799-11-phucduc.bui@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/mediatek/mt8192/mt8192-afe-pcm.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/sound/soc/mediatek/mt8192/mt8192-afe-pcm.c b/sound/soc/mediatek/mt8192/mt8192-afe-pcm.c
index c533b7c7e8097..95b1ea63cc722 100644
--- a/sound/soc/mediatek/mt8192/mt8192-afe-pcm.c
+++ b/sound/soc/mediatek/mt8192/mt8192-afe-pcm.c
@@ -2107,7 +2107,11 @@ static int mt8192_afe_runtime_resume(struct device *dev)
 		goto skip_regmap;
 
 	regcache_cache_only(afe->regmap, false);
-	regcache_sync(afe->regmap);
+	ret = regcache_sync(afe->regmap);
+	if (ret) {
+		regcache_cache_only(afe->regmap, true);
+		mt8192_afe_disable_clock(afe);
+	}
 
 	/* enable audio sys DCM for power saving */
 	regmap_update_bits(afe_priv->infracfg,
-- 
2.53.0



