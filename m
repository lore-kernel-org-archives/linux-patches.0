Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 818F615E8B;
	Mon, 30 Dec 2024 15:59:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735574370; cv=none; b=nyZw3GzxDOXnsKqMiw2u7UN5R8ItQQWmj5ul96/H3RufmuXZHT22jcOPa7hOEkcSJUy4aygRWUqBUJ0RW2ia0CcP9IlXIhJ1+ZI4Tx5USObZTL/Enqoo8OQTM1u+JNi5yBMnKVteTXTJHl6VuzWhO1W603Feltjq0AucQBaUmyg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735574370; c=relaxed/simple;
	bh=MgAbtB6+zKEMApn/z33H01sDSMBj93dVz5qSagjJP2Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pfLnRMUDJQOnUycax0MOt42SMEs7hzGSP589w7vMyODC2FDN59TKrdi1jeipgGPwzr1yeZHv9cb/UZAUtiuqPCiXc5mPFRMxMMDSiJsL3+U5hhp92uvuk1R0dm0hkGDHSo0srgdgPEfSb68EKnyhcjLQ1LvM5kR20WkwKi/CJSc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=llNXPUhE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="llNXPUhE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5098C4CED0;
	Mon, 30 Dec 2024 15:59:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1735574370;
	bh=MgAbtB6+zKEMApn/z33H01sDSMBj93dVz5qSagjJP2Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=llNXPUhELH3I/rMN1/r6bupZ165nyXmbi+ilQrWWhS+4pkgRxSpeE8omPjOOEEjgW
	 xErdipFNEUBco7z4VO3ZPpSR/gQdkXvEWZ4pSVbZWIbals4RIYNEl5r0cLnSQS/1ig
	 HojRXNcjMXMFCviXkio8diOY4xXJOXtIKwWZJCys=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.12 114/114] ALSA: sh: Fix wrong argument order for copy_from_iter()
Date: Mon, 30 Dec 2024 16:43:51 +0100
Message-ID: <20241230154222.515529490@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241230154218.044787220@linuxfoundation.org>
References: <20241230154218.044787220@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
 


