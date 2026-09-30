Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C6534DAF9B;
	Wed, 30 Sep 2026 15:38:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790782699; cv=none; b=Q2xUlC3nqUDOFiKWCD3fx8/Rn5rE6Fas46wY6MyLDBRQXIs8qp14Et3KltyGglH7JlkFNr2tYjDK451xVj/w/2Vxll6Qj+BmPCK6CFRc+sKusROWRCVPwn8EnxRyqb4QBiR2wyi9mFuEXRg1O2Eav7y3OCLOtROH60OWZU39xiI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790782699; c=relaxed/simple;
	bh=LO6IiLF338RRDK8RZxhQIEBkcwK6PBtgY6GxxoIt3II=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iHVYrlBwkoPvY+49JVp7jFemPaJTAoIZ4bfHPEhGeSEzCo1Rqns6t6t+s7MsOEnV8104J0eZpQ2NNTJwQmcdVPjOqmvS5t77YKUdh3H45K03pYDA/URbILSgL2W0n4Y324g/4lkgMtZ7xOj8BmmKH8zJZPaIi7auvRX12YO7SXY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0pU17ZQf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0pU17ZQf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A97021F00898;
	Wed, 30 Sep 2026 15:38:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790782692;
	bh=56fnoxDfKdQFfFOSVFD20+siq9y60hxcsPMtdBP4FZc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0pU17ZQfv7FF59ieNhAeRtNO/9zCjdkqvPtNMQ5tqoWV+XgM2ZZSC3V+NkHHMgnQ3
	 MBvZCI4J2r9IplkBOsb+N26oEHVyJvOgDTkG49m9xMcyzMWJTNjwK8uKWHJYqkaBpc
	 vqsfmZzPkn4uI3mF0lpP8QVCjIR1m/vxtwPBu5rg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jean-Louis Colaco <jean-louis.colaco@orange.fr>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 136/595] ALSA: usb-audio: Add quirk for YAMAHA CDS3000
Date: Wed, 30 Sep 2026 17:20:29 +0200
Message-ID: <20260930152350.661111117@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152347.700140858@linuxfoundation.org>
References: <20260930152347.700140858@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 75ce583f13153..3891952e17476 100644
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



