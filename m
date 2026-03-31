Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2402E2FB632;
	Tue, 31 Mar 2026 17:04:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774976647; cv=none; b=ImnrGB25Rvroe80iu7/3AGOmNl6nQHK8c6IIQU0zpppt8ZD0wrBNgAPYaurDnCMoikmpHCL/G/Z3ZvNdnXDaa//ZCqQOc/ElT2ZmdzwSgkTNim3Z2zMLn4eWQE4LtquAuH7eIYTraSYJWUiv4ycZV9GsXxpUWp4B8FvMr9mxlJg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774976647; c=relaxed/simple;
	bh=v8Ah5t8eaWacYunvW3v4eit8+iH6Pr9dDxqguH3SeBs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O6wqiWrU0pGQzjL6jJoe4bY6Sz9ykKBEudyeYJbzlf0aE7rfxZbvkxDUEOLKEnewGKTZu4XQ7wwho9wtFYOl35XGvTGfjG9hJonPLH6Hki6rSUsiJs/mZLbphmFTGHNQiMQ2HC5th3mjYqrHHiJ9JIp8TAIDPQEpH2+W4Cp0EYU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SnJ7q6Za; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SnJ7q6Za"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D672C19423;
	Tue, 31 Mar 2026 17:04:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774976646;
	bh=v8Ah5t8eaWacYunvW3v4eit8+iH6Pr9dDxqguH3SeBs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SnJ7q6ZavghcACuiirk78btJ20QbPZUZA3H9Zzn6cR5YR2q/tUyBPyCGKFge1QF+N
	 Jt7Hyt9gnsDHnF3tz/eU4LqqGu7q12nF3B7pzRZtU2RoSC1VmxxMyUGVmC6BorP9ZQ
	 lhNMvA8f3E8wqhOgrUn4l/BMntz7PaEXZF6GC1UA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Geoffrey D. Bennett" <g@b4.vu>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 174/309] ALSA: usb-audio: Exclude Scarlett 2i4 1st Gen from SKIP_IFACE_SETUP
Date: Tue, 31 Mar 2026 18:21:17 +0200
Message-ID: <20260331161759.871117514@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161753.468533260@linuxfoundation.org>
References: <20260331161753.468533260@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 11823549900f1..45d0e1364dd98 100644
--- a/sound/usb/quirks.c
+++ b/sound/usb/quirks.c
@@ -2423,6 +2423,7 @@ static const struct usb_audio_quirk_flags_table quirk_flags_table[] = {
 	VENDOR_FLG(0x07fd, /* MOTU */
 		   QUIRK_FLAG_VALIDATE_RATES),
 	DEVICE_FLG(0x1235, 0x8006, 0), /* Focusrite Scarlett 2i2 1st Gen */
+	DEVICE_FLG(0x1235, 0x800a, 0), /* Focusrite Scarlett 2i4 1st Gen */
 	VENDOR_FLG(0x1235, /* Focusrite Novation */
 		   QUIRK_FLAG_SKIP_IFACE_SETUP),
 	VENDOR_FLG(0x1511, /* AURALiC */
-- 
2.53.0



