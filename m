Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CB1E4582C6;
	Mon, 31 Aug 2026 13:43:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183836; cv=none; b=q0jgmbQdL2iwzx1BO+aYsU6VlqIpIKX95fx14uH/ytVosmTiDliUtfZW3i7ZW45tv4Mbj++ReFFfFr6uC/n8W4qFbn9SogkMU6ibVcSMKUQU+ngoNoLA7kLMDflPiaQBL3igdnU7KHkv+um8KYmt42yCtTDi5j5K2iNk+q7zO0U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183836; c=relaxed/simple;
	bh=v6HN+aUDVTlVFb41nA9MAD9x57+c//d2mTJH66RPcsY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mowNrUNVv8AHi9Obj8YSQseQT94SIZUDZx6YH8etay+t6hOtwznMZKsPrDBG69Kk2BxOZkyEh8MzVy6XL8dq8GY9ItowybvSAV5icuujDC77YKY0bvi/Ae/0pdzU2RZfvLpKo4dZKVZDnVVNgg+a4/Fhe2f30Zw25X1yS1+6iDI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PqxmxYUG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PqxmxYUG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BAC61F00ACA;
	Mon, 31 Aug 2026 13:43:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183834;
	bh=zAOK90tEDjgPGLmjGqCHOnLSN/8+LFnej7Fk+i6ofgk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PqxmxYUG7Q8fb0CiSgamGngK7rjb7gcMsI7drGaFdFl6/JkoNMWDA1YUjEK2cwbol
	 NTq3uwGR+NPUZbJE2AfF7X+P86IWrN41MNuJoJZ6erO8KVIuv9zXLEkWOLHzmc5eJn
	 fNvPnYkJOjlYYeRRfClpe1lc++BMj3Rly+Gg09Wt7alETfXXPZPh5CJoDhKGnXD9Y9
	 N1tkyl8K/RRTXF6eSQNe6NnbUpFs2LjbwNvsWPkxPAIxSaomsm/iEfOvbtIdmd07Z9
	 TdeLKZlg0yIAVWCa3EHLCmP8x8bBgLjqQW3MQXSGz6WaUkfpTkR/aGoGpZZFnPuFBV
	 Z+JBtUwmkbRrg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Jean-Louis Colaco <jean-louis.colaco@orange.fr>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>,
	perex@perex.cz,
	tiwai@suse.com,
	linux-sound@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] ALSA: usb-audio: Add quirk for YAMAHA CDS3000
Date: Mon, 31 Aug 2026 09:26:00 -0400
Message-ID: <20260831133314.4125787-332-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260831133314.4125787-1-sashal@kernel.org>
References: <20260831133314.4125787-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.48
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

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

LLM Generated explanations, may be completely bogus:

The background `git log` searches finished and match the earlier
analysis: there is **no CDS3000 / `0x150d` quirk commit** in this
6.18.44 tree. The only relevant nearby hit is the UR22 template commit
(`f0b127fbfdc87`), which this patch copies.

The backport verdict stays **YES** — a small, device-specific hardware
quirk that should apply cleanly between the existing `0x150c` and
`0x1718` entries in `sound/usb/quirks-table.h`.

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

