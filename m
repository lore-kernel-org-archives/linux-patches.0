Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792773770;
	b=5dqK4g+7e3Efs4NC9YuH666k66qDc6l2V/OirBpWEDZBCRpZy2mNdD2C5Dyxi1XNQ55g
	 P5H1HDxykbcDDeEL2j7Ddys2+/mJmQb7bOfFandgf9I7iayzHJCUhqum+YDNFpbOncnFO
	 12dL4sILHzu8jQg8PalFcG0DQ9/kA55dfT6gJGo+v1XVl2bNMFknxwfJ+bn9fJTxQfrSC
	 sc/i/1MGQNra+urJmIGF4GUksCrn9rxjbgGZMlyBWoB8P4XGzgtl+/fcQg6i7Pw7tMSZh
	 kQR5rcgZGtwTnmVAjp1jzbtvbyogbngWZf8JEzbqCn6Q1qv7F+AOx54dfAadgCSVWsQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792773770;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zc6DHgyco9fDxuILWozYUzp/d2fuHgBUQEuogTx9/Dg=;
	b=r86PVFVSgikHWCmOnjbfSBoOxPrqL/CTtkvb0mPAsi3PstiO2zNd4vLcx8QBVrtD+f2J
	 suV1MqXUy2jaCeAn+fnCAfpfRcAqN0D2WLTlneXYcwBTDrY1mIuWUg4H0e8Rz40H4BYZR
	 /3fUW3Jmly1Fh47Iivvehlt8pa0KtdkfsvuS141woAvI7JP+tlYOv51HSa6oqFmnDeW90
	 w58+PyQDF0VGpjKWICKBxRyNfqPMHEjNSOyCoCxLUxWX+BcnpS4KWYBzbeiDgRJOf3pv4
	 vDdckfmtmHvHTsedg6ECJEqP2fkwq3YGbQV4WpKtwndJT5UfqQhFuCqyLpAuRYBjkOg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YJkEhbss;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC442606A31A;
	Fri, 23 Oct 2026 16:42:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YJkEhbss
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0EE71F01829;
	Fri, 23 Oct 2026 16:42:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792773769;
	bh=zc6DHgyco9fDxuILWozYUzp/d2fuHgBUQEuogTx9/Dg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YJkEhbsspZZptkfAeiHPuHwUD48zKajvF8yMu2oRl4qeLWPP1/E5W9PdhV8sY144X
	 FFmUW1WjgRHccKxG8qDVv3ySl7OILeWoYnOPTmojDewZqI2yiBDx98kSl8pqi1aCK+
	 dYqDbsAJW3IT0iuMB8OcFsuLEAXYYx2Enm1B8RBs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 002/193] ALSA: ctxfi: Dont enumerate SPDIF1 at DAIO initialization
Date: Fri, 23 Oct 2026 18:34:39 +0200
Message-ID: <20261023163714.261220823@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163714.201276352@linuxfoundation.org>
References: <20261023163714.201276352@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit 75dc1980cf48826287e43dc7a49e310c6691f97e ]

The recent refactoring of xfi driver changed the assignment of
atc->daios[] at atc_get_resources(); now it loops over all enum
DAIOTYP entries while it looped formerly only a part of them.
The problem is that the last entry, SPDIF1, is a special type that
is used only for hw20k1 CTSB073X model (as a replacement of SPDIFIO),
and there is no corresponding definition for hw20k2.  Due to the lack
of the info, it caused a kernel crash on hw20k2, which was already
worked around by the commit b045ab3dff97 ("ALSA: ctxfi: Fix missing
SPDIFI1 index handling").

This patch addresses the root cause of the regression above properly,
simply by skipping the incorrect SPDIF1 type in the parser loop.

For making the change clearer, the code is slightly arranged, too.

Fixes: a2dbaeb5c61e ("ALSA: ctxfi: Refactor resource alloc for sparse mappings")
Cc: <stable@vger.kernel.org>
Link: https://bugzilla.suse.com/show_bug.cgi?id=1259925
Link: https://patch.msgid.link/20260331081227.216134-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/ctxfi/ctatc.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/sound/pci/ctxfi/ctatc.c b/sound/pci/ctxfi/ctatc.c
index 7cb33d7c43d2f..79dc4aed736cd 100644
--- a/sound/pci/ctxfi/ctatc.c
+++ b/sound/pci/ctxfi/ctatc.c
@@ -1401,10 +1401,12 @@ static int atc_get_resources(struct ct_atc *atc)
 	daio_mgr = (struct daio_mgr *)atc->rsc_mgrs[DAIO];
 	da_desc.msr = atc->msr;
 	for (i = 0; i < NUM_DAIOTYP; i++) {
-		if ((i == MIC) && !cap.dedicated_mic)
+		if (((i == MIC) && !cap.dedicated_mic) || i == SPDIFI1)
 			continue;
-		da_desc.type = (atc->model != CTSB073X) ? i :
-			     ((i == SPDIFIO) ? SPDIFI1 : i);
+		if (atc->model == CTSB073X && i == SPDIFIO)
+			da_desc.type = SPDIFI1;
+		else
+			da_desc.type = i;
 		da_desc.output = i < LINEIM;
 		err = daio_mgr->get_daio(daio_mgr, &da_desc,
 					(struct daio **)&atc->daios[i]);
-- 
2.53.0



