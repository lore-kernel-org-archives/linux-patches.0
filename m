Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795041804;
	b=20Y0QxYw6OLnsfeVq5KTlpl+ELheBVcm4Q5HPsjXgBWwNQHOkw8ZQKiNAfHnEHVkxVb9
	 7+qN+5oRMeESaptrEzDTAsVYNti4hRSIOIXUQ9ZBiLg88cxGreA2gvWB0euA0eSs85LL/
	 tvC+kGARWVgLL7V2rQsHyeQhOS0joZ+h5XkbSGRAK4aGoEkUcl/tEO7YPqtmQirUY7lxX
	 Rw77uvRN9g5iZ4UBUsAQwQJgt57lchPX5pDyR++RrjVu7YYWBGuSy0pwdMllnyXbmSWeQ
	 6w2+HW1s+qZPoxwwEudFyWTs8vb9/WNc2txF464UNwfSSmOPdNzn9o5VX2NCTUH4oPA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795041804;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=kiUtWfJ7aorUY6CtvyvmNa+D9cydRv2EpXjSji/Ps2w=;
	b=vdmTvqvbpnqU4WOWtV8DdTbGM3W+32Y+bRix4ZXWAYiioMFm+YgDwa+NZPuhO2045lOL
	 8NgBZ80nj0CFbDcDrwIrroMQpRbfXA8duPbxGT7uEA9WzxrHd2zN3yQ+Lk1xsQcfuSqCs
	 Ok9T2iL9SMyQdk9O0IEDIopDHmY7Zbqqc5rgNNQC3DYMLdA936Mm/UwYisFnILJKl1mmL
	 CqO7kia9Sgbijx7DANC2iAT9ND5nDB3692XdqZTW+3bsybdZiGdUdzNfzX5QavXGAbtDz
	 kYiUBNOHG/RZ+g5MXgmIX2FK8B4aa5xAt9qA9K7f9miNOxrf2809bp2n5rHV6/GvghA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bhoMNayM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C351606A320;
	Wed, 18 Nov 2026 22:43:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bhoMNayM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF6DD1F000C4;
	Wed, 18 Nov 2026 22:43:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795041804;
	bh=kiUtWfJ7aorUY6CtvyvmNa+D9cydRv2EpXjSji/Ps2w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bhoMNayMslDcgfczPDZiV3UkbASD/6PiFEP8//Y6xCfUgbftnHcdjI3WRAcucA0LT
	 keBk+TkFJ5YZc25emgjosAmEHVRTOiIQPKWY/2G3EvmVr+U2zT81vLP8HYqSSewmcX
	 5e5HvFgvr3YrzQQ2bnzSozh0KW0yXR0HyvQcDcw0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hongbo Li <lihongbo22@huawei.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2945/3318] ASoC: remove unused substream in macro soc_link_mark_pop
Date: Wed, 18 Nov 2026 15:59:27 +0100
Message-ID: <20261118150448.686970524@linuxfoundation.org>
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



