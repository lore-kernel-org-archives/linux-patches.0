Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795046899;
	b=DgrgYJshepOFONBimEV9ew6d56OmDzjZ+FggA4tyLuw1uWQloIHeMOQmZTwtQvaiJNuj
	 NCnzL4lyQCq8PSNKy1b+WX47PS43yfK94ieY8g6/IMluDB9MOC+EK8p/LRn7Q3sBH0BkX
	 5sTfYAOgdQ421GrKz9+OHjXVgNxPJ7IRm/mMrveNo1dfUwVMLOVSAvzKrcnKumn8vO5Aj
	 VbyaWXuosMJ1uCLRPmrbAbLwsJ5U/UqM8kgEUlv+5deNYFXQl+FDaf/WIzx6iDKgA3cr/
	 SDiwDCoy850V9jeVbSebkcK6hTzq2f++fwCnpu5EJ2WpWcdtwDB1eQDab81cCeJLVPA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795046899;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4GS/u72WQ8grZCrAd1aaM9zbGm62xSdftEjfhkL7sf8=;
	b=vdgbQotvbJ1vmiHn8zAgAJ/RjVS5KxVmcSvHfe4tN1BiVee3+zbz8jbPIcDDn4RzLiD7
	 22jtyO9faW+XN02cdJeZ9OwtqpSIZDN54KNioFxh11laDg2yYuu6cCszCK90FSNoBSy9l
	 1duGm9tLQwRyVQ4M4RaqQ4bfTyP60/Cvl4r0RFzTZ/LXzp6+FjAIP7gA46Rc3W58ZnucA
	 Uea+E1NKek5HL/nAZ7KldcpyWqPfYfAlEnXbdXbSTAsyxsq3QqYv+kqy2yxQnR+w9b3Le
	 RXFLfWh5oIeHnTuDkjcCTDesOy2LGB7eBNZFyNjbkjgA+EEIyDXgf/9jZx4xR1tPi5A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="knp/9vZX";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44C63606A325;
	Thu, 19 Nov 2026 00:08:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=knp/9vZX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EADA1F000C5;
	Thu, 19 Nov 2026 00:08:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795046898;
	bh=4GS/u72WQ8grZCrAd1aaM9zbGm62xSdftEjfhkL7sf8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=knp/9vZXpQ9R/lXb28u9s1kqTEXlXlXPT5oEnEq0vzm87MkZtvrgdi8z4QJ5ytJBT
	 BmmBYlHqT3GedHktZ5tUhrusHpSTBXPvRDNeOjkFDDalhXpE2C56zDk6/YOZwaL0fJ
	 QEUbg4JKpiCtV7JEYb3a5FV4DTSyTI7R3Y8EweQ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1446/2857] ALSA: hda/hdmi: clamp sad_count in ELD proc write handler
Date: Wed, 18 Nov 2026 15:41:20 +0100
Message-ID: <20261118150253.380424814@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: adjusted the target file to the older HDA ELD source layout ]
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



