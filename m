Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5FF819CD0C;
	Thu, 25 Jul 2024 14:53:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721919236; cv=none; b=HsqAe+K4QAUP9dSNQsSskarMzPr03k1ehDt3i/WuYMo6wdKTZMk/9XhM8+ans12oMsxfTPNkpi3yqSoQ/iNgtFPwCKQaf8VBLMsIuLnt07NN+eLJKFd7QY5204gS/h46uffq1+l21FL7basBtsn/JC5KGCowUuDccqdSjrLmVLk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721919236; c=relaxed/simple;
	bh=DKpJsBUZeAmEzJrdHXofOhktP7jygO1zy4sxu0RMhZc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FSXG76CF+iM0jCrMnFy67X1mltWt1XIW6+gDeuAQuyN4JDA4W/a89siV/53MGZwlNdmJ0YA6BQKWEegKgBc0IF1B1LjFBW+U4z4w9XGu+xDbf61f8N9dvekZlVtNTD8y4bTdmg+eNLDjC8jcZpilP3ikg0uYNoXaNyWpMdVVcIY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zc7kX9lg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zc7kX9lg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8F7EC32782;
	Thu, 25 Jul 2024 14:53:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721919236;
	bh=DKpJsBUZeAmEzJrdHXofOhktP7jygO1zy4sxu0RMhZc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zc7kX9lgxdqP1irkKNoVhtEh8SQ799BKTq5gXZqSRenOv3Zf3nt0DE970kPXohjE/
	 ABV+UWNESM3ZV5uI7iDvO1gDFBr7YALvT4tf0l0f857hhiEzOS+aB4YXOclQ5Xr4rR
	 luiaeRPC9b8jVrwfTlCdWcsh3XoxbVfrmqc0GrwI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kailang Yang <kailang@realtek.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 34/87] ALSA: hda/realtek: Add more codec ID to no shutup pins list
Date: Thu, 25 Jul 2024 16:37:07 +0200
Message-ID: <20240725142739.721931287@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240725142738.422724252@linuxfoundation.org>
References: <20240725142738.422724252@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 6e3772f2d6bcd..aeecc208e7fa0 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -577,10 +577,14 @@ static void alc_shutup_pins(struct hda_codec *codec)
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



