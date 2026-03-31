Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88504426D27;
	Tue, 31 Mar 2026 16:38:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774975081; cv=none; b=KCR47ROVSvzSJRceJ6mKB7KqirBJ10SkCVN2dkmh9hUO9DUaPAk7SvBbC3xbvrETsrMsjPlP/2AzgLR/VpMf6rF6YP2zWlpYsEHboXJ1X+bP0e0MNJB7tzwoePDo6mh7vGAgdRdXEmWtbrORaqtSx+K6/zkA8I9Q5Fh/JZMnREM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774975081; c=relaxed/simple;
	bh=SLdV3D0V7RhKEsjtr9lFQJDnsNWy55qfihMWrJoGy28=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HopBLS9UxxziUavj/e0yGDFD1AqB6kKJjXR5z0LD3ZJh2A1IBtWh3/kp78MhTwl+5QbyOCeEjhs00QQHvt/235od2MDREzcA08yvNDxSzN5WBFJcr3kqVygtek7fKu7ZliAzfUkNGeprtmc06TvLJBgtV7RgSQRO3sCu4SnhJXE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ejoXvLJr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ejoXvLJr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0D41C19423;
	Tue, 31 Mar 2026 16:38:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774975081;
	bh=SLdV3D0V7RhKEsjtr9lFQJDnsNWy55qfihMWrJoGy28=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ejoXvLJrsEweVdwwKMy5BQc43A/lJbBUQwOPGF5WYKCq+ULtdWYV5Vpzad8cQ79JN
	 DhDABXrzsMs9x/YWforulngQJuczEd9Tk5JFqa5dLx5cEIhGhJzYDL4Uqoxn0c1oK+
	 Wd57KcHIrZHndPWR+/0ICV1q9H+tqGDv4tR/Jcng=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Geoffrey D. Bennett" <g@b4.vu>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 155/342] ALSA: usb-audio: Exclude Scarlett 2i2 1st Gen from SKIP_IFACE_SETUP
Date: Tue, 31 Mar 2026 18:19:48 +0200
Message-ID: <20260331161804.712771928@linuxfoundation.org>
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

[ Upstream commit 8780f561f6717dec52351251881bff79e960eb46 ]

The Focusrite Scarlett 2i2 1st Gen (1235:8006) produces
distorted/silent audio when QUIRK_FLAG_SKIP_IFACE_SETUP is active, as
that flag causes the feedback format to be detected as 17.15 instead
of 16.16.

Add a DEVICE_FLG entry for this device before the Focusrite VENDOR_FLG
entry so that it gets no quirk flags, overriding the vendor-wide
SKIP_IFACE_SETUP. This device doesn't have the internal mixer, Air, or
Safe modes that the quirk was designed to protect.

Fixes: 38c322068a26 ("ALSA: usb-audio: Add QUIRK_FLAG_SKIP_IFACE_SETUP")
Reported-by: pairomaniac [https://github.com/geoffreybennett/linux-fcp/issues/54]
Tested-by: pairomaniac [https://github.com/geoffreybennett/linux-fcp/issues/54]
Signed-off-by: Geoffrey D. Bennett <g@b4.vu>
Link: https://patch.msgid.link/abmsTjKmQMKbhYtK@m.b4.vu
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/quirks.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/usb/quirks.c b/sound/usb/quirks.c
index d87b988516bbf..461d7d254e378 100644
--- a/sound/usb/quirks.c
+++ b/sound/usb/quirks.c
@@ -2425,6 +2425,7 @@ static const struct usb_audio_quirk_flags_table quirk_flags_table[] = {
 		   QUIRK_FLAG_CTL_MSG_DELAY | QUIRK_FLAG_IFACE_DELAY),
 	VENDOR_FLG(0x07fd, /* MOTU */
 		   QUIRK_FLAG_VALIDATE_RATES),
+	DEVICE_FLG(0x1235, 0x8006, 0), /* Focusrite Scarlett 2i2 1st Gen */
 	VENDOR_FLG(0x1235, /* Focusrite Novation */
 		   QUIRK_FLAG_SKIP_IFACE_SETUP),
 	VENDOR_FLG(0x1511, /* AURALiC */
-- 
2.53.0



