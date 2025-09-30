Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 665DB2FCBFC;
	Tue, 30 Sep 2025 15:01:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759244511; cv=none; b=pZ1tyKpmCGP3ggPmFRifCTlLQqarQrUbhiU+jJ5LQQgPVBi6nE2U3MExpK/2uPuxbwozGzDskEwGELkSuznNl0cr2Ix/YIhxqFC8fCap4BIkti0cOYetK2o56CvD93jXVjp509MUnWurRh9ajwBn5QlO3X0gxZE4Kau4k/vi5tI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759244511; c=relaxed/simple;
	bh=xEu9YKBUmqJC0NAIKeKaeJMSJoFRv3FtELEScLuaVbw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=azzdJxjJhrJ8FzzkKE0VMdfr0kaHQt7KbjgdpB3Bsqf8Mkd2Tfd1L3vTxUrNp9Dtu+qYgtNPJ9d0WUByIpXhiyW2Yi8UOIBGqlG0YqCdFINtR3xWPOnS+GJNHQ4PP/4wJkRtE9D3Gx49oMDMiQ+k2Lg+ViVo0vInptJQL/KNrV0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l65LbMZV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l65LbMZV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7450C4CEF0;
	Tue, 30 Sep 2025 15:01:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759244511;
	bh=xEu9YKBUmqJC0NAIKeKaeJMSJoFRv3FtELEScLuaVbw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l65LbMZVu8oMiTEoA3/1HIuOMntFKhhc/MkePUoSeTki/0KiBObmf9Vk1CEqtRzNm
	 JB5wL3xpPlmBdn9WjiF+XYIfCY0R8406oRLdsRazoGS9wOvC8NpPVgve7XPTDRLCHD
	 S6Hw+AczvzbUO//vRppCx8b/PXUF075oAM1ps13w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"noble.yang" <noble.yang@comtrue-inc.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 030/143] ALSA: usb-audio: Add DSD support for Comtrue USB Audio device
Date: Tue, 30 Sep 2025 16:45:54 +0200
Message-ID: <20250930143832.445517234@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143831.236060637@linuxfoundation.org>
References: <20250930143831.236060637@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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
index bd24f3a78ea9d..e75b0b1df6eb2 100644
--- a/sound/usb/quirks.c
+++ b/sound/usb/quirks.c
@@ -2408,6 +2408,8 @@ static const struct usb_audio_quirk_flags_table quirk_flags_table[] = {
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



