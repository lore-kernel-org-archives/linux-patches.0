Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795036173;
	b=f5ZLBNocgcv9987XB33AXo55CxCLFCVUWSAqC5NFQZZ1Udqzbb759JT8yt4sLC1wEqOq
	 xqRc0lgBmEwIB4xpOyFHfCcEoxC4t7ZZ6fSdJ/m7VquEflZlMt8TegUf14pHFcfNSM0RB
	 K4pvA9kdds0kdA3ReBy6Nc6NWJrqlSs4X4K6a2X1T4aGIWnfPe7l6taACSXWW8fjLpDgf
	 BO1wfL7S+JMelp4XmCIkpiHR1aqJCPh1BjH1aeDs4GBiqxUEsSvepJVl/YJbFfmlkOqOI
	 QlXPdu1Y2o1G/CUZLkgBbkt4bnV/2NR+zFM6TFo4yDeUsTW/2jVsFKWa6tdERDCwANw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795036173;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=MKbF3zkWPJeeJwWrGGyJYE438G9zh8uSbsSaRDcxDyU=;
	b=rxf9WFP1GJfjgKkLB6BbyY7ykqoL7I0h9obszs8ehpGmwQyjs8zLjG3K/WSc/4z++QtW
	 aYMxgm54OyEWrsLeRRCPZ+VGuPzArcTT7me7tgvCkerUHEN7u6a8AVH+lKU2kVDegLJL6
	 ZCja08GrPnk7NRT5f33EkM8ZIKWKPqbxiRU0EqbsB6wrfBU1o+6z4LhOzr5+uHYMXrb2B
	 75/9joY29ohPXILfl5mT8B4WytXIeUMhY0/JaWCJH3YWfY7pua2EpM1KHum68VctrPhYC
	 6sN+p4xSv64TedvHsE6M5sh9ppAO5twFVZk1YUq3Wk3iDCDc2osEK5YEl1QKJkEt2bA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dcWQ04TX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 650DC606A320;
	Wed, 18 Nov 2026 21:09:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dcWQ04TX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B422B1F000C4;
	Wed, 18 Nov 2026 21:09:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795036173;
	bh=MKbF3zkWPJeeJwWrGGyJYE438G9zh8uSbsSaRDcxDyU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dcWQ04TXTEe6hGN7ACOVIlJLT/8FkjdX0DI3t+qpnCN0y6pIi3Oo38vQR+DVxxxsM
	 lwR0AtGw9HuBDot6ZgKd7ekzfew8Q010yptvE/SpBi5CIYK35W7T2raimNTIW83tex
	 UEByn7MBla8hW3aYCMfl42zQtZUCtFoeFVkrarSU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0963/3318] ALSA: core: Check shutdown flag at D0 power-state, too
Date: Wed, 18 Nov 2026 15:26:25 +0100
Message-ID: <20261118150348.549601903@linuxfoundation.org>
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

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit ad63c5b62843895e8c3cd7291ed07cc659df0355 ]

The snd_power_ref_and_wait() skips the card->shutdown check when the
card is already in D0 state and immediately returns as successful, by
assuming the all-green in D0.  This assumption makes the code after
this sync point behaving as if all power is up and ready, even though
actually it might have been already at the disconnected state.

Add the missing check of shutdown flag there for the more consistent
behavior.

Cc: stable@vger.kernel.org
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://patch.msgid.link/20260929125346.1478631-2-tiwai@suse.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/core/init.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/sound/core/init.c b/sound/core/init.c
index afb02fce36780..09ae2aea74d51 100644
--- a/sound/core/init.c
+++ b/sound/core/init.c
@@ -1147,12 +1147,12 @@ EXPORT_SYMBOL(snd_card_file_remove);
 int snd_power_ref_and_wait(struct snd_card *card)
 {
 	snd_power_ref(card);
-	if (snd_power_get_state(card) == SNDRV_CTL_POWER_D0)
-		return 0;
-	wait_event_cmd(card->power_sleep,
-		       card->shutdown ||
-		       snd_power_get_state(card) == SNDRV_CTL_POWER_D0,
-		       snd_power_unref(card), snd_power_ref(card));
+	if (snd_power_get_state(card) != SNDRV_CTL_POWER_D0) {
+		wait_event_cmd(card->power_sleep,
+			       card->shutdown ||
+			       snd_power_get_state(card) == SNDRV_CTL_POWER_D0,
+			       snd_power_unref(card), snd_power_ref(card));
+	}
 	if (card->shutdown) {
 		snd_power_unref(card);
 		return  -ENODEV;
-- 
2.53.0



