Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795027010;
	b=aoQnoRhuqh71azsUJP2YClMECpdCtfQoBIrKTN/nYBsdGkMK+jxmV2Nak2t78uZYSe2g
	 hnzDlbyG6AUXo+O+mxeToGMMJa4gEubfbjXHTLKHxuRMj6z5MvQswW/04wMzvaOFHFFmo
	 GCLAeOCZKfaJHjxr11GuO9/iit9Tbwmc9O1uJDiITOEegs8ZVT1NCVWMyFjG7qbKAYtwL
	 1UY15nefbrg0YX32j4VUHiolLJzxiKb+dVy5wlijK+biNRUBeHaobt/HULmrvrPDoeGgK
	 5of4xseHc01ynNkh2XJ6lamoLfFnbJV3/vHZ8OFdUY6nrDcqZSnqUyZ5afs0/5sBxUA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795027010;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7ZXcvWdoK2Rlmr1GgPJjQe5A//dw0qCJFC9dV+I+H6c=;
	b=vUZywk22uKCQHHXbI3lK1pMAEWcmAE5Mz8KKVa3mkiWmxgos7UdYeOLY5ccTU9jTEsNd
	 mlc6jXx4sdLsxkzJMhVBa4zYHWkBgWj6Rd8qL9HRHO3kTVjIAGKPqklMPIQ19XB78Z/S/
	 UMKseYzeD7vInlGzv2cUSwUkPm667sK6rwfHRzgF9rBeWQ7N8YgPJpDHklLmNT4ECQKvj
	 OOUcmK/VQMdxeb7p6WBkvZv/6e00oQFREsH6ElOFmmEt+Z2HXVnJxAgboPAqbuxjw5ZQy
	 dzinhf2m1KinqM1WdOyFRl8vX0xIkElS+w0Vvlbj8q+h3MxJLXHlWz53gMY6gG9aF0Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=K70DpI7y;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4A0260A2601;
	Wed, 18 Nov 2026 18:36:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=K70DpI7y
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3CD31F000C4;
	Wed, 18 Nov 2026 18:36:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795027010;
	bh=7ZXcvWdoK2Rlmr1GgPJjQe5A//dw0qCJFC9dV+I+H6c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=K70DpI7yEHvZdz3AAT8M8CG6poJNufCkFCSRa89Fo4sHtmynhU04tGbCZxVOHEnwp
	 ZVC2srfRwci59z8EkiUawBsNJpW1ndo6En+ccgITMyORndBKKSJl5Zu4NAqA8vxIiS
	 Twe6ESxcBgyw7PrT7wgQJ2ygyj0FejOe2QCTtM1A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1637/2151] ASoC: mediatek: mt8195: Check paired MEMIF clock enable in FE trigger
Date: Wed, 18 Nov 2026 15:56:12 +0100
Message-ID: <20261118150221.498397470@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 5c4e40713fce6..0d66e1b6dd3c9 100644
--- a/sound/soc/mediatek/mt8195/mt8195-afe-pcm.c
+++ b/sound/soc/mediatek/mt8195/mt8195-afe-pcm.c
@@ -466,7 +466,14 @@ static int mt8195_afe_fe_trigger(struct snd_pcm_substream *substream, int cmd,
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



