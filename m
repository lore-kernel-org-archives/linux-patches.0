Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590750;
	b=p0AWzelHsqb1VYdQekHDVEI4zTwggOtox+erjI5J6xqw7KTbUQIDJIj0EMR7bswYPrz4
	 cK0n6ffCDZEYZEVkmZ5X97tCDBmG5KuIn3r564FWK1i4sZJg+6Tgut+F7Z1T+XzaVEaF8
	 ImAaWlcXqRYj4qwaXp4vLdaVf/alpjoj8phmmxytewyZg4Cc/ihb+ljBzd3neNvEoNrGB
	 MgZFWI5RRsCfnex+aCdGa8/tMfgE7OVDJjJz4TrhIQT9gxA9hd+oEJk71M8UYm7asXchN
	 mtKv5B1XQygDWPtwNYGoQ//Go2GM4IH+bBnY11s/wCtw81yb19GRJv2Z6pHklzOrx5Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590750;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=FBOA4zA8M+0qhNsiw4E1ILibDO3EjiKbDvb7rs/UPDw=;
	b=EnaZKkL+K4HZ/gYNd24i7zi8hIuHB3LjZTkYPNf7KHtC8tgc2AC0WunxKsTMicgqpHrs
	 tvjrDd1h7BtgOR63IufG0OHGo8Y1wWTPUpjIEVRT495kyofjqgli5J/Jtn3HQUyLzglgN
	 X9xOYDNnok6GeeLLemGKKAYBzn+N95Pf7V4OQcuF8NfK1JMqOeQ8TfegksXNAA+4rQcIT
	 OTeHODGGYd9Ef2ITpPBrkaa1H32quwLi2OmB3RgGwtvnoO7M6m/WZzoep12gBFtgqF9yi
	 AjnEsogImPpzmR6zu8ButsIJOjfDd6O6S4KudkBePYMTvJukOQtwV0rvcW3EaClqvmA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rKsModaY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DCE3606E202;
	Fri, 13 Nov 2026 17:25:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rKsModaY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCF731F000C6;
	Fri, 13 Nov 2026 17:25:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590750;
	bh=FBOA4zA8M+0qhNsiw4E1ILibDO3EjiKbDvb7rs/UPDw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rKsModaYw4uEN0Ooblvp/6i6JRJ7/julAwdPrAfClinDcqr4OPmNNoEWhGVHBxdDz
	 Aq3lRZpFJDt4nvYInjxK1QMFma318BA2qg5iQsRLMypRmuan5vRys7EirNldEju39X
	 3h2veQHMXO8lMd8Kcjzrxq/scr4WJn5bAsJHmvZg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Art O Cathain <art.home@gmail.com>,
	Vijendar Mukunda <Vijendar.Mukunda@amd.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 609/686] ASoC: amd: acp-config: force SoundWire probe on Dell 14S DS14265
Date: Fri, 13 Nov 2026 10:52:22 -0500
Message-ID: <20261113153842.538740062@linuxfoundation.org>
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
index d73059f400d57..7ed461c1d5192 100644
--- a/sound/soc/amd/acp-config.c
+++ b/sound/soc/amd/acp-config.c
@@ -51,6 +51,13 @@ static const struct dmi_system_id acp70_acpi_flag_override_table[] = {
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



