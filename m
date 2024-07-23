Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DAF013D600;
	Tue, 23 Jul 2024 18:32:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721759578; cv=none; b=pDCmfNQHLOCak/VcbroB1275mrmoCfMRaVKkHtcWnb1HTmZh3bc3gBLN9rYCWv1CXFYrUNZeT0q0hqvYehjtzC8+wCsW5qe6JNZveCYvhOrqbNX/NjfFwbj5Th/u8VDq2KdUCUWY2+Zde6GNVB3dJAcVpBTUZcgBoiPymqYAHak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721759578; c=relaxed/simple;
	bh=3Hf+9KtfIBH1wZtOtMEXP+K0pQEl+okfT9zDS6JJE+k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OeSSmJXinYduRB0BVaq7oxbYlcgCZNlNNEFoTaw1M+UptF4KNjbCGsJBCiUXBbqGK7JeQjsLJPoF0QPBUIbdYMnq32i3GXCoZEqWcQvkJrpLjVEdmvK/JZlhMBBVRKDarbTHxbeJgnR6kT8dvf0VY+L3WKNLelwYDk1ASnvHFsg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LINvQvEb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LINvQvEb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB4AEC4AF0B;
	Tue, 23 Jul 2024 18:32:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721759578;
	bh=3Hf+9KtfIBH1wZtOtMEXP+K0pQEl+okfT9zDS6JJE+k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LINvQvEbBje/y7jvp9IF1G9AQfS7nnKOOUJrJYmhrQa+GiSCL5EvqQxKOw+FVQEM7
	 DDd8i+REt+J5Zp8VgEaS7XS9JemHECFRTXzBkj5qSS5NdRNn7F5S4n3jBDKP4ATnZY
	 w0qCPM+w+2mfSYcojP8ZzJCMNCmc6y5P9r7iCXS4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kailang Yang <kailang@realtek.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 056/129] ALSA: hda/realtek: Add more codec ID to no shutup pins list
Date: Tue, 23 Jul 2024 20:23:24 +0200
Message-ID: <20240723180406.952842032@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240723180404.759900207@linuxfoundation.org>
References: <20240723180404.759900207@linuxfoundation.org>
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
index 0624006bbaf40..20d5769fc0eaf 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -585,10 +585,14 @@ static void alc_shutup_pins(struct hda_codec *codec)
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



