Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795038315;
	b=3vqEaJONQHwJn9XvcHjNOVPZq+Fnmg07HTyyjJVJrZ6+M6gO1K7AzUIpPIyJJU9aFoZR
	 +RZD0EnwKfGxNUtSEpvobYYJ+Ze0UuH/ItMocVr4KWLHhLFrfICwXDwK6ajR41Pl7tflY
	 1EKD6QMWYN4rjVM/bxe41PPmsshKaF35dYuRgYKBMvHIUDgVuyaXCwffFY5v6rTbAFb1p
	 wSxX7NkIoIuVzda4Pq8CdJVDcEtqCDxnVbXo4yiBBo9Ute2N2cnYv3EAFqHIGYym2HxAK
	 AcgAwXXxmwWQpqq9cwn125QSjcp3dpCRh9a38p8MzPcrRYcXvgeSx9qPmuOEJWsByZg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795038315;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=jzKAeAepKzBJW9xya/0Mlv9clB/E6pLHSDKkty2mD88=;
	b=MODatyFvc5Gum6d+tH4Tu2ZdCJwFFsr6mAPOnJAfQBfuakU1o1fmAyMKwy03iPHBknMx
	 aNJZL0z55TlZDzkayjEeCY3+rQFj+60usSGeaNcBZz3UYMWReM6nhAD1qe3uDulA0P9Ql
	 nljsEqxiYhx/X4ZfTEoeT43dRsAKxabdNR+0cI4MHwaJ0/HUJ1HdpA3afoYw6YuIQg29w
	 ftyg9PYqqkPIzAE4dtiekgqWa+B3OkqHD9dvJUCUHmfWwD6S3mXUr0lsP/tTd5r9RDzpw
	 0H88xDaacqteOy0Rsx4L/e8fW2RyTg5lQoxlbrSt+0YAkIklrAwmDHem6kg4kWzL8jQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PYvcFoXr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9858F606A332;
	Wed, 18 Nov 2026 21:45:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PYvcFoXr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5CBB1F000C4;
	Wed, 18 Nov 2026 21:45:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795038315;
	bh=jzKAeAepKzBJW9xya/0Mlv9clB/E6pLHSDKkty2mD88=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PYvcFoXrSyMZOLEaCUBghsnW120uNR+ex14HR57Bgk6EaZCwYVVQ04bdzhdgGIFVR
	 n227bUfmbHEVlYyZPg6YCm+5hDC+a9gRXSMF5Ra2pUW7/BGmZmW7DHOg5rMrVaZGsY
	 TbgY3n6P9yyvIfaBfCApnMcl4CfiFctjWthNt9Lc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1702/3318] ALSA: hda/hdmi: clamp sad_count in ELD proc write handler
Date: Wed, 18 Nov 2026 15:38:44 +0100
Message-ID: <20261118150412.911595531@linuxfoundation.org>
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
[ sashal: adapted the patch to the older HDMI ELD source layout ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/hda_eld.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/sound/pci/hda/hda_eld.c b/sound/pci/hda/hda_eld.c
index 1d108ed5c6f25..2f3cf2a88cebe 100644
--- a/sound/pci/hda/hda_eld.c
+++ b/sound/pci/hda/hda_eld.c
@@ -525,9 +525,11 @@ void snd_hdmi_write_eld_info(struct hdmi_eld *eld,
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



