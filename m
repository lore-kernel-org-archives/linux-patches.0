Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795060835;
	b=BfKIa/r2KYE6iBcyasXJEQqDQ8vbB5rsfUVHW86ZUVCbZhREerptuyK+QvW6uHiefza7
	 IpXRXOuOi6al+SYC8XpDyoEomvBa9ok6s+hspg0H0YeOblhUrl8k0NGAOfbKhRy7NmRCN
	 OLfRrVze5HzmC3iyT4iIRrvionVEJTxbkO3iqq4weAYyshqeeg8BsiZJpr/jx/vmI93jM
	 wAPb8sm5i3y2MkMR9EVvOXUK3ne4ywzwvdBqvRpdOuL7SMBOC8wmRb67tCQTeThgKQ8da
	 sIY7weXi213e4Cwy2JakgPdawQUGNU4csop0iHZwdaOrU4HB9soYrHHb29DSRAA9zEg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795060835;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=78QVOaRpFLYmpGf9sjxJWZvwFi+UA06/M5TctUPDuiQ=;
	b=RHEpe975tHSCjy/BYVbDKsOz+Ul3OwBDKXmf+NrBJoMnpRhrRzukui8F15HMZmyRqR0x
	 wT8Uqsf433q1IZFZaOHb4tEEFIdmaEinRCm/8CbsVrnMTYwh57UMqcHoggRUpy+kvImHF
	 T5GwByUHdI7r+kGxQJH0t8vbSZpK8QT4jeOVWoLQMjDnDESzUHVHu0VdJ89drMQc2fP2L
	 8dkbgKIijNciw2LFidyqUo9IKViTzT8Cjd6oemWMPM3p9koWk/F75m16ENRNRTbJkpcrr
	 ZN54gpdxabW7efeufT0jeSbE5FcLvr0sDpzD9s74kdcx2s0r+T45YyclHYqEY6aF9Tg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="m/KbuyXY";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB9B2606A320;
	Thu, 19 Nov 2026 04:00:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=m/KbuyXY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 293DD1F000C4;
	Thu, 19 Nov 2026 04:00:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795060835;
	bh=78QVOaRpFLYmpGf9sjxJWZvwFi+UA06/M5TctUPDuiQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=m/KbuyXYOfkoe9jZuVNp83tx+p0V1XUYdeOiKKlfUE1fF/56T+sQ718RyGspgdu/C
	 Y6RAUlQIq7jVL5D1D2zHAbFBCY/b+ZkTNuphjUkjhnqmClzMe8bfE20lxfo6ErVEUv
	 ojCLCOTz+uape29VUbrrVPrqg8Uld2d35CtfvAiU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1342/1848] ASoC: adau17x1: return cache sync errors from resume
Date: Wed, 18 Nov 2026 15:56:20 +0100
Message-ID: <20261118150015.868008529@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

[ Upstream commit 8ca84987c11d11e0ba60f202e3199b3b80c87721 ]

adau17x1_resume() restores cached registers during component resume but
discards the regcache_sync() result and returns success. A failed replay
can therefore leave the hardware register state stale without reaching
the component error reporting path.

Return the cache synchronization result. The ASoC component wrapper
reports a negative callback result and retains the established
best-effort resume state, so this adds observability without introducing
rollback or retry semantics.

The optional switch-mode callback remains ordered before the cache
replay.

The issue was found by a tool we developed.

Fixes: 4101866c743a ("ASoC: Add ADAU1X61 and ADAU1X81 CODECs common code")
Assisted-by: gpt 5
Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Link: https://patch.msgid.link/20260902013256.93072-2-pengpeng@iscas.ac.cn
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/adau17x1.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/sound/soc/codecs/adau17x1.c b/sound/soc/codecs/adau17x1.c
index 30e072c80ac17..c4d4835f09664 100644
--- a/sound/soc/codecs/adau17x1.c
+++ b/sound/soc/codecs/adau17x1.c
@@ -969,9 +969,7 @@ int adau17x1_resume(struct snd_soc_component *component)
 	if (adau->switch_mode)
 		adau->switch_mode(component->dev);
 
-	regcache_sync(adau->regmap);
-
-	return 0;
+	return regcache_sync(adau->regmap);
 }
 EXPORT_SYMBOL_GPL(adau17x1_resume);
 
-- 
2.53.0



