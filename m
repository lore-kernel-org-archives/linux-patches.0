Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795053814;
	b=kgzKWuVzd2bKB8yqRUcrhFAq6xVpvRbphsbb1RxfM8W5llOK2yJiHWecKnH9OLAdkhd6
	 2r/EqcLMGmi3fWKl5lCGFK4OV+bDc7HcL+RWYQTI1/3wsu0UVT1BtZ8nRbpaXBaG+LNIi
	 F2Gi6+bM/TnaDjfU0Eegpn7IXdBWdYJI3l/2SO5tjFy90AIYAm9MBm7qVqnwockyETqlQ
	 cwNWjCCNgaD7C7je/neEnNFeEaaNz1xn4vpa7Xl+S20o0nhp91y2UHEomiN2bM98EJ1d/
	 9skq0PUg68vYyLTh/cXKE3DeBtZ/2W2Nx7aT7swle2Czqk++HK5NtApLUBLD5Qo8YcQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795053814;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=nfgXzetbTRS8QBJ4AaYFGvfpGOoh/6eKcQ7QK7IZ+Ag=;
	b=2k131CVzx4EAROigb64c/JVDvhfL+GfjpxbVXsHSW3zLqzIurDoMf1q+SCTZimO1SQaz
	 SABLJgzOV3xJCvCr6oWK+SgrISoxYg1HfaItyZeOFPWz74O3PpgMAPKQadv1EP8hrUP1e
	 HfZzpQUPvC2aQv/beZWMJJVfkh+c34J1vnx1xrl0FWzTs4NI6z2WiGikWgAHDO6V/vPSQ
	 5og25DSYCl4ohg9nV4YcDSIpro2BU6ClqLkUcQCRxAx1rFNzJ6WZwqSy9bGXNqLw7HW6i
	 Pin4MvuZHQIHfvZoUO2r46V17O27o0S0VeJkr8/k33Lst0N4tUHNLXO/zOQW8H4Ufng==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OW8cLNR9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AF9C606A320;
	Thu, 19 Nov 2026 02:03:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OW8cLNR9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B76B1F000C4;
	Thu, 19 Nov 2026 02:03:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795053814;
	bh=nfgXzetbTRS8QBJ4AaYFGvfpGOoh/6eKcQ7QK7IZ+Ag=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OW8cLNR9WyT98CENMiZIasNFH731gTWAC9+h2scd24Pbdhux3QqmB6a0NyNX1cihQ
	 hXB5MjkvDF0h1ULYwOpKY2b7S748X06f+V7nuC+vbs4EgF9OHxVwKgNebIf4etsAII
	 SHLFCETSkOu3HZgxdKNVlo7a2hJv9ZtzeCLK6YV4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1051/2214] ALSA: hda/hdmi: clamp sad_count in ELD proc write handler
Date: Wed, 18 Nov 2026 15:45:27 +0100
Message-ID: <20261118150054.371009665@linuxfoundation.org>
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
[ sashal: adapted to the older location of the HDMI ELD source file ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/hda_eld.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/sound/pci/hda/hda_eld.c b/sound/pci/hda/hda_eld.c
index 9e97443795f83..113c2081dda37 100644
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



