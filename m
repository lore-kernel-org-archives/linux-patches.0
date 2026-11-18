Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795059556;
	b=hByPfQqcPMZJ6+FspJIuc6GUZ8aMpyi3Q2BhaeboWgKXjhgQbzHDbU2c5EGK/Hrq9DFX
	 0aWeRyllxEyld+obe22kOsJ31AfaeoYumvj+CAfHQvlrum7aJJq3P2VqDvG3mhUBy8OM5
	 G3lbHJkJWUniCtPx8uawjV7kntYbxSCR6RoHh7O95v2bSAT9jzVFcNf7j1H73i/Vb64Lh
	 iZ+vuKjNzw/56w0Jg351wCrTJhHY/fO0Pde4tJp4nCelsSqSWw4lkfglszM4noo2D5nK2
	 kkPJICog83VxDNjekZQhJfGN0tgx3dJUf4l2TxB0hiVlFPIZhzSPunmxL2Zef4ukVSw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795059556;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=In1msnVp1XN+3O1Xz5bJIYkEkIvtMo+aM/eEQGJkJbs=;
	b=JvUE+HgFOwfF7GssgLPFy6bAKCiIxjXDdtK0bblhuTHdAi8RYi5jVQpwv90vDJP2rDud
	 ONv7rBKx+fJXF9tgRhY9qA+AqFrAiYck0bBzNfmLtSMtijdF5mJXs30bZQXbSs2Q8Bjzo
	 q3mQyLfHy9tVtWBULnPI2qgd/pTP4jPRzAgyy90oYp/fiomHICMoezBHUWSJL4AsMAV0O
	 cj+C0C/q9n/gdgEAikbcTlMXzVP43WVAQp+IlOinNd4Ejit+bmJo7I/wNzhwG5UCkP1UZ
	 bPD/cVtcXLuXO7rTWqvsGCE/SYYxY+bRmXrJK1P9vqlUkHIFUFMR4UbUPkewji5eLEw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hX38cnyo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FBAB606A326;
	Thu, 19 Nov 2026 03:39:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hX38cnyo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8C721F000C4;
	Thu, 19 Nov 2026 03:39:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795059556;
	bh=In1msnVp1XN+3O1Xz5bJIYkEkIvtMo+aM/eEQGJkJbs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hX38cnyoEABOMDvJvsqNzhvDYX18uErACiwcje3hi5/Xwq0RdUeRKFtOEtROo77QN
	 jXXPBH9c3dAqrnBAi9QuNuVMX+CNDI6+zFJooV0I/Mjq0BudJJhjt/2ETEP0GWCtGV
	 mdC2wJ8cg6RJzWfb+mQvaDOPROokVHCjyoWVWf+s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0882/1848] ALSA: hda/hdmi: clamp sad_count in ELD proc write handler
Date: Wed, 18 Nov 2026 15:48:40 +0100
Message-ID: <20261118145953.333223506@linuxfoundation.org>
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

From: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>

[ Upstream commit b3e7ddd694f8429217ba509b55b910a0e4361dfb ]

snd_hdmi_write_eld_info() parses a "sad_count N" line from the
root-writable ELD proc interface and assigns N directly to
e->sad_count with no upper bound, unlike the per-index "sadN_*" lines
a few lines below which are already bounded to ELD_MAX_SAD.

snd_hdmi_eld_update_pcm_info() later iterates
"for (i = 0; i < e->sad_count; i++)" over the fixed
e->sad[ELD_MAX_SAD] array, so an oversized sad_count read from the
proc file causes it to walk past the array.

Reject sad_count values above ELD_MAX_SAD, matching the existing
per-index guard.

Fixes: acb059938810 ("ALSA: hda - ELD proc interface write updates")
Cc: stable@vger.kernel.org
Signed-off-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Link: https://patch.msgid.link/20261008085133.9528-1-peter.ujfalusi@linux.intel.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
[ sashal: adjusted for the older source file location of the HDMI ELD code ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/hda_eld.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/sound/pci/hda/hda_eld.c b/sound/pci/hda/hda_eld.c
index 136477ed46ae2..5d2f48b5d7166 100644
--- a/sound/pci/hda/hda_eld.c
+++ b/sound/pci/hda/hda_eld.c
@@ -521,9 +521,11 @@ void snd_hdmi_write_eld_info(struct hdmi_eld *eld,
 			e->aud_synch_delay = val;
 		else if (!strcmp(name, "speakers"))
 			e->spk_alloc = val;
-		else if (!strcmp(name, "sad_count"))
+		else if (!strcmp(name, "sad_count")) {
+			if (val > ELD_MAX_SAD)
+				continue;
 			e->sad_count = val;
-		else if (!strncmp(name, "sad", 3)) {
+		} else if (!strncmp(name, "sad", 3)) {
 			sname = name + 4;
 			n = name[3] - '0';
 			if (name[4] >= '0' && name[4] <= '9') {
-- 
2.53.0



