Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831107;
	b=JDDqJK5oAAyHFqked+uEUrJfgycRwc2+xZncSMQBX2dfiylySPAOnPUo5CUJ8bpAIHMm
	 Arfl6Orb/RhoAqylPPrhAGjr0pgFBIQNsQmsD1oBR6UL2EEHFi51CzdOTDglrSO4/63c8
	 Vs5NOQwczHjKmd4PFNq4d8XP7diJiyz4mgoEuv7xvpCI0rzeFoJwKhBXdC0SlsYFbSJIQ
	 C0f7hQ+epx/CiCRBGhx/TwHM8RW50ReGIkjyWc4h1kVUK1WbitmLs6f4Vgx/NK05PYC0q
	 YXyREKtSjJmZg3fZXZqgEmGUVc+/Gr/TkLFF3Oc3ZNeVThMETdVBPwYHJyuNM9Rvu3w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831107;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=HilU6WH2TxuLd8Oh/9ViRgdvZWC+SaoBjNjXMFZxedA=;
	b=vIbUD0hI1vy3WZTkohGOYJkPOi65UeCc6gnlEJvqzamQbWy0bjFbkzfc3BK0fMfyT0Jt
	 q15mO4hQ7IDqKy41tlePlEcvSgyj9iAZRNpkByAWVWleRZo/IqJ7PL4ntxq3DZ5ycCsXG
	 1/PqVtyuTCLY4hZNTB8VXCwyLNV1nOpzP2zKo7AS1oRCpG3PZPdbF4wsCE9JPhylh9MwE
	 BtLLAksC7uiKZCUwVCeX1fQ9gr7/kN1zYdv6dH5FWJvKcgBIkMGcojM3jM67Te8pHAL/f
	 591WUzDk0PeHCuzanXTYdFYu5UTrKbIlWEPuKNDSGwV1WKgG8TCGRTuEIZJz/Pb1Dtw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=U6juKPtT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99C30606B2D8;
	Wed,  4 Nov 2026 22:25:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=U6juKPtT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 333201F000C1;
	Wed,  4 Nov 2026 22:25:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831107;
	bh=HilU6WH2TxuLd8Oh/9ViRgdvZWC+SaoBjNjXMFZxedA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=U6juKPtTXb9bwEnIBQdYy8w1FkmJLZGSOfqJb1Hh5fXN7W4b3X0hj4nexDkNm6BpU
	 SoDJnV+b3NjZLecxnXfJuN+Bxt8u6Jn71pLh3FG4SFv8W2WaZJQwrozvRhT524VGex
	 bJkLMyiyhM4mYn3d21aRxF+NJzd1CGUkKY52vdjE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mehmet Aysel <mehmet4ysel@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0468/1005] ASoC: amd: acp3x-es83xx: Add HVY-WXX9/M1060 DMI quirk
Date: Wed,  4 Nov 2026 16:03:21 -0500
Message-ID: <20261104211057.122546641@linuxfoundation.org>
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

From: Mehmet Aysel <mehmet4ysel@gmail.com>

[ Upstream commit c1a39c228aceebc0ede83781ea906d257e324009 ]

Add matching DMI table entry for the ES83xx machine driver, so the
HUAWEI HVY-WXX9 / M1060 board (MateBook D16 2021, Ryzen 5 4600H) can
successfully probe its ES8316 codec via the acp3x-es83xx machine
driver, consistent with the existing M1010/M1020/M1040 entries for
the same board name.

Signed-off-by: Mehmet Aysel <mehmet4ysel@gmail.com>
Link: https://patch.msgid.link/20260825092432.56292-2-mehmet4ysel@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/amd/acp/acp3x-es83xx/acp3x-es83xx.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/sound/soc/amd/acp/acp3x-es83xx/acp3x-es83xx.c b/sound/soc/amd/acp/acp3x-es83xx/acp3x-es83xx.c
index eb5d4a5baef24..b18a8971aec94 100644
--- a/sound/soc/amd/acp/acp3x-es83xx/acp3x-es83xx.c
+++ b/sound/soc/amd/acp/acp3x-es83xx/acp3x-es83xx.c
@@ -379,6 +379,14 @@ static const struct dmi_system_id acp3x_es83xx_dmi_table[] = {
 		},
 		.driver_data = (void *)(ES83XX_ENABLE_DMIC),
 	},
+	{
+		.matches = {
+			DMI_EXACT_MATCH(DMI_BOARD_VENDOR, "HUAWEI"),
+			DMI_EXACT_MATCH(DMI_PRODUCT_NAME, "HVY-WXX9"),
+			DMI_EXACT_MATCH(DMI_PRODUCT_VERSION, "M1060"),
+		},
+		.driver_data = (void *)(ES83XX_ENABLE_DMIC),
+	},
 	{}
 };
 
-- 
2.53.0



