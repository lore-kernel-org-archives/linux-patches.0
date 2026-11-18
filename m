Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795040357;
	b=AY3ttsufJZm5wvouKpfMaYuEipI024iPY2ObOliEP6DMat69+7+X3pHGzFwTVzYBzQQC
	 gwcQxsUJhzPXapO2D5TRTikL0Jv/5JEZtVNEymJjfnfPt9yOfr1LEIr/ng+AtC7Pu6ZBe
	 XcSpTi+zNpRYeYEY6WT9FgB+tRdpN2Zjc8C2ocYIuqZsI3cmioDDud4vVTj44KagWfQfW
	 4CzHXvwXSSR17DxPy3XC1KTn7p7EfuCnu1rUpgPGAc0Rzq2ZzdYCifYUEUTBNw77ggaYC
	 toXMPMrUMe9bkDNb4EjGKXfp5WC/mDASJULOgDMGQ94fqgMBjVjo1FA2EIBmrWbFS/A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795040357;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=NWiuGmtfwh1XEIKr3dt+AE3Mk7DC39GH+n9JwN6HxUg=;
	b=O29Ys/vRRwC7wI5AaxsmgzEykCMQpRKah4uPh/kgt52ZXIOVq2drXEzsVTEXZYyAxCDq
	 5qxJFjWscTOkQFeqXGQ+X9tMeaF3rYE2JLxYq0c9snbLxWd5ZT7/XKUSCeqLUpnXldVZN
	 q6CoBC0b1pCQN8HPFBkrXij/hCrMdrcwiHzL5GlOvo06cOX0rV9wSXruaa2oXEXgy/xUg
	 dct3lcKwbgnJ4q0Gp7G8ULIkafhUf8ki5sX6rEriyUzu6od7G9sf80jP5ieDmum7I55Z0
	 FwF9mmds3eci31F6jfSLYbOkL8sKACMbhNAg/RC7gTJweUisNs0mtAg/kv6b4OSA0Lw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Uka7yfQg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B30F0606A31C;
	Wed, 18 Nov 2026 22:19:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Uka7yfQg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C5761F000C4;
	Wed, 18 Nov 2026 22:19:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795040357;
	bh=NWiuGmtfwh1XEIKr3dt+AE3Mk7DC39GH+n9JwN6HxUg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Uka7yfQgydDmLO0PD7I0TbLUYCsTdGkBLwIcQF8YRJPbUwWD1IwLdnYogA4g8v/AZ
	 cTzrtWAUVQyk3Dowj7Gr50z9uMZHJCw/8LZg7jmVL9rdg4DQgWb1qhWMaiEBAgMEOg
	 LXRvtQOwATFel2tT1bCUmbKmF4YebzgHJOr/SmNs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2428/3318] ASoC: mediatek: mt8192: Handle regcache_sync() failure in runtime resume
Date: Wed, 18 Nov 2026 15:50:50 +0100
Message-ID: <20261118150434.304650767@linuxfoundation.org>
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
index 988d9b2d28bf4..713870f1f823a 100644
--- a/sound/soc/mediatek/mt8192/mt8192-afe-pcm.c
+++ b/sound/soc/mediatek/mt8192/mt8192-afe-pcm.c
@@ -2104,7 +2104,11 @@ static int mt8192_afe_runtime_resume(struct device *dev)
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



