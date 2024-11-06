Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 528911D2784;
	Wed,  6 Nov 2024 12:29:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730896147; cv=none; b=mEsk7ZpM/NPjo3dfUQSJGLAVGnj37l6dfp41BqsEiPvVi9qjaPWOmzJYizvSJEBYbGaXI8DEFD8IBwCJc7pH8qLz4N8fNyYvRPgLSB07sy7iZmAZOoFJ6YgEd4EVu6vqsMwNn6lkNBnxHMs12lF3xyUnQRrS+Kd6HkKs6M8B8is=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730896147; c=relaxed/simple;
	bh=4zHnNJApI2T2y9h5pLXsS4pzhh2fI4lZW21MljLBQEU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cCsvNhsul8Y6JkS3KESC5OKHSB9pkhHU/UC1y7Vz2qqt1eHHpNppWETI6PZePNKGoLNFE3B+OHYkTvTUzqjc5LAhFx5VMwnMtSn6BacQ0N0hE3aWSMYIgPqLGoOv9T0px5PbTNFAm6vo/nT6xvj8QK/k73gl98tI6UYy7xy/IUI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0EP7xqQS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0EP7xqQS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCCF8C4CECD;
	Wed,  6 Nov 2024 12:29:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730896147;
	bh=4zHnNJApI2T2y9h5pLXsS4pzhh2fI4lZW21MljLBQEU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0EP7xqQSvty1nUTkDN9g/U1JgK7FIgl1GmVaL4L8+4SNP8qIKntFusa660RuNtARK
	 1BGH9tAkh9hJ2S5SzuP2EA/JKE33t9UaL9US6SwA0urbDfIitTCLeGbS0IA1d1yxo5
	 esS2kujybg5JxoxGivf6lIELZlETDLZIlY4ddNe0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Jan=20Sch=C3=A4r?= <jan@jschaer.ch>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.11 105/245] ALSA: usb-audio: Add quirks for Dell WD19 dock
Date: Wed,  6 Nov 2024 13:02:38 +0100
Message-ID: <20241106120321.799810217@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120319.234238499@linuxfoundation.org>
References: <20241106120319.234238499@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Message-ID: <20241106120238._0OBfbcxNAcb0H4JbwFSV4IbgpdalIaJzz8dGFNMeBk@z>

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Schär <jan@jschaer.ch>

commit 4413665dd6c528b31284119e3571c25f371e1c36 upstream.

The WD19 family of docks has the same audio chipset as the WD15. This
change enables jack detection on the WD19.

We don't need the dell_dock_mixer_init quirk for the WD19. It is only
needed because of the dell_alc4020_map quirk for the WD15 in
mixer_maps.c, which disables the volume controls. Even for the WD15,
this quirk was apparently only needed when the dock firmware was not
updated.

Signed-off-by: Jan Schär <jan@jschaer.ch>
Cc: <stable@vger.kernel.org>
Link: https://patch.msgid.link/20241029221249.15661-1-jan@jschaer.ch
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/mixer_quirks.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/sound/usb/mixer_quirks.c
+++ b/sound/usb/mixer_quirks.c
@@ -3880,6 +3880,9 @@ int snd_usb_mixer_apply_create_quirk(str
 			break;
 		err = dell_dock_mixer_init(mixer);
 		break;
+	case USB_ID(0x0bda, 0x402e): /* Dell WD19 dock */
+		err = dell_dock_mixer_create(mixer);
+		break;
 
 	case USB_ID(0x2a39, 0x3fd2): /* RME ADI-2 Pro */
 	case USB_ID(0x2a39, 0x3fd3): /* RME ADI-2 DAC */


