Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795056586;
	b=yFnfJ6E+TIAn+s5RvL7A/5FDazH3ZsaEuGTPbSr+ovUHLdLyXJGVnsic6KjOLVhz2gO6
	 OOF9vUDoLqchvH6gNMssOaZ7ruCKO4TN0VxO743FbEiBJtuIBmP/tf24x7wL6tvGZD2g5
	 La0MwWaz7PoWnf3PhookGi4Mb9929AetiiaYQ70DO5B8gUmQ7d0nFGE5YWtcsKIQBHkey
	 mXkinBlTOlS+QXuGn8FEfTuNElKywYbMKx1VoaBcA/zTzllos3meciG/2xt9XWtHihYOU
	 n/GB3WNMJP/KXoCeBVDsafEFXZkITMeOfgqxgSxXte2+Q3ZTWRbYJ7uUoxKWPPWAyFg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795056586;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=AX79/L5rFlL2n7Nhno7fYZnGjq+13vQrMjFWjPXUru8=;
	b=0U1eEXS0Epg+JJkoulKLMoAR+mxxZv8dIBI4vluLTofI/VYQ8qjejoafWo6H0LmgPj9T
	 Vtrey6V4AeOm56jAGAMYJe3gLvuB/vtMq9svPKAwJzWSTICX9brrPLHs+F/7eY7U3JXAj
	 xCRUZhqtUIqSjzqBr5nb5q/ryvQ3shyKzWfP1uMmzTv6BLlJJtXWl5MqGoaowBtBKw/40
	 tlXysQbANLgZG8JxwXDwJYFzxrQ7Zw/VeJglXPCtOiflwniT95GpEk1IrFKKEw0csVZUE
	 USoS7fGkiq8fzxiHoPFKxs8A7v+83dJorBoiL0xy3L8MlvcSM2CvdkvOggxVJS0Fg6g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Przx2Ylq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B441606A31C;
	Thu, 19 Nov 2026 02:49:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Przx2Ylq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 747881F000C5;
	Thu, 19 Nov 2026 02:49:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795056586;
	bh=AX79/L5rFlL2n7Nhno7fYZnGjq+13vQrMjFWjPXUru8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Przx2YlqkwYY8uSdby96w5h+VDq+sKfc1m7eJ1ONa/VOuMotcg7XyyImARlLc4SpW
	 V3vj8vZsyxoTXHBCBHlR+Ds/wfdRaNL33UyHLKSBDZvjkGcZob5jnvBU2eUluc6QT8
	 0+HKMORjeKupzfeHxRc3ei8XuBHen8gIc2P3gc8g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1989/2214] ASoC: mediatek: mt8195: Check paired MEMIF clock enable in FE trigger
Date: Wed, 18 Nov 2026 16:01:05 +0100
Message-ID: <20261118150130.405322398@linuxfoundation.org>
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

From: bui duc phuc <phucduc.bui@gmail.com>

[ Upstream commit a2ae972c75a18ecbdcbf331ddaab21e1a08333fb ]

Check the return value of mt8195_afe_paired_memif_clk_enable() on
START/RESUME. On failure, stop the MEMIF and disable the channel
merge before returning the error.

Also skip enabling the paired clock if mtk_afe_fe_trigger() fails.

Fixes: 6746cc858259 ("ASoC: mediatek: mt8195: add platform driver")
Signed-off-by: bui duc phuc <phucduc.bui@gmail.com>
Link: https://patch.msgid.link/20261014112752.683032-9-phucduc.bui@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/mediatek/mt8195/mt8195-afe-pcm.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/sound/soc/mediatek/mt8195/mt8195-afe-pcm.c b/sound/soc/mediatek/mt8195/mt8195-afe-pcm.c
index 6dbecae658748..432a14683c5fd 100644
--- a/sound/soc/mediatek/mt8195/mt8195-afe-pcm.c
+++ b/sound/soc/mediatek/mt8195/mt8195-afe-pcm.c
@@ -464,7 +464,14 @@ static int mt8195_afe_fe_trigger(struct snd_pcm_substream *substream, int cmd,
 	switch (cmd) {
 	case SNDRV_PCM_TRIGGER_START:
 	case SNDRV_PCM_TRIGGER_RESUME:
-		mt8195_afe_paired_memif_clk_enable(substream, dai, 1);
+		if (ret)
+			break;
+
+		ret = mt8195_afe_paired_memif_clk_enable(substream, dai, 1);
+		if (ret) {
+			mtk_afe_fe_trigger(substream, SNDRV_PCM_TRIGGER_STOP, dai);
+			mt8195_afe_enable_cm(afe, cm, false);
+		}
 		break;
 	case SNDRV_PCM_TRIGGER_STOP:
 	case SNDRV_PCM_TRIGGER_SUSPEND:
-- 
2.53.0



