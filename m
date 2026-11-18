Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795058518;
	b=Mw+cvYU+5bI9/apD4aHgr60TTIDnK0D5ze0T6nkRP0VyyixqaoDv2aQ0zoLm2pErvGfp
	 a60Iaj/DvojliJejKIqi0rGMoMcHDms0klWPMEvmXMFT6avmdxfiB4rj9Ko/PAnYFeEsJ
	 qBmQZU2pckQhWbPakfJqEX5cLIZ0i2+IkAGdChTMXBfe8wPz2A1SS0trnTi8fGxGdqbD6
	 gDyLkr5ftlpTs4um9X9DKjkxgafeON4uKrnC0zzPJbAW9l+corY6a0b4xaVDGCuaxJICf
	 WwqkpxQFFULL2ZBJAKguhI1ksUlmeh+/By20B+6nXFYa9mkt5td8YAzpEvsDQc0ulKQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795058518;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Soa1x866/w6clWdQj8wRhL0goFFiKwquOfuFeoctODo=;
	b=t1bkNrjdzmXmGvcB9G/BQjSQyZGMnVAyxH6QeIGYLRbvEIfU4nZ4DF8FNEtoHPvtv3vU
	 nCwiznq6a5ORpPtn4MbvN6sQgcJozGV25hqCOKjqZUhEc41sFKVY8u8SoLHGP0a29gBSy
	 H2v8zRnOc/h8txhqKP8L5J6KVWlq02m6FCE8+/K9eYFft97k1/H0nKVMEdJbbvA+/Au5g
	 7+OXInskXc9DeduyMB680PJKhfQRqVV9fN3PgJZ0uIciF5jtn6kEYHynDc6kOe+gH3sqB
	 7TK4CXrOgoREwhVj6QVSm+VteIzK/Uc/lwTG6EXCNHSw0sB4FS2jBXRfMbNCCRyL/Pw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2G5Cq2Wy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C8D1606A334;
	Thu, 19 Nov 2026 03:21:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2G5Cq2Wy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C7861F000C4;
	Thu, 19 Nov 2026 03:21:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795058517;
	bh=Soa1x866/w6clWdQj8wRhL0goFFiKwquOfuFeoctODo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2G5Cq2Wy25vIm6OvKYAGONFJUrzC7i1CQ+uuiCnzpdWOFqy7Rgtvl5Qj7BbCxh+kn
	 JArougfeHgvylryecvFiVKwIkeRO6zbqEn5b4g89cV+a8zKslWq1Te4A2TVipl6umF
	 fGrIJvYbeB2U+nVm8CJUbPfGlCQoMOfwzUEYHzNk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Denis Arefev <arefev@swemel.ru>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0514/1848] ALSA: cs46xx: fix unit mismatch in DSP code area bounds check
Date: Wed, 18 Nov 2026 15:42:32 +0100
Message-ID: <20261118145936.232123675@linuxfoundation.org>
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
index 05f3f6dc918dc..5d7c38a0ac7be 100644
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



