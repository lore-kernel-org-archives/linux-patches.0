Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 545B4340A47
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:50:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301014; cv=none; b=kSBsLPmtXDjxNFKwZYCJxeGgpKnJnkRm0jUimv30gKkysiLZ7ysAc6IiuDaU4S2OpiPqA2mbyUgR8xin3v7N0+/QSu2ACUV4EgqX/ZE8KF8jxjvQjUzWTiCFhh691pXQ9+GIvyVcmguANLf+uUov6F3oIzKuCH0xEEzHKCeXuH0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301014; c=relaxed/simple;
	bh=dD72bwRv9EvnxG3ePYZccDaeKZRvJ66n7pOMOvsx9hI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GZLTip/URnta1QijwCvTHjHLSDhE6G229TrHnDMMHQP0rJGF0WPLOk3etd5HcnGDTTpYQmvmH773PHgzKax0p6NWHUN/bjtnC1/XEJh+kZpN3pTCfx3IB7pKcDpcxcv0nagq140Ih/xho4S3jvyvVxqAqBhcqVA8pkwdK3rVA54=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KMn3qA7g; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KMn3qA7g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A502BC19424;
	Sat, 28 Feb 2026 17:50:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301014;
	bh=dD72bwRv9EvnxG3ePYZccDaeKZRvJ66n7pOMOvsx9hI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KMn3qA7gzpGdC1FaKstYIjYpCRUiCDIY60ggY+0Cs5YyQJsswyfRsL4NOy6Hz3qoh
	 vcImdj2X455HAYDd/tycYadovlVlj3jzqmQIdpl9iAuT1iuHT0wf9Wzjo2eYIYxdBB
	 dio5IFSSC52h67VYbnAWUdZkM2+ZyT0oBiJpOicsAljlWD8+M8Kjwm7eqJ7sCI7Nxn
	 LHiyL86v8wQyPn6HmKaAtWZNnQHt1BxvuWTNVoP+cpf6HB3Wy77Y98CEbfsN2wjQOy
	 z0D4UVVXL8tWUHq32ryXvbGt3ynRTKCG+y4AF4pN9S29nuvQ6j9pc28sTB7EhhD2u3
	 IiRHiv5TLsU4g==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Sebastian Krzyszkowiak <sebastian.krzyszkowiak@puri.sm>,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 149/752] ASoC: wm8962: Don't report a microphone if it's shorted to ground on plug
Date: Sat, 28 Feb 2026 12:37:40 -0500
Message-ID: <20260228174750.1542406-149-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Sebastian Krzyszkowiak <sebastian.krzyszkowiak@puri.sm>

[ Upstream commit e590752119029d87ce46d725e11245a52d22e1fe ]

This usually means that a TRS plug with no microphone pin has been plugged
into a TRRS socket. Cases where a user is plugging in a microphone while
pressing a button will be handled via incoming interrupt after the user
releases the button, so the microphone will still be detected once it
becomes usable.

Signed-off-by: Sebastian Krzyszkowiak <sebastian.krzyszkowiak@puri.sm>
Reviewed-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://patch.msgid.link/20260105-wm8962-l5-fixes-v1-3-f4f4eeacf089@puri.sm
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/wm8962.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/sound/soc/codecs/wm8962.c b/sound/soc/codecs/wm8962.c
index 6491e098bd212..ab8247ae431f8 100644
--- a/sound/soc/codecs/wm8962.c
+++ b/sound/soc/codecs/wm8962.c
@@ -67,6 +67,8 @@ struct wm8962_priv {
 	struct mutex dsp2_ena_lock;
 	u16 dsp2_ena;
 
+	int mic_status;
+
 	struct delayed_work mic_work;
 	struct snd_soc_jack *jack;
 
@@ -3077,8 +3079,16 @@ static void wm8962_mic_work(struct work_struct *work)
 	if (reg & WM8962_MICSHORT_STS) {
 		status |= SND_JACK_BTN_0;
 		irq_pol |= WM8962_MICSCD_IRQ_POL;
+
+		/* Don't report a microphone if it's shorted right after
+		 * plugging in, as this may be a TRS plug in a TRRS socket.
+		 */
+		if (!(wm8962->mic_status & WM8962_MICDET_STS))
+			status = 0;
 	}
 
+	wm8962->mic_status = status;
+
 	snd_soc_jack_report(wm8962->jack, status,
 			    SND_JACK_MICROPHONE | SND_JACK_BTN_0);
 
-- 
2.51.0

