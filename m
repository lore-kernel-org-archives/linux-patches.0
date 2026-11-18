Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795042490;
	b=rSwSPLsF83ZnblRSJRdJr3Bn7xgFJ8k1/xAarogV+vJt89u/smxBpAziv1+lFy+79I4t
	 hXuffswI96FxsZogSORPMJvgmix9tf1LjKvnEfZxVHOJu7zvzsAe9nW19irS4EqzwU0Uq
	 Lzx3RzRELpxcxVYYX6KdJH/rhbUOof4PnvF2mIKSz9sJSreIzkI53nXTJPY+uTK9iYFlY
	 w/JFlUzGlv3XpvzNAWdo8HKpSomtOjLV0ibE+D4t48QUGD+/4gG1aHQbvTPgNkM+Jn5/b
	 WaLP3+pcyQm1+zYu7gEtB0804lTWxSLgNdYocKxw/vihjFZU9hCWKmdccjp5bNQt6+Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795042490;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=SnoiSoePvfqRBec+ijhHeyfELBnymaU2ilMf4E4dGSo=;
	b=nsCGDctRrdrexZ7OfllcvdBf4fu60TP5tC4Vwpw5820MGIL5N3EMTsAo2zoyc9MJHiqZ
	 QLMKNgIviPiAyI1pPWcj/POYxaz7gPYnP7ogCF9gYCFkwDweImTFWGn4G/F6yEZXDXgsB
	 FKo3yOVwy2XW3/DyiJg7QO4vqV3btk86PFNesH5Om8Yv31vQt2/ujGCJRe3RMh6bhEbp8
	 +ALMefTcMsJ9L/8tr+7iNgcqHw5vfy+m7SkQqILwECafIAcx6G9tIT+gpMKnHmVAhyein
	 yU3WjKeP23OG0VE6PpkPjPKRSbfTgYpewhIY+2GlW/HJ5ab31CSPND2Q9gkjATv0Ewg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=peJ4ApfW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5AD6606A320;
	Wed, 18 Nov 2026 22:54:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=peJ4ApfW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCAB91F000C4;
	Wed, 18 Nov 2026 22:54:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795042490;
	bh=SnoiSoePvfqRBec+ijhHeyfELBnymaU2ilMf4E4dGSo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=peJ4ApfW2WALcPWGZM93jWwhQFl85ukNqsxuP2FYx9/f0AWrWV8A+jEvjO4K5MLEQ
	 alDHfDDhfuckW+aoTm3qydjbUm55skzW5F/OQ2dqZFuaOoNPFMEvdqTCwMn1H8YRXc
	 eQvgCzNZ1TRstPjKDZKe/Olvxl/IDzlq98j4WLd8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HyeongJun An <sammiee5311@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 3188/3318] ALSA: pcmtest: Honor the enable parameter
Date: Wed, 18 Nov 2026 16:03:30 +0100
Message-ID: <20261118150455.435895221@linuxfoundation.org>
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

From: HyeongJun An <sammiee5311@gmail.com>

[ Upstream commit fe3b45a0875a8b0944d2adee3ca62283d876edc0 ]

The enable module parameter is declared and documented as "Enable
pcmtest soundcard.", but nothing reads it. Loading the module with
enable=0 still creates the card.

Return -ENODEV from mod_init() when enable is false, as the pcsp driver
does.

Fixes: 315a3d57c64c ("ALSA: Implement the new Virtual PCM Test Driver")
Signed-off-by: HyeongJun An <sammiee5311@gmail.com>
Link: https://patch.msgid.link/20261027012228.3797565-1-sammiee5311@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/drivers/pcmtest.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/sound/drivers/pcmtest.c b/sound/drivers/pcmtest.c
index 6c144efa2d2cb..ac4a3149601ec 100644
--- a/sound/drivers/pcmtest.c
+++ b/sound/drivers/pcmtest.c
@@ -761,6 +761,9 @@ static int __init mod_init(void)
 {
 	int err = 0;
 
+	if (!enable)
+		return -ENODEV;
+
 	buf_allocated = setup_patt_bufs();
 	if (!buf_allocated)
 		return -ENOMEM;
-- 
2.53.0



