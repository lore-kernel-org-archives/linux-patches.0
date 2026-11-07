Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064807;
	b=hYoiA/Ol47wbQIQJEqnngFo7AH3FnAz30KXAzsi+h9P+XulXutQJs3a3Xc4mihYCU1C7
	 WJcgIlvfLxbG3HsRpgPxNvW9L8P9plNbrFN2BZT3UJgKiH5o6PTcicMkB6gyNBa80SMVc
	 ao4H4Ok/lqJhjBl6D+PEUxG/U4FYoHw3iEha6wQsIL1iukoBLi+UVPDpqYnO+YoAzKt3M
	 FIWkdwI3rIqHYQuxuxyCDBq85Z9ACYwLlY2Z9+NJvHIwtSB3p4owYhugsmrXib3flzLNr
	 RqcsZmY3Bc+zXnKNCnenZHNqRax4m5bj9+wOCcceCHYxNz3w5BdWQwEfvsIZ9k27bPQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064807;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=AjHuqYrpktNza/tahbS4Heg6hTjThT3nQp+PtjSNY10=;
	b=UT8ItQ304Gca/P15YzpDwhsyVZE/04r7nL9qB/LUKuznw1fn2JooJJx2flIQjnxmzAhc
	 Ny9KkH0OKSmktXvOBmHka/dOmGybLjnHqvMl3+UJH9PYM0ZZXYIxM/dE0UuMJsPU2Z+1O
	 mRkEGUft+hCu3y9KkPIR64TUkG9bzydlJBjWj81QiTnrv+83YZvdjyvoHFc5yV4yb2EuZ
	 jZB0peV6uzG17Klvm5xiSvU9qNsrIMOaypwT9PZHQGuHXQhll/JJKpqR7WTSYJYC65dHw
	 G/HmGCHSLX1V7XnWdDvT07GYs6ahGUgNKfoFNP34vymHguZZinETA9XtUKUTHR9MdgQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AVIy5mXB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47A15606C02A;
	Sat,  7 Nov 2026 15:20:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AVIy5mXB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA3251F008A3;
	Sat,  7 Nov 2026 15:20:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064807;
	bh=AjHuqYrpktNza/tahbS4Heg6hTjThT3nQp+PtjSNY10=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AVIy5mXBPbnCSkVWv3gh2wMHXkLV1a7j2+zg1dvRWMbikvAuwNBJuobMQ4Rm6gLKL
	 tnwvQuQfVfKVjfcMvnE9WXdTIwqT4QHNbwLjOu6yQ4KEST/3ORsP7jWrxPyv1BPp7F
	 m+wfqYvO2UQkJ6cheYe/zMEUoZ0Lc2kl0RfVHO0E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Denis Arefev <arefev@swemel.ru>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0746/1257] ALSA: cs46xx: fix unit mismatch in DSP code area bounds check
Date: Sat,  7 Nov 2026 08:50:42 -0500
Message-ID: <20261107134959.895363536@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 6fd4f629d1d57..a77e6f5a14ada 100644
--- a/sound/pci/cs46xx/dsp_spos.c
+++ b/sound/pci/cs46xx/dsp_spos.c
@@ -393,7 +393,7 @@ int cs46xx_dsp_load_module (struct snd_cs46xx * chip, struct dsp_module_desc * m
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



