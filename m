Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB990157A4F;
	Tue, 23 Jul 2024 18:27:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721759249; cv=none; b=Sg+cLsWe31Jxpn2m6XYbz5adKXzn+5EnjmEBrda2sTClreS8Xd+RivXncWgPOajuGxjh+Qw01/jzwVy7o3mfpxxzC+4qNXAga9hmq4y94CBpMyVYCBOWvWA1rxTbMuxBAGhBI14y2EY+yOY51H7GdDXf+ZYUelavpZA7JkBDIJ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721759249; c=relaxed/simple;
	bh=Lfp4MMIcETNvcAogfgVLrQuPWnpiyjBlqNr+W7yzR4U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Wng/ZplYyY1d6LPVM71nLM+fvCVVsA1ZWlEEUV8ggB/CLTIOoVgA5f/jZ3QxMiVNbmIj1pxmUDzA4nakJzDQoCT+qCPNvP6DRb/55MoWWWn8J4sF27OrGV/n8bDWhHeh1GCEtv+e3v0aOILSl5oh0SV/dJ+2wZKD5Xg3bInE0Kg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ugoCIlzC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ugoCIlzC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 407CAC4AF0A;
	Tue, 23 Jul 2024 18:27:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721759249;
	bh=Lfp4MMIcETNvcAogfgVLrQuPWnpiyjBlqNr+W7yzR4U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ugoCIlzCdw4I8EHAQh+NZfKAK4vJHa+N3Ty7ivaWh0EJyTa5SbOUacMnnfhAFUzIR
	 98Co8gjvQBO7fjHK5gCoAivsou6uTKt+DqaM241LFYI00owNQ3MUmfrgEruLjX2FPw
	 w3P8jZPbT/qPBIVQPzlXksvk6ows2pknKdT52DJo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kailang Yang <kailang@realtek.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 052/105] ALSA: hda/realtek: Add more codec ID to no shutup pins list
Date: Tue, 23 Jul 2024 20:23:29 +0200
Message-ID: <20240723180405.256210479@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240723180402.490567226@linuxfoundation.org>
References: <20240723180402.490567226@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kailang Yang <kailang@realtek.com>

[ Upstream commit 70794b9563fe011988bcf6a081af9777e63e8d37 ]

If it enter to runtime D3 state, it didn't shutup Headset MIC pin.

Signed-off-by: Kailang Yang <kailang@realtek.com>
Link: https://lore.kernel.org/r/8d86f61e7d6f4a03b311e4eb4e5caaef@realtek.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_realtek.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 06f00819d1a8a..8852c0b429fd7 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -583,10 +583,14 @@ static void alc_shutup_pins(struct hda_codec *codec)
 	switch (codec->core.vendor_id) {
 	case 0x10ec0236:
 	case 0x10ec0256:
+	case 0x10ec0257:
 	case 0x19e58326:
 	case 0x10ec0283:
+	case 0x10ec0285:
 	case 0x10ec0286:
+	case 0x10ec0287:
 	case 0x10ec0288:
+	case 0x10ec0295:
 	case 0x10ec0298:
 		alc_headset_mic_no_shutup(codec);
 		break;
-- 
2.43.0



