Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F3151C29
	for <patches@lists.linux.dev>; Wed, 23 Nov 2022 09:40:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66C92C433D6;
	Wed, 23 Nov 2022 09:40:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669196415;
	bh=kAigqeMZPJBt2ntHZIObOuDoIoBub1ivzXrK8HvDdIM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ePXD5CDyQa0oNufCcridtkx9d2kitr5vvyxXN0jrhc1SGt0X9FfTDap4ybza+f5ug
	 90jXb5nykqAAcjef4e5o9vSaSMuYza++jfAmu1DZvH2tFIExTHHQ4D0/Wd5bNpk9jA
	 hl+gNa4BORwzKAu5kYlr5scYevvQ5ZSfAP8bVdq8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Taroe Leohearts <leohearts@leohearts.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 024/314] ASoC: amd: yc: Add Lenovo Thinkbook 14+ 2022 21D0 to quirks table
Date: Wed, 23 Nov 2022 09:47:49 +0100
Message-Id: <20221123084626.594803001@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084625.457073469@linuxfoundation.org>
References: <20221123084625.457073469@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Leohearts <leohearts@leohearts.com>

[ Upstream commit a75481fa00cc06a8763e1795b93140407948c03a ]

Lenovo Thinkbook 14+ 2022 (ThinkBook 14 G4+ ARA) uses Ryzen
6000 processor, and has the same microphone problem as other
ThinkPads with AMD Ryzen 6000 series CPUs, which has been
listed in https://bugzilla.kernel.org/show_bug.cgi?id=216267.

Adding 21D0 to quirks table solves this microphone problem
for ThinkBook 14 G4+ ARA.

Signed-off-by: Taroe Leohearts <leohearts@leohearts.com>
Link: https://lore.kernel.org/r/26B141B486BEF706+313d1732-e00c-ea41-3123-0d048d40ebb6@leohearts.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/amd/yc/acp6x-mach.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/sound/soc/amd/yc/acp6x-mach.c b/sound/soc/amd/yc/acp6x-mach.c
index 09a8aceff22f..6c0f1de10429 100644
--- a/sound/soc/amd/yc/acp6x-mach.c
+++ b/sound/soc/amd/yc/acp6x-mach.c
@@ -52,6 +52,13 @@ static const struct dmi_system_id yc_acp_quirk_table[] = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "21D0"),
 		}
 	},
+	{
+		.driver_data = &acp6x_card,
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "LENOVO"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "21D0"),
+		}
+	},
 	{
 		.driver_data = &acp6x_card,
 		.matches = {
-- 
2.35.1



