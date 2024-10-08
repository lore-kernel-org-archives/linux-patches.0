Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F40C21DF270;
	Tue,  8 Oct 2024 13:11:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728393088; cv=none; b=X36THVQp2hL++X6NaGytdHdSSvoLyXW+5+OG9cyp23EbDPzct+iAexgw5Pa1pV6jtj8EVTP2ZjrbR2s8C7Jl7jY2vvCvnIytf45cg1+iwYry/3JMsR59ux+E7NUcyJkxZb2agx30aXtWk7BhfhA0NGrTEs7pgnma1pxis6LrgM8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728393088; c=relaxed/simple;
	bh=/E8oonKZnhVLMuhLfqWuIfTw3qXA/uAiuVOei5GtTaQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eJ7fFFKrVTCUgLprT/le66miqIAz190gHFFrLx3zv3IOcLOMwfFIlKUHc2Qyjj+X8mmBpfP3wsdq/9E6NeaUGhQWa9b2YTJFy1ZYRHqZSIloQL1Afcd6BQI+w00nt9AAC8zmf3k6F0/Z8RXz62cw/uybNLENmx5shx9cWOfxEg0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wf06PNYa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wf06PNYa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06267C4CEC7;
	Tue,  8 Oct 2024 13:11:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728393087;
	bh=/E8oonKZnhVLMuhLfqWuIfTw3qXA/uAiuVOei5GtTaQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wf06PNYaX5daQ37Drun6oRlZb7ecFSHjgyvS5nxhXisU/qpALvle9DpL1p75VGUZB
	 xOoh3mX15HGpUDm2nQQiaJiUSV3sFlqGU3DuVMA3s9ldMMQcLYLLSSsKIGf2hP/Xe4
	 kmnlv6bg+umFOy79XQswzJIXNRTun2ryfZYjbtXo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oder Chiou <oder_chiou@realtek.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 048/386] ALSA: hda/realtek: Fix the push button function for the ALC257
Date: Tue,  8 Oct 2024 14:04:53 +0200
Message-ID: <20241008115631.362788843@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115629.309157387@linuxfoundation.org>
References: <20241008115629.309157387@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oder Chiou <oder_chiou@realtek.com>

[ Upstream commit 05df9732a0894846c46d0062d4af535c5002799d ]

The headset push button cannot work properly in case of the ALC257.
This patch reverted the previous commit to correct the side effect.

Fixes: ef9718b3d54e ("ALSA: hda/realtek: Fix noise from speakers on Lenovo IdeaPad 3 15IAU7")
Signed-off-by: Oder Chiou <oder_chiou@realtek.com>
Link: https://patch.msgid.link/20240930105039.3473266-1-oder_chiou@realtek.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_realtek.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 130508f5ad9c8..657223c49515c 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -585,6 +585,7 @@ static void alc_shutup_pins(struct hda_codec *codec)
 	switch (codec->core.vendor_id) {
 	case 0x10ec0236:
 	case 0x10ec0256:
+	case 0x10ec0257:
 	case 0x19e58326:
 	case 0x10ec0283:
 	case 0x10ec0285:
-- 
2.43.0



