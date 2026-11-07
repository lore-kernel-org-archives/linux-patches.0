Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794065019;
	b=2MVkCZQ7LbR75w3BUX8RrhXV+s5RfLkhVCc/kvYFteCYJua63+qU1lywylfkd6VrVplo
	 vZ2xIVQO9DuPhwhqDb9YyQMvzB59TIF87MPcCRIfayZUfiVTVLRcTNzc9YoB+lpRPkg9S
	 o8mH+P+YelTBX0APRtupZZ7zkWHp5LT3zU4XwFS10Tf6IwGeBfDsKSTYEBAuy0AREdmrj
	 wANZdXh4o4Jz1q4TJxdayl28cuVajZ7cypSSJyIfVyF//2VDumw3rZxQVSgkw09zNPePM
	 +Ez6E1PFCRH8cTat7uMTgVYyLdHODnhYQg5hCo0Z8EDwnqwBhtWDhVki7vj+S7pvlzA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794065019;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=jHEFTQ5RCoYmMwKHDrX8/dhSqFD4n2/QuhzI18q88Js=;
	b=xU0xVYnYEvaDzRdApf0WmL64uXZK5vFRomzLiULvyvSor6m2HQs/p/mBoMGIYFlnSp8n
	 yoVVShsrRdR3CHUKFADJj3iREtq5+2FdPA9ugsmeV4YU9jUB86Kt8tQFrh8tLG1Cliblz
	 yRQO6XMHw+QOddDCF1EOgulWydf/THI139YqPhhQNL/vb4v0WLn8+WKLi3ZcyEE9omSXb
	 3RLmKy6Kk3C43eV9Ls99zb+O0+j47CRsSoVwaVE81nOZRuKbnYTHobTUwDpctyOVjdekS
	 u2hHKg759UCqbxkAUfwBFQKALXcJ44qt6P4psbDFUKDb+FFK7jZGIFYHY5/2xwp4Rbw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yUbPKmcl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26634606A336;
	Sat,  7 Nov 2026 15:23:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yUbPKmcl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AABB41F0089F;
	Sat,  7 Nov 2026 15:23:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794065019;
	bh=jHEFTQ5RCoYmMwKHDrX8/dhSqFD4n2/QuhzI18q88Js=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yUbPKmcl6KjlUodp/r6/D291RY/KOqz7Hd7MLziP0mmjZoDWkROj9AJE57ySwDtaq
	 1WFe3MGYhAZ1kEqHvQTI2HFGJHygfB3xeXcTF5hNockSWXwAeXJXejnG5D33Nu5zPk
	 CPAgU6you6XNcRJe5TR15Dpj/nFBojzjQEHMLKDI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Art O Cathain <art.home@gmail.com>,
	Vijendar Mukunda <Vijendar.Mukunda@amd.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0840/1257] ASoC: amd: acp-config: force SoundWire probe on Dell 14S DS14265
Date: Sat,  7 Nov 2026 08:52:16 -0500
Message-ID: <20261107135002.525569184@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Art O Cathain <art.home@gmail.com>

[ Upstream commit 38cb2ef26b6411277826da54c6bcf94523541058 ]

The BIOS on the Dell 14S DS14265 (ACP PCI revision 0x72) reports
acp-audio-config-flag = FLAG_AMD_LEGACY_ONLY_DMIC. As a result
snd_pci_ps returns early and the SoundWire links are never scanned,
while the legacy snd_acp_pci driver probes the device, finds no
matching machine driver ("No matching ASoC machine driver found") and
no internal sound card is created. The CS42L45 headset codec on link 0
and the two CS35L63 speaker amplifiers on link 1 never enumerate.

Add a DMI entry for the model to the ACP70 ACPI flag override table so
the firmware-provided flag is overridden and snd_pci_ps probes instead.
Match on the product name rather than the board name, as the same
symptom has been reported on several boards of this model (09PVND,
0M0J65, 0C7F12).

Tested on a DS14265 (board 09PVND, BIOS 1.5.3) with Debian's 7.2.6
kernel, with and without this entry. With it, snd_pci_ps binds, both
SoundWire links come up, the CS42L45 and both CS35L63 enumerate, the
existing CS42L45 + 2x CS35L63 machine entry matches, the amplifiers
load their firmware and calibration, and the amd-soundwire card plays
through both the internal speakers and the headphone jack. Also
build-tested on asoc-next with W=1.

Developed with AI assistance. Claude read the ACP driver source,
identified the BIOS flag as the cause and the override table as the
fix, wrote the DMI entry and the out-of-tree test module, and drafted
this changelog. All hardware testing was done by the submitter, who
has reviewed the change, understands it and takes responsibility for
it.

Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-5-5
Signed-off-by: Art O Cathain <art.home@gmail.com>
Reviewed-by: Vijendar Mukunda <Vijendar.Mukunda@amd.com>
Link: https://patch.msgid.link/20261016-dell-14s-acp-v1-1-89b40d95720c@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/amd/acp-config.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/sound/soc/amd/acp-config.c b/sound/soc/amd/acp-config.c
index 3d48bb0f100f2..f190d3cdc81e3 100644
--- a/sound/soc/amd/acp-config.c
+++ b/sound/soc/amd/acp-config.c
@@ -98,6 +98,13 @@ static const struct dmi_system_id acp70_acpi_flag_override_table[] = {
 			DMI_MATCH(DMI_BOARD_NAME, "8EA2"),
 		},
 	},
+	{
+		/* Dell 14S DS14265 */
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Dell 14S DS14265"),
+		},
+	},
 	{}
 };
 
-- 
2.53.0



