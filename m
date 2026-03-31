Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9629440710B;
	Tue, 31 Mar 2026 16:39:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774975182; cv=none; b=Sg9C8HQh+fp+/3s3tTvFSoz00rx2a1RseWJxB4UiHAYesuATB/hUSEzodhkgOn/T9sc8L1y7Q97qxN7ONJrYYVtN1nULzz+LaqEwowMXbbaBIrHyrfJlFowpaqHqFRHvZqtEVTrCmUXK83wVyzYDjpGOHCqFlN1qql3xmJx3mQY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774975182; c=relaxed/simple;
	bh=+y9stYM9PIYSlglvvnGLNzZM772KK8PAD8ok1trZZ98=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UZh6G1F5XCebhT/jif+s+TcIv52kkmZK9rMTAKME3KwK1WLTBkmA1US2do42NqDvFx3JFjVyNWXHYtz/IH0BX6B7VtniJ3awcjbGn2KpuEOIRIz9LrF1MSWJ2rxAIU3aZmKKLDFxDJCZpzbv8RNNAQ6G2RMflIfYSkJFsoYWxxI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=klNxLSFO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="klNxLSFO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E077CC19423;
	Tue, 31 Mar 2026 16:39:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774975182;
	bh=+y9stYM9PIYSlglvvnGLNzZM772KK8PAD8ok1trZZ98=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=klNxLSFOSXpmlnPCA+fgm0BPPrpZn++ujbWFfI7oMvd2sBYxokj3innjcmlauNbpO
	 QapND6rDkatlwa6U+j26xeU8h0SHKMDXXKGXfJX6y1dcch2gBXJ9ReQCfMCyjp1CXT
	 81oFkCqaFlkLGp4KJO4y16mNJQXCUs+xrgveEFkA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Geoffrey D. Bennett" <g@b4.vu>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 194/342] ALSA: usb-audio: Exclude Scarlett 2i4 1st Gen from SKIP_IFACE_SETUP
Date: Tue, 31 Mar 2026 18:20:27 +0200
Message-ID: <20260331161806.132701592@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161758.909578033@linuxfoundation.org>
References: <20260331161758.909578033@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Geoffrey D. Bennett <g@b4.vu>

[ Upstream commit 990a8b0732cf899d4a0f847b0a67efeb9a384c82 ]

Same issue that the Scarlett 2i2 1st Gen had:
QUIRK_FLAG_SKIP_IFACE_SETUP causes distorted/flanging audio on the
Scarlett 2i4 1st Gen (1235:800a).

Fixes: 38c322068a26 ("ALSA: usb-audio: Add QUIRK_FLAG_SKIP_IFACE_SETUP")
Reported-by: dcferreira [https://github.com/geoffreybennett/linux-fcp/issues/54]
Signed-off-by: Geoffrey D. Bennett <g@b4.vu>
Link: https://patch.msgid.link/acEkEbftzyNe8W7C@m.b4.vu
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/quirks.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/usb/quirks.c b/sound/usb/quirks.c
index 461d7d254e378..09ed935107580 100644
--- a/sound/usb/quirks.c
+++ b/sound/usb/quirks.c
@@ -2426,6 +2426,7 @@ static const struct usb_audio_quirk_flags_table quirk_flags_table[] = {
 	VENDOR_FLG(0x07fd, /* MOTU */
 		   QUIRK_FLAG_VALIDATE_RATES),
 	DEVICE_FLG(0x1235, 0x8006, 0), /* Focusrite Scarlett 2i2 1st Gen */
+	DEVICE_FLG(0x1235, 0x800a, 0), /* Focusrite Scarlett 2i4 1st Gen */
 	VENDOR_FLG(0x1235, /* Focusrite Novation */
 		   QUIRK_FLAG_SKIP_IFACE_SETUP),
 	VENDOR_FLG(0x1511, /* AURALiC */
-- 
2.53.0



