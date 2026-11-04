Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831027;
	b=0bJrC5dc1xFpRZBlFp5Jbak40BqJDzkLkUUh7JkwbfRJbfReekLlQwFOvSonLhFxJ7wZ
	 CZoSFOO3OeSSj/2Y5FT7hXcGwmNUTYxC4BAbp7ZYzPu/nFLq+AfHfJyPmmlkOLA3FXtgd
	 hGyTGZva60lWKlYWeJHHCIDBk686mxNOHzWfAWhcLvZAlr5F9+tRjMDvedS0j3NJsYyqu
	 X7OEpC6L1fKKyr/l2G+om2egq3KOhuCwwfA7QB9qf/v/4fMgBmqm1ZfIlMPJ1mejnvNYO
	 iaZgpFFvo1fSrIvENxqvRJwBLPzpjSDMwtiju4VERggUro5E5tKwcoshvj2BAQ6R1GA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831027;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=w6g5G2PmUuXRyUgt0usHO3yCu+TehUMajeUEdF0aUmg=;
	b=scsudH9BjKZGJ1HfGDpZ8KC85o3UkYWMh+TLgYyb5HSls8QvtCCB3CA6ULgVzE6hi7Zb
	 TQ90lVe5c2SxI9x3BG863URN2sYqeC6zTrg432tlrV9dTe0OnFP8Yr6IgxjBsrW0ekfvA
	 sCzVLdIgzGdHWOC5T0Q5pkLq9/IuzaHfD4a4sihwmsjcDHJAzvSZrT4MK1aOKLd1GFKQp
	 W9TttEDvUho5XV8NF7JdjvS7jTO713+mirvjdToy85sKcPuHA3xwgqNoH7GJXfhAiKwFA
	 IaUBMeeFWVdFDftp1k34WNmUsuLdKJThYJvR5hVHjdElE3yu+gnWRX4KAOgSMUvPLSw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NXjmn6I3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04498606A843;
	Wed,  4 Nov 2026 22:23:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NXjmn6I3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 759631F000C1;
	Wed,  4 Nov 2026 22:23:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831026;
	bh=w6g5G2PmUuXRyUgt0usHO3yCu+TehUMajeUEdF0aUmg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NXjmn6I3aJNJAiaahtT3CHQjLD/SpoB83Adt0KgRuTLxVHQ8ZVqXbfFw8lptU4z89
	 lbMnKKN1CTjJWZVMrehKQ5Rz1BnB7GdoKbOOubam6zB6N+8Xa5sCPtuldj0wh2Kx+W
	 LsVHTLwdB6X1ey7+vh/0GHaX3QPw0oEtxcKUkqh0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xu Rao <raoxu@uniontech.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0426/1005] ALSA: hda: Add Lisuan HDMI controller and codec support
Date: Wed,  4 Nov 2026 16:02:39 -0500
Message-ID: <20261104211056.031028838@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

From: Xu Rao <raoxu@uniontech.com>

[ Upstream commit ceaebef91d1aff671a512d5f003766ea41152d94 ]

Lisuan GPUs expose an HD-audio controller at PCI ID 4c54:5010 and an
HDMI/DP codec with codec ID 0x4c545020.  Neither ID is currently matched
by the HDA stack, leaving HDMI/DP audio unavailable on these devices.

The existing downstream support uses the generic HDMI codec path and
attaches no Lisuan-specific capability flags to the controller.  Its
dedicated AZX driver type only changes the short driver name.

Use the corresponding generic upstream paths instead: bind 4c54:5010 to
AZX_DRIVER_GENERIC, register 0x4c545020 as MODEL_GENERIC, and add the
Lisuan codec vendor name.  This keeps the enablement minimal and avoids
a vendor-only AZX driver type with no vendor-specific behavior.

Signed-off-by: Xu Rao <raoxu@uniontech.com>
Link: https://patch.msgid.link/DE1B62191D573D37+20260817085531.992573-1-raoxu@uniontech.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/hda/codecs/hdmi/hdmi.c  | 1 +
 sound/hda/controllers/intel.c | 2 ++
 sound/hda/core/device.c       | 1 +
 3 files changed, 4 insertions(+)

diff --git a/sound/hda/codecs/hdmi/hdmi.c b/sound/hda/codecs/hdmi/hdmi.c
index 42e4dc0949ec9..480d1c5f129fd 100644
--- a/sound/hda/codecs/hdmi/hdmi.c
+++ b/sound/hda/codecs/hdmi/hdmi.c
@@ -2348,6 +2348,7 @@ static const struct hda_device_id snd_hda_id_generichdmi[] = {
 	HDA_CODEC_ID_MODEL(0x1d179f8e, "KX-7000 HDMI/DP",	MODEL_GF),
 	HDA_CODEC_ID_MODEL(0x1d179f8f, "KX-7000 HDMI/DP",	MODEL_GF),
 	HDA_CODEC_ID_MODEL(0x1d179f90, "KX-7000 HDMI/DP",	MODEL_GF),
+	HDA_CODEC_ID_MODEL(0x4c545020, "Lisuan HDMI/DP",	MODEL_GENERIC),
 	HDA_CODEC_ID_MODEL(0x67663d82, "Arise 82 HDMI/DP",	MODEL_GF),
 	HDA_CODEC_ID_MODEL(0x67663d83, "Arise 83 HDMI/DP",	MODEL_GF),
 	HDA_CODEC_ID_MODEL(0x67663d84, "Arise 84 HDMI/DP",	MODEL_GF),
diff --git a/sound/hda/controllers/intel.c b/sound/hda/controllers/intel.c
index 3ed33cba7d83f..fd61dc8e21a53 100644
--- a/sound/hda/controllers/intel.c
+++ b/sound/hda/controllers/intel.c
@@ -2830,6 +2830,8 @@ static const struct pci_device_id azx_ids[] = {
 	/* Hygon HDAudio */
 	{ PCI_VDEVICE(HYGON, PCI_DEVICE_ID_HYGON_18H_M05H_HDA),
 	  .driver_data = AZX_DRIVER_HYGON | AZX_DCAPS_POSFIX_LPIB | AZX_DCAPS_NO_MSI },
+	/* Lisuan HD-audio */
+	{ PCI_DEVICE(0x4c54, 0x5010), .driver_data = AZX_DRIVER_GENERIC },
 	{ 0, }
 };
 MODULE_DEVICE_TABLE(pci, azx_ids);
diff --git a/sound/hda/core/device.c b/sound/hda/core/device.c
index ebaa106d0f018..010dd38007a99 100644
--- a/sound/hda/core/device.c
+++ b/sound/hda/core/device.c
@@ -664,6 +664,7 @@ static const struct hda_vendor_id hda_vendor_ids[] = {
 	{ 0x1af4, "QEMU" },
 	{ 0x1fa8, "Senarytech" },
 	{ 0x434d, "C-Media" },
+	{ 0x4c54, "Lisuan" },
 	{ 0x8086, "Intel" },
 	{ 0x8384, "SigmaTel" },
 	{} /* terminator */
-- 
2.53.0



