Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16D451E525;
	Mon,  1 Apr 2024 16:47:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711990068; cv=none; b=SwsoqrSXf5D9Pre76ad4ai3OJAyQBc6EzjhuqwZ5qdLlsU3ZHy3iUvPOTljsr950I7jDTq1HJX7mNGV80romS+O4h24WRsUYPbPO7qeZpvTbq2vDfT/eWUyuyEbgPQiZyjp4y1BPD75uW+fc++dIg3lq/r6Ujy7TKe2rJjBKkKk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711990068; c=relaxed/simple;
	bh=wDkzHUdW9M4KI4j214yORY4UvDGmV8U4edh/GiZqo4U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k4BbZwk5jJvdhSCbg7fBz8zJ0e3M+2OLdiTMLTZcQ2PZRN73vmangCid9RSLMmbB5KV2k09WBkQiPni4r5Gdq0j6pAl0tBKtKldRexkodnT+03S857qHwHBjzZs5MrKvNRSUj5Bt+YQBLvhyAs9aVTgwn26sZ450gMSsciw6/iw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I2vzK+A9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I2vzK+A9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BD8BC433C7;
	Mon,  1 Apr 2024 16:47:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711990068;
	bh=wDkzHUdW9M4KI4j214yORY4UvDGmV8U4edh/GiZqo4U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I2vzK+A9cFJfu/imwjI4dYMQAF+Nk1IxGbwQhMdYEfeW+Zk87fiZgZEOo7qf+xlzU
	 M5T3pnHZcmm4lfRDSObInmi9NOvyKuDN5RFOnol2YbdC7CDrj59GkWyzoXVQa9A3G6
	 +uib3/MFRQweH9+WzR8FDHPvs26tCH1EiLVOtqyA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kailang Yang <kailang@realtek.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.6 236/396] ALSA: hda/realtek - Add Headset Mic supported Acer NB platform
Date: Mon,  1 Apr 2024 17:44:45 +0200
Message-ID: <20240401152554.951660116@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152547.867452742@linuxfoundation.org>
References: <20240401152547.867452742@linuxfoundation.org>
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

commit 34ab5bbc6e82214d7f7393eba26d164b303ebb4e upstream.

It will be enable headset Mic for Acer NB platform.

Signed-off-by: Kailang Yang <kailang@realtek.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/fe0eb6661ca240f3b7762b5b3257710d@realtek.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -10935,6 +10935,8 @@ static const struct snd_hda_pin_quirk al
  *   at most one tbl is allowed to define for the same vendor and same codec
  */
 static const struct snd_hda_pin_quirk alc269_fallback_pin_fixup_tbl[] = {
+	SND_HDA_PIN_QUIRK(0x10ec0256, 0x1025, "Acer", ALC2XX_FIXUP_HEADSET_MIC,
+		{0x19, 0x40000000}),
 	SND_HDA_PIN_QUIRK(0x10ec0289, 0x1028, "Dell", ALC269_FIXUP_DELL4_MIC_NO_PRESENCE,
 		{0x19, 0x40000000},
 		{0x1b, 0x40000000}),


