Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEF611C8FC4;
	Tue, 27 Aug 2024 15:17:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724771833; cv=none; b=s6pYPydHtq1J4oHcne4dUmN5P7DAALpN2kQvMIhVHT8kZ32zuRtZjBh7dD49BSc8y2u18COMD3VElRDUaIZJhSRozKtIvtiFIaepshrqIKnoj95AmaOD1ZV4Ib2O44m7jK4k7YnO7UhGU+OlxSCyPmqOIdTEqdWeSfX1KCaYaAc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724771833; c=relaxed/simple;
	bh=CXSO4zILeq+3C1ZVHbFZVb19TD1mpifK7sKQHOjzEnE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SeQ8Jm/OIuduzHDQgRmP7Azr4+E85yD+MQwuUW7CFSKfGiCGovZqH/lnOLFBbTnmj+vL8Sl/lxkq0KL6qPPND/SEj7CiEFEBk7gwQb10MkmrKKcNSOtRVLsKWlTeI3nbxkJqfDfPYxFhcqQNkXBjWPBW06D73S2UCv79Y4f0V5A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TBOCQkwh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TBOCQkwh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E6F5C4DE1C;
	Tue, 27 Aug 2024 15:17:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724771833;
	bh=CXSO4zILeq+3C1ZVHbFZVb19TD1mpifK7sKQHOjzEnE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TBOCQkwhcmXcKDyFvsUQq8XrN9l/uTGMOAafoyE6qievS5rCuQiTawMjyuwTGgjWs
	 ZdJLWuLCDow7CpwUtqIDruMQqi2hiiLvVF6UFb/ki8ajNPXeKhI8bC9/9z/yZM6X4S
	 bv7YdFxtbfI9hzn2Nfn8O8V1FKo5gbm4c+rasw/g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lianqin Hu <hulianqin@vivo.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.1 006/321] ALSA: usb-audio: Add delay quirk for VIVO USB-C-XE710 HEADSET
Date: Tue, 27 Aug 2024 16:35:14 +0200
Message-ID: <20240827143838.440682421@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143838.192435816@linuxfoundation.org>
References: <20240827143838.192435816@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2179,6 +2179,8 @@ static const struct usb_audio_quirk_flag
 		   QUIRK_FLAG_GENERIC_IMPLICIT_FB),
 	DEVICE_FLG(0x2b53, 0x0031, /* Fiero SC-01 (firmware v1.1.0) */
 		   QUIRK_FLAG_GENERIC_IMPLICIT_FB),
+	DEVICE_FLG(0x2d95, 0x8021, /* VIVO USB-C-XE710 HEADSET */
+		   QUIRK_FLAG_CTL_MSG_DELAY_1M),
 	DEVICE_FLG(0x30be, 0x0101, /* Schiit Hel */
 		   QUIRK_FLAG_IGNORE_CTL_ERROR),
 	DEVICE_FLG(0x413c, 0xa506, /* Dell AE515 sound bar */


