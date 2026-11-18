Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795037538;
	b=OgHU5MS75G13M0iOVf2Vsv7IHbix+5TBPMPZF8qXKgvOhX2f/ifDPg3ZXaqTGQxEHFAc
	 nHYZPoCmufEnB8a4tJb3Hkz9RKXDikyRvYIJmF4FVZwfhdb9eW82FPLU0t8a1veckZU6q
	 hWo05lRNF0geKwjzugJs+NGWi4muluFeemBM6villWsLsRuTmE8LAGPUM/R2YtXXvH9n+
	 rdUl0FOVwSI4vp3HlikNgKRCv2DA0jHLaeFekvT6VZ2LD1BG373/N5SWCHwi6fYKVp2Vy
	 3c3le4byRFXskekxDT4kl+pv1sWgZGuJxsZ0NakuMP8R2bXhWPH9CzG7ViequHUzGYw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795037538;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=d3XyXZm20lhYZRSnKptCplqZ3L6sPNVnFEPQ1gvGsbw=;
	b=dwKmpALeW181fsK0P/apIQs3JQN0xhCdhmZuBP3K0c9RVdugaVA25+F52b9q8kpcLBIP
	 z6Esll48My7MzFHtbdV0w/mDzPZlYcc+X1oXQAIqGrne14aD2GqodQ6Slg9vJn7hiLNXJ
	 zeX+OCsUeN1ETnRX1GJtvcPItVBnGEgjmNF0yEKaH9sRV9YOwj9CDCiyiTE2u22Ry35Hf
	 KokVnQ3J7hfq7vuHyLMLwRWvtY4gAkXxfsJCsKsmlJrNibdmUVYp1gwkNnv49YYAoEwbp
	 Y9d81w6QpeNncZKALtcjn0DryIMxbEoCpMgTFK2cqPGyDPSUDNVO3ky9kDTNlOyWlpg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cYBvhhbt;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 987E4606A31C;
	Wed, 18 Nov 2026 21:32:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cYBvhhbt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B815B1F000C4;
	Wed, 18 Nov 2026 21:32:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795037538;
	bh=d3XyXZm20lhYZRSnKptCplqZ3L6sPNVnFEPQ1gvGsbw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cYBvhhbtYxUgEElflv6bvFNA79a3UD/rzOT/Xmwz6d0wT2M8Nc1waJZBKxbeICuVg
	 nlT+SkddB0t/ORe6tr1ii5OFy4Cc4cGSwhBvJMTkdsRD/NusXVSR+yciCzkLqtgRP/
	 g1jTDPlcRUn97fDuJSOiOdS5ISajfVJ/sXRm8xmo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bin Yu <byu@xidian.edu.cn>,
	Cheng Wen <wencheng@xidian.edu.cn>,
	YuanZhe Liu <25031212351@stu.xidian.edu.cn>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1433/3318] ALSA: hwdep: Serialize DSP load requests
Date: Wed, 18 Nov 2026 15:34:15 +0100
Message-ID: <20261118150403.771657929@linuxfoundation.org>
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

From: YuanZhe Liu <25031212351@stu.xidian.edu.cn>

[ Upstream commit aee83c204f80d56b4d55f53acdb8594308ddcd4a ]

The check of the loaded DSP indices and the call of the driver's
dsp_load callback in snd_hwdep_dsp_load() are not serialized.  A hwdep
file descriptor can be shared among threads, or inherited across fork,
so two SNDRV_HWDEP_IOCTL_DSP_LOAD requests for the same index can both
observe the index as unloaded and enter the driver's callback
concurrently, even though the device itself is opened exclusively.

This breaks the assumption behind hw->dsp_loaded that a firmware index
is loaded only once.  For example, snd-usb-usx2y hits
WARN_ON(usx2y->as04.buffer) in usx2y_async_seq04_init() and may
allocate the US-428 sequence URBs twice.

Serialize the check, the callback invocation and the bookkeeping with a
per-hwdep mutex, so that the second request returns -EBUSY.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Co-developed-by: Bin Yu <byu@xidian.edu.cn>
Signed-off-by: Bin Yu <byu@xidian.edu.cn>
Co-developed-by: Cheng Wen <wencheng@xidian.edu.cn>
Signed-off-by: Cheng Wen <wencheng@xidian.edu.cn>
Signed-off-by: YuanZhe Liu <25031212351@stu.xidian.edu.cn>
Link: https://patch.msgid.link/20261029084810.21910-2-25031212351@stu.xidian.edu.cn
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/sound/hwdep.h | 1 +
 sound/core/hwdep.c    | 2 ++
 2 files changed, 3 insertions(+)

diff --git a/include/sound/hwdep.h b/include/sound/hwdep.h
index b0da633184cde..7357727f06603 100644
--- a/include/sound/hwdep.h
+++ b/include/sound/hwdep.h
@@ -57,6 +57,7 @@ struct snd_hwdep {
 
 	struct mutex open_mutex;
 	int used;			/* reference counter */
+	struct mutex dsp_mutex;		/* serializes DSP load requests */
 	unsigned int dsp_loaded;	/* bit fields of loaded dsp indices */
 	unsigned int exclusive:1;	/* exclusive access mode */
 };
diff --git a/sound/core/hwdep.c b/sound/core/hwdep.c
index de7476034f2cf..378188a528d05 100644
--- a/sound/core/hwdep.c
+++ b/sound/core/hwdep.c
@@ -212,6 +212,7 @@ static int snd_hwdep_dsp_load(struct snd_hwdep *hw,
 		return -ENXIO;
 	if (info->index >= 32)
 		return -EINVAL;
+	guard(mutex)(&hw->dsp_mutex);
 	/* check whether the dsp was already loaded */
 	if (hw->dsp_loaded & (1u << info->index))
 		return -EBUSY;
@@ -382,6 +383,7 @@ int snd_hwdep_new(struct snd_card *card, char *id, int device,
 
 	init_waitqueue_head(&hwdep->open_wait);
 	mutex_init(&hwdep->open_mutex);
+	mutex_init(&hwdep->dsp_mutex);
 	hwdep->card = card;
 	hwdep->device = device;
 	if (id)
-- 
2.53.0



