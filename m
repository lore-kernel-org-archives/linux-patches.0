Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792773775;
	b=a23aaUeQ9XU5bJnQPiYMmdl0RnPRtTIaJ+2070CWI3OmGKSTVgKUvlFWX+rKAwm913Ng
	 CGjYGykjiTJor9I6UzRYGmqMO0JEhcK4pSjtMXL1xMNMEDEMrQkyIkuqpa5wTMl/Cf516
	 i0LWzwXZ6zWw0wUQgVbCAechCHGn5OdEEWxJHLiOPtrGl6UyTXkVWpyR9nPqkJpEs0N7+
	 SPdaWdWU1b/yQP6DdCdf29xtkpboE+IYvRkk7s+qU2fsUTTGE1My9o/chzlGLFHgJepgm
	 l2f6I6B+KfA/dm1hRYP5Ra1c/XkwYZRxXyI9zYv1jgQZw6Izld1tfm3odfWx0zuNZxA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792773775;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Rj/RHteVbDTprOSbliqb8coeSkXKiMwLp99/jTMlWzI=;
	b=GxP1iqe5w7rA2C2c4j2sR/Hx8/ep0UnYHi8YWe9DQU0HfPsBJ7Ztr6XaCsIFimPsTzc/
	 jS4iUWJyD9OgWj+/jPXGYDqns0ZdDt4jEKhJSVawv5j//50vQmFYD2qHVpq6IW7MaIHdp
	 Tx5laFAkloXLpG1rN43OQcYoUJxOEzQoM/CkW0rhj6w35Rg0M50+bx+SJqxLZgl9AgC30
	 Apqu9ebNGp8cEBdLd863xX7LEDGcggVXPne7uCbYGTU3RXWFWiAqIPp2VlThdrizyVNCL
	 UNkOnZQsH/IvRAhSImDrdjxGoFezXi+hYP6qXHYewdxRQnzSIES9bWrjOr6ONzx9BXQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OCxi1PBp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64E61606A31A;
	Fri, 23 Oct 2026 16:42:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OCxi1PBp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B51601F01825;
	Fri, 23 Oct 2026 16:42:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792773775;
	bh=Rj/RHteVbDTprOSbliqb8coeSkXKiMwLp99/jTMlWzI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OCxi1PBpYbdlH3QBpzJHSuqL/Jnj2/YEelCXJN72I7uxI1UwAGlgEcujMtOH6b0+u
	 pa7t62uJHNQNVQ1aV8BRl+y4NM58gIaDE3m45SE4Lr2D45YmtIcRq0H3w3cOhl5KcH
	 Cdeby/661XjlHGUrqT8dBhLZigOjbGw/WHcbZfSA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harin Lee <me@harin.net>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 004/193] ALSA: ctxfi: Use correct DAIO type for da_desc
Date: Fri, 23 Oct 2026 18:34:41 +0200
Message-ID: <20261023163714.307644306@linuxfoundation.org>
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

From: Harin Lee <me@harin.net>

[ Upstream commit 07b116b44e52d78af40c2d39a8e1e34ef1283d0d ]

Skip the unused DAIO type per model (SPDIFIO on CTSB073X, SPDIFI_BAY
on all others) and use the correct DAIO type directly as da_desc
type. This removes the mismatch and misleading between the actual
DAIO resource and the da_desc type like SPDIFI_BAY (formerly SPDIFI1).
Update related functions accordingly, and drop the unreachable
SPDIFI_BAY case from the hw20k2 daio_device_index().

Signed-off-by: Harin Lee <me@harin.net>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://patch.msgid.link/20260401090159.2404387-3-me@harin.net
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/ctxfi/ctatc.c  | 18 +++++++++++-------
 sound/pci/ctxfi/ctdaio.c |  1 -
 2 files changed, 11 insertions(+), 8 deletions(-)

diff --git a/sound/pci/ctxfi/ctatc.c b/sound/pci/ctxfi/ctatc.c
index 5f2eef00009c5..da728549ce42b 100644
--- a/sound/pci/ctxfi/ctatc.c
+++ b/sound/pci/ctxfi/ctatc.c
@@ -981,6 +981,11 @@ static int atc_select_mic_in(struct ct_atc *atc)
 	return 0;
 }
 
+static inline enum DAIOTYP atc_spdif_in_type(struct ct_atc *atc)
+{
+	return (atc->model == CTSB073X) ? SPDIFI_BAY : SPDIFIO;
+}
+
 static struct capabilities atc_capabilities(struct ct_atc *atc)
 {
 	struct hw *hw = atc->hw;
@@ -1096,7 +1101,7 @@ static int atc_spdif_out_unmute(struct ct_atc *atc, unsigned char state)
 
 static int atc_spdif_in_unmute(struct ct_atc *atc, unsigned char state)
 {
-	return atc_daio_unmute(atc, state, SPDIFIO);
+	return atc_daio_unmute(atc, state, atc_spdif_in_type(atc));
 }
 
 static int atc_spdif_out_get_status(struct ct_atc *atc, unsigned int *status)
@@ -1401,12 +1406,11 @@ static int atc_get_resources(struct ct_atc *atc)
 	daio_mgr = (struct daio_mgr *)atc->rsc_mgrs[DAIO];
 	da_desc.msr = atc->msr;
 	for (i = 0; i < NUM_DAIOTYP; i++) {
-		if (((i == MIC) && !cap.dedicated_mic) || i == SPDIFI_BAY)
+		if (((i == SPDIFIO) && (atc->model == CTSB073X)) ||
+			((i == SPDIFI_BAY) && (atc->model != CTSB073X)) ||
+			((i == MIC) && !cap.dedicated_mic))
 			continue;
-		if (atc->model == CTSB073X && i == SPDIFIO)
-			da_desc.type = SPDIFI_BAY;
-		else
-			da_desc.type = i;
+		da_desc.type = i;
 		da_desc.output = i < LINEIM;
 		err = daio_mgr->get_daio(daio_mgr, &da_desc,
 					(struct daio **)&atc->daios[i]);
@@ -1535,7 +1539,7 @@ static void atc_connect_resources(struct ct_atc *atc)
 		mixer->set_input_right(mixer, MIX_MIC_IN, &src->rsc);
 	}
 
-	dai = container_of(atc->daios[SPDIFIO], struct dai, daio);
+	dai = container_of(atc->daios[atc_spdif_in_type(atc)], struct dai, daio);
 	atc_connect_dai(atc->rsc_mgrs[SRC], dai,
 			(struct src **)&atc->srcs[0],
 			(struct srcimp **)&atc->srcimps[0]);
diff --git a/sound/pci/ctxfi/ctdaio.c b/sound/pci/ctxfi/ctdaio.c
index 55d9c5c3d9bd3..1c12fffce1a2d 100644
--- a/sound/pci/ctxfi/ctdaio.c
+++ b/sound/pci/ctxfi/ctdaio.c
@@ -119,7 +119,6 @@ static int daio_device_index(enum DAIOTYP type, struct hw *hw)
 		switch (type) {
 		case SPDIFOO:	return 0;
 		case SPDIFIO:	return 0;
-		case SPDIFI_BAY:	return 1;
 		case LINEO1:	return 4;
 		case LINEO2:	return 7;
 		case LINEO3:	return 5;
-- 
2.53.0



