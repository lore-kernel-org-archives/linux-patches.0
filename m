Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590746;
	b=loGGdIjct0dmHfAZs6GoG90NaobG3A+6gxS8e8DqUwt14E4/4H+cZtt2qOzVmJ2HwQUU
	 E4azSW8LkHklGm0Ms/TdipQoZcQyTCN9QQNNvaTrZtmU3vGcX251/HOq6kjLD6LXzDq+C
	 gsUQZw94k6/Xf8D8iUZHUO/9i/rBsuyfCGyPMxEagAoqIkBipm7SX1O3wLZqJaYznrYuB
	 /eX8wbwzAwwq8IrPSLhjD5pS9TMOVP2d2iGRVR8Iv9PTA3nueNmM5QLBCe3G26fTeMG/n
	 RI/lKNKHW2KreaV65UNktmgWgLdPEmv6oAoR6PrYhCyUiAStcWdSjykV5eNjDOcA1kw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590746;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=z6W8i2g9T2qsUbAAtAMmJETgMKx1ZYSJ8hHU4LlTofM=;
	b=3xW9ciquFGKlaDtqoqTlBcNyVL7HWVRtNRaxc0zrQhsw0fKGAu5mcNAe6JrkjiTW33x9
	 yi6QAUpOJI/dyGhmhAmJEUjVjDAwzLgQWLgGiHzw7eZoODmPq7qjMbWSa1yT5HDo6ZB1X
	 v2wzy57Vnztq92i2z5JK4euG3RW2qisOTdbDkejCUudebHyw3Dk/yBi+48fAnmjzeRV8l
	 qGZDqSqoG1QCAUowz1SKRzufctZIbgpS9ELJRggA+vO6qNYhnc3/2Co496qWI8uEqll4w
	 CajTedp2py45gIDvT/bIjGAoENKgD8eFa5WlCO+oJc/tyPEqWRv/1YLXmoxms2IIVjg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AkShm60g;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C741607B5BB;
	Fri, 13 Nov 2026 17:25:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AkShm60g
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29EAC1F000C4;
	Fri, 13 Nov 2026 17:25:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590746;
	bh=z6W8i2g9T2qsUbAAtAMmJETgMKx1ZYSJ8hHU4LlTofM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AkShm60gPHDKCp1gh3i4FyXgsmnZNU+dZ/xTUgLAR9C+g4d+L4HIVdTFJd0qrowfu
	 TPcn0DlWPD6cys5J9Fkk3FiLijs4jS5dqO7aOboPtCzw4efShR2htXPmWRaap4dPF7
	 cwOxNCd+L2G/q/b4/ToSTn18Nkqz/ffF3xDC2U+U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jasper Smet <josbeir@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 606/686] ASoC: amd: acp: Add DMI quirk for ASUS Zenbook S16 UM5606GA
Date: Fri, 13 Nov 2026 10:52:19 -0500
Message-ID: <20261113153842.448130689@linuxfoundation.org>
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

From: Jasper Smet <josbeir@gmail.com>

[ Upstream commit 6e4bfd9da8851f562f04503d8e43221957f96eeb ]

The ASUS Zenbook S16 (UM5606GA) with AMD Ryzen AI 9 465 (Strix Point,
ACP 7.0) has a BIOS that incorrectly sets the ACPI property
'acp-audio-config-flag' to 0x10 (FLAG_AMD_LEGACY_ONLY_DMIC) for the ACP
device. This prevents snd_pci_ps from probing the SoundWire bus, resulting
in no internal audio (dummy output only).

The hardware uses a Cirrus Logic CS42L43 (headphone/jack) and four CS35L56
smart amplifiers (speakers), all on SoundWire link 1. The corresponding
machine table entry (acp70_cs42l43_l1u0_cs35l56x4_l1u0123) already exists
in amd-acp70-acpi-match.c and correctly describes this topology.

Add a DMI quirk to override the flag to 0, consistent with the existing
entry for the HN7306EA.

Signed-off-by: Jasper Smet <josbeir@gmail.com>
Link: https://patch.msgid.link/20260513052137.56703-1-josbeir@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: 38cb2ef26b64 ("ASoC: amd: acp-config: force SoundWire probe on Dell 14S DS14265")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/amd/acp-config.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/sound/soc/amd/acp-config.c b/sound/soc/amd/acp-config.c
index 8d7b968c4402c..cc3620db62bf1 100644
--- a/sound/soc/amd/acp-config.c
+++ b/sound/soc/amd/acp-config.c
@@ -30,6 +30,13 @@ static const struct dmi_system_id acp70_acpi_flag_override_table[] = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "HN7306EA"),
 		},
 	},
+	{
+		/* ASUS Zenbook S16 UM5606GA (Strix Point, ACP 7.0) */
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "ASUSTeK COMPUTER INC."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Zenbook S16 UM5606GA"),
+		},
+	},
 	{}
 };
 
-- 
2.53.0



