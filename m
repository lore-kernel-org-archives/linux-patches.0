Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 926851BC9E3;
	Tue, 27 Aug 2024 15:00:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724770857; cv=none; b=U7sbDeyJYuI/giYEFSDgTvR3Za7DvK/W6ajrOsRKMaS26yrqWEFvyBAJaqKASSG+U+UkucH/T5oh4UoH0ArCwijXw3dIJYrTRw5d7gTHvwNTGTiUQ4djaskBslDUhi5MQD6SNrlhGJIE11+gAeOqTYq+je5m9WlRpcVN7NMi0hM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724770857; c=relaxed/simple;
	bh=uGO517zlueyrLdcs0rUjSDJDgu4/WyQh5wtNi7KQmOY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EtwXVyqz8jsmMhp0jUR9NUGHRjVWAVmsLsE3584sWCQdWakjcNZwihTDx5qTD5XqutDvH9a9P1j+f1febIptOAVYPs418Upt/EiD1kBVZaMLg3GXCRPZEdF6dmdaqx92kuvO0Bar3vsMXNxbOuw3LzFTg/Ybxff85ftrUw/1QT4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v5OrRH2+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v5OrRH2+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3D7EC4AF1C;
	Tue, 27 Aug 2024 15:00:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724770857;
	bh=uGO517zlueyrLdcs0rUjSDJDgu4/WyQh5wtNi7KQmOY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v5OrRH2+pA8fxxhME71qucOKpJ3CRemU61a/IJ3H2G+5C1Io6KytiYS4AFI4HGGrq
	 THhH4czcL4haIyfDrFQe0NPgi/zh9gTyJK6OyfBwq0cz4hyIqtcMPncBDlxtwgBVhW
	 8FIKB7MYiEfnIyX9DWlVstG4f2Gwqm3UOjrpCSLY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lianqin Hu <hulianqin@vivo.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.10 014/273] ALSA: usb-audio: Add delay quirk for VIVO USB-C-XE710 HEADSET
Date: Tue, 27 Aug 2024 16:35:38 +0200
Message-ID: <20240827143833.928862283@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143833.371588371@linuxfoundation.org>
References: <20240827143833.371588371@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lianqin Hu <hulianqin@vivo.com>

commit 004eb8ba776ccd3e296ea6f78f7ae7985b12824e upstream.

Audio control requests that sets sampling frequency sometimes fail on
this card. Adding delay between control messages eliminates that problem.

Signed-off-by: Lianqin Hu <hulianqin@vivo.com>
Cc: <stable@vger.kernel.org>
Link: https://patch.msgid.link/TYUPR06MB6217FF67076AF3E49E12C877D2842@TYUPR06MB6217.apcprd06.prod.outlook.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/quirks.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/sound/usb/quirks.c
+++ b/sound/usb/quirks.c
@@ -2221,6 +2221,8 @@ static const struct usb_audio_quirk_flag
 		   QUIRK_FLAG_GENERIC_IMPLICIT_FB),
 	DEVICE_FLG(0x2b53, 0x0031, /* Fiero SC-01 (firmware v1.1.0) */
 		   QUIRK_FLAG_GENERIC_IMPLICIT_FB),
+	DEVICE_FLG(0x2d95, 0x8021, /* VIVO USB-C-XE710 HEADSET */
+		   QUIRK_FLAG_CTL_MSG_DELAY_1M),
 	DEVICE_FLG(0x30be, 0x0101, /* Schiit Hel */
 		   QUIRK_FLAG_IGNORE_CTL_ERROR),
 	DEVICE_FLG(0x413c, 0xa506, /* Dell AE515 sound bar */


