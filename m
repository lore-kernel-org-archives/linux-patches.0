Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795050328;
	b=vXMmIxgUx/yJHKgFQIvOpYPGshjoqZLpWahWOBQCd4wAaqY3J23XJhT9CpoVwDj7Ir7J
	 11DArQHCmoxLmlJ1x7qS2IHLop+z3aMTwiXFSbFfUUcNlVNLwpcbQmfsNzUEkzDk9hKCA
	 H4b1HNAQxmisFBim5kvp6frCHp9jeP65DIs1iNC6b7HgDFLIjs3JKUzQPxs+yd2TwDtjX
	 lvdOTG0+HF1sjW4em+xdjIX4q53DCwDMunkEP4FaFw/D3bB8J+oaz0XNGbDW7RZtl/pbb
	 e+6B4pZ5o1WfxaD/I1++HWjdSALPV+x+pi4I/6HrpajaP3JYtBddA10E1Wei6CiUQyw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795050328;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+V0KwIYxkqpa1+LotJi6AiU/D4uSv0JJFOXbNXEqcvM=;
	b=HX00wlI+VsvqPvw3E0LAvJUzggFf8LqpDfHE4ye99EByi56C2+96YZpp+gkM4jesLn0i
	 o6bfRztTBNnU/ttqPka6oAAtIwUoQ/EDKX00A2j/TIBqMgXsQbRbhkbs58+PhByDm9+Yv
	 +OKrTYLM1Glch6hlVVMOjCj4Ly339SQEcKbEBsQ1yl04bOluz5Ygj6/UUEwJ5L7NhhI/E
	 n+FvpNrmLufRJXj/yunHA4qna3N5xW+49KiQNHkJJed9++eUChG3+UEpBLosLUlVJ2VHL
	 tos36V8Mlw2Q00UyXHjrwd0dwNH/1zSLP1yeMNqeKUz/J71/xhgdMfqONVKPZVLbJHw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dofqXxNt;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8C87606A31C;
	Thu, 19 Nov 2026 01:05:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dofqXxNt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6FBC1F000C4;
	Thu, 19 Nov 2026 01:05:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795050328;
	bh=+V0KwIYxkqpa1+LotJi6AiU/D4uSv0JJFOXbNXEqcvM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dofqXxNt7DgRPbRe8034gxOK8x7Ivu7lZkuWBHXn80WKYW3GXL1KYGiHUFwLbr32t
	 ghRnXZTNy3mNHsvKRThgZ6gR44qK4nr+dB40WSziNww4FEEzgmyZPiD6TB1NJXgNsn
	 8o64U34hj9iE10Fxqzx5GwZ8JK7WXGvFs5G69wHg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cen Zhang <zzzccc427@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2628/2857] ALSA: pcm: Remove channel-map controls before freeing substreams
Date: Wed, 18 Nov 2026 16:01:02 +0100
Message-ID: <20261118150336.210432100@linuxfoundation.org>
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
index 8855481be5b48..adf1e80d3cd90 100644
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



