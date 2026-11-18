Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017672;
	b=geUVlAwqrO7Hh6BnSvclfVM1EDTDihiOx10JTLMi+Xhsh4W4fvOneDkWyGxr68O/pvH4
	 7qEqTLK4jKgj4MQB2JmwTUXzJQiub5r73FFRvowbwhQqFUQoXxNMIaDy9jpuJ5WtgXduT
	 OetcVQUYbMPuui6oP8RgMk7cgzmx8ZS0D30wdg+XfNGWf/PXaM9vvPC51HvYy0jqrmCLx
	 /87eyJJOomscTQcEnQmMA8rjqSFztgulP2YgL7zg23mSa2T8ZnK97BkPJSJmvhCbEyGdo
	 VSCItNiRS3ayrGy7wgd1ki5xl9OlRmRWaz0mhIW3mRmETusnO9R/QVQa8N1ui5tglLg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017672;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xKPetUX9GxG73bNPsBYxUvF7rRG/lM6/vzxY+sT2Xck=;
	b=A/CO1vN7leis7JetoZoAizS7vqczcPiQNqWwPFxuYbxGk3EPdKQr2LKp3TpKeGw9zpTP
	 WlI1XarmaMh8yWOJRjutBJmM21Yj/rOXCWqe2AajGztzbSQi3fnqjrCYyIoFDJAZbzQNL
	 YwET6avLQKfG88e04XtQtKZY3FZaPnx9ayBSBzu+1KZiz1iwznzHew6gMmBA80oNAUOpN
	 D7DEl/Ij3d15wVRV42wM9HeiarlQdIyijNn6UuDnsqDSQjOy2wQDEVaXCV0u6TVmhVI8G
	 ySRepdFCjpx+we2n/dfOnGENsPu8zvDMmzrvqGG7JYCdtg3IonYsRDbTyfOJxRBUekw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=emTw0VyR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 951F5606A320;
	Wed, 18 Nov 2026 16:01:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=emTw0VyR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E09AF1F000C4;
	Wed, 18 Nov 2026 16:01:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017672;
	bh=xKPetUX9GxG73bNPsBYxUvF7rRG/lM6/vzxY+sT2Xck=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=emTw0VyRBzI0WK+tfA0B081P5WgG9FoXx1DH36cwG9BzczS9v4/H4qbRYn+W0ySAZ
	 Hkoitg459DFVNTSK2uAY0EJWnq7JXEBNZzxygXjGdjbYksaEPbqO/fvyTkts01gHgz
	 lXip0DTeD2xL6PokUyD2ozMni4gCjn478fhuool0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0969/2651] ASoC: mediatek: mt8192: Handle regcache_sync() failure in runtime resume
Date: Wed, 18 Nov 2026 15:36:49 +0100
Message-ID: <20261118150322.789792375@linuxfoundation.org>
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
index db0ae44a86afe..5e633e9573a31 100644
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



