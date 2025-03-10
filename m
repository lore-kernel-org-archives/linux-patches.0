Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3007B17CA12;
	Mon, 10 Mar 2025 17:52:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741629135; cv=none; b=kK+L0DurpovWS9xol8aKWMwJFYZYfIpK13ba/d1+gbqBZfFrB9MIdQC/wv3xeckcOzqAeYwyxFkIHUUf/wowQil8XcTH+xuqzImbl/K8P3dIty6EpoWKp9IkrlzRexwbjvFsJ4r5nLb6Y/uaG8EJDiiGc1BGoofgiP4VcIae+0E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741629135; c=relaxed/simple;
	bh=HHMCLwpZjtvexxhHFDESUyhOg7A5mN55uLAz8jtlcFo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r6WvR/mar7DKiBqoYRFhWmJugPH76DcB6XntZ4V8gr7o+Flgt+eUax4X+UN+RjMRDQYSSw7wOxznAAz0k9+RY4vJ1F6xE+Z0fevoShLUcY4H8s/Oq2D2TxBzzOQf9lPizi67UW0IvFxAcJoUQrzZsD+XjX2iFpsiMpzcGyMjdko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qVWvFglp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qVWvFglp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1442C4CEE5;
	Mon, 10 Mar 2025 17:52:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741629135;
	bh=HHMCLwpZjtvexxhHFDESUyhOg7A5mN55uLAz8jtlcFo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qVWvFglpYxVMd6fFTvklYbiYYJrTJa+m/tvnp3ydF6LUdkMr8+0ZX3uCZxvuhJ9k9
	 QIUQXVeuMLTtMENikh8sui4c3se2zgAkWm+LuY+XSCSMGgW5czML1fvamwviTGwP7/
	 ZwWFHi9pIlhEPRc5CdcIMW0vmN+Mzgr0n2rWknic=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lianqin Hu <hulianqin@vivo.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.15 190/620] ALSA: usb-audio: Add delay quirk for iBasso DC07 Pro
Date: Mon, 10 Mar 2025 18:00:36 +0100
Message-ID: <20250310170553.135585368@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
User-Agent: quilt/0.68
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

commit d85fc52cbb9a719c8335d93a28d6a79d7acd419f upstream.

Audio control requests that sets sampling frequency sometimes fail on
this card. Adding delay between control messages eliminates that problem.

usb 1-1: New USB device found, idVendor=2fc6, idProduct=f0b7
usb 1-1: New USB device strings: Mfr=1, Product=2, SerialNumber=3
usb 1-1: Product: iBasso DC07 Pro
usb 1-1: Manufacturer: iBasso
usb 1-1: SerialNumber: CTUA171130B

Signed-off-by: Lianqin Hu <hulianqin@vivo.com>
Cc: <stable@vger.kernel.org>
Link: https://patch.msgid.link/TYUPR06MB62174A48D04E09A37996DF84D2ED2@TYUPR06MB6217.apcprd06.prod.outlook.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/quirks.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/sound/usb/quirks.c
+++ b/sound/usb/quirks.c
@@ -1934,6 +1934,8 @@ static const struct usb_audio_quirk_flag
 		   QUIRK_FLAG_CTL_MSG_DELAY_1M),
 	DEVICE_FLG(0x2d95, 0x8021, /* VIVO USB-C-XE710 HEADSET */
 		   QUIRK_FLAG_CTL_MSG_DELAY_1M),
+	DEVICE_FLG(0x2fc6, 0xf0b7, /* iBasso DC07 Pro */
+		   QUIRK_FLAG_CTL_MSG_DELAY_1M),
 	DEVICE_FLG(0x30be, 0x0101, /* Schiit Hel */
 		   QUIRK_FLAG_IGNORE_CTL_ERROR),
 	DEVICE_FLG(0x413c, 0xa506, /* Dell AE515 sound bar */


