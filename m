Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017171;
	b=nftMgufJlW6nP8ZElGDpXfnyseS/R1CU4mNaaLim6dT7AGy+/S5Yo2rtNQs+eJW3s7Nm
	 TroEoYJuXAPEDWAxMopOcmkEZnABPKUG+W0sz2zTH6TJoqdldR3WdgPK3Ykn0yDIWYdcq
	 8SPZhU8eBestIeTdC1JyMt5QzQygTdnMmR6nXGbtaADOJJvwojMyixo61LhNp99cCAWRz
	 gkuQm2jHfI6JXDJnNVPe3zHznZQFyz70QoAnWJI8l8aa1ewvxODyLv8uWhhfKlIVGZ/0l
	 q/YSr10A0jfj/hQGhb9wtnubr/g4iW+7g1bfsI4/515JicddfzrHhcZOE7kU+Y5btTQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017171;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=DIRSU25dRVfKHTrCQ+z/7QfyGBllWJJCcWOiJtijm+w=;
	b=a5PSM36mHO7Ka4RAdoxuRIF+QbOgCOhCQ50Ig/o9bfCw4JcRx94bQpyWDUQSs/0yy5nh
	 99IHhGSZLz30pywmeqhXeQXERYc+4Y6fJ3rmTyV9Xbu7sRsVDRVl+TA+lrNeFJq/K9okJ
	 kWy/gbNnsdmNkCF5aPwqxxSz35A0PEdCDdxiBcI+AywRUr1j29QHWB9HdEJOx4x0teCTw
	 JhoDpLQ/rx60THu1R8Dur9VTuF/FV14VrmSn0V98XP+eki5a4nlUBIdCVYO49zlwEy0TR
	 5b+hYdz/X4txfDo7Px+VGRkevOmarMfVmTcgH9mrqGsRdNQQCcfA430WhnyB8UM4piQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sKEwEQlV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3117C606A320;
	Wed, 18 Nov 2026 15:52:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sKEwEQlV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 836831F000C4;
	Wed, 18 Nov 2026 15:52:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017171;
	bh=DIRSU25dRVfKHTrCQ+z/7QfyGBllWJJCcWOiJtijm+w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sKEwEQlVDEFqGuYTqpHfiolgrUE0Osv8U94xh5mLmgSpKNmmC3QILYXKP8Kfia9QF
	 SlpjLEE1lPb71da0+NZ8Dl7xFhZyZQtwd2/zlnuDFkvBL6ck5Dlc0oWEMWuHCnWfza
	 /4eIZemP+Q6d0MxIKnF7mtc+/0O1GrNpPk4WSOa4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0790/2651] ASoC: adau17x1: return cache sync errors from resume
Date: Wed, 18 Nov 2026 15:33:50 +0100
Message-ID: <20261118150316.327295760@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 26d7eb437ad18..00efaff44e927 100644
--- a/sound/soc/codecs/adau17x1.c
+++ b/sound/soc/codecs/adau17x1.c
@@ -989,9 +989,7 @@ int adau17x1_resume(struct snd_soc_component *component)
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



