Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 472CF53B356;
	Thu, 17 Sep 2026 17:05:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789664751; cv=none; b=T3ZVoq7QBVYM6NjIekBMCZCh8AkluwrMlinwvDVGeplPRHSJQxwMKLd+Li0XbadGpt2paNFy0AE4C1Ec12xNVUIhoygQTZ6NQ+qfV2TBctiSdEJWnJ/Hu30uZMV/2EYnzrjDE1a3hIFSIxEph71Ci2NEhoATWrLIhX0yIkoexzw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789664751; c=relaxed/simple;
	bh=9U3pKWi+RrGdQfxztOF59jZhLc95cRaYDkXanRIC8Z4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qeE5LpeTcsQ30LgAObD4HlzdWGfwwgwi6g0u9Bge/nrTdYNUS9GyyK7E0RdB0iH3Igko3gkg1VrkDW1DolwUbgH+7wxugjaaV+lU9MADu+4I877d8hhaygJ1N9oL7TQ82MEgx31z/p8xe+/PRjSZ4Dt/lkAwNm+IKbhGV/OoXQM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tV8MUcMj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tV8MUcMj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F4B81F000FF;
	Thu, 17 Sep 2026 17:05:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789664749;
	bh=hZBRkF4DgmSntXNzcUxN0eusAPq1RLaCg2J5x1PknHo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tV8MUcMjKJ2lcBbBl1JTBbX36l1Rp4ypflIqz6IK9DEG+h9PcDwzMQyD44v60aeBY
	 Dyfpm7neuoPrg3Ym5iIzSYJ/sTnrKuyh4JgBISYZNmszKMzrA/by/KCx9SdHynLKt6
	 xddZKtA/CMI4xPrlbUq/Wzk1TZhrve7DM9ZwWPow=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jean-Louis Colaco <jean-louis.colaco@orange.fr>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0437/1250] ALSA: usb-audio: Add quirk for YAMAHA CDS3000
Date: Thu, 17 Sep 2026 16:03:52 +0100
Message-ID: <20260917151603.857506148@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index cf6a2bb5264d4..d783dae1850a0 100644
--- a/sound/usb/quirks-table.h
+++ b/sound/usb/quirks-table.h
@@ -390,6 +390,20 @@ YAMAHA_DEVICE(0x105d, NULL),
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



