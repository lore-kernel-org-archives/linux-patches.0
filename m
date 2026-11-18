Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017208;
	b=mEXBTQSPPJ68NHAk6ShjDkyYSqp21YOWg+ZdtwcSiuz36R4HukHTifCtehQDvzW6XCTU
	 QxzoD54DKOp8xYxSrhaGQQzTQiXzhnYnI47TY8GQj9gHVwHzR4OkA1pNedO0jExvwIQdw
	 +DI+sKPbdP6X++cyYWzbDGPOeU4I3AJ77sXhqiVtKdubderJcbPa3B5nhXfnfl9E/Od6v
	 YdtgxGFzaCowq2xei1uh1vfdpdeUXa736j0nvbIQJU/4vN+nv5teZT3X0UinxrJ55asDG
	 nsWKe/lr/YCzvfYqYJ7Ed9YliUZEBHBrnXA/gKKIzEwLq6H9U8SIAmbDd1UMZ0ip+ag==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017208;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=pDGDLID0/i/KNQtmOCBhx7lQhDWFSwDBZrNFOolrSEk=;
	b=KzkP4HTDrJWCsMbXTU5z/Sa0v63UXU4JfNeFWft9NN7iEHHLAjFLfoEARe4wucFmnVYE
	 vgD33lHnyGOS3RTfXkY86p29RFwMWV9KwyTTKOsMuFIuLixTEKF/fBgR9lXyxwQNGMEqu
	 ceDHOZ/6BRK3uUeKeZynqk/xOdcDX4bWbS8D8C95N489VbQVX7QyIZsmC/1BljlTbg8z3
	 Amys4sjD2Zifi3dweYJbskfbM65WYxVZEr4OUq6sfcwWHzcutgAVULjSIR0va1FiLBste
	 WV78utNmTpu8oxlFx75/NUDUNHU9qhs77+nBv0eH6CyS9nHNeX/c8w2u3NVmfpFy+jw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=br3OcY+2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20E5B606A31C;
	Wed, 18 Nov 2026 15:53:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=br3OcY+2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48C431F000C4;
	Wed, 18 Nov 2026 15:53:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017207;
	bh=pDGDLID0/i/KNQtmOCBhx7lQhDWFSwDBZrNFOolrSEk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=br3OcY+2b7V0tEXiK1F6jCbpApUFKwVvyZVNDLYM+XkERiYua6TCj0bXdKmRdODzE
	 qmr1D8WXhvqag8o6IM3zLy1nuSYb3x2ZkS98AVylM0/kH1lXSeUy53DHjcKdIAddFD
	 Cp5sM+ggWOfoLeH/bHlxW/k1a0KS66wNsgHygGbs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0802/2651] ASoC: rt5660: return cache sync errors from resume
Date: Wed, 18 Nov 2026 15:34:02 +0100
Message-ID: <20261118150316.751761335@linuxfoundation.org>
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
index edf2e3e346e4f..830498c947e0d 100644
--- a/sound/soc/codecs/rt5660.c
+++ b/sound/soc/codecs/rt5660.c
@@ -1148,9 +1148,7 @@ static int rt5660_resume(struct snd_soc_component *component)
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



