Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD8F32EBB8C;
	Mon, 13 Apr 2026 16:18:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776097130; cv=none; b=rt7sq7whoNp7d0XZXBPMYrIQVMRkUMX3sWGBm50V+WgLkOOSassXr9Bo6EBIse+rhMFDJw8ZPMisbujtVxS1phkb7dRKpT3sk3EHPVcmbl+5YGgh/ONwGUb7md0ctFh9b7ptMd17LPYxZStFti5ycNsECuS7N75BuChJoZsfcF8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776097130; c=relaxed/simple;
	bh=v3gNPXMYPrtPiMCuy4GkC1l0wrTfuMv5lDALBxakuo0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J0XEvr1orvqkRMyne+HJevAg7Q8d8gr+MB3f6KkRgnxXbmeyMA81zfzeQHqmqqrhNDE9AwO8wzU+vwNKrxACE9ln5MJ9tZ9i4stH5KTpexR+2a6bvjLubFQKrgwmjW7FwKD0MWg3UkNUjZWpZhTwOFHJ3hZR+N/IFrnz4CQDxvk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q7EQLmga; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q7EQLmga"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DE63C2BCAF;
	Mon, 13 Apr 2026 16:18:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776097130;
	bh=v3gNPXMYPrtPiMCuy4GkC1l0wrTfuMv5lDALBxakuo0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q7EQLmga3sl51I7iL1+2ivfe6WpoZNGixbJAE6p5h7Ybp5oxbSiLYPQP2fjHryJwJ
	 lHpgXVeYjAcZ3ha6w+450dV737Qm3E0nYpfjLpcslNWmerhcoMQGGgwi8wOsvAtXCD
	 DMYC0QKYRh9jGbGYI2oVyWvCZE6x6gz4WmDegyMQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Geoffrey D. Bennett" <g@b4.vu>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 005/570] ALSA: usb-audio: Remove VALIDATE_RATES quirk for Focusrite devices
Date: Mon, 13 Apr 2026 17:52:16 +0200
Message-ID: <20260413155830.596728908@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155830.386096114@linuxfoundation.org>
References: <20260413155830.386096114@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Geoffrey D. Bennett <g@b4.vu>

[ Upstream commit a8cc55bf81a45772cad44c83ea7bb0e98431094a ]

Remove QUIRK_FLAG_VALIDATE_RATES for Focusrite. With the previous
commit, focusrite_valid_sample_rate() produces correct rate tables
without USB probing.

QUIRK_FLAG_VALIDATE_RATES sends SET_CUR requests for each rate (~25ms
each) and leaves the device at 192kHz. This is a problem because that
rate: 1) disables the internal mixer, so outputs are silent until an
application opens the PCM and sets a lower rate, and 2) the Air and
Safe modes get disabled.

Fixes: 5963e5262180 ("ALSA: usb-audio: Enable rate validation for Scarlett devices")
Signed-off-by: Geoffrey D. Bennett <g@b4.vu>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://patch.msgid.link/09b9c012024c998c4ca14bd876ef0dce0d0b6101.1771594828.git.g@b4.vu
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/quirks.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/usb/quirks.c b/sound/usb/quirks.c
index afd7765b5913e..55fd74f198184 100644
--- a/sound/usb/quirks.c
+++ b/sound/usb/quirks.c
@@ -1978,7 +1978,7 @@ static const struct usb_audio_quirk_flags_table quirk_flags_table[] = {
 	VENDOR_FLG(0x07fd, /* MOTU */
 		   QUIRK_FLAG_VALIDATE_RATES),
 	VENDOR_FLG(0x1235, /* Focusrite Novation */
-		   QUIRK_FLAG_VALIDATE_RATES),
+		   0),
 	VENDOR_FLG(0x1511, /* AURALiC */
 		   QUIRK_FLAG_DSD_RAW),
 	VENDOR_FLG(0x152a, /* Thesycon devices */
-- 
2.51.0



