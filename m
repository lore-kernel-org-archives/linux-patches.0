Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795052249;
	b=SlTBkiu5pC3nBmXm1gilA9DLgNu2X0ju+GIrAT8uKXgQs/d9QRFxxBbHSHjWcXUmcp0G
	 CnUUQU+bj9YjgKW4qF2ZINpCka05pO+T7VHfYHWagkLFyn0i6fPCpE0nbrQDx5Uv8Hs0i
	 LFigRjKFcn1yzuubtKVROrhVj5LPspjhqo2BurMHTlMeT2ulX966gPVO1fei7SVfkMqgj
	 e2e2GDl1uQnJG3qi0s2mvgCCGh2+tRSe53oHZjmsstVtD4+uuzenVDXrensR0A+ADCa14
	 r3LAuSj8XoXkEG4+53iCTDGyJY1BvrPKFv1tEU+sZpnrLq5SNBvM29Hqat7dZjXflaw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795052249;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=uvhmgE1IVzIdRWZc5Np9FYsyUZMBOj7gttdww3IO2l4=;
	b=gdsBS/6ucK7BBmhI54cCOyIGPSHb9LgrrUOuBeVMC20jB2i1o4nsKmaGYlPUtH4QmbP7
	 tOD/QPhh4LB1nW7qayd6KysVTgtBhKDlPj/6PUnoSJEXR0DHUL7xGKvnHGj2WD7lf3ap1
	 NkmCz/d4Jnabfrt3W6u/d4pE3mf7lO/7sOjD+FSGxj3ht8Yc+prellDL+1owxnTtyg209
	 NVUYoW/WwW6v3GL1sNCXk3ylYwzALtB3dXUd9X1IA9KiZVjWqgkYHhLLAJLWGWkr+Z8j/
	 6XUP/QGVEMQWR0ScK2kMnPdn9+bTwxzBUT23D60fF9yO2quObzt/nn4eMtKdKrsZSlQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cSMyfgtt;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 965D0606A32A;
	Thu, 19 Nov 2026 01:37:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cSMyfgtt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4B031F000C4;
	Thu, 19 Nov 2026 01:37:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795052249;
	bh=uvhmgE1IVzIdRWZc5Np9FYsyUZMBOj7gttdww3IO2l4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cSMyfgtteNuoVeH98qSPDJtiBzALXf6md9fMzTwoImYYinr4yaCPxi/a6IW9Lv7AI
	 4d2UJgCoagdaWVolPuC/iEXXDZsJ4bzfujnwD90VKGNNy6aMoJk6WOcJLA9tv8cg+B
	 tNbYzSKVlQ3ltGVsUa/Ur+etXMfZvlwQpLBqWfxg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0496/2214] ASoC: arizona-jack: Fix runtime PM imbalance in arizona_start_hpdet_acc_id()
Date: Wed, 18 Nov 2026 15:36:12 +0100
Message-ID: <20261118150031.009325918@linuxfoundation.org>
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



