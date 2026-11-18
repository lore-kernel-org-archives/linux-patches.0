Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795045027;
	b=kQgbgA0eT3VByDX0gnNK3lG0d5oDpECDIQbhZQVSAKnTnupQJOM3vSCdBxvdpEjln/e8
	 Fvfzr3/JSVkRWxh5ypudtJoFJf8uUfs6FQfxmbdyBGL9mzZ3KQZXENu6yWAltuhA9K4RX
	 bNU8zAtW8GSrY1rjkX0hI77wlHw+Vs0J+Dz80DouJgIv0dA7fzVJIOkcgbVwNBBa5CKAP
	 2jfE07vkMZzTSWvpyVwMVeULT49lnN9cNMrlEwIkaNNl/IvsM3cLnoiAoGPN8K68udnRn
	 f8Zrg5eTh8pjCESOVu1auIiHoIJDqay00MsjuW5XFYoi++fX8cAr5dC4lunwL+WCqHw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795045027;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=yPLsUSAmcoU2FNSD0PvuPgm5a0UOCZ8+UO/Kxr5pzjM=;
	b=Yro47+bwJDM1W70Xc0EOKR3dd/JShP395rNiafkmix/bTBsSnKqlb7kluGN6MD/HlcKE
	 fv4kmsdNgbwuXHSfV6R4je7N4tUKfJzKHb+cRAjowsPlthf77MxEMG69H5LKpZgfeKLhV
	 VuCXTloPNLC4lQL6I3yF061+St3Csz2SxjIOYlE6KoAGJHytuX8PVJivh+QHYUvFqIOQq
	 IHx+RhgA6J4qUEQjKpW16WdsYFW94EEH47UXiWj8HWl++z8xQC/uxSaeEjXCvIBU4HbDl
	 HWSO/tRHLbJOabY3gx2nIZfoS/ftFRAdJEX9ruNRAUXnGfJXkRGQdYrmEcb1a+Pmm5Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SdKUoHWX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25B3A606A325;
	Wed, 18 Nov 2026 23:37:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SdKUoHWX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 770A71F000C5;
	Wed, 18 Nov 2026 23:37:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795045027;
	bh=yPLsUSAmcoU2FNSD0PvuPgm5a0UOCZ8+UO/Kxr5pzjM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SdKUoHWXggDtwFIrV5iC7/YnptwaPE0XqTUA+tQ/hMRmf2Zieteu2FUhpuYudRh+2
	 ux0l8/bMbzDFtH4SCBf1/07lSI3vVJIEG3e0H6ccnJn3F1NnEjq9XQtwBik/aP7Pj2
	 kpyNPPGaSgKn65Gd6WoE5Oh9ttSjz5mmC7TtWHLA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0775/2857] ASoC: arizona-jack: Fix runtime PM imbalance in arizona_start_hpdet_acc_id()
Date: Wed, 18 Nov 2026 15:30:09 +0100
Message-ID: <20261118150229.474168122@linuxfoundation.org>
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

From: Wentao Liang <vulab@iscas.ac.cn>

[ Upstream commit e04dcb895b4622d67164e218a1179785e2c75999 ]

In arizona_start_hpdet_acc_id(), pm_runtime_get_sync() is called to keep
the device powered during headphone detection. If setting the HPDET mode
or starting the measurement fails and the function jumps to err,
pm_runtime_put_autosuspend() was not called while info->hpdet_active was
set to false, resulting in a runtime PM usage count leak.

Add pm_runtime_put_autosuspend() in the err error path to keep runtime PM
balanced.

Fixes: 9dd5e53d9d2f ("extcon: arizona: Retry HPDET identification for high impedance")
Cc: stable@vger.kernel.org
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Reviewed-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://patch.msgid.link/20260916072900.1971595-1-vulab@iscas.ac.cn
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/arizona-jack.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/soc/codecs/arizona-jack.c b/sound/soc/codecs/arizona-jack.c
index 9c15ddba6008c..62e695bb69c42 100644
--- a/sound/soc/codecs/arizona-jack.c
+++ b/sound/soc/codecs/arizona-jack.c
@@ -704,6 +704,7 @@ static void arizona_start_hpdet_acc_id(struct arizona_priv *info)
 	snd_soc_jack_report(info->jack, SND_JACK_HEADPHONE,
 			    SND_JACK_LINEOUT | SND_JACK_HEADPHONE);
 
+	pm_runtime_put_autosuspend(arizona->dev);
 	info->hpdet_active = false;
 }
 
-- 
2.53.0



