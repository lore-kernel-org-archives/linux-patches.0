Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795059381;
	b=J3NodXG1k/ptphKgxUtILtOv0o2r+rnSQoTLhba35GU68RQqSjAdaRo4kG45yG/AuzKY
	 WFYs3y7X+yhrvjXfzPb5AFZpDADfA3qKqm9sc3kCJvMgGbb/hf1E3jn8ZSGG5miyOa0+r
	 mlZPtWkeUZwLJCdAy9k21xoErwoyzfgE1CVsTG8npK72qWZeju4OxFSDKK0Fz0/ea95mx
	 +Y8cniYn0LPDY9oPUvaErXC5quvxxldAdQXsON+8Q4b4IBmRNy+E31ZYWbNHSRLz6gP93
	 QuHyKLxRV2oPsFZasQMYfi6hai4c842HO3qPrkHW5z1tRI2FUruO/FA7OSQHJfsHe3g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795059381;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=fMyZhJ3ZIaF6FbxUcDgWafkrlfYm8V+kkt0Hai917QQ=;
	b=2nNE9/2Z7luwEpHFUupZZnnDhllAXLiVTxIlTeC/t+f4+QyVOod6RAfOeIGICpb5EXZt
	 e7sdbLZPeXif+9Cj+bwYvBJHJFFVkJBVKx/nIfKn1R6/IDLtGzVUqbQit8kuNCvHtUfFy
	 cS5ZXuAFIxyV6sT3cQFHxRISX2LPF1Zle59dI4W1J2mhlEEK/0lSuhmY6tPfeLp7uPsec
	 vfrZ+wfDOfEEXIgkFpwBycvZLq6eItT0xREnBQha1/iXoU2Ar0rgnNMVEgfs4TfFOjovD
	 IqdRlnLEtGw79zMn13bV5gSP24kh7D9UcKC9enuneUFaHixCkdo0dtwkspWjjZeYgEw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="Iw7fl/78";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22920606A325;
	Thu, 19 Nov 2026 03:36:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Iw7fl/78
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7825D1F000C4;
	Thu, 19 Nov 2026 03:36:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795059381;
	bh=fMyZhJ3ZIaF6FbxUcDgWafkrlfYm8V+kkt0Hai917QQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Iw7fl/782ktTviXhKx4GQL65P7mXvMy8OqbaqPAd1aZ9RyGrbZOSmk7ANesfueJkf
	 vSxYla9zl2SNjnrKJWcvyXFgOLj9UzCPGjXFseXJOehwVpxx75CnoCob8Rrz4lQfdK
	 iPoaYIZflWEIYiuny79BWgTN4+98G5t9kJOK0ZeM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0821/1848] ALSA: usb-audio: Protect Roland control activation
Date: Wed, 18 Nov 2026 15:47:39 +0100
Message-ID: <20261118145951.004951780@linuxfoundation.org>
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
[ sashal: Adapted guard-based locking to the existing explicit mutex and rwsem lock/unlock calls. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/midi.c | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/sound/usb/midi.c b/sound/usb/midi.c
index 2ae37bb2ad645..fc5c640d0a009 100644
--- a/sound/usb/midi.c
+++ b/sound/usb/midi.c
@@ -1168,7 +1168,9 @@ static int substream_open(struct snd_rawmidi_substream *substream, int dir,
 			  int open)
 {
 	struct snd_usb_midi *umidi = substream->rmidi->private_data;
-	struct snd_kcontrol *ctl;
+	struct snd_ctl_elem_id ctl_id;
+	bool activate_ctl = false;
+	bool active;
 
 	down_read(&umidi->disc_rwsem);
 	if (umidi->disconnected) {
@@ -1180,11 +1182,9 @@ static int substream_open(struct snd_rawmidi_substream *substream, int dir,
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
@@ -1197,15 +1197,15 @@ static int substream_open(struct snd_rawmidi_substream *substream, int dir,
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



