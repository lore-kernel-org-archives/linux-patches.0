Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 030F0306B05;
	Tue, 30 Sep 2025 15:26:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759246003; cv=none; b=B5wf+M5cJgb8CJlT6/lZ8I/Ga6vwmI/BczrWZre3ClmpwITjc7XLd50MJB6h9wG3VrDgqsmxwi4eGEjGEfJNw4ZNs/6Hb0N62IcjzzdqRGW1TvXycZ+D9T/UswTJlBkXSXAfjCQ45Z0JwWJtie76ZUPlByIu/Phi6pUzaeBn7wQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759246003; c=relaxed/simple;
	bh=WvZv5JTJLW0XGCKd49GPBC/PdVT+FNQEaZq2T+cs818=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iAdY/1B1QrTxClCCpl/7hP6mWjsFYkLcnU/zYR8lCe7toBseuf+INrjEnku4hLIbUvkKvGtlTQOlnJJDQ2eQIaZhl4Di/Vtcfg3W4EcqGBM1GF1TKTmw5h6wfoT6n+qh/yF5HhnpzxZabZPug3Q59pd8SHjPsstQMyNp+05OytA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TuS7afFW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TuS7afFW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 746B8C4CEF0;
	Tue, 30 Sep 2025 15:26:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759246002;
	bh=WvZv5JTJLW0XGCKd49GPBC/PdVT+FNQEaZq2T+cs818=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TuS7afFWjXRoXGIk074KMOQYBbtdMB3sP5rfXnDX5sal1hOIlMtPCrwvO3Hw3vd0M
	 ak8rpA2+7m3IC0apKkNIo8WL90H+ayCpVmAjmRghMbf6B++tvHS9Wujj8oP7lolirw
	 BUllLmQyKfC8lgFqKxRXxkXU9yVNG1pgasFJwEJE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"noble.yang" <noble.yang@comtrue-inc.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 22/89] ALSA: usb-audio: Add DSD support for Comtrue USB Audio device
Date: Tue, 30 Sep 2025 16:47:36 +0200
Message-ID: <20250930143822.813095822@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143821.852512002@linuxfoundation.org>
References: <20250930143821.852512002@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: noble.yang <noble.yang@comtrue-inc.com>

[ Upstream commit e9df1755485dd90a89656e8a21ec4d71c909fa30 ]

The vendor Comtrue Inc. (0x2fc6) produces USB audio chipsets like
the CT7601 which are capable of Native DSD playback.

This patch adds QUIRK_FLAG_DSD_RAW for Comtrue (VID 0x2fc6), which enables
native DSD playback (DSD_U32_LE) on their USB Audio device. This has been
verified under Ubuntu 25.04 with JRiver.

Signed-off-by: noble.yang <noble.yang@comtrue-inc.com>
Link: https://patch.msgid.link/20250731110614.4070-1-noble228@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/quirks.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/usb/quirks.c b/sound/usb/quirks.c
index 0da4ee9757c01..de57cf35d8258 100644
--- a/sound/usb/quirks.c
+++ b/sound/usb/quirks.c
@@ -2405,6 +2405,8 @@ static const struct usb_audio_quirk_flags_table quirk_flags_table[] = {
 		   QUIRK_FLAG_DSD_RAW),
 	VENDOR_FLG(0x2d87, /* Cayin device */
 		   QUIRK_FLAG_DSD_RAW),
+	VENDOR_FLG(0x2fc6, /* Comture-inc devices */
+		   QUIRK_FLAG_DSD_RAW),
 	VENDOR_FLG(0x3336, /* HEM devices */
 		   QUIRK_FLAG_DSD_RAW),
 	VENDOR_FLG(0x3353, /* Khadas devices */
-- 
2.51.0



