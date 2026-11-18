Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795028001;
	b=sIMH0e19w0nMo0+WXk2eUwDRS7LdpLchC0h10Y7F6k6fzf6AG/Acz0AMXzqCdjFVIwNS
	 2GtlA1MJNPsLVTzfH+UlT7KUDK5FeByNuHtlj9NdPMui9iN3DCdtuOStLOYo0EY11voMV
	 xBk1DXdA/bMhYyi7hK7sE+p0U7fcE/Nq0wWjd00JAkN+jLUG7vJh1CQyp1m9er9cYc1oA
	 aBQ97Gf6MPt3UVh0AA1ry44Fb5/yS36oQZN5GWzJh9Igk4sJY6RcTXkC17Vh9GzW99gUf
	 9QZoR4dG8sQvG+WPUD518OIZAWAkPHZFNG2yAdlbrRBl7c8QJT1mN1UoEMDXWA1r9lw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795028001;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ngwW+DhJrKF0Ep1v2n98LG0s1qN/W6z14N+8CCgnFEY=;
	b=0VZetmMeKKQWCNLenIWqr0l+EpkWuENtEgMhtKdqvtQ55fDXhTMdGjX2U/y85V9B8EyY
	 wz5ytJgwNEbr5mGT+G3MIsie392LcRE99XDXmol0pF9X2EvCDL0ng9DeG/8RLm1pp/zXt
	 jtP+y5fieITyJNijur7hHoO2rsBzo9g09ivnvFvQ9PEzQ1YNt3hpKB+zkP4WsjqNNfsKa
	 VIiMYha4pNLnQMX1UzFtfXWW5DedvpGH+CzCi/BlOHJcwhdwTLTq0K5P7e0SwN7dbS+hK
	 JTJau+FCD+eI+eaWi7QGQO+ywHhEn5o+ASmv3aNymfTZocOD+x2MHhL/+zd6ilXKyfg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ao9Y67d6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D30C606A31C;
	Wed, 18 Nov 2026 18:53:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ao9Y67d6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1330F1F000C4;
	Wed, 18 Nov 2026 18:53:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795028000;
	bh=ngwW+DhJrKF0Ep1v2n98LG0s1qN/W6z14N+8CCgnFEY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ao9Y67d6/eIEHkCuRBje7b56kF03dbFlhFsLDpYKKXxpTJb5DeLVCJZTq8CyrkWKb
	 i/D6nOGPApu2lcA8oZdIIawPFuztVDP/ccf8GxaMxCxXtwbhk10v4cWAiU4XGcLY2o
	 oQdpVcMVVDyzTSLZvceub6hLHTjQDbd/j7I0s38o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sally Marcher <me@gry.sh>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1988/2151] ALSA: usb-audio: Add correct datainterval in the quirks-table for Microbook II
Date: Wed, 18 Nov 2026 16:02:03 +0100
Message-ID: <20261118150234.144231646@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sally Marcher <me@gry.sh>

[ Upstream commit a09c2f3b267e47767b8937f65930567edbb88d44 ]

This patch fixes playback issues on the Microbook II.
The correct value was in the older driver for this device
(https://github.com/manuel-rhdt/snd-microbookii/blob/dd304c097bb6a9d52276ac29c6969fa02bc7674a/audio.c#L914).

Datainterval needs to be set explicitly.

Fixes: a634090a0f24 ("ALSA: usb-audio: Add quirk for MOTU MicroBook II")
Signed-off-by: Sally Marcher <me@gry.sh>
Link: https://lore.kernel.org/d5dfd044-69f6-4fc3-9884-6599d88afb55@student.tugraz.at
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/quirks-table.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/usb/quirks-table.h b/sound/usb/quirks-table.h
index 061d21da91fbe..ff9dd3a4b845e 100644
--- a/sound/usb/quirks-table.h
+++ b/sound/usb/quirks-table.h
@@ -2753,6 +2753,7 @@ YAMAHA_DEVICE(0x7010, "UB99"),
 					.rates = SNDRV_PCM_RATE_96000,
 					.ep_attr = USB_ENDPOINT_XFER_ISOC |
 						   USB_ENDPOINT_SYNC_ASYNC,
+					.datainterval = 1,
 					.rate_min = 96000,
 					.rate_max = 96000,
 					.nr_rates = 1,
@@ -2775,6 +2776,7 @@ YAMAHA_DEVICE(0x7010, "UB99"),
 					.rates = SNDRV_PCM_RATE_96000,
 					.ep_attr = USB_ENDPOINT_XFER_ISOC |
 						   USB_ENDPOINT_SYNC_ASYNC,
+					.datainterval = 1,
 					.rate_min = 96000,
 					.rate_max = 96000,
 					.nr_rates = 1,
-- 
2.53.0



