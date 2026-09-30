Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78C8D50AC08;
	Wed, 30 Sep 2026 16:09:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790784560; cv=none; b=A9c84jpLN9O7MXnCze25qGeQSG7tSH2CPfLH7xp31ztwuBWmjkmWlUwCMTqfqRq9PZwUplBquCVVkBytSXluGIpSiIVQLhzjafhvpXkWLkhugG6dL8T6tbjMbGNDgKGioph7xM3YQGzS9Dqcs7wT9h9JvWMHo3UZ8icS2FsrcBI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790784560; c=relaxed/simple;
	bh=u8ztuRXwyhHDl1FsJBRKe2ulS3Uo6pKnVSOYHmD0vdk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VLL3LLIdM91jgEFd/ueWEIpPPzUPUmZJmz81jb4NmKl2hPNAJJo+0zGSuM3GzPq0LYdAkaW7uMyFu9okLD7YuYc8ZP+RRmjNBLmrv53hNpFlwyv+UyiVkVp+mcMGiGb01PqFtGx/vMSgHhzeK44ZyYobkXQwYJvVjjKr+KQbaIM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2uCOrSLx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2uCOrSLx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 313BE1F008A5;
	Wed, 30 Sep 2026 16:09:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790784555;
	bh=j/1IkeHxZ9XXL0F/v9VLrt07CIx3adUTlx1eZXEnuyI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2uCOrSLxeP5i8/rGPrhnSlqgAGpZRcqzfBcv7l0M57cRv2NFZ6hwc+gyop3jicYFy
	 IP209dh4jK7e/c7Atq4iJbsixWYpK4lF6+3jRNwvTcM9XitiR+nyrb1B35ldRt22e0
	 9EPOleE4/39WV6QqFXluUZfxRDC6m6b9QP6o9UDs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Viktor Menshin <ripeeerr@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 196/982] ALSA: hda/realtek: Add quirk for Lenovo Xiaoxin 14 GT
Date: Wed, 30 Sep 2026 17:15:32 +0200
Message-ID: <20260930152421.023211644@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Viktor Menshin <ripeeerr@gmail.com>

[ Upstream commit 3a3e810e91080a5121170ee11554a55ed89a1c8b ]

The Lenovo Xiaoxin 14 GT (Chinese market model, AMD Ryzen AI 9 365)
produces constant electrical hissing and crackling noise from both
internal speakers and 3.5mm headphone jack during audio playback.
Audio works correctly on Windows.

The PCI SSID 17aa:3912 is not present in the quirk list. The device
shares the same AMD platform and ALC287 codec as neighboring Lenovo
14" AMD models (17aa:3911, 17aa:390d), so apply the same fixup.

Note: the fixup selection is based on similarity with neighboring
models and has not been verified by testing a compiled kernel.
Guidance from maintainers on the correct fixup is welcome.

Signed-off-by: Viktor Menshin <ripeeerr@gmail.com>
Link: https://patch.msgid.link/20260615092515.1082-1-ripeeerr@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_realtek.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index a7e802e6d0d58..5ff2e113054fe 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -10399,6 +10399,7 @@ static const struct snd_pci_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x17aa, 0x3902, "Lenovo E50-80", ALC269_FIXUP_DMIC_THINKPAD_ACPI),
 	SND_PCI_QUIRK(0x17aa, 0x390d, "Lenovo Yoga Pro 7 14ASP10", ALC287_FIXUP_YOGA9_14IAP7_BASS_SPK_PIN),
 	SND_PCI_QUIRK(0x17aa, 0x3911, "Lenovo Yoga Pro 7 14IAH10", ALC287_FIXUP_YOGA9_14IAP7_BASS_SPK_PIN),
+	SND_PCI_QUIRK(0x17aa, 0x3912, "Lenovo Xiaoxin 14 GT", ALC287_FIXUP_YOGA9_14IAP7_BASS_SPK_PIN),
 	SND_PCI_QUIRK(0x17aa, 0x3913, "Lenovo 145", ALC236_FIXUP_LENOVO_INV_DMIC),
 	SND_PCI_QUIRK(0x17aa, 0x3977, "IdeaPad S210", ALC283_FIXUP_INT_MIC),
 	SND_PCI_QUIRK(0x17aa, 0x3978, "Lenovo B50-70", ALC269_FIXUP_DMIC_THINKPAD_ACPI),
-- 
2.53.0



