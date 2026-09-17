Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 390C9547052;
	Thu, 17 Sep 2026 18:04:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789668274; cv=none; b=kJ6K/tCnx/dD5o+HcvbR4JZ0zOkR2g01ICz6KtCDOgmnWMLEi7XUjl607uhmamm2vlvvzxL4fAQ2BbDtjnV5nD495u98C4kNBN0LhzkjuQPwcKdKHU/1KSPIAjY0WNCUrVP5uWXmiifw8H9+em+OBeSTYYl4R/Z52syXHRNJ3U0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789668274; c=relaxed/simple;
	bh=jRcIkJOtsdODI7toPDt1fqBpDmaN86r52gX0XTvyhBQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cM6d2uA+Sum+zq4g20T2k0NLxWrnPfpXh5nT2qNeqLKs4wsKeL4hjW8/FiV94Xy6gG+J0zR2CsNolwoc9lIjpVB/gp0RYN9IqQtP1HKa050P47CiITWnrcTJAxAZVJR7YkVgMhByyVce9Q7ZOkeCFXFBVNT3PGs+7P7tSFfgLj0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZQLbfdfc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZQLbfdfc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D3A11F000FF;
	Thu, 17 Sep 2026 18:04:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789668273;
	bh=k4/RrA7b2YhfYKx6OB0kIk5umD2m9NfEGK70d+TrU3E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZQLbfdfc9VNHYs0jq9JVZSE0utci2sO/y1HEtmYGJ1TAWMv8Jt5Ky/5A0zTQ/Vf0c
	 HpGGanb6r92/uizQGldRXsZ600NP+nUEtE7O31WFrHLNPA71sHIL7SsEJfaTmCQlXl
	 JXGY/mS+9eftiuWsvrGT5ljSZQX8U7QhA9NfpsK8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jean-Louis Colaco <jean-louis.colaco@orange.fr>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0332/1102] ALSA: usb-audio: Add quirk for YAMAHA CDS3000
Date: Thu, 17 Sep 2026 16:04:35 +0100
Message-ID: <20260917151547.968373750@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 4e7d242dfebdc..8f47f29f38de7 100644
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



