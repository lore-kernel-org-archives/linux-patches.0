Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 538C063B8
	for <patches@lists.linux.dev>; Mon, 20 Feb 2023 13:57:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0334C4339B;
	Mon, 20 Feb 2023 13:57:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1676901434;
	bh=sPsvOSqlhoWC/q+W+LIn1MJRKhl1TyhFwQxIEx9ez4I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GfMgFVWRyDwxgSH5Vx5rwLJlZeyX+2jgZt87bZhoOJ+AKquhbBDOudxHgT05p1xZi
	 9s2wjQsuLkmJX9syPwTQ91G31qFh+VX/6EukEpfGBPQ2w+ClWChiFVIs+kSDgMrnSx
	 bkqK+EGXONAYRR6YM3EPnb6L0RfCEBR35dwKP1rE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	fengwk <fengwk94@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 016/118] ASoC: amd: yc: Add Xiaomi Redmi Book Pro 15 2022 into DMI table
Date: Mon, 20 Feb 2023 14:35:32 +0100
Message-Id: <20230220133601.057896480@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230220133600.368809650@linuxfoundation.org>
References: <20230220133600.368809650@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: fengwk <fengwk94@gmail.com>

[ Upstream commit dcff8b7ca92d724bdaf474a3fa37a7748377813a ]

This model requires an additional detection quirk to enable the
internal microphone - BIOS doesn't seem to support AcpDmicConnected
(nothing in acpidump output).

Signed-off-by: fengwk <fengwk94@gmail.com>
Link: https://lore.kernel.org/r/Y8wmCutc74j/tyHP@arch
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/amd/yc/acp6x-mach.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/sound/soc/amd/yc/acp6x-mach.c b/sound/soc/amd/yc/acp6x-mach.c
index 00fb976e0b81e..36314753923b8 100644
--- a/sound/soc/amd/yc/acp6x-mach.c
+++ b/sound/soc/amd/yc/acp6x-mach.c
@@ -227,6 +227,13 @@ static const struct dmi_system_id yc_acp_quirk_table[] = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "Redmi Book Pro 14 2022"),
 		}
 	},
+	{
+		.driver_data = &acp6x_card,
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "TIMI"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Redmi Book Pro 15 2022"),
+		}
+	},
 	{
 		.driver_data = &acp6x_card,
 		.matches = {
-- 
2.39.0



