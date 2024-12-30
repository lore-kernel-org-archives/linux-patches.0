Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5B8D15E8B;
	Mon, 30 Dec 2024 15:52:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735573955; cv=none; b=MxUYknBIiFu35pEBsWjEdK/2xEtIChMVFdqOrEGS/igRmnSA9USoIFH96+AqiO10kIRxl5afQOXRrcl5Zz21DwroysQW2qrw5/KBZ6dIykNlpzW3qs2Gg6UinglWZQwt407QuR8kninfqrttvv3e3bqXlJ4OPOHnX7HA+ucHKrU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735573955; c=relaxed/simple;
	bh=jCuBaEJfhmjsYRWaFB0tHsKJgCEOaviUhdZrBr3PkFI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lrmk8wAE9dmTTKOhLuR4udEfe2OQIeslKXLxo4TtTgNxdemZrQsuQteBhU3543bPEWjcT/lmEYMw05BKyTE1h6WHtKd3Z+9T9dA3sc/dDEKAAps0He1iu5YHHvEqCZ0BY9Oo41PzGtxiO7D/VzMof2+qzjzxs2oJaQu/c0E3MLM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1GoGeihQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1GoGeihQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32C4AC4CED0;
	Mon, 30 Dec 2024 15:52:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1735573955;
	bh=jCuBaEJfhmjsYRWaFB0tHsKJgCEOaviUhdZrBr3PkFI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1GoGeihQQluZXfsMAaA+aHIhgiZFqa73ObstNpSc4WhzE2U7qX5PJY15Q6eFGwCAX
	 /UiCqmb63aSisYVDf/60ewAcUjjTXpqN6OZU2MK630Duw04WOfYvqJu8+mg+buEEFg
	 VBCS9G+QNhOMHppKbgdFjjsCHQPULGvAhVCepMP4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.6 83/86] ALSA: sh: Fix wrong argument order for copy_from_iter()
Date: Mon, 30 Dec 2024 16:43:31 +0100
Message-ID: <20241230154214.863683387@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241230154211.711515682@linuxfoundation.org>
References: <20241230154211.711515682@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 66a0a2b0473c39ae85c44628d14e4366fdc0aa0d upstream.

Fix a brown paper bag bug I introduced at converting to the standard
iter helper; the arguments were wrongly passed and have to be
swapped.

Fixes: 9b5f8ee43e48 ("ALSA: sh: Use standard helper for buffer accesses")
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202412140019.jat5Dofr-lkp@intel.com/
Link: https://patch.msgid.link/20241220114417.5898-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/sh/sh_dac_audio.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/sh/sh_dac_audio.c
+++ b/sound/sh/sh_dac_audio.c
@@ -163,7 +163,7 @@ static int snd_sh_dac_pcm_copy(struct sn
 	/* channel is not used (interleaved data) */
 	struct snd_sh_dac *chip = snd_pcm_substream_chip(substream);
 
-	if (copy_from_iter(chip->data_buffer + pos, src, count) != count)
+	if (copy_from_iter(chip->data_buffer + pos, count, src) != count)
 		return -EFAULT;
 	chip->buffer_end = chip->data_buffer + pos + count;
 


