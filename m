Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795061928;
	b=a1OUGLSXXT06KNsEwEJWEmGM7AT3C8hDCOywrRwatjiQJBWhpbBj5SfNFgjyEHEOVB0C
	 2l/v4M5VOrXDE+DEXOVkqjK82uiBSbguOyPRB5OBqWCnrPjN01ReJ4Y6DZHfYu4eft5ib
	 b1OFnHo2An7YFBjmJc7BjRDuamrKUJ5js7Godg+H0tspZl2VAHAG+5H8Uqv2CNBRc7srN
	 mMCzq5t7s/x7IIzuf3yuqxEYwlxBCCGH/Ec9D813Izm+BCx6G3EWEb0Slk2lLRON/2r1h
	 PObq/lQ9gvl0N8gA7qLUDj7q/Ss8kaondz3bA3RoFbMS3mjOY0wj5kJhXmU1Dbie9jQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795061928;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=5nstCvd4yIbgobtg144MG1qMjkFTeY6BcfUdCy7wXNc=;
	b=isPTj2W477YP2OAZuJW9cXw2BdzP3klZ8TuToTO8s9piYkBvVQOyjmSjTrLhN9Lsebwq
	 x5uywNvUgZb7gRJb7MCoZBG9rg78JPmhp8ZM5h6H7fxQWVo6UTD5vK5rR7AkehVdHuat9
	 b6tYvRB+zUko0ZpKXx9npwyFanrlFqh2zZKL6upMyGF/kil/Wb72juELbmqbYcN3D9jW3
	 vn7SAO9kGuUAdldnwDkppYDJ/xej6AqrCl6kdrDDg5YjmRpGTtqgw23ewLW+FdhY01k2M
	 Gp6rnVxbgjliBFPXeFQUhl6kBkCJ0AGjb4XLOmeDcL8sSt8kVrR90GvjWKOsNkJEpZA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=h6SRE+vJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79871606A326;
	Thu, 19 Nov 2026 04:18:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=h6SRE+vJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAF211F000C4;
	Thu, 19 Nov 2026 04:18:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795061928;
	bh=5nstCvd4yIbgobtg144MG1qMjkFTeY6BcfUdCy7wXNc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=h6SRE+vJ6iaHNCiPnetNuGxzbkieHm2Iuo3Vum020tDkgruwbfto/fMbDg11qTy26
	 DRBxvn21yYXQvEq7sSgskDtaQvYVtHB4D5f2lwBKY/VNhCG2g3IBpwMgVjcoYuwwRF
	 D1LgDLqhYG+4pQKpexaFKVOJ5pMxFbM1WVoEXgMU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cen Zhang <zzzccc427@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1726/1848] ALSA: pcm: Remove channel-map controls before freeing substreams
Date: Wed, 18 Nov 2026 16:02:44 +0100
Message-ID: <20261118150031.868628576@linuxfoundation.org>
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
index d4eb842784143..756857ea80d0b 100644
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



