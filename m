Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09D871A00CE;
	Thu, 15 Aug 2024 14:40:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723732832; cv=none; b=sQxq4ZpMkIEHxtFaFkal5sVQYdY68olPmOQruFBtj/7l/d3kUjhzk5hCQ2lUpZp7ZbHZsKkOocAQ6N5Gs2gs5yJ966PdUFkEBuOmUu8+2TCk4UV+CSNi1yL15PQEmpXLtPaEL7SEZDc2OqAGtbhyl7gvYjkpRbUmH81OBjFdxgU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723732832; c=relaxed/simple;
	bh=x07Sem0VZX64xXKetQdtnjzxwhiG4uSEe3JadiZBigU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PW+Ti8xYxY0sBUlMMnBExPmEPJohudcXWmetxD0eu8N8i+wQ0efyHDs1mrMSK2caRIkX7Qts8Q7YZHXnJk9ThzezsKqsqeHW/ujNTW3y+k4k5aBbD9EPVE6u8Mmyz81EYvinwtljMlKOB8RjDuSFpnU/cQeh5yl1BiSlkFOhOBs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mlp5zHab; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mlp5zHab"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82146C4AF0C;
	Thu, 15 Aug 2024 14:40:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723732831;
	bh=x07Sem0VZX64xXKetQdtnjzxwhiG4uSEe3JadiZBigU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mlp5zHabqDDKukp+eBBbWY8EwEE76znlSJYQqykSOOuxAJ8w2MTtlrcIQTsTYOJdK
	 dDMOj6Il0Ffk7NSQIyidnTqGlprMcMOaYjHMSn0iXCcxFV20MrdIykUVrMd0f+N+iQ
	 ldPsuqAuvLhlhxhi5rrDuo/s1wBG3F7GYwx6vaaY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 300/352] ALSA: usb-audio: Re-add ScratchAmp quirk entries
Date: Thu, 15 Aug 2024 15:26:06 +0200
Message-ID: <20240815131931.057669277@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131919.196120297@linuxfoundation.org>
References: <20240815131919.196120297@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit 03898691d42e0170e7d00f07cbe21ce0e9f3a8fa ]

At the code refactoring of USB-audio quirk handling, I assumed that
the quirk entries of Stanton ScratchAmp devices were only about the
device name, and moved them completely into the rename table.
But it seems that the device requires the quirk entry so that it's
probed by the driver itself.

This re-adds back the quirk entries of ScratchAmp, but in a
minimalistic manner.

Fixes: 5436f59bc5bc ("ALSA: usb-audio: Move device rename and profile quirks to an internal table")
Link: https://patch.msgid.link/20240808081803.22300-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/quirks-table.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/sound/usb/quirks-table.h b/sound/usb/quirks-table.h
index 97fe2fadcafb3..8f2fb2ac7af67 100644
--- a/sound/usb/quirks-table.h
+++ b/sound/usb/quirks-table.h
@@ -2573,6 +2573,10 @@ YAMAHA_DEVICE(0x7010, "UB99"),
 	}
 },
 
+/* Stanton ScratchAmp */
+{ USB_DEVICE(0x103d, 0x0100) },
+{ USB_DEVICE(0x103d, 0x0101) },
+
 /* Novation EMS devices */
 {
 	USB_DEVICE_VENDOR_SPEC(0x1235, 0x0001),
-- 
2.43.0



