Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795050080;
	b=l56rjEp7YvcbL+0MBeespRu0tJMqFytgCfwEDj9AxEWY0TwkSB2IWP904cPejz52v+vC
	 XwBBrIZCvaaF69fTnCH6ei8kLVpNf4cbnR3xUFmGZby6NiZypB3sGmW+kp+/ls+A95FbU
	 l+p1MR+p/mbGoPyAxvBlTwSbtrZePRGEYJv44xZhP9XPvnXEVJRbg8WcyNync8VRsyUgz
	 2DdsSzi6R9cu+M9bkic5XBQwxPgXXGQUbk3/SbaRvsg8nbJFd2H4SiJXgA2geMuprTXVf
	 uLZf3MzW40oqjL8I/ZTW2zn+YE449YhSdYirSZR1uhhY9CyLVa+x1WGzZVcBIgmC7Sw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795050080;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1OmmsolQ6r6/t3WtofMuy1De6ncgMZ2zd/s5K5Ee9pU=;
	b=RQlcw0BoULCYDYGKDTmQQDlbbOm3Sx7Z72/0XUifPBk4bmXSRmREZKwSWlU2zJihSFZo
	 CqYxMBbBsL9AyTn9IsOS6mRmIcRpUk3UO8H1XDQLvqUhp55+lFEIhEDGnJOu1guaC35PO
	 t6W8ID8aUmVfB3c+N6WPNykAA5vvHv1/13VO2FDamenLptJNMY3X9pOEmeoG+hjkebt9o
	 ArQful4c4CJxEZXLNWnDReZ3+m5ue0EiBO8jHxVOHmFmjDiy7jmzMaA/0aJKTqFziNiC3
	 uFsQhZIa39QG+QtG6LJ/ns90qMaAITwpFQSZ57EcRTM11h02T6+mugdCP/hxzQrpE7w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dhA6OQDk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 979CF606A31C;
	Thu, 19 Nov 2026 01:01:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dhA6OQDk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 996F91F000C4;
	Thu, 19 Nov 2026 01:01:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795050080;
	bh=1OmmsolQ6r6/t3WtofMuy1De6ncgMZ2zd/s5K5Ee9pU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dhA6OQDkCgK6s5VK7nZTqJe3ILZqKEw6u32yPvvUdg//alNiW9svkqFN40f0hTKI+
	 6cO4Qytjnik+X+jJ6CzP1BIiZ5aCHs97kLEPxpmeJQb2o1N+cIFNk1ribIk84kOYgP
	 Ko285Z7dhWDpdNh0YmHUnn3HUXDUfXWbLDpX/3BQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hongbo Li <lihongbo22@huawei.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2540/2857] ASoC: remove unused substream in macro soc_link_mark_pop
Date: Wed, 18 Nov 2026 15:59:34 +0100
Message-ID: <20261118150332.980986991@linuxfoundation.org>
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



