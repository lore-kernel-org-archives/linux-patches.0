Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A0E128EB
	for <patches@lists.linux.dev>; Mon, 30 Jan 2023 14:00:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BEF3C433EF;
	Mon, 30 Jan 2023 14:00:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675087245;
	bh=6uAxm5KEIl3IcxH80/PrBEBFQrOTSh5clf3i1F9u3mQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XFqhbOcuijJyrzqjEu5UOukGcsQCtLZSUv8CzG346xbxCeVpQNB4cTlJz4KxE9txd
	 iJ7GQUy2GmjrtSerxmXl0SBCMz+2LZ4EjbhWqelVCIq9K7Y93vrIl5wd4Q/dbBQBwd
	 jhUPXow/TgE5IChOVw0SdR8ww/Nu2aAjBnE8oP3I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wim Van Boven <wimvanboven@gmail.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 145/313] ASoC: amd: yc: Add Razer Blade 14 2022 into DMI table
Date: Mon, 30 Jan 2023 14:49:40 +0100
Message-Id: <20230130134343.410031123@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134336.532886729@linuxfoundation.org>
References: <20230130134336.532886729@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Wim Van Boven <wimvanboven@gmail.com>

[ Upstream commit 68506a173dd700c2bd794dcc3489edcdb8ee35c6 ]

Razer Blade 14 (2022) - RZ09-0427 needs the quirk to enable the built in microphone

Signed-off-by: Wim Van Boven <wimvanboven@gmail.com>
Reviewed-by: Mario Limonciello <mario.limonciello@amd.com>
Link: https://lore.kernel.org/r/20221216081828.12382-1-wimvanboven@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/amd/yc/acp6x-mach.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/sound/soc/amd/yc/acp6x-mach.c b/sound/soc/amd/yc/acp6x-mach.c
index 1f0b5527c594..469c5e79e0ea 100644
--- a/sound/soc/amd/yc/acp6x-mach.c
+++ b/sound/soc/amd/yc/acp6x-mach.c
@@ -220,6 +220,13 @@ static const struct dmi_system_id yc_acp_quirk_table[] = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "Redmi Book Pro 14 2022"),
 		}
 	},
+	{
+		.driver_data = &acp6x_card,
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "Razer"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Blade 14 (2022) - RZ09-0427"),
+		}
+	},
 	{}
 };
 
-- 
2.39.0



