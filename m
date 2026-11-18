Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795038091;
	b=zAgOPxK87nQOlq3Iin5dY2Rd1/JaPxZZN6xpUXm/ufy0GHmCUBXHjBqRmErTttvXv8eX
	 nc8bCra2HEFEnfNPsYf8aOEszGjmm9YOHganB9yux6sRCsGzW9hECvWlEkD0sdzmj1DYu
	 hjsZutzjhXegT67HBPClDnAfezLPKTsl1P8hcZSx6ZX359bQLfjHvlFLTr/6bk067QceQ
	 TWv3b6Kd9iGlvpGI/sghimvMvNTxbdnzxoee3qD21IBlnc6NFQDC0gz1G4Hd7HExqhOr0
	 ojFEk257yD8dOnyD1xMia4I5NFsJ2SRBIP15wySCGD8jA7Y6UkOpNGCXIlfyoVdGuMA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795038091;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=mVoH1cXI5bpWPtr7EIpKDOJ0ZiaQPUTL3mDSg2i0BSc=;
	b=SPqGP7wMvlNmYZyPxT1yy+MFJZWU4CJ9rAUfIjEXyzT2IQaSItlCL9X1BLdYKJTzkzFG
	 XHBKVWdDi7wAYtFOdAO9SQTZ2N/4FpV6HKPl8aGHUhRRlg3tI7n2NAQZLwySyUWyyYn12
	 m45sWxN63yJ1PrdX0h3to8nexz5G1L50j7OhhqPo5d5z521iYCD/YD+c7dGtMMPbJvvDz
	 T8LP2FbcHiZjmDTOldxOwNuf7qyY8O3njMLOiYYeek8pDGm502LBriB0zhU1E9+TNFNm2
	 cPwjy/SxNskN14R2lqKeeTz/EYKWIHzvJCVKIWrRt5k7HlA5sqtCBoHd5Kv3qqaBZwQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lEq2gpMD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E089606A31C;
	Wed, 18 Nov 2026 21:41:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lEq2gpMD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E4691F000C4;
	Wed, 18 Nov 2026 21:41:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795038091;
	bh=mVoH1cXI5bpWPtr7EIpKDOJ0ZiaQPUTL3mDSg2i0BSc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lEq2gpMDLfMRU6CzweAq13XPDQKHN/zpNJkzibyqKTr7qaaROZXDdZu9E3vv6Sdya
	 67TRVSWHdbWcZh5+Qxs0yO5VMX4BSKHHMURydRT1grKSmq1LGUlxP/4wjtNVIKpQ6m
	 1r5fxJlwqK+EAUfJCGJ4RUXLSfXzX+zGhg0YzobQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1623/3318] ALSA: usb-audio: Protect Roland control activation
Date: Wed, 18 Nov 2026 15:37:25 +0100
Message-ID: <20261118150410.422883082@linuxfoundation.org>
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

From: Runyu Xiao <runyu.xiao@seu.edu.cn>

[ Upstream commit 19b42c1fff7f220a6346c614d79ce1bda6d95b40 ]

The USB MIDI driver changes the Roland MIDI Input Mode control's access
flags directly from the rawmidi open and close paths.  These changes are
not protected by the ALSA control core and the corresponding notifications
can race with control access.

Use snd_ctl_activate_id() so that the control core updates the access flags
and sends the notification under its lock.  Release the USB MIDI mutex
before calling it because the control write path holds controls_rwsem while
roland_load_put() takes the USB MIDI mutex.

Keep the state transition and alternate-setting change under the USB MIDI
mutex; rawmidi's open mutex serializes the enclosing open and close paths.

Fixes: 96f61d9ade82 ("sound: usb-audio: allow switching altsetting on Roland USB MIDI devices")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Runyu Xiao <runyu.xiao@seu.edu.cn>
Link: https://patch.msgid.link/20260929141726.2166899-1-runyu.xiao@seu.edu.cn
Signed-off-by: Takashi Iwai <tiwai@suse.de>
[ sashal: adapted scoped mutex locking to the existing mutex_lock()/mutex_unlock() sequence ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/midi.c | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/sound/usb/midi.c b/sound/usb/midi.c
index 156b16e48373f..0758422e949bd 100644
--- a/sound/usb/midi.c
+++ b/sound/usb/midi.c
@@ -1152,7 +1152,9 @@ static int substream_open(struct snd_rawmidi_substream *substream, int dir,
 			  int open)
 {
 	struct snd_usb_midi *umidi = substream->rmidi->private_data;
-	struct snd_kcontrol *ctl;
+	struct snd_ctl_elem_id ctl_id;
+	bool activate_ctl = false;
+	bool active;
 
 	down_read(&umidi->disc_rwsem);
 	if (umidi->disconnected) {
@@ -1164,11 +1166,9 @@ static int substream_open(struct snd_rawmidi_substream *substream, int dir,
 	if (open) {
 		if (!umidi->opened[0] && !umidi->opened[1]) {
 			if (umidi->roland_load_ctl) {
-				ctl = umidi->roland_load_ctl;
-				ctl->vd[0].access |=
-					SNDRV_CTL_ELEM_ACCESS_INACTIVE;
-				snd_ctl_notify(umidi->card,
-				       SNDRV_CTL_EVENT_MASK_INFO, &ctl->id);
+				ctl_id = umidi->roland_load_ctl->id;
+				activate_ctl = true;
+				active = false;
 				update_roland_altsetting(umidi);
 			}
 		}
@@ -1181,15 +1181,15 @@ static int substream_open(struct snd_rawmidi_substream *substream, int dir,
 			snd_usbmidi_input_stop(&umidi->list);
 		if (!umidi->opened[0] && !umidi->opened[1]) {
 			if (umidi->roland_load_ctl) {
-				ctl = umidi->roland_load_ctl;
-				ctl->vd[0].access &=
-					~SNDRV_CTL_ELEM_ACCESS_INACTIVE;
-				snd_ctl_notify(umidi->card,
-				       SNDRV_CTL_EVENT_MASK_INFO, &ctl->id);
+				ctl_id = umidi->roland_load_ctl->id;
+				activate_ctl = true;
+				active = true;
 			}
 		}
 	}
 	mutex_unlock(&umidi->mutex);
+	if (activate_ctl)
+		snd_ctl_activate_id(umidi->card, &ctl_id, active);
 	up_read(&umidi->disc_rwsem);
 	return 0;
 }
-- 
2.53.0



