Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061069;
	b=SzuTCsrVlmNw30h2qhF4upY78yNPY892zKU0UGdGmWZjV+oYJeNia9VyWgsryboiqli+
	 r5xENSTo3c5UzHWCGsgvpAUxjWE2eWxUOwdFn3pA0lpY/I77QAvmHx0PZ770VC23VChWB
	 8+BQF3EomABVLymTJwP9meOJL5MUjY5n7NFRFu7MuzBf5RbZ/QEq5o036vNNOYCXfwJsk
	 oLrBa5mHGkkOdxx1E2azC/KpiftwZmB4As18bfPNXh6N2E/8ToWXu0/Ng6QUCKvaLemrV
	 lUrYWsOWiUxG9fAWBGesDesd/Xv+c6Bbj2l76TOwt/xJmAPwSNpr7yXOdrmdQicSntA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061069;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=wn8xhDNsQpIwtMLij+/RAmsQ9sCcQatxsLbbXNY6274=;
	b=GXdmrY9roKVVaDX/kq86yIBt2zahYhAw3+PsMmM9H01KL8cdlXaGNtaXzTpeSjv0VDoF
	 e6TEEGY3N9R1NMV3d50oMh+qPpm4wfh9NFJF2HK399KWodtrPzCKqHhF+ETjugBzr3yGz
	 sHj+iY2m+BWGf2eubiM8ljbbqhl6xVkVyjC3sJe1l0MrRirWhcZytC7sFwekrboMKaJ/z
	 DFGKgGXGhREips0IeDTycRpBwa4aGc530g51TiHIcF5GwX2D4Z39+wXC8PnIqFpyphqnm
	 xPsHPgjw7lZHegSXqZlOUZ+JWDtZgJaOyNzaTiI+NI917tAEbzNe79kN2YBlyVTDtLg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ykm9oqV5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FD07606A336;
	Sat,  7 Nov 2026 14:17:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ykm9oqV5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CABF1F0089F;
	Sat,  7 Nov 2026 14:17:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061069;
	bh=wn8xhDNsQpIwtMLij+/RAmsQ9sCcQatxsLbbXNY6274=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ykm9oqV5yXiMRLSi2pUu4R6TMXG/MAhr7RFkQb3ZwU3dyDee2A+7VbnHRS4YIA9QP
	 ZItGy0rJt1vmlds6USuUd7s9LqZQ3lS0/lsUoB9vhfzFNM9SuWI24vY/INSQzcpncu
	 AVNKN9jjmQ+3gsY/h1tIiPf32UV9WYqKOCROWgoM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mehmet Aysel <mehmet4ysel@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0396/1536] ASoC: amd: acp3x-es83xx: Add HVY-WXX9/M1060 DMI quirk
Date: Sat,  7 Nov 2026 08:40:12 -0500
Message-ID: <20261107135008.715617702@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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
index 2b0aa270a3e9d..3dc41dae158cb 100644
--- a/sound/soc/amd/acp/acp3x-es83xx/acp3x-es83xx.c
+++ b/sound/soc/amd/acp/acp3x-es83xx/acp3x-es83xx.c
@@ -378,6 +378,14 @@ static const struct dmi_system_id acp3x_es83xx_dmi_table[] = {
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



