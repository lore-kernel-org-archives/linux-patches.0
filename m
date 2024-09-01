Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6ABFE1E87B;
	Sun,  1 Sep 2024 16:58:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725209927; cv=none; b=CGg3/5nfZlQVU4SIHXWav88QdQ0HqOqmfDBc3rfMH5Cqa3SXKCBDTA8ZMZVAPl2TNIL3tKXM0RHyE1QSfSefHiw6SCUeBlZQ/jdNhKb1nlALPq0yk3obWYzzNtvAkd4LE2xrb/OTmJLOLMBBGye2661Obm9rC6NKU2nQXWJARHo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725209927; c=relaxed/simple;
	bh=soE1SAzPdMw4HSEqd7fO0Fu4XWhUAU2ntDoXPjB5PwE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GvTHcDhbsz7aIWrHqklWGYGdCmTFeKl6YxBD+/XzrLXcRiebhYu7MG0/zOcVJZxnX9aKCQpBbdkCviaeh12rANr2AApL5yVM8/SpBqbKNSH2vjAQSslDNbPjGuTpaCT3YoNwCPtA1PWZABDaBSM0EKYi5XKT3B4Lx2lELYcEOFk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ysmexQj/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ysmexQj/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3C54C4CEC3;
	Sun,  1 Sep 2024 16:58:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725209927;
	bh=soE1SAzPdMw4HSEqd7fO0Fu4XWhUAU2ntDoXPjB5PwE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ysmexQj/XNeED46hR73n9ns3eCo11yGH7zh9j4t3oy1W2ni2g3g2xwQhUPL7DHvIR
	 2Ewau/24vUlrB9rj7CWk/1c8IItwqn1gKFvw9Oe5JMpZDH9YS/Z33mhtaQ840JJstt
	 ycUILJ8jVy2XgX8DnrsUzmGL6vMTfzimIvUf+/rY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lianqin Hu <hulianqin@vivo.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.15 005/215] ALSA: usb-audio: Add delay quirk for VIVO USB-C-XE710 HEADSET
Date: Sun,  1 Sep 2024 18:15:17 +0200
Message-ID: <20240901160823.443501912@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160823.230213148@linuxfoundation.org>
References: <20240901160823.230213148@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1900,6 +1900,8 @@ static const struct usb_audio_quirk_flag
 		   QUIRK_FLAG_GENERIC_IMPLICIT_FB),
 	DEVICE_FLG(0x2b53, 0x0031, /* Fiero SC-01 (firmware v1.1.0) */
 		   QUIRK_FLAG_GENERIC_IMPLICIT_FB),
+	DEVICE_FLG(0x2d95, 0x8021, /* VIVO USB-C-XE710 HEADSET */
+		   QUIRK_FLAG_CTL_MSG_DELAY_1M),
 	DEVICE_FLG(0x30be, 0x0101, /* Schiit Hel */
 		   QUIRK_FLAG_IGNORE_CTL_ERROR),
 	DEVICE_FLG(0x413c, 0xa506, /* Dell AE515 sound bar */


