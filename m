Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBF1B11C83
	for <patches@lists.linux.dev>; Mon, 28 Aug 2023 10:23:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D09FC433C8;
	Mon, 28 Aug 2023 10:23:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1693218184;
	bh=SFbCvAfJvEaJNjgLiZAIewoLmudJ5u0bTQdLKOCPIXs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lPKSjZVx664TPKP3LkmMq6AzLg7G90oR7GMjcZOiSDbLltENB9IoFSRe9QwJ6KUwo
	 3plRE6Q+ZJh5hxydbh1A6EGLzerRdLC4J6NuCJ6pMsZZ2pVTPJAzOsiphq6E/ZVzP+
	 UeSRMVi4GvqoOvD0EKGgNgn4U6ZMNQQRiD291WXU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	prosenfeld@Yuhsbstudents.org,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 125/129] ASoC: amd: yc: Fix a non-functional mic on Lenovo 82SJ
Date: Mon, 28 Aug 2023 12:13:24 +0200
Message-ID: <20230828101201.593714178@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230828101157.383363777@linuxfoundation.org>
References: <20230828101157.383363777@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mario Limonciello <mario.limonciello@amd.com>

[ Upstream commit c008323fe361bd62a43d9fb29737dacd5c067fb7 ]

Lenovo 82SJ doesn't have DMIC connected like 82V2 does.  Narrow
the match down to only cover 82V2.

Reported-by: prosenfeld@Yuhsbstudents.org
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=217063
Fixes: 2232b2dd8cd4 ("ASoC: amd: yc: Add Lenovo Yoga Slim 7 Pro X to quirks table")
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com
Link: https://lore.kernel.org/r/20230824011149.1395-1-mario.limonciello@amd.com
Signed-off-by: Mark Brown <broonie@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/amd/yc/acp6x-mach.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/amd/yc/acp6x-mach.c b/sound/soc/amd/yc/acp6x-mach.c
index d80adbea05219..5310ba0734b14 100644
--- a/sound/soc/amd/yc/acp6x-mach.c
+++ b/sound/soc/amd/yc/acp6x-mach.c
@@ -217,7 +217,7 @@ static const struct dmi_system_id yc_acp_quirk_table[] = {
 		.driver_data = &acp6x_card,
 		.matches = {
 			DMI_MATCH(DMI_BOARD_VENDOR, "LENOVO"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "82"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "82V2"),
 		}
 	},
 	{
-- 
2.40.1



