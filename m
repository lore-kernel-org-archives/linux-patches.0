Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A75D13D896;
	Tue, 23 Jul 2024 18:41:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721760110; cv=none; b=kQI1/YygojB6RkLiaWJuMDPKv47fClbElXaDnJFkQqBsegpYDrnAJ2xtk8Wk4GWCcVagqs+jXIf/GIK/APRlSL4+DkhQCSt7EnDV0Z5mQgzgb9LZus3Va9Yqs0zIHyjSdVDPy5/I/Nhu3+jzDf7ZIUze1VJtKRJvi9eFBVUlZ00=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721760110; c=relaxed/simple;
	bh=suzVP3IiyNPm1YwYRv6kLTGTHj5euoagWLKy/iuCmsA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rAEgOYv7aXh8JWkjdEf5p1WHc/9umF2VWbZZ9fL/LqLsGZqGO3W+1uD1K2GcNLBqQjuDrrEO5yPIdyLoFdb/S+a9VzaZAqXwvWvvCmSiDYYxJUfQ7+UmebH9xQT70B2nvgNPqnukVzY5idGQ6D3njVc+2cLOvGbOWcsDv0lJ13U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=boUL8gG7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="boUL8gG7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2BEAC4AF09;
	Tue, 23 Jul 2024 18:41:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721760110;
	bh=suzVP3IiyNPm1YwYRv6kLTGTHj5euoagWLKy/iuCmsA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=boUL8gG7IaC9Gxkhu8xVMV7ebIohsPtgH7Mix80OPhkjjCrcah79m4ISTNVrtzOmY
	 oeiDWhZ1Hc3f+QBFBrXhywsZPN9Uoc2seaPmz/bGjBhA7PEbg/FRUGBPor533NuMOH
	 HD6uNJEdsltKKdrcYQw/Zz/XWD9r5MQ2JzcyBypA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kailang Yang <kailang@realtek.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 075/163] ALSA: hda/realtek: Add more codec ID to no shutup pins list
Date: Tue, 23 Jul 2024 20:23:24 +0200
Message-ID: <20240723180146.367869735@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240723180143.461739294@linuxfoundation.org>
References: <20240723180143.461739294@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

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
index 9a326e66b0b19..a260dfb7fde0c 100644
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



