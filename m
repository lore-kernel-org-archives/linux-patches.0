Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795056622;
	b=1FI06FRXVyBavQN4E76r1SHqeTaXpbimMR1vzEl0uykPNqj8heO4WjJT566VqG37R2UW
	 8/vtPpJREu2y1Cr4R+SDDtHYbzjkNs2ePG/pbNcE9o+FVWXkbTWyLs4qgEOYXRfJYuzVb
	 /dAMrjaqRZ1kAc08h0SENUFA+XYCumq4ZHk8loK9RvwMAmgDj4kFd7w0y4YTGEh6gAzy6
	 sqQl4NoYsCQJj6Dbd2f/+ygAjBt/v7p3nouHNBlbeX2jVtYX7pGD6BpFgZjNSkKm3Icck
	 BRnm8t5E7bQFUoeZStBNlgE/42iKGTySxqz25NYM6sE87wuVDK3tB8D9JUTyq3xwuXw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795056622;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=V4IhDJUtdK+bkCaOM7JH4QuQ+Kh4okhEdwj4MCBypi4=;
	b=EkJLJQ/lEyLSUc6Wd5sjUGGVfPK6oaGm2B0+2BUL9HHynFhcZ4EJfEYBzNSC/DifsJyN
	 NtyI3puOzQH6M1cC1SBBP7F1F1YY1hXj+Rg+epK9ELuNT4dfUubLz0RL0IOqy/9tOZTYx
	 yD4bPPsXV94zOyk+hUlTW6fLrRBNnWFuw+g+cwRAnl0IxChoLyAbvygYr/bcrHG05Jy/R
	 MmGWWN3TddLEe3+G4k540O5orbFTwoOv9vI6n52avkvfWVYVTmUV2hTqOW4R4AYcD1pmA
	 1FtRl/vhQYgtkCff06LbBFTyBCSlFSH2KtDQOlkaPsJkdCTa9nIcSnGrrSZoS2ANv+Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0O2rfioO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FF71606A325;
	Thu, 19 Nov 2026 02:50:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0O2rfioO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7FB81F000C5;
	Thu, 19 Nov 2026 02:50:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795056622;
	bh=V4IhDJUtdK+bkCaOM7JH4QuQ+Kh4okhEdwj4MCBypi4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0O2rfioOlkOZHafdMy97jdT854ASnaJljQc0U3Lkjf3jltCMN11Ci5ebxVGrI1xo6
	 Guild1hNHCe2mb4x3AR21CR4Y/arSPcSiavUToG71WK+f161mmkn6SG3CxFQskdyjP
	 iYF3YSBYRQkiX/ZxYgPqF4ILYb5im6MCtBGV1Vyg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cen Zhang <zzzccc427@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 2053/2214] ALSA: pcm: Remove channel-map controls before freeing substreams
Date: Wed, 18 Nov 2026 16:02:09 +0100
Message-ID: <20261118150132.820873725@linuxfoundation.org>
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
index bbb5e3fab57a2..edfea73da2bf0 100644
--- a/sound/core/pcm.c
+++ b/sound/core/pcm.c
@@ -830,6 +830,9 @@ static void snd_pcm_free_stream(struct snd_pcm_str * pstr)
 	/* free all proc files under the stream */
 	snd_pcm_stream_proc_done(pstr);
 
+	/* Drain channel-map callbacks before freeing the substreams. */
+	free_chmap(pstr);
+
 	substream = pstr->substream;
 	while (substream) {
 		substream_next = substream->next;
@@ -844,7 +847,6 @@ static void snd_pcm_free_stream(struct snd_pcm_str * pstr)
 		kfree(setup);
 	}
 #endif
-	free_chmap(pstr);
 	if (pstr->substream_count)
 		put_device(&pstr->dev);
 }
-- 
2.53.0



