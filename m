Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591506;
	b=SbN//SLucYIFsZjapEDq2BthMHCbqDXbpd1IDWlUMOgtj48fd1Fc8Wql58cp1uT4dnlV
	 7IWVAMIz6eFh9+qfR1cHHIZWDaiHG6etD5jVkO2VXk2k8v2Y0R3Q4gBZCaAZQTEFwg5fl
	 FSnoJmm0qU4HdyNI7mRu28qKMd5wHqwESvgpAeSRbva+aKsNBMlI3a91K8UnVtnJImNHj
	 UZiaxaRGVA4yFiaM8tPd998Bj/3bqtdBKiCzCzn14Rr65XrsOQuPJuEqO7wSLhV+EyRwp
	 W8zCRJ9CFUj5BlGUtwzNEcj+/J1r6ZvFjD3/8vbo+8NpBrj9IZW7vD3lUigZVNaYLCg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591506;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=0EQO/GdtIyINPGj/ZgNBMyHAaJsSslIO7POJxTPQ0XE=;
	b=fVHwzYCeVQvFrb56kh8p4aotADWEY97xfYVZRUUaGeLA6KNAHLoJdSqVE4kvhQe3P4AE
	 sMR3KJ3UlDQeV/r0vPFaEZzpEi/3Smbj6hIQ0d/LSr+NAHuKh6qeOz7RJ+M4+mL9UM1gS
	 9QfH+J/rRi1Lq86lP6bG+BEFtdkHCzYdt8qF552HIxNdmpIQqevnLJC7IZZfkclqrYEqz
	 CHecVU6v7du2HuOIjr/rKq2TAfNK6KudqJck9E47Y+OEx3BuuOjFaLyay3gSkjnfSqlPv
	 m/hS1ixqy143U3URvYYaICzlocLRPXxXNOFXpVx6F9qcYumGCiMKd4s+tjjn/eNKRGw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="hWeNPN/f";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9833606D48C;
	Fri, 13 Nov 2026 17:38:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hWeNPN/f
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 389B31F000C4;
	Fri, 13 Nov 2026 17:38:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591506;
	bh=0EQO/GdtIyINPGj/ZgNBMyHAaJsSslIO7POJxTPQ0XE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hWeNPN/fMAOISdSZI2tqQzl75etVDF0cNT0yjFrt1drayKDN3fh4C6cJSChej/p2A
	 z71tH/xsn5GAH0lQj+juw8836qnMIG0gySq1KDQZteB3UxYHWOE0rgojFBFxdxDCoZ
	 bJ1/qyqVejtwRmkDKo8E2di1C5NSzN1MBcGMj7bE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sehat Mahde <hskmahde@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 578/670] ASoC: amd: acp-config: force SoundWire probe on HP OmniBook X Flip 16
Date: Fri, 13 Nov 2026 10:52:22 -0500
Message-ID: <20261113153831.432610215@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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

Append the entry after the existing Lenovo quirk because the neighboring
upstream entries are absent. Preserve the HP match unchanged so the
subsequent Dell quirk has its expected insertion context.

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



