Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B67E5381
	for <patches@lists.linux.dev>; Mon, 19 Jun 2023 10:45:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84308C433C0;
	Mon, 19 Jun 2023 10:45:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1687171525;
	bh=ai00HA7+vtURmaK2lAc7tdM9pjXyQsS5zmBzx0bqBOs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yZ9VSTJ8rRY3wUuZ1PlvCCAD+zAy3h0As+fq+MwI6PLTBi39xbp3czBOBT2r+sU1b
	 QzGO2l7z5SMNXva0FN38bK83bfYeCg5ISA2noHfQPlV+oKtPiEMgh1gRn9orKatiNy
	 AvmVrB1Ov3CEIWJlLcGwMeze6cAUOqsgxPpYxkPI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lukasz Tyl <ltyl@hem-e.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.1 063/166] ALSA: usb-audio: Add quirk flag for HEM devices to enable native DSD playback
Date: Mon, 19 Jun 2023 12:29:00 +0200
Message-ID: <20230619102157.846139217@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230619102154.568541872@linuxfoundation.org>
References: <20230619102154.568541872@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Lukasz Tyl <ltyl@hem-e.com>

commit 122e2cb7e1a30438cc0e8bf70d4279db245d7d5b upstream.

This commit adds new DEVICE_FLG with QUIRK_FLAG_DSD_RAW and Vendor Id for
HEM devices which supports native DSD. Prior to this change Linux kernel
was not enabling native DSD playback for HEM devices, and as a result,
DSD audio was being converted to PCM "on the fly". HEM devices,
when connected to the system, would only play audio in PCM format,
even if the source material was in DSD format. With the addition of new
VENDOR_FLG in the quircks.c file, the devices are now correctly
recognized, and raw DSD data is transmitted to the device,
allowing for native DSD playback.

Signed-off-by: Lukasz Tyl <ltyl@hem-e.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20230614122524.30271-1-ltyl@hem-e.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/quirks.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/sound/usb/quirks.c
+++ b/sound/usb/quirks.c
@@ -2191,6 +2191,8 @@ static const struct usb_audio_quirk_flag
 		   QUIRK_FLAG_DSD_RAW),
 	VENDOR_FLG(0x2ab6, /* T+A devices */
 		   QUIRK_FLAG_DSD_RAW),
+	VENDOR_FLG(0x3336, /* HEM devices */
+		   QUIRK_FLAG_DSD_RAW),
 	VENDOR_FLG(0x3353, /* Khadas devices */
 		   QUIRK_FLAG_DSD_RAW),
 	VENDOR_FLG(0x3842, /* EVGA */


