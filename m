Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795059922;
	b=sCsLhhZLAAYKUKTB9kp00tkm0gdv/AvJmgHiK/mwJSSIJ3T6FxRsi9JPq800jIlY7fsF
	 KjairxKJ0mO+hlk5CQr/u/0kf4ZPgxw3LSVXw9Z+f4p2soqdx5wOrOwwbRY7Dg8d68rGl
	 XVv/z6d7128Gr3kJFszz96TciLTWa/MVcOPwhjBNm1u+4Y1MmSd9ywjrZNWwdHev9M7D7
	 gCGWJ83jRopYm+dfv0LqRtA1Tp02Mpu8L3PAd+sI6QU8bvcrI3Y7nihfnhRrqhf3nzJPN
	 GUQROxxcmX9qSENXYLKD2BbVrT8DegyinowJAIO/BS4WSsH2+cRmlToGQRDJ67b9YDQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795059922;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=hsn61N9NOH1nVmiK63u6xkjUaQD97ymNnACwXXYM8Lk=;
	b=x9sy4V7WWDS6lKf1CFc0j9A42ptwD9OdqYOAPDtDqDrQHSDZCtXsRINpQpcse42e+1im
	 a731uaNQDfz7Mzq1xL8IAsD2yXYY6rVUwm8en6hhFf+oV7bUNQ/8YQ/zJ57gwue/IPqF1
	 XliO/k+/mDeyqMTZZJLHizdKM0dukqOEgTFGXhZ8uiVZyG09N9Qj1KeqNYh7UB0yHQrQX
	 I+biZfT8wIaoBwmQEQ4M+fL9vk9Oa7n8WxOl5/GM5W6xQNYFpPUzdlQ6q44sieJdaseiw
	 0hwXhRrxwO4Ez3vWNKYwmPh5mmUuI5NwQq8fz/aXT7yeASm/vQhkcfwqdgOACd72XUg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AOKMOwDi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01C38606A325;
	Thu, 19 Nov 2026 03:45:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AOKMOwDi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51D1C1F000C4;
	Thu, 19 Nov 2026 03:45:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795059921;
	bh=hsn61N9NOH1nVmiK63u6xkjUaQD97ymNnACwXXYM8Lk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AOKMOwDiclMeBZj2h7iYc0p2JC9Svfr/lWVapwInnWiVmlxTPwsqYZ1V2Khir5fd9
	 VrDIoq1stF5efutHhz6rKEFAuvD29Zwd3tcU/uMXKbiJHbLcevpQlpRDUFtGZx0nDD
	 3axI+myNG5nt5FyFv5B95+iVdlh1AwkZ2omBvIjE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Henrik Enquist <henrik.enquist@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0977/1848] ALSA: aloop: Update the PCM Slave controls for a matching playback
Date: Wed, 18 Nov 2026 15:50:15 +0100
Message-ID: <20261118145957.851286246@linuxfoundation.org>
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
[ sashal: adapted the checks to the existing err/goto unlock flow and snd_pcm_running() helper ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/drivers/aloop.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/sound/drivers/aloop.c b/sound/drivers/aloop.c
index 5ff8fdaf8989d..6f0aa9a6f6dcf 100644
--- a/sound/drivers/aloop.c
+++ b/sound/drivers/aloop.c
@@ -352,12 +352,15 @@ static int loopback_check_format(struct loopback_cable *cable, int stream)
 		check = runtime->format != cruntime->format ||
 			runtime->rate != cruntime->rate ||
 			runtime->channels != cruntime->channels;
-		if (!check)
-			goto unlock;
-		if (stream == SNDRV_PCM_STREAM_CAPTURE) {
+		/*
+		 * Matching params also go on to the update below, so that
+		 * the setup controls follow a playback that joins an open
+		 * capture.
+		 */
+		if (check && stream == SNDRV_PCM_STREAM_CAPTURE) {
 			err = -EIO;
 			goto unlock;
-		} else if (snd_pcm_running(dpcm_capt->substream)) {
+		} else if (check && snd_pcm_running(dpcm_capt->substream)) {
 			/* close must not free the peer runtime below */
 			atomic_inc(&cable->stop_count);
 			stop_capture = true;
-- 
2.53.0



