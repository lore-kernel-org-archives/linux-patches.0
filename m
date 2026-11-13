Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590749;
	b=jSDX4i1LnOPT9cXQ5TIVwIecCg8meHmnMwh7o5G2XhGom9fAxn7wuGgIEus04juUKCfU
	 1gXNxt+gF5Bqu2RSt3wx6HYYY1HiEsPOrf/tQxcMSiTrgUjQQEoGAgf4GhqCk54FgH1c8
	 +B8VhBGyTCyqfxdcUh8/m4w6TEROc0/yVdSZjgYz9wAqctjsHPm8DnbR+KwEg9TiU59k3
	 r0pW2lB1eVPc4IW5oqz1izxUpOuqU/XXeY4DTaPyogHfsZgB7S1IYOIyQA60uF2uficHS
	 qpMF2EldBUBZzOsSxedMtI8qkdxW/0dzvAIIUWtCOT/mWgDSWICloZFKKHc3pP5wmWA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590749;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=SfYcfUeWsvZo8hLiD3ggG11dUbu6lrADUMZMC7lrJJA=;
	b=qNmXsPnM/rR/v61hQmavSb+GFkZEjUsnA8nn002bTQDfYmvAWqncFpNedhL62X9zkOMO
	 rnOCfr0c1jRvOZlhM8gRPo2sjyNfUnlI1SkHYWOVeAvAYDqnpmQj4Fz/U3S6ivL+dqH7C
	 TtHIA59XhbX2buPbJSK+gM62shXT2+2MRzDS/Y1yoO8joAHIB5RBUr1V+by5G+voC0fQh
	 BsKTFUNHbC/VhbVlDDxchVLEe8YSx0azp2WpqyutI6svmpGE7lRAxIbOQ/QKs484yFiPJ
	 I9b6RuvRICZU4om/xu+WFHJwtFaGGvsg6MF+9G7slZcDoCgPUxyGlzAufMCG5KTeadQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bCBmnor6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 042FE607B5BB;
	Fri, 13 Nov 2026 17:25:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bCBmnor6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4AD11F000C4;
	Fri, 13 Nov 2026 17:25:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590748;
	bh=SfYcfUeWsvZo8hLiD3ggG11dUbu6lrADUMZMC7lrJJA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bCBmnor69j1o5wsiHbWoHho7DaxsmWYik5qj7UqD5ZR99i3eINDqcxA48STqlaM/R
	 xSUCSTg+4S7Em5QdeJdIk6kR7f8n30xzhAJqE40B8yjoednxJpZjkaDGe4zbnTW8Xa
	 Cq3ydhLOdxJDPgoCajYtlAVP0qG9oaB44PZYljho=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sehat Mahde <hskmahde@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 608/686] ASoC: amd: acp-config: force SoundWire probe on HP OmniBook X Flip 16
Date: Fri, 13 Nov 2026 10:52:21 -0500
Message-ID: <20261113153842.506827671@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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

From: Sehat Mahde <hskmahde@gmail.com>

[ Upstream commit 4d6642d64cd00f276549ec2c0b0278aea2f8c1aa ]

The BIOS on the HP OmniBook X Flip 16-cc0xxx (board 8EA2) reports
acp-audio-config-flag = FLAG_AMD_LEGACY_ONLY_DMIC. This binds the
legacy ACP driver and registers a PDM-only card, so the SoundWire
links are never scanned and the two TAS2783 speaker amplifiers and
RT712-VB codec do not enumerate.

Add a DMI entry for board 8EA2 to the ACP70 ACPI flag override table
so the firmware-provided flag is overridden and snd_pci_ps probes
instead.

On the affected system, an otherwise identical upstream kernel
without this entry binds snd_acp_pci, enumerates no SoundWire slave
devices and exposes no internal speaker PCM. With the entry added,
snd_pci_ps binds, both TAS2783 amplifiers and the RT712-VB enumerate
over SoundWire, and the amd-soundwire card exposes the internal
speaker playback PCM.

Developed with AI assistance. ChatGPT helped analyze the ACP and
SoundWire behavior, structure the controlled A/B testing, and draft
the patch changelog. All hardware measurements, kernel builds,
reboots and playback tests were performed by the submitter. The
submitter has reviewed the change, understands it and takes
responsibility for it.

Assisted-by: ChatGPT:GPT-5.6 Sol
Signed-off-by: Sehat Mahde <hskmahde@gmail.com>
Link: https://patch.msgid.link/20260825224640.13662-1-hskmahde@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: 38cb2ef26b64 ("ASoC: amd: acp-config: force SoundWire probe on Dell 14S DS14265")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/amd/acp-config.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/sound/soc/amd/acp-config.c b/sound/soc/amd/acp-config.c
index a46b9a029cbb0..d73059f400d57 100644
--- a/sound/soc/amd/acp-config.c
+++ b/sound/soc/amd/acp-config.c
@@ -44,6 +44,13 @@ static const struct dmi_system_id acp70_acpi_flag_override_table[] = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "83W5"),
 		},
 	},
+	{
+		/* HP OmniBook X Flip 16-cc0xxx */
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "HP"),
+			DMI_MATCH(DMI_BOARD_NAME, "8EA2"),
+		},
+	},
 	{}
 };
 
-- 
2.53.0



