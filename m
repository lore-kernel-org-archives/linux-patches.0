Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795042099;
	b=io52itDXLqRDVBb7aZkGXhB10RJpCkfkKNicBoiqGEGy9wUfCTF3luF36wKtkUnV+kFp
	 Fz1LO5IKk0ZBt9qYpSSPiIazPRKIHPtCEFyafTQjFIrSqXCHf5OmkfFjAG4N0fFCYhzPj
	 ELLEik6bLVka1xHjJk+WKEuyIzJIr2L7GdBrJw4WhSyJY1b3HBt1MWXm78075GLgW6NsF
	 LkT5ZFIGIPtGZpsFNlL7zcys3hE2K+Kxosqkj1MOOCzwVnlwlnIIZEiAHwEmP8WhDsrv8
	 OjpX+Za97lilJZbq61jP4MN9mR0+k2BsA4rIaym5szdG/4MyqzG9/vD6Ss0ghX5l8Ww==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795042099;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Ib8oC3nqy7Ob8cRverWngAnmeUONoaE5QWqVBuWTN68=;
	b=q9oyLgqN8lj9jmmOzfSwcTnUiPWzPsVJ7RlUZabUJwLAFW/kPohI5AohS1na2FaMnp3C
	 HeyxADfftBrs2Y1iae3Db4u5Iqecca/+lzg69DqVJTRC+t4zXQlx8M5Q4fr3frNSqEJYe
	 SK3zBbFOKASIycw9Qdk7066KNKKcAdIas7RJP/F+/u7+zvN2sLaRHlo6FbKD+DauykD1U
	 Zgkt5mMWTOwzmNkbqGUnmaGIGBTONytKlkTU5HcOJxI/ASpD4446S4mFgqIHoSvjBaEVO
	 1LYWmnraS9LZt5R1KWqTQYKjKZ2nyJNMQt0TFv3TwLlsCli4OO0JXGbp9eLRFBAdYMw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bbAmdPtr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1781D606A31C;
	Wed, 18 Nov 2026 22:48:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bbAmdPtr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CA751F000C4;
	Wed, 18 Nov 2026 22:48:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795042098;
	bh=Ib8oC3nqy7Ob8cRverWngAnmeUONoaE5QWqVBuWTN68=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bbAmdPtrK3aR11G4PlVLVtfHCBeXSGFbS0/r9J7DnVSv7smqcvjOiTvJxyn5VX1BL
	 yNzU2avl5t3S9TNKTVj3yDH/4C73yHSZS9Vhq5pdx96nu6OuD/vxHQ8jUTHjohuDW3
	 6gNnj8Mh2Gta78oGIPhV8Sj0ZeWDovndC2a8ErX4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cen Zhang <zzzccc427@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 3049/3318] ALSA: pcm: Remove channel-map controls before freeing substreams
Date: Wed, 18 Nov 2026 16:01:11 +0100
Message-ID: <20261118150451.622909433@linuxfoundation.org>
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

From: Cen Zhang <zzzccc427@gmail.com>

[ Upstream commit d5dd05c1f72a95d8ab06828d7272a185ad2b9185 ]

A late HDA codec bind on an already registered card builds new PCMs
before registering them. add_std_chmaps() publishes generic channel-map
controls during this BUILD stage. If an earlier chmap succeeds and a
later allocation fails, probe cleanup frees the BUILD PCM while the
card's control device remains accessible.

These generic controls are added directly by snd_pcm_add_chmap_ctls();
snd_hda_ctls_clear() only removes codec-tracked mixer controls. BUILD
devices also skip dev_disconnect. snd_pcm_free_stream() then frees the
substreams before free_chmap() withdraws their generic control:

  Late HDA codec bind / rollback        Control GET on the live card
  ------------------------------       ----------------------------
  hda_codec_driver_probe()
    snd_hda_codec_build_pcms()
      PCM is BUILD
    snd_hda_codec_build_controls()
      add_std_chmaps()
        publish an earlier chmap
        later allocation: -ENOMEM
    snd_hda_codec_cleanup_for_unbind()
      snd_hda_ctls_clear()
        generic chmap remains
      codec_release_pcms()
        snd_device_free()
          BUILD: skip dev_disconnect
          snd_pcm_free_stream()
            kfree(substream)
                                       snd_ctl_elem_read()
                                         down_read(controls_rwsem)
                                         pcm_chmap_ctl_get()
                                           walk freed substream
            free_chmap()
              snd_ctl_remove()
                wait for GET
                                         up_read(controls_rwsem)

The control read lock cannot protect a substream already freed before
control removal starts. The failure above occurs before
snd_card_register(), so the PCM has not transitioned out of BUILD.

Move free_chmap() before the substream free loop. Its snd_ctl_remove()
withdraws the control and drains readers under controls_rwsem before any
substream is released. Normal registered-device disconnect already
removes the control, so the later call remains harmless on that path.

Fixes: 2d3391ec0ecc ("ALSA: PCM: channel mapping API implementation")
Assisted-by: LLM
Signed-off-by: Cen Zhang <zzzccc427@gmail.com>
Link: https://patch.msgid.link/pm-pmb-4a207d9ef3a3597a74a4-v4-80b0113669b1a62fbbe9@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/core/pcm.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/sound/core/pcm.c b/sound/core/pcm.c
index fa2f0bcbb63dc..cda9f608e0308 100644
--- a/sound/core/pcm.c
+++ b/sound/core/pcm.c
@@ -836,6 +836,9 @@ static void snd_pcm_free_stream(struct snd_pcm_str * pstr)
 	/* free all proc files under the stream */
 	snd_pcm_stream_proc_done(pstr);
 
+	/* Drain channel-map callbacks before freeing the substreams. */
+	free_chmap(pstr);
+
 	substream = pstr->substream;
 	while (substream) {
 		substream_next = substream->next;
@@ -850,7 +853,6 @@ static void snd_pcm_free_stream(struct snd_pcm_str * pstr)
 		kfree(setup);
 	}
 #endif
-	free_chmap(pstr);
 	if (pstr->substream_count)
 		put_device(pstr->dev);
 }
-- 
2.53.0



