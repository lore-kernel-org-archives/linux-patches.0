Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93FA3331220;
	Wed, 20 May 2026 18:09:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779300581; cv=none; b=lwLq/Qp77cKSfBU4dPSdMfKskVHPZtyX3nBKaail46+MaRtfDDAgVCeV98TcUUNWr6Ajia5oE3jHlRto3cjtQNNT8IcNS3RbIuTX/I9ZAZnphgXoQrTVLC9DF43buEUixVK/O21vF6NJStYnb2oGyyaP8l8mXsyoD+3uNjDJJPs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779300581; c=relaxed/simple;
	bh=EBoUQ++KW5WADrPFFg1k05z6j91rsFUjL1zYnb7W3Bs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Tqsh110FU0ni3QT3VKIcxevEg9PMEEpH8pvX7Z0MRaawpNbfc206NTYUBkdIOWQz9np9pyYUrJQPkxmo4HN+B62iWZBcdT7rDhZZemzqXqCg/Fmv5NF03YcDfZE2EREu/LkmgvTQwsPkSSRi48M20fIStHb6DWkbAHsrcpKwUNk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dIk9jlFo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dIk9jlFo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05F091F000E9;
	Wed, 20 May 2026 18:09:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779300580;
	bh=shXfF4X7qyyNJr2IC7R2TEfTTQnMhMkPexY89cbjPjI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dIk9jlFoAa8lDSFDyzVupqlsbBRSI1kPWsCFFRvrTWLFwD6jUEPOeR3tAnNcgt5UE
	 unGvlfCmOD/yqYU12zCS4UskjRMYOew9f0PMRaPdsrt4bmeOfl66Y6zg1pJ5JLbtrf
	 vze7AIjryN/tdLz5F70Fjr4gQgZj+ADcWj58SACU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Panagiotis Petrakopoulos <npetrakopoulos2003@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 229/666] ALSA: scarlett2: Add missing sentinel initializer field
Date: Wed, 20 May 2026 18:17:20 +0200
Message-ID: <20260520162116.175998198@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162111.222830634@linuxfoundation.org>
References: <20260520162111.222830634@linuxfoundation.org>
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

From: Panagiotis Petrakopoulos <npetrakopoulos2003@gmail.com>

[ Upstream commit 2428cd6e8b6fa80c36db4652702ca0acd2ce3f08 ]

A "-Wmissing-field-initializers" warning was emitted when compiling the
module using the W=2 option. There is a sentinel initializer field
missing in the end of scarlett2_devices[]. Tested using a
Scarlett Solo 4th gen.

Fixes: d98cc489029d ("ALSA: scarlett2: Move USB IDs out from device_info struct")
Signed-off-by: Panagiotis Petrakopoulos <npetrakopoulos2003@gmail.com>
Link: https://patch.msgid.link/20260405222548.8903-1-npetrakopoulos2003@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/mixer_scarlett2.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/usb/mixer_scarlett2.c b/sound/usb/mixer_scarlett2.c
index fe1d6e512699c..ef5945aa40e4a 100644
--- a/sound/usb/mixer_scarlett2.c
+++ b/sound/usb/mixer_scarlett2.c
@@ -2221,7 +2221,7 @@ static const struct scarlett2_device_entry scarlett2_devices[] = {
 	{ USB_ID(0x1235, 0x820c), &clarett_8pre_info, "Clarett+" },
 
 	/* End of list */
-	{ 0, NULL },
+	{ 0, NULL, NULL },
 };
 
 /* get the starting port index number for a given port type/direction */
-- 
2.53.0



