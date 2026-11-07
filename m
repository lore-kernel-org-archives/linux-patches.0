Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062391;
	b=oQ/Fw5BOXoPLg4spaxsEq3zOdVpS+GjLEcIMu9ho939OBShkgHTgz3cDUiZcCJ6iK27W
	 fG9G88t9cYCxuosnHuKnmPOL9TRHfiChQr/2gpLAIah7fVZUy6AiE1Kj4bOhuNF33rBfV
	 GKvCc2l52M9IKzMjF5A5U8BF5afxw3SMLFWnQSvl+nb1814FST3vDOVkLC0srSJylWEbN
	 +nJw7MzM6HtA3Kklr1BbHHPhKMrvcaBfTfNkpTE8DAq3nVfmXCKezuD+baVyoClaNap8v
	 LmvdM8ToarI3RwWnoD7aUnNkJawUavlE3v4qNLorN0wMRomIlmJ9LiixMhvLpXoQizw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062391;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=k1X13/pLxlB7Z1BupEYUzAFKJpXPVe5oSPPFpwBHsAk=;
	b=4vRVShW7uwgL3ejaOcRA8n0oK/ppkP/6hnALI5oMeqHep2oAcAlQTrpiRN+8cNlVd2mo
	 EVbCTIKs5wc8FHT6Fa+Pepzo+gToMX56d0PejVy4hpxtFKDtHq820rA66FkTdeCGu7ZR4
	 DYSm4TD6+1tJGwqlrUCoezRYQq0GRSyPEF92z2sqoe0+SkBfzGFGrz7YnqvEWzkXfstOb
	 mzfBj1+EYclI7WB7w7EfVjEO3R47aIeqG94bLTm5u0Hm2kTVBVeZHR5sPBZkt3cnhywRd
	 sly8s4ig5gKWFuFWM7o3EVjWE+ActKfbM4jWa4xGkPXgTPVrfEahqQgS65fflT+Y9Jg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DQcHUSzC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 763AB608361C;
	Sat,  7 Nov 2026 14:39:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DQcHUSzC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 240691F0089F;
	Sat,  7 Nov 2026 14:39:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062391;
	bh=k1X13/pLxlB7Z1BupEYUzAFKJpXPVe5oSPPFpwBHsAk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DQcHUSzCkh5sa4x/UhbEdGSJLpS68JNblgZTZltX+zsuIFBgmeS+qXOZtXVE0gguJ
	 tcNn7hajD+9eJcCLWEU282pSEm8ZWugKMe5F9a/goRvfvADr5vtqEYSANqDFYS1/pC
	 Pq9qxj/KZ2CiQ1oLtoqPoFSVTZwTVKsN6zptwc1o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1310/1536] ALSA: ump: Correct return size of fill_rpn()
Date: Sat,  7 Nov 2026 08:55:26 -0500
Message-ID: <20261107135034.589518283@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit 85e8c5f933ee3dbc9d061e121237797e9fa05315 ]

The RPN/NRPN conversion in fill_rpn() is supposed to return the number
of bytes of the resultant UMP packet, but it returns boolean values.
This would result in the incorrect ump_bytes in the converter, which
will confuse stream processing.  Correct to the right value 8 as a MIDI
2.0 UMP packet.

Fixes: e6ce8a28c768 ("ALSA: ump: Transmit RPN/NRPN message at each MSB/LSB data reception")
Cc: <stable@vger.kernel.org>
Link: https://patch.msgid.link/20261015075439.50088-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/core/ump_convert.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/core/ump_convert.c b/sound/core/ump_convert.c
index 85cc67de63306..0a7972d91ec52 100644
--- a/sound/core/ump_convert.c
+++ b/sound/core/ump_convert.c
@@ -323,7 +323,7 @@ static int fill_rpn(struct ump_cvt_to_ump_bank *cc,
 					      cc->cc_data_lsb);
 
 	reset_rpn(cc);
-	return 1;
+	return 8;
 }
 
 /* convert to a MIDI 1.0 Channel Voice message */
-- 
2.53.0



