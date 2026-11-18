Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795049994;
	b=VGwP9L1QxXN/YwCKJdSm2Hv3EmeaiIJMUijb1RmOwB419ZlsnO0Y1zXRY7xx+5MSnoUj
	 1oXoej0RNdk+yuA1X9ucsGvw5hhf1IoWdDQjGBoxiqREj2gh6T5YHp+HNDEX+PAzujnIM
	 cE8RjdoaOcV3IN5TX7oS0bEYNRWD7RdGqIYE42fxlj+AXyFy1AbKEUxcMu7GAbA3UyUfp
	 mSHRihFioahHxUAJbJPC3avAMmzBZeBGPHVmzWIGRC//Neer2f/B5/rc6zCaHDd4gnsqA
	 jVGZQ+Mr6GGKLVnPKpIfl1hzr3qsYJmrBOpc/X6gxZQmuXe48njrZa/maMg5G8QrY0w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795049994;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=IOKnciXsU8q63o0KsNqYm83OURtx3JoR7a+AXTIorVo=;
	b=CnMhIIc9AHI4YuVRQ+fBnDdQW7NRph7ndV1Zku158qv9Vty/eZrB9TGOR84+K3moYsaT
	 ZO6rlpdkqIhW6sO//FfuObMuqeJblwY/Ioo6MJN9L+TDzSsSYUJHH4/cKAJ/gulT3c3N8
	 TeYVQ2HvwCOvt7I6gVgQV4YH+HR3BD1C3HPDm74pLvyDaWqXHZr5cQEG4DQB76ESx/ylk
	 peZbtZz4C9dkuFFLRoXsme6qfnZ/lkN+CX2nQN1SraMWzfwajz2drBRLQ/N9nicnL5KPL
	 De0sJBiPK9DhbQSLmKQ+eB5hiJlRpXByA0a4Dcah5SJH4Xlfl662zVvvP3T3vPaCDwQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FMKkOdxN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6169C606A31C;
	Thu, 19 Nov 2026 00:59:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FMKkOdxN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 857EA1F000C6;
	Thu, 19 Nov 2026 00:59:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795049994;
	bh=IOKnciXsU8q63o0KsNqYm83OURtx3JoR7a+AXTIorVo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FMKkOdxNA6+gQum5rk81wQlgGZFYHZ/tL+cb0JPuf8YXL9foM9X995aoUutmduOkl
	 OrJacBGevUgOSF/X2FPR9Vl0Tvha8Q5WdkDn3eTXh7cyUK6FZenpf7d6Q9TlswAuWr
	 9kvy+P0oU/hIN2psT84lypsh23HJQezgkTzIlM28=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2551/2857] ASoC: mediatek: mt8195: Check paired MEMIF clock enable in FE trigger
Date: Wed, 18 Nov 2026 15:59:45 +0100
Message-ID: <20261118150333.363743165@linuxfoundation.org>
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
index 5db4cd4743a2e..34b05a4871eef 100644
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



