Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795053632;
	b=0nrrlaTChpkJP18v+caDP2CC0hWoHO9Q9qp79GLMkZ9iVCCgKWbAQtsFmeijhpjHFOGr
	 QNL2GAPTRorBlmHxXxQIaqfxOFr/0k2+PvN/HtSAGbeCCPYMVioToOzWSZJ7BJAJuen9s
	 PTuAZzjNEUqgeJQddhW58GLomQiTBDzb13pptCALkDkk4VizBwP/iuesWmRX6nu0RAYam
	 iOVWOddx+e41fFmUh4EsmEmtW+sg73IVQfRYnRZ403wnAd6E/XRBCIf9Y7lFRULWIWphK
	 UWJ7a2xSj/LC8dYZuycHui43gs1gmgpZKLYht48Jaj5+Sk017qYV3AemW4B1ijMhDjg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795053632;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1hu5satxLTdn1Brd2oOyrZyg0rrUZ6bWu/ocvkNo2HM=;
	b=u3dT6AYRvdCjwC3hPAv60s8J1bDgSHSpyBEi39cslNmk0hEqIe6uebRdvWfrVZpxWKIb
	 oJDCht5jeUGuRB9p1ujVIJ57sHl8hKtKGJU/5w9wGybE13BICXm6KB9udqoTRXmAa440X
	 v5Lt8I0Ziar7TryeOm0y8ZcZWxPGieGb0yF9Jyvn1KUEX2i4NZMgN78WfEoQsXcNiBFs2
	 nP9JxbYChOMdg8WJEomyKiYb8tO5ptOC7os62ZFPbZ6NjYtzAyH+B+TcAYiYqVL8kEyxD
	 /3Bsn+kaevcYtuuFMLA7DYQnR83ooyjuDzFLYPvpjiFWONB3j2W0M3IJSkJ+vEJ6A1Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ujH5433Q;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E3B6606A331;
	Thu, 19 Nov 2026 02:00:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ujH5433Q
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC8ED1F000C4;
	Thu, 19 Nov 2026 02:00:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795053632;
	bh=1hu5satxLTdn1Brd2oOyrZyg0rrUZ6bWu/ocvkNo2HM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ujH5433QcfC3Ex4XOyV6Ba3olItJqgfsm2ymqygcSwrTsVggYEGbecesnCHD+gcgC
	 JPdl1fhENzS6/SuYW3VsCKigdnDzJYZvm5pPwW5M5qWFh0PFG31wx++jbF1t93cJb/
	 WvxlzvgRgpw1xu4TonA1tIHCycQD1cDqrkBvREXQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0989/2214] ALSA: usb-audio: Protect Roland control activation
Date: Wed, 18 Nov 2026 15:44:25 +0100
Message-ID: <20261118150051.856605268@linuxfoundation.org>
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
[ sashal: adapted guard-based locking to explicit mutex and rwsem lock/unlock calls ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/midi.c | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/sound/usb/midi.c b/sound/usb/midi.c
index 4738d70ed75f3..70084be58f0fa 100644
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



