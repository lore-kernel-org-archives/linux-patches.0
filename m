Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795056410;
	b=rPRhpymrCer618Ddsj1xhLckDs7GygST91hT6lnHtEFTWHcMvzuTENmzZnOoSCBV51ra
	 /Z9SbDbAV3LblB7zuSKlicez2Db3hStSiJUAbknVd2q6dheA6zYBIserHuwO5+0F8Edf+
	 Dkm9d5jT3z8/tLb9IK72LaTTEAIZpEVaPD5vCMWCZ4johfzvVawDIu9kmZFwlNAvvADxr
	 WNJExo8sYinjMs3lZLN1IyvCmsxRRwje5llRPVBpZYUn1tBpaSyQB8hsfN1P3dssYm7tr
	 Jfoibcjfju6ekCuTgAxqQCdeZfeet8DeFubUbdegfQPgDQAphFfpLx1Z7vRcUMKW56w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795056410;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Gn0mfGq5UBd92waJdxF+NdbWZneKr22hhuHBYh6ggjU=;
	b=rQfIqfj2yWqr7/QVuC+500QBzTi3Wit9Cww7NTCVZOIGPf4xe1NGXGn2iwWQaFRGJPDY
	 2Ge/bKlUkbBfEI39Fbng8uqQIbTlNcPmCBEOI4QbVokj1doBfrFw6/8JWgZuY0VSMIgLN
	 GWe1x9r4ExJjTcmnobwZREOVUG0yTShUUq5Zqnnura6YD/4OeRPQN/kthvt4bM+s/0CJR
	 PFtlm+ECVIExjYY6Pd2qIaIEKlZUIQpYntxnhyb/oxSiWNts6E8iTOHpVqSN0ts/ZGMqE
	 f0IeJwcIyoz85h6ZPYjPa25KqZsov2YkxIh3b0CkqVddHZxwm+thY1t1h6iWXOIspUQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qYTnTbOv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA8F8606A31C;
	Thu, 19 Nov 2026 02:46:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qYTnTbOv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 050461F000C4;
	Thu, 19 Nov 2026 02:46:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795056410;
	bh=Gn0mfGq5UBd92waJdxF+NdbWZneKr22hhuHBYh6ggjU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qYTnTbOvsKOPx7du/WtAHQQx04Sn0VfkhmE+QWjaNC/T7k2LFfD8qoCpgr8b4AGBY
	 uVzvKaECObO5EOKXXbFO7irlDvUfnm7P/KTl1jdRRrYpyZ6+xTuTiA8V/5M0HM3Wct
	 vZcJuAbvZs5eW3j1YymY+SXojE/VjqxuvwWfIvFk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hongbo Li <lihongbo22@huawei.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1977/2214] ASoC: remove unused substream in macro soc_link_mark_pop
Date: Wed, 18 Nov 2026 16:00:53 +0100
Message-ID: <20261118150129.973952154@linuxfoundation.org>
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

From: Hongbo Li <lihongbo22@huawei.com>

[ Upstream commit 2f12d0de77b99f0f35755d16efeb12e6f45e5710 ]

The soc_link_mark_pop don't need substream, therefore we can
remove it.

Signed-off-by: Hongbo Li <lihongbo22@huawei.com>
Link: https://patch.msgid.link/20240821070815.2326534-5-lihongbo22@huawei.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: 7ef99fcfbbac ("ASoC: soc-link: Correct stream stop operations in snd_soc_link_trigger")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/soc-link.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/sound/soc/soc-link.c b/sound/soc/soc-link.c
index 619664cc9ab95..e6d806591bb13 100644
--- a/sound/soc/soc-link.c
+++ b/sound/soc/soc-link.c
@@ -35,7 +35,7 @@ static inline int _soc_link_ret(struct snd_soc_pcm_runtime *rtd,
  * In such case, we can update these macros.
  */
 #define soc_link_mark_push(rtd, substream, tgt)		((rtd)->mark_##tgt = substream)
-#define soc_link_mark_pop(rtd, substream, tgt)		((rtd)->mark_##tgt = NULL)
+#define soc_link_mark_pop(rtd, tgt)		((rtd)->mark_##tgt = NULL)
 #define soc_link_mark_match(rtd, substream, tgt)	((rtd)->mark_##tgt == substream)
 
 int snd_soc_link_init(struct snd_soc_pcm_runtime *rtd)
@@ -94,7 +94,7 @@ void snd_soc_link_shutdown(struct snd_pcm_substream *substream,
 		rtd->dai_link->ops->shutdown(substream);
 
 	/* remove marked substream */
-	soc_link_mark_pop(rtd, substream, startup);
+	soc_link_mark_pop(rtd, startup);
 }
 
 int snd_soc_link_prepare(struct snd_pcm_substream *substream)
@@ -138,7 +138,7 @@ void snd_soc_link_hw_free(struct snd_pcm_substream *substream, int rollback)
 		rtd->dai_link->ops->hw_free(substream);
 
 	/* remove marked substream */
-	soc_link_mark_pop(rtd, substream, hw_params);
+	soc_link_mark_pop(rtd, hw_params);
 }
 
 static int soc_link_trigger(struct snd_pcm_substream *substream, int cmd)
@@ -175,7 +175,7 @@ int snd_soc_link_trigger(struct snd_pcm_substream *substream, int cmd,
 			break;
 
 		ret = soc_link_trigger(substream, cmd);
-		soc_link_mark_pop(rtd, substream, startup);
+		soc_link_mark_pop(rtd, startup);
 	}
 
 	return ret;
@@ -209,7 +209,7 @@ void snd_soc_link_compr_shutdown(struct snd_compr_stream *cstream,
 	    rtd->dai_link->compr_ops->shutdown)
 		rtd->dai_link->compr_ops->shutdown(cstream);
 
-	soc_link_mark_pop(rtd, cstream, compr_startup);
+	soc_link_mark_pop(rtd, compr_startup);
 }
 EXPORT_SYMBOL_GPL(snd_soc_link_compr_shutdown);
 
-- 
2.53.0



