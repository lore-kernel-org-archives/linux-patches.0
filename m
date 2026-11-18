Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795032105;
	b=XLXfJoxHcpyTMckrHypseRznu9zwx6mGrp+pmDVhYlYiOmwI5842TBWdVOTtyjdzCMFx
	 7ar2+/MweNXZAv4BuZEaOhtq6CXewidCdo62q/bxqjr9XvTL7W7x11DMsPcjDHEsEAY9a
	 zOZ/hAzam/OnzfN6PnhX56jyrN5paKLLNiHzza+LQ6zU7JoE46tJ+b/qFEfz9oca2WCkd
	 6FaQb8WxqaIKgJfQeUiT7KmKiw4hjiEOgo9nSrUvXQYY9NpBe4pyyrXVnK1E86GnkRT/j
	 d3yeL5IxvHrM/aVvYPgTJp63qgnCzaWsfvjJaCtI7bjDvwaSPxak6ecwgUo1QqNV0CA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795032105;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=W2TtHZJEWZby5LJ6wK+LksH/LKIFgVBy2Cqw7orkWU8=;
	b=49rblUtb1r4vt4cFvmZaSO2otaNbjx9hBLpWlkiRImVWf8tUBS4u3RT7hKQrMVB8+oSD
	 RiZsTIFcAjh2AlWeD1KJTLT+RbRce9zIfrqcG3QQpwEjeFAkHu0KL42ylIBf1zt4oEzLh
	 ZiYs4wvakyubACW5cnLbZ2dEY7i1msoNwhLqGYkNrhQBHuURm//0quULF2Ebj88+iWWic
	 dqbVNlTKXHkomPyguSw6vgNyFuSVXX6clZEMLlZzQ0dsIfC9aRs5AHupw2m4eEg7XFBNC
	 u5u1tKEYpnINYdKWweWy3B/CXLev9pOEY2gHG8WEEiwCX7CBFw/tmy2xZacQaAd0t8g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DRMLxMXy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B7A2606A31C;
	Wed, 18 Nov 2026 20:01:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DRMLxMXy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FDC11F000C4;
	Wed, 18 Nov 2026 20:01:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795032105;
	bh=W2TtHZJEWZby5LJ6wK+LksH/LKIFgVBy2Cqw7orkWU8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DRMLxMXy8agkg/91lBIlb6olcJBGJo61+ZDsCeVsBx4RG5FhReJ+nwNffHZO/TX75
	 QImtmNUBNr68iYsW6RQHpays4oJUrKLTPJa+1QnUBMjvoCWXgxETX3V/RgCqueyfir
	 mHjIn87BpyfRNmUEcUX8uvjX84pwzj6RQmsj+YA0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hongbo Li <lihongbo22@huawei.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1295/1756] ASoC: remove unused substream in macro soc_link_mark_pop
Date: Wed, 18 Nov 2026 15:57:02 +0100
Message-ID: <20261118150101.086899214@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index fee4022708bc7..7f1f1bc717e2c 100644
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



