Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2724619A29C;
	Thu, 25 Jul 2024 14:44:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721918644; cv=none; b=tCi1TakZ6xQ7K6IBQomYduWqImZOpJ4NZBaRBcqKdUD4At3NDLqrq0a+7q0OFbv6YPtR8MfvALt6VMnFoxFOvOETze//gFdc856TX93oohrrYhcxLzI/ffKAhN3qFRY/qv+1UtqaoMhsiyoAZXe64yb7tvBuHVRZx07BgJio+Q8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721918644; c=relaxed/simple;
	bh=h10HA9JyKN7oa7riOA6oCD7euPYX+Ju8z84nT9wZP6I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J8vv8kZVRO24zl28/Ooq2tfpVeAIALxyBv8/aLFZtTqK8Ku7DrpPslGbUKY9/sOuvl3f33c3TpzbT0eLHQgTdRAQZBrgq19vJ2H2l5/GrctTUBkJidU+7fuzM5W+5SvRVeiooo1+roT7br5ezKX/b2mAjMlSynD2GTD1eEFf+TU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v5QaQ2aq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v5QaQ2aq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92D85C116B1;
	Thu, 25 Jul 2024 14:44:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721918644;
	bh=h10HA9JyKN7oa7riOA6oCD7euPYX+Ju8z84nT9wZP6I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v5QaQ2aqUpuj6lFugYCEPFKsrwGp3wJAn3BYiFlXh9Bpukd2vJV+gqhBg6fXVYgDP
	 imJmnQ4nw4H/AgHiu87DH3zFHP1qWZwJF/cpza6kHsxfEWzWZ6dQE83TdQnCCCecTq
	 TTZDunCaqH2Dmv+6Q+HaeNHB2fSqJlXcAukEQuuQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kailang Yang <kailang@realtek.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 16/43] ALSA: hda/realtek: Add more codec ID to no shutup pins list
Date: Thu, 25 Jul 2024 16:36:39 +0200
Message-ID: <20240725142731.087580026@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240725142730.471190017@linuxfoundation.org>
References: <20240725142730.471190017@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 8a411a6fe0b7c..ff3a90e2e35cc 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -520,10 +520,14 @@ static void alc_shutup_pins(struct hda_codec *codec)
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



