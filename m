Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794065211;
	b=q40E+E4yt9owE/vSea+VtnfulefnHlky6QMNp4mnShjnUw2wDAxveiDayzuSxkB+T0aS
	 s7S1sEjjY27dPR3jurFKBLzgxphdC7w1W6n2q42QG2RNoMiGrzULfXTrLAFQbat/Ni1Kc
	 v+Me2FpdTnYWoEGrpT3OokbS8xxFeIX573GJHORWleYXDFGHPqcDX8IY6VsTG1un+of1y
	 puXfRUl0vsh06OSbXDTryWKNadtZsTENhrPV/k5AdLYEM5VTrbeK08rfLUMk8MY/4turG
	 v8kcgQNOf+JtBZ8m/Gy8rUeNbn9Ad8jTFt2MKunIOcR5QfxfRxKqfNAtiM5/KR5CGQA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794065211;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=G792xdiAf2g2u95nOI/zXJYO36LP/CWStBxy0KyCW/I=;
	b=A6W+r3vFe9fqaLgenK8nwN0l9laSHf3FeMe5SXBhekgaMfxiDJJgtBHej3RIlfx/dvjg
	 xhPPn5nwKMWiz7pqEurttlv1y3heo2RtcDZ2KAW1OY2ENU4MjmHGA4QyQXhxBXw29wCvB
	 foDswGXuaUxb+cZXTwkIwKJrW2TaQ8UgHqK0EjrX16fkocIYwek1+mMM5LA3ZSJODPD0Q
	 zMqAvZ6zmBi3gw37ws5GUnIrmopS+a977mhbY/fqbc1JSGrE5UylEqmoF31JB3Pc3VBCj
	 fJ9av1MCRO30dEe8w/7U8FUpGQhnTlKbU3htN7pcpCa9pR1VcImcMBEp449K5HygBLA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tcxcGIKh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F137B606A339;
	Sat,  7 Nov 2026 15:26:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tcxcGIKh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B8EA1F0089F;
	Sat,  7 Nov 2026 15:26:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794065210;
	bh=G792xdiAf2g2u95nOI/zXJYO36LP/CWStBxy0KyCW/I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tcxcGIKhG5Wq9K7Q8JVyhi7Oue/X4oywtFwgXIS7zEdUpj/4x8nY4x+o1L6e5Lbtm
	 8zpKWa6GAm9/hZrVD3+XBti5cFCxxuweaqwdL+dqOG3xsYU0Lka2IGvzeqzeCA9OGs
	 TPvsTz1keBCHe6t3ZpLdc1/00XKgbxYZzPznfsYs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Henrik Enquist <henrik.enquist@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1006/1257] ALSA: aloop: Update the PCM Slave controls for a matching playback
Date: Sat,  7 Nov 2026 08:55:02 -0500
Message-ID: <20261107135007.129329946@linuxfoundation.org>
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

From: Henrik Enquist <henrik.enquist@gmail.com>

[ Upstream commit c3bde2beacbcb40790f0e3c3f909f9e16bbced9c ]

The "PCM Slave" format, rate, channels and access controls report the
parameters of the playback side of a cable. loopback_check_format()
updates them when a playback starts, but returns early when a capture
is open and its parameters match. The controls then keep the module
defaults, or the parameters of an earlier stream.

A playback that joins an open capture with the same parameters is the
normal case without notify, where it is constrained to the capture's
parameters, and also with notify whenever the player happens to use
them. An application that reads the controls to find the playback's
parameters, for example to reopen the capture side at the right rate
after a restart, then gets the wrong values.

Only skip the capture stop when the parameters match, and update the
controls in every case. A value event is still sent only for a control
whose value changes.

Reproducer:
  arecord -D hw:Loopback,1,0 -r 44100 -f S16_LE -c 2 /dev/null &
  aplay -D hw:Loopback,0,0 -t raw -r 44100 -f S16_LE -c 2 /dev/zero &
  amixer -c Loopback cget "iface=PCM,name='PCM Slave Rate',device=1"
Before: the control reports 48000, the module default.
After: it reports 44100.

Fixes: 597603d615d2 ("ALSA: introduce the snd-aloop module for the PCM loopback")
Cc: stable@vger.kernel.org
Signed-off-by: Henrik Enquist <henrik.enquist@gmail.com>
Link: https://patch.msgid.link/20261021-aloop-slave-controls-v1-1-62297727177f@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/drivers/aloop.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/sound/drivers/aloop.c b/sound/drivers/aloop.c
index 5f0e2dc96769e..38fe3f4ce5d83 100644
--- a/sound/drivers/aloop.c
+++ b/sound/drivers/aloop.c
@@ -412,11 +412,14 @@ static int loopback_check_format(struct loopback_cable *cable, int stream)
 			runtime->channels != cruntime->channels ||
 			is_access_interleaved(runtime->access) !=
 			is_access_interleaved(cruntime->access);
-			if (!check)
-				return 0;
-			if (stream == SNDRV_PCM_STREAM_CAPTURE)
+			/*
+			 * Matching params also go on to the update below, so that
+			 * the setup controls follow a playback that joins an open
+			 * capture.
+			 */
+			if (check && stream == SNDRV_PCM_STREAM_CAPTURE)
 				return -EIO;
-			else if (cruntime->state == SNDRV_PCM_STATE_RUNNING) {
+			else if (check && cruntime->state == SNDRV_PCM_STATE_RUNNING) {
 				/* close must not free the peer runtime below */
 				snd_refcount_get(&cable->stop_count);
 				stop_capture = true;
-- 
2.53.0



