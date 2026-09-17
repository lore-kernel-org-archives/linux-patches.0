Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A62F4E9C10;
	Thu, 17 Sep 2026 16:53:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789664000; cv=none; b=DFq/bbN95LH0H28EHx7tf++mjN9y9ZTL/4qPB+G/bVtw3UeafWv76OWlEFM8rM6nIiqPutg40hbqKReuU53kpeVmR5pANXrwTLVyytTmRXtlyb8elXxdzKoQw2tTz95TaydrJG3hODmCabud5uXquupXYnl3E4qK0ZK6cBQsxps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789664000; c=relaxed/simple;
	bh=le5wwdS7xxoG9AoVULR6gqJhPh0bwLBr/SaLJSkJyJs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JlgXdVFMYYzvgU58UV7LHhav78c+6TlU9c/Du3brEpvTE3s39K1FYHxjuZZELGM6LzWhc6rwZgaa2nkkZOoTFmJIFOvjsDcLbXKE/cK9rbs8FXXEKiUICsHa+OdoaEJup2pLX863VOB0DtMOS2JQJqZ782rpbYpdd7vznF7jeQw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VLsGp2Jc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VLsGp2Jc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64A881F000FF;
	Thu, 17 Sep 2026 16:53:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789663998;
	bh=DR1idOypOJDPseVUUecBwbBWteGtYIR9Qjrz4uWBfbU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VLsGp2Jc6MLtMBeEy7ngMhFR3WS0fSeUfQyVGaLvKb/0ETqQlV1C1jAdYg7EC19U1
	 u5uim+oFQrr2uG9JjdDPM2e9VyXfaMWM70FNu1yncMBmf+QIrw/x5VY5lXwIVDM3hs
	 r7t3Ng7B/VBrVLND/HCahH9bQw6YFmxJ2921DJnE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20K=C3=BCchler?= <uwe@kuechler.org>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0226/1250] ALSA: usb-audio: Add quirk for Novation Mininova
Date: Thu, 17 Sep 2026 16:00:21 +0100
Message-ID: <20260917151558.266393661@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
User-Agent: quilt/0.69
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Uwe Küchler <uwe@kuechler.org>

[ Upstream commit b2e9d2cbbb71b00faf3e27fb741a27b9ad455edd ]

Add a device-specific quirk for the Novation Mininova synthesizer
(USB ID 1235:001e) to enable proper recognition and functionality
as a MIDI device.

Signed-off-by: Uwe Küchler <uwe@kuechler.org>
Link: https://patch.msgid.link/20260526162033.7513-1-uwe@kuechler.org
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/quirks-table.h | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/sound/usb/quirks-table.h b/sound/usb/quirks-table.h
index eafc0d73cca1f..cf6a2bb5264d4 100644
--- a/sound/usb/quirks-table.h
+++ b/sound/usb/quirks-table.h
@@ -2131,6 +2131,14 @@ YAMAHA_DEVICE(0x7010, "UB99"),
 		}
 	}
 },
+{
+	USB_DEVICE(0x1235, 0x001e),
+	QUIRK_DRIVER_INFO {
+		/* .vendor_name = "Novation", */
+		/* .product_name = "Mininova", */
+		QUIRK_DATA_RAW_BYTES(0)
+	}
+},
 {
 	USB_DEVICE_VENDOR_SPEC(0x1235, 0x4661),
 	QUIRK_DRIVER_INFO {
-- 
2.53.0



