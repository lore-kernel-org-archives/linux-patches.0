Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF95933A6F1;
	Wed, 30 Sep 2026 18:55:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790794528; cv=none; b=spyOrFG/dZSvs3w8qWvOUZoz/VyhrjsWbeiZ5Uj1QB4BGhWdnU65e8t3noRujYAy+wym/7gQBdbt/4NuLGP5pwE0kk+FxMzTSm1kQ7kRpW2BA8OxOJ2Kg381F2TLtvR/anOy7IP+G1RrsGge97/+TjVbEgeH9SiXir0mEglgK+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790794528; c=relaxed/simple;
	bh=bGdi+cm8qfyd6F9bvs/kv+9vNcesPUUKTX58Z13fFA0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BhtPvNezMTBDEjCCr6cwgTS1GcYGm08z7bzD7ALboKznM7qi++kx72cokGlJNqcPVThz+Wo2IuXFYMzWasAJeWgbsvQLIDwXCqNVdqlJ9prbv+TQHZGYkDhBu+V5h/kCSq2jhKyPa2lfWOcHtpnGmEy5QlrqosfdE7JkAcoAYSQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WyA0vtXR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WyA0vtXR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8BCF1F000FF;
	Wed, 30 Sep 2026 18:55:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790794526;
	bh=DnVyoVueH9mGVkY9J1RjqXIkpt26QxqNqMijTgQA1Bc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WyA0vtXREVF5hwQL2JDGvXsielQ6pfuAO5NCCTSTp1kX9B8x7UmdhUFIpaZhy+UCv
	 fxqQIXuKnPdlvj80G7wJzq57BWb55BhJdyQtHGfn9+eNouE47Z1FgYnAsPXQlwMb20
	 jWC3sfXSEFFvZ4jKJU8yzq2UaizLzWitgblsSN7w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jean-Louis Colaco <jean-louis.colaco@orange.fr>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0243/1193] ALSA: usb-audio: Add quirk for YAMAHA CDS3000
Date: Wed, 30 Sep 2026 17:15:27 +0200
Message-ID: <20260930152439.592088980@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index c20a4df886906..f4995560050ab 100644
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



