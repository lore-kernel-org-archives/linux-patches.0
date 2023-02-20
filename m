Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1301463B8
	for <patches@lists.linux.dev>; Mon, 20 Feb 2023 13:58:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9095CC433EF;
	Mon, 20 Feb 2023 13:58:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1676901483;
	bh=KlVsMxAVvKvxUT+qHdljU0jf9knMEDwhqc7W5rc9BhA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N5H6KjAn4b0abAbOelvPv5/xkMR5MOTM3UNLgsGvSm4499opQQPefBB0X0M0dRRHw
	 3fsLgRFO/b79uTynD8rjsaVgUlWFLJxt4GVHXA9zlnp+hzlDoAC2wzNjBesLCnUGHO
	 VrgEq2Jp/M+d9IVC3gn6iJzrcSpISSszeOgPeA9I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	shanshengwang <shansheng.wang@amd.com>,
	Syed Saba Kareem <Syed.SabaKareem@amd.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 007/118] ASoC: amd: yc: Add DMI support for new acer/emdoor platforms
Date: Mon, 20 Feb 2023 14:35:23 +0100
Message-Id: <20230220133600.696835164@linuxfoundation.org>
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

From: Syed Saba Kareem <Syed.SabaKareem@amd.com>

[ Upstream commit 7fd26a27680aa9032920f798a5a8b38a2c61075f ]

Adding DMI entries to support new acer/emdoor platforms.

Suggested-by: shanshengwang <shansheng.wang@amd.com>
Signed-off-by: Syed Saba Kareem <Syed.SabaKareem@amd.com>
Link: https://lore.kernel.org/r/20230111102130.2276391-1-Syed.SabaKareem@amd.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/amd/yc/acp6x-mach.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/sound/soc/amd/yc/acp6x-mach.c b/sound/soc/amd/yc/acp6x-mach.c
index 0d283e41f66dc..00fb976e0b81e 100644
--- a/sound/soc/amd/yc/acp6x-mach.c
+++ b/sound/soc/amd/yc/acp6x-mach.c
@@ -234,6 +234,20 @@ static const struct dmi_system_id yc_acp_quirk_table[] = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "Blade 14 (2022) - RZ09-0427"),
 		}
 	},
+	{
+		.driver_data = &acp6x_card,
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "RB"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Swift SFA16-41"),
+		}
+	},
+	{
+		.driver_data = &acp6x_card,
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "IRBIS"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "15NBC1011"),
+		}
+	},
 	{}
 };
 
-- 
2.39.0



