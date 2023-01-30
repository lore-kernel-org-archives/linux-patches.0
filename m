Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49A4E28EB
	for <patches@lists.linux.dev>; Mon, 30 Jan 2023 14:01:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B93CC433D2;
	Mon, 30 Jan 2023 14:01:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675087263;
	bh=24SmoVPrrLsw/V4ZCXScCKOQE+2HunAS5YBa2iYOwP0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D2qGfDCDHIn6X2zlQSFSq/qm+xqJ4soh39WeinyomKkebAqpdZyWJ150tI/fByGF3
	 w5BNHQkxb1QVTNt3gkhObprC+5grH37tW76tfBCZpWuBJb026d0cRwEQhzkvhGkzif
	 b47qUXRDnCdMU3oGG70KK49NZi/es4iyEM0ZfDWU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Aniol=20Mart=C3=AD?= <aniol@aniolmarti.cat>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 151/313] ASoC: amd: yc: Add ASUS M5402RA into DMI table
Date: Mon, 30 Jan 2023 14:49:46 +0100
Message-Id: <20230130134343.694331168@linuxfoundation.org>
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

From: Aniol Martí <aniol@aniolmarti.cat>

[ Upstream commit a0dd7fcab5cd221fa960f594c586e1f9f16c02c0 ]

ASUS VivoBook 13 OLED (M5402RA) needs this quirk to get the built-in microphone working properly.

Signed-off-by: Aniol Martí <aniol@aniolmarti.cat>
Link: https://lore.kernel.org/r/20221227224932.9771-1-aniol@aniolmarti.cat
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/amd/yc/acp6x-mach.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/sound/soc/amd/yc/acp6x-mach.c b/sound/soc/amd/yc/acp6x-mach.c
index 469c5e79e0ea..0d283e41f66d 100644
--- a/sound/soc/amd/yc/acp6x-mach.c
+++ b/sound/soc/amd/yc/acp6x-mach.c
@@ -206,6 +206,13 @@ static const struct dmi_system_id yc_acp_quirk_table[] = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "UM5302TA"),
 		}
 	},
+	{
+		.driver_data = &acp6x_card,
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "ASUSTeK COMPUTER INC."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "M5402RA"),
+		}
+	},
 	{
 		.driver_data = &acp6x_card,
 		.matches = {
-- 
2.39.0



