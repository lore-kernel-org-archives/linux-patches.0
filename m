Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795036561;
	b=2gzJ5F/1prfNttRYAIxuFkSTjvAsPqol3i/sMSBMK8wZUKUkZUB/nplc4PCmb+jtL6lc
	 7OjhXFYE1GZtGG5caURklm2qiiz8CWXHJxG4+et59azcbBFQnLWjxYOfA+zkk88Tum0N6
	 GzSLZ5Vp8UKrBa6Tza6hhmvTm83fWbJjb7tG8r+T/UVp9c5v+yqiaQ9H0NHUGLC3g2z/n
	 WxhpKkbj64+0A+pcWwViwv5pZmhd9wwuIgIm/vRU+5OIeI/9SBDHtXmhkBUXPSxya93pM
	 ENLhJ9ARudWEr2RgARWW4QCfEoUpR7LxATc2VNSAnOAi6hHj9bCPhIAPmeBpWeEmQRA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795036561;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1BIJadSDM5z5EbxwLglOn/AgmoZ4MDUm7qIL5di+efk=;
	b=XiK9ICfxeW0Z6UU8iHgTdFP6qQVKxKEfB4Vn+rczCLGPOi4gvyYJ9LYE6yQMKcPOTDcl
	 Mt66AKOpUUymmEcA9R2T90GPE7QSpZAnXRbQvGQs+fg9aFr39FOi9Dz5hUcjFSRMjdV0H
	 hTEgvKY/4sAB4A8bEQRmO39xvHNCyJgClNmNg/ENe0hVZ0c40mpDWT4Gu1qNIojYkp8mZ
	 fRwJTwMr8PrG6e605eGDqrLvc3Txg0k8hWSWgB0GAgYiK8wWeNmVQqN+yR0P53WKt7whn
	 F1EsYUmSoLBKYY/xNGVGecocje6eW8WJUlhwlwnGPCcgUDVfqCUbIav14tIgrOOr6NA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jzLibYtt;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD49F60A260B;
	Wed, 18 Nov 2026 21:16:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jzLibYtt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8CE91F000C4;
	Wed, 18 Nov 2026 21:16:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795036561;
	bh=1BIJadSDM5z5EbxwLglOn/AgmoZ4MDUm7qIL5di+efk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jzLibYttg5UFt4mAtxT7QU+RtUXAQLAGyzz9t3doyB6lglg2/k/gi2gjt57iHdolD
	 khEyyARZ4nlcoVCKu+3dxHC/Z7nMkXM9JK4AvAu5XfuLmj4RNVuknr/WkmzNqL0OjS
	 pVmgfBvVfkHSxFVVFuhBiZIsUQKkukAHgGC4vNtM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Denis Arefev <arefev@swemel.ru>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1102/3318] ALSA: cs46xx: fix unit mismatch in DSP code area bounds check
Date: Wed, 18 Nov 2026 15:28:44 +0100
Message-ID: <20261118150353.047832282@linuxfoundation.org>
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



