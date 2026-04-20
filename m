Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DD1033262B;
	Mon, 20 Apr 2026 15:48:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776700081; cv=none; b=Md05YRPMchLSE20yFxnotxN16VR1Pbi7/53qmzTA40JRVn9DY/SmuV/oiex2w+9sumFnmv7vwu+1pxq47IoJD9pkAmAe7BcLzfEyydsb4uhKPZ0m44LNdBk8WiTDGxs3ON+hdBKuLBpo8ePyvs7JWzi16biK7NNfeerB11jD8qo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776700081; c=relaxed/simple;
	bh=igHgcaYwpunnbyqRMGA/1pvj+mSwJ70HwZ1OFuZviik=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=odqO35LbEb6kqmiKocr4CbQIFvpewwPdwBQwqJw4O+EcN9vOh58aSxZxGgDi5k8/EHIu+yR4ip5jjJvttDRQxHNr0Co7YtA1SPlRxVVgx0G++4gcop0uC+rPicJ+d7KXazE+agV2sxWjGlyOWTvb+xx7123d3ftCmG+luifE4HY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d37jG5BN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d37jG5BN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 985B6C19425;
	Mon, 20 Apr 2026 15:48:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776700080;
	bh=igHgcaYwpunnbyqRMGA/1pvj+mSwJ70HwZ1OFuZviik=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d37jG5BNzNuHBxNpH59twxcxIIu2UO1GfgMSxml+0CEpWYGfZHGqGN/Zm6xybVn6s
	 y8qs8oAttzvlXJaFXBEfbqlCItPVNza5N/8Hl43Z8Dq2q9dfjqvREN1BihRRKtgxEI
	 +aE/5vbFfx5RRaiz6nMGV9yaTX2gBaUvQpWfjcqU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Heng <zhangheng@kylinos.cn>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 005/220] ALSA: hda/realtek: add quirk for Lenovo Yoga 7 2-in-1 16AKP10
Date: Mon, 20 Apr 2026 17:39:06 +0200
Message-ID: <20260420153934.214265692@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420153934.013228280@linuxfoundation.org>
References: <20260420153934.013228280@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhang Heng <zhangheng@kylinos.cn>

[ Upstream commit 7bae956cac0433c4d41aac9f1d04e42694e0b706 ]

This machine is equipped with ALC287 and requires the quirk
ALC287_FIXUP_YOGA9_14IAP7_BASS_SPK_PIN to fix the issue
where the bass speakers are not configured and the speaker
volume cannot be controlled.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=221210
Signed-off-by: Zhang Heng <zhangheng@kylinos.cn>
Link: https://patch.msgid.link/20260313080624.1395362-1-zhangheng@kylinos.cn
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/hda/codecs/realtek/alc269.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/hda/codecs/realtek/alc269.c b/sound/hda/codecs/realtek/alc269.c
index cbe4bbf9b1171..ce9cb7614bec7 100644
--- a/sound/hda/codecs/realtek/alc269.c
+++ b/sound/hda/codecs/realtek/alc269.c
@@ -7613,6 +7613,7 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x17aa, 0x38ab, "Thinkbook 16P", ALC287_FIXUP_MG_RTKC_CSAMP_CS35L41_I2C_THINKPAD),
 	SND_PCI_QUIRK(0x17aa, 0x38b4, "Legion Slim 7 16IRH8", ALC287_FIXUP_CS35L41_I2C_2),
 	HDA_CODEC_QUIRK(0x17aa, 0x391c, "Lenovo Yoga 7 2-in-1 14AKP10", ALC287_FIXUP_YOGA9_14IAP7_BASS_SPK_PIN),
+	HDA_CODEC_QUIRK(0x17aa, 0x391d, "Lenovo Yoga 7 2-in-1 16AKP10", ALC287_FIXUP_YOGA9_14IAP7_BASS_SPK_PIN),
 	SND_PCI_QUIRK(0x17aa, 0x38b5, "Legion Slim 7 16IRH8", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x17aa, 0x38b6, "Legion Slim 7 16APH8", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x17aa, 0x38b7, "Legion Slim 7 16APH8", ALC287_FIXUP_CS35L41_I2C_2),
-- 
2.53.0



