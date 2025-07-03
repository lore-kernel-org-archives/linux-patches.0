Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 303E12EB5BF;
	Thu,  3 Jul 2025 15:21:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751556065; cv=none; b=Ks2914jJG9ulNlPK+egQskABzLP3ra++z+86tfH80qy8LluLk7I1cHlrrb4OACxfBnHxNFqgFbOYpY5dFRLxUu9CqA6I4X1WcQ2cmpjjM+KsEyRsYuN5dM85CZpdIHizx9RYKaIs+FWPuIYM37jRH1o1QpoZmL1VjqWgAUVKcf8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751556065; c=relaxed/simple;
	bh=0gxkLTKuoaIfa2E1rr7Ygv16G4Af/ki18z1FP1P+xpc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nxaD1PQyhQd8+5wQw5rjZDkFy8+yVImTBzGt4sBv1tQHV3wtiY2MwlJ0EsxbKOR7E87Q4BMihI9l45hlyRfIuuNPaFqDNfLc9OkOYnNBnJqHBDnTbJ9NRWMym0OWZF3U1mMieHS773pWaGIhy6Jk70gSldxGdlk+/SjbIWSgIOI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W4AqcVF8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W4AqcVF8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BF90C4CEE3;
	Thu,  3 Jul 2025 15:21:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751556065;
	bh=0gxkLTKuoaIfa2E1rr7Ygv16G4Af/ki18z1FP1P+xpc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W4AqcVF867PucH2efpRnglpXTmJd7ybhWKRikSY4WJE/qBXH56SbGJZ7Qmt3qLDO/
	 om0gaHgcR4YyeSRILqn/jBvv23ypz3T/hz9COGOFxl1o1+moTYR100IP+VMdXEYC2S
	 EdulJk4Gf44T1PN5iObkYq651VHFpZISBHig0ETg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 033/132] ALSA: usb-audio: Add a quirk for Lenovo Thinkpad Thunderbolt 3 dock
Date: Thu,  3 Jul 2025 16:42:02 +0200
Message-ID: <20250703143940.717330386@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703143939.370927276@linuxfoundation.org>
References: <20250703143939.370927276@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Mario Limonciello <mario.limonciello@amd.com>

[ Upstream commit 4919353c7789b8047e06a9b2b943f775a8f72883 ]

The audio controller in the Lenovo Thinkpad Thunderbolt 3 dock doesn't
support reading the sampling rate.

Add a quirk for it.

Suggested-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Link: https://patch.msgid.link/20250527172657.1972565-1-superm1@kernel.org
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/quirks.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/usb/quirks.c b/sound/usb/quirks.c
index b2a612c5b299a..ac43bdf6e9ca6 100644
--- a/sound/usb/quirks.c
+++ b/sound/usb/quirks.c
@@ -2180,6 +2180,8 @@ static const struct usb_audio_quirk_flags_table quirk_flags_table[] = {
 		   QUIRK_FLAG_DISABLE_AUTOSUSPEND),
 	DEVICE_FLG(0x17aa, 0x104d, /* Lenovo ThinkStation P620 Internal Speaker + Front Headset */
 		   QUIRK_FLAG_DISABLE_AUTOSUSPEND),
+	DEVICE_FLG(0x17ef, 0x3083, /* Lenovo TBT3 dock */
+		   QUIRK_FLAG_GET_SAMPLE_RATE),
 	DEVICE_FLG(0x1852, 0x5062, /* Luxman D-08u */
 		   QUIRK_FLAG_ITF_USB_DSD_DAC | QUIRK_FLAG_CTL_MSG_DELAY),
 	DEVICE_FLG(0x1852, 0x5065, /* Luxman DA-06 */
-- 
2.39.5



