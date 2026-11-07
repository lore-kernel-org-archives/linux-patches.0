Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064527;
	b=FkGrz8R2QRUslzOAPmA694DtrMxiVa7I9o62VbPoqCJgFXPeoxy5OImgKM3QMdDV9u6V
	 vrmeec0R2dCIbnw2/mGoAMwCh45sIpSR1FDs3iDKBNv9+3j0OXySINZINEQ4bG547FdqG
	 p6Rb0SpLVEYeakt+4jX1h3y6qYsKLkMb7f/hVYrbKgOf+jlHut7Id7NcqEKiQSispWS5W
	 7aMrV4ENO+JAPOqP+Ej4I307+yxnLHfC+9/3TRUqLo7c3mCfCez/3QWQNpSXV961ZgxJo
	 vOXLl0w+Ex7JwLql1PI/0pp+vhK/M8xB+InrCFc65GLe6nWxLgIf49hIjvCdQWhQUow==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064527;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=L2EsdtizaovPCxKOpQPFE3ugTSuvMh4jo3zmby1qKUI=;
	b=ILgLafUr0tLcH0wsvqPHE+IYZycjSc1HHURC1JKX7SXU/ZPFwcg2jKMYPlWvThdEG7YR
	 TvnIq2qytExMnHKnui87UNx7td3doD0tfeT3SkngeV5g2dNLrNuTsCIu4WINgTOF9Rxo1
	 5o74QLlfrEzK5nzOUYlvgs0mDfIEiU1Ka4jHISC6pCCSlRiwpnm116kWgH8rtr9LB9AEj
	 ELAooi5WvNxGVGFRWIFSUrggqg/7DaGH43Zo+XZmq0811mEA2Ud/nPoGhHIQT64wjr5ar
	 wagEOe4s1RTxEGSROm2Dw9io8zqZrvbsILCx+SUoH1qS4pNl/B3oBHWrJTMf+YtoQqA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=D4cF4ko3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D498E606B89A;
	Sat,  7 Nov 2026 15:15:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=D4cF4ko3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83F771F0089F;
	Sat,  7 Nov 2026 15:15:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064526;
	bh=L2EsdtizaovPCxKOpQPFE3ugTSuvMh4jo3zmby1qKUI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=D4cF4ko3i+4fW83QeyKqMshqFaA8Bt3diZWGgcMBVPq5Rg6VFlgHH9w34+pBznDDY
	 b5ox9uB8e2AO5Jy7IEk07gBg43EAd/4biEWsoYKjGff1lo3TE4XiJxspFyaSJs7Y3r
	 b73HxsTurZ65COw9shLyjLOO2hVqDrfOu1ed7Ob8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0557/1257] ALSA: hda/hdmi: clamp sad_count in ELD proc write handler
Date: Sat,  7 Nov 2026 08:47:33 -0500
Message-ID: <20261107134954.763365844@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/hda/codecs/hdmi/eld.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/sound/hda/codecs/hdmi/eld.c b/sound/hda/codecs/hdmi/eld.c
index 1464fd1c675bc..fc6fe1b0873c3 100644
--- a/sound/hda/codecs/hdmi/eld.c
+++ b/sound/hda/codecs/hdmi/eld.c
@@ -155,9 +155,11 @@ void snd_hdmi_write_eld_info(struct hdmi_eld *eld,
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



