Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795041092;
	b=B/8e8aj1f9xaoD+Z1Lbvo2Z9IpxMVjNGA/m2OVoe6JNKyvMoW1YhxJpI/PWFJmVljhBx
	 wjC6Hj8K23fhbUqcJmkC+e+XlKbzVkjJVr5ZdRxkj1t5QKDxszBK2STvZDG9MVwM5byNp
	 DrLPxz+MqhkDGTDWdx/J+6jDJIAy0lLjXwTW/MrYp02bDP9+THu96tM6U233uqkNcRoEZ
	 6kJKGXoE4+AraXMQ2VLskhgq8Y0MDPQdeMWGEovjBF0K798xRqGFrqHrZmPtFrYNcayYC
	 i1TKjUh5RIqe7mRE8PYZAkturYg2yrvVkW2N5ndJfjoNNirxWn9nQK7ids6ocPC/N/w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795041092;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=aTQdxidUfc4W4GTJSNGoYtLSK/IdMR7kL3V6qweEbC8=;
	b=obQluzUvOOG9tEpJuMy4MRPglHlfjg60t0VwMJeSoKOivYy0oxwucPa26PEhr0inPdkj
	 b4cKmSEVQyApnxJWpR0e8z30RuiWwMluKn3vENWrSyl/EUzWb9VLFyS9UuClBgHNkPp8z
	 Cwol7jyiOtj2k1HiTpFUAn+/izcYePZpC5my8LR7TnY3w4Icf3m0sh4D83fR2xRE7Ltyo
	 FqW4vP9lqsGr3PgK40NDZx1eA3WCqRqWZ1MCVYMhOoHLfIG/gW9Ic9QUK+58hB0vw4clh
	 rZBQjvsXn+lZhsPzMWb0o8CyFcfbcWalFCCPN6FespH0LjnLy/suSB9eRsyGRIHJrzQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=moREYHHO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70372606A320;
	Wed, 18 Nov 2026 22:31:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=moREYHHO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89AE41F000C4;
	Wed, 18 Nov 2026 22:31:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795041092;
	bh=aTQdxidUfc4W4GTJSNGoYtLSK/IdMR7kL3V6qweEbC8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=moREYHHOZqTxMv0Dh4kk+TpmM4qIFk4X6MhyVa1sLRevTvtqlEAcldudc/3REEvVU
	 z57ZBtZRxVObT1bEQTZAvpd2NbQsnPZkZQr7sR+tL8rJbqlBYUQMjien1U7kxiTG9h
	 aXrRcMMW/LXzaYS/tqfaJ0lue5E9ec1zduR4V6vM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2690/3318] ALSA: core: Remove superfluous CONFIG_PM
Date: Wed, 18 Nov 2026 15:55:12 +0100
Message-ID: <20261118150441.655943846@linuxfoundation.org>
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

[ Upstream commit da0713fff528112890aac02fea08937b65d5c8ba ]

Since the recent code change, the conditional build with CONFIG_PM is
calling only snd_power_sync_ref().  As a dummy function is provided
for this function, we can get rid of CONFIG_PM gracefully now.

Link: https://lore.kernel.org/r/20240510125128.6058-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Stable-dep-of: a69138357354 ("ALSA: core: Add missing barriers for power_ref vs card->shutdown")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/core/init.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/sound/core/init.c b/sound/core/init.c
index 09ae2aea74d51..c934e26207793 100644
--- a/sound/core/init.c
+++ b/sound/core/init.c
@@ -555,9 +555,7 @@ void snd_card_disconnect(struct snd_card *card)
 		clear_bit(card->number, snd_cards_lock);
 	}
 
-#ifdef CONFIG_PM
 	snd_power_sync_ref(card);
-#endif
 }
 EXPORT_SYMBOL(snd_card_disconnect);
 
-- 
2.53.0



