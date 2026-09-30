Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 193CA51C048;
	Wed, 30 Sep 2026 17:57:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790791041; cv=none; b=p0Vj6jKzGe0oT8d5iVHoSCVgmv6c4C5x6rEZc22ganRV5H2GEXM+31e43DNZ913WXSm1eKS9F//atEQLvKpfVT00SSt3TDGBPZEmzqzEyZdcsevwpstIyH3OkfYT4nNRUnI9PkMcC1odVwOqnBzteAJBJgUfjQ0zHr5HhzLajuo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790791041; c=relaxed/simple;
	bh=Rs9FI4W9vd0IBJOuY9DxEYnhwMCKBY1roErmdt/eVUI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lpCJOBQ5O+LVI8+4YcUq5ADITPufoh0O8/lQTMEnKICdaVX8HHI2NDaccHIGXcKiyLeSpbpgoKx4HEn6pwjBsT7Rh1uI+gAzBz+w5lc54j869xC1PseJ8p8V0Rvybq/lA95nXVUnk0Blyoo6G9F2OKY1f2wwktScCoWsqtg/d74=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1WyUzwLi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1WyUzwLi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 723CA1F00898;
	Wed, 30 Sep 2026 17:57:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790791040;
	bh=E/s8a/J60UWNVt8BocMrt5JY4rYlcnewk6Vugt1gC2A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1WyUzwLiEMpiS/zgnrysczqUm5i22Dwg85lVBjqdQKytf+UbaYqD/2yGcoEmb4ZiZ
	 JapqGtEm/hx6Vo3PFdBGVouEy0+w+GPbuXtR7jBZvq7PGzNvBZB3SuSn8zd2X1Xwv1
	 QfsAk5pnfwXcxdJGCk9hHOBBPRqUUehTl+8vPWSQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jean-Louis Colaco <jean-louis.colaco@orange.fr>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 162/752] ALSA: usb-audio: Add quirk for YAMAHA CDS3000
Date: Wed, 30 Sep 2026 17:20:32 +0200
Message-ID: <20260930152401.702559156@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jean-Louis Colaco <jean-louis.colaco@orange.fr>

[ Upstream commit 348f69320e4db6ebec6940c81154bec4b9eb275a ]

This quirk is identical to the one for the Yamaha Steinberg UR22, here
applied to a CD player that also uses the Steinberg USB interface.
This quirk is necessary to avoid sporadic "clic" noise when using the DAC
of the player.

Signed-off-by: Jean-Louis Colaco <jean-louis.colaco@orange.fr>
Link: https://patch.msgid.link/20260618113202.8363-1-jean-louis.colaco@orange.fr
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/quirks-table.h | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/sound/usb/quirks-table.h b/sound/usb/quirks-table.h
index 8e0e44b1f5262..40de1c6fafb8b 100644
--- a/sound/usb/quirks-table.h
+++ b/sound/usb/quirks-table.h
@@ -484,6 +484,20 @@ YAMAHA_DEVICE(0x105d, NULL),
 		}
 	}
 },
+{
+	USB_DEVICE(0x0499, 0x150d),
+	QUIRK_DRIVER_INFO {
+		/* .vendor_name = "Yamaha", */
+		/* .product_name = "CDS3000", */
+		QUIRK_DATA_COMPOSITE {
+			{ QUIRK_DATA_STANDARD_AUDIO(1) },
+			{ QUIRK_DATA_STANDARD_AUDIO(2) },
+			{ QUIRK_DATA_MIDI_YAMAHA(3) },
+			{ QUIRK_DATA_IGNORE(4) },
+			QUIRK_COMPOSITE_END
+		}
+	}
+},
 {
 	USB_DEVICE(0x0499, 0x1718),
 	QUIRK_DRIVER_INFO {
-- 
2.53.0



