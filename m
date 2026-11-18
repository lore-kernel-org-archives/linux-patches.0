Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795052778;
	b=ngcwHd+UGvFhGJQ3O2B1SEk0e8jDEyFdj2AAvcOliM/EwP5yqUDuJZ3/5mDvFxjVbQFo
	 UqizPSrNBTv3qIC+YFH7LXARlMEuxigBl5UgB8Q+6/rseJBiiEmZeD31wx7beKzcxDW/s
	 vzhiW8PFbUud8UpRcr5QEpJE/paY3hGvwWyNf+0v2Hf1UE8gB9D+IH2f1CaQwSf7BidGG
	 /g48bsSq63uENRBY2Fk4K8w0HgorWK4/9r939DDdeY+T/s+qb/O5Y0nQAjBohL1h0Fhlo
	 LLtr553NGCcYrtU5jArXGtYklWFpzhhhQiudmnzRXPFlY+yUvL/xviqSV6fGN9mwO6w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795052778;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=PnyWF7PpUSK1+3zZgBXNWTrffQbjpyEt18I9T6uDkIw=;
	b=TbP6ElcdrDdFYfVnS/HhaAP5peOVECfljy9RfxC4ydCNK6RyDsXPvlIgRTJgyBP9ijxQ
	 mWvtdPrIJCOVHeERQeNM1YHb/8Z2Mf+nqSsmnBqKAdtEl0C0lA7hvWmDxic8UOBIw8Lcd
	 m3GO2z/Hm+b4pG8s/CCoKR9muIrdGZ3jT8Xe6MBQlpdrnMPEJuU7UD8zuwV9iC1ebF5ZQ
	 q+nn7Z6nfP1POSsFgerIc2FVE4v5YxFqS4JuypLfCZdkDUKGTX9ytT+NuRJKGiBxzIK3Y
	 iQfORfyZp6WqoKXgsebUo/BO9h0qK2uEnUCJWg1tzYvUIh+VxPpDkNGJip14LS7ohew==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BCzNNSOf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17D45606A31C;
	Thu, 19 Nov 2026 01:46:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BCzNNSOf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 695EE1F000C4;
	Thu, 19 Nov 2026 01:46:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795052777;
	bh=PnyWF7PpUSK1+3zZgBXNWTrffQbjpyEt18I9T6uDkIw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BCzNNSOf/071b1FIYcVKFKDvLz2C+f0Q95caXv89wwtWitr696H1jp0wRmnI5sn5i
	 bLGPjMTJCEqWJoGcCKHsxzOzfWpX9PNhLdlwFfCfbCbZrKLw7DbX83kToKrZRoBBfW
	 qHgqgTf5IIfZ0BXr8wX7xUKlzLfbxcXvfvgyu7nY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Denis Arefev <arefev@swemel.ru>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0636/2214] ALSA: cs46xx: fix unit mismatch in DSP code area bounds check
Date: Wed, 18 Nov 2026 15:38:32 +0100
Message-ID: <20261118150036.781638343@linuxfoundation.org>
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

From: Denis Arefev <arefev@swemel.ru>

[ Upstream commit fd65108f5001ffb416dc9bd37ec1893f55cff24a ]

ins->code.offset and code->size are measured in 32-bit words, while
DSP_CODE_BYTE_SIZE is the size of the DSP code area in bytes. The
check ins->code.offset + code->size > DSP_CODE_BYTE_SIZE in
cs46xx_dsp_load_module() therefore allowed up to four times more code
than the code area can hold.

The shadow buffer ins->code.data is allocated with
kmalloc(DSP_CODE_BYTE_SIZE), i.e. it holds DSP_CODE_BYTE_SIZE/4
words. A firmware file with a code segment larger than
DSP_CODE_BYTE_SIZE/4 words (28 KiB) passed the check and caused an
out-of-bounds write in shadow_and_reallocate_code() and an
out-of-bounds read in snd_cs46xx_download().

Compare the sum in words against DSP_CODE_BYTE_SIZE/4 and cast it to
u64 so that the sum cannot wrap for large code->size values.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Signed-off-by: Denis Arefev <arefev@swemel.ru>
Link: https://patch.msgid.link/20261014102619.16415-1-arefev@swemel.ru
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/cs46xx/dsp_spos.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/pci/cs46xx/dsp_spos.c b/sound/pci/cs46xx/dsp_spos.c
index 1db6bc58d6a61..dd23b7d68c164 100644
--- a/sound/pci/cs46xx/dsp_spos.c
+++ b/sound/pci/cs46xx/dsp_spos.c
@@ -396,7 +396,7 @@ int cs46xx_dsp_load_module (struct snd_cs46xx * chip, struct dsp_module_desc * m
 		dev_dbg(chip->card->dev,
 			"dsp_spos: module got no code segment\n");
 	} else {
-		if (ins->code.offset + code->size > DSP_CODE_BYTE_SIZE) {
+		if ((u64)ins->code.offset + code->size > DSP_CODE_BYTE_SIZE / 4) {
 			dev_err(chip->card->dev,
 				"dsp_spos: no space available in DSP\n");
 			return -ENOMEM;
-- 
2.53.0



