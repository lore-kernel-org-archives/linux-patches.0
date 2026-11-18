Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795045616;
	b=KrcbDMKlQ3AoqOaSBgVyXZfUtjqs3mDCxuQxOloauOz4Zr5WNY9GJF0NfujQbmLd86xu
	 3P4GU4ZnHOw1iY90JdbvIAp3kCjqSRdsLXTzXr5UQLE5cceiHB+VZFtIOI6JtCWYGaLsu
	 WlWZyj71dDnb2hVE5txlZS5m3JJL0+gqfSAfSEbz65AmZtJ5FY5bqmBB92DsvJHpmCwsD
	 WnyjuRnPyVR7AKRYKuxwu1sx9EIT6HdBHyGnuAXeWbL7l0DBxVpABCgnCdOWTIMSPQktx
	 ETjkqotMh+DPw942oSEx7HXlN8+pHgtFNkuvk2QCsJ5bf3vIohakrDN+usbpiQLlPyw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795045616;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=JQnhlmOidrGbst3//E1twTI00m+K1NoowtlO+hTzzoA=;
	b=w3sUi9jfuQbo8G1MRWL6/SgkpWF33NndivqFJRGFIMMNXw2YXOVWBr+EPnkcU379GkLX
	 BgbEj1/Qqn3B8sTdWEllG1oonBU+1FeUH5N0mwqecx+E92ZjfaaCsO+bM7OPLnWx6lqqm
	 sfI7aDy4ACdOWBhooDnickt23CgCPSe79mtEB9QGWFaMbBsREoLocf0fXP8H5pZFabC/7
	 6VjoD6e9rEErPwqDAwPSVbohAtyzI0aWdGgWX1+32HqUVb7wWXuuy6VMrrNHKGhRdwhK6
	 62IPbe4eb6FN5JR+/+sqnbsWeaqXBkW8hGU9BfzfnBCoPAid180+z+RNtP8z9Xr8BUQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=s8FksZ5J;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D94F4606A325;
	Wed, 18 Nov 2026 23:46:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=s8FksZ5J
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 377CB1F000C4;
	Wed, 18 Nov 2026 23:46:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795045616;
	bh=JQnhlmOidrGbst3//E1twTI00m+K1NoowtlO+hTzzoA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=s8FksZ5JEVwEgaZ+yOBDSvgldXj49ztQlFTzERqWaZoP3R97sbpB3ozNCuppenRV/
	 +BrJwMyFessXvRpTC9AnZpgt+xYzo/ma/yP02cRPG1g7Jctnd5DMHFjCy8D/E5aEu1
	 gQUK6BrOvGkMFIgCDFlK2NkXbtLPDIn9fLruAfTs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Denis Arefev <arefev@swemel.ru>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0947/2857] ALSA: cs46xx: fix unit mismatch in DSP code area bounds check
Date: Wed, 18 Nov 2026 15:33:01 +0100
Message-ID: <20261118150235.705096104@linuxfoundation.org>
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



