Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83AF71CA8F;
	Mon,  1 Apr 2024 16:25:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711988747; cv=none; b=OEngwAeuuBvhnwS71nZdSZpLsmqAiZHj6TvTUB58PHFSHAIxZ1j1Fpj9EfFQWuCwc0ZUndfXh0TmzSV8Z/y7II1iOXlxHg1HeZaaUYgI10Bad8R54zSDyoiK3LJEdAN4Jg0Mw9Io9QPZb+mhRGRNUZQfLyrWuHtnh7AgSu+JDvo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711988747; c=relaxed/simple;
	bh=MVEy7z/2lN9URB+hZMvTX1fFQT4LLfpRNvfpmZGCSs4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GQz7pqC62XrN3yD0ZJQER8M099pqRmQOL7zWe+1Qmt4RhFkt68mGymIaKUcqVFbmrVzvQZCZ1c+dZ3rg5JIQEZzNgaLvbe6PyHcWgWjBQ7s51mObYK30zydLx5KccQFU4tg5EqOARkMu0ZCs/cmn4qRycrjeB0jVDCsTSZwOWP0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0QEl7F8P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0QEl7F8P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 072F8C43394;
	Mon,  1 Apr 2024 16:25:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711988747;
	bh=MVEy7z/2lN9URB+hZMvTX1fFQT4LLfpRNvfpmZGCSs4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0QEl7F8PW2lJncn1o6cM63uxjWRLc08VH/TL9+9+7gLNnf5a32shEW41zM2HRI1o6
	 sSAC0jjCCN/fVY8F6+S/LKpSovbdGkZ5KoXQ8BbS5A2g3yqyjt02jH36cffSNsvmNI
	 YNs1FNutT9n9LRgsst3q1JdQp4OuwPpGFth12zOI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kailang Yang <kailang@realtek.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.7 276/432] ALSA: hda/realtek - Add Headset Mic supported Acer NB platform
Date: Mon,  1 Apr 2024 17:44:23 +0200
Message-ID: <20240401152601.405527892@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152553.125349965@linuxfoundation.org>
References: <20240401152553.125349965@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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
@@ -11046,6 +11046,8 @@ static const struct snd_hda_pin_quirk al
  *   at most one tbl is allowed to define for the same vendor and same codec
  */
 static const struct snd_hda_pin_quirk alc269_fallback_pin_fixup_tbl[] = {
+	SND_HDA_PIN_QUIRK(0x10ec0256, 0x1025, "Acer", ALC2XX_FIXUP_HEADSET_MIC,
+		{0x19, 0x40000000}),
 	SND_HDA_PIN_QUIRK(0x10ec0289, 0x1028, "Dell", ALC269_FIXUP_DELL4_MIC_NO_PRESENCE,
 		{0x19, 0x40000000},
 		{0x1b, 0x40000000}),


