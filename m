Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15A141C08
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 16:46:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4585DC433EF;
	Wed, 28 Dec 2022 16:46:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672245970;
	bh=Z1+QdG5qxU2B1H5u1JGOnxupPA9gwVz/YGQf95Ij7Rs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LHvjkq5ftoHdjG4EJbiXyc2SFQ9C5X0R2dqpA5V4IuhT1bvDMyGVK9I5pP0JgyFOF
	 LDBS7VfLZQDJVRjdUpR9F5P2OL4Qq+lHqymC6BoZG8JVHH3DV1z3ARQeBM4RlR96q3
	 PRRlWpIh5QA30a7mNRyq0GWN1zONu5dl+af9Kcb0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Artem Lukyanov <dukzcry@ya.ru>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0962/1073] ASoC: amd: yc: Add Xiaomi Redmi Book Pro 14 2022 into DMI table
Date: Wed, 28 Dec 2022 15:42:30 +0100
Message-Id: <20221228144354.170800371@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Artem Lukyanov <dukzcry@ya.ru>

[ Upstream commit c1dd6bf6199752890d8c59d895dd45094da51d1f ]

This model requires an additional detection quirk to enable the
internal microphone - BIOS doesn't seem to support AcpDmicConnected
(nothing in acpidump output).

Signed-off-by: Artem Lukyanov <dukzcry@ya.ru>
Link: https://lore.kernel.org/r/20221130085247.85126-1-dukzcry@ya.ru
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/amd/yc/acp6x-mach.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/sound/soc/amd/yc/acp6x-mach.c b/sound/soc/amd/yc/acp6x-mach.c
index d9715bea965e..1f0b5527c594 100644
--- a/sound/soc/amd/yc/acp6x-mach.c
+++ b/sound/soc/amd/yc/acp6x-mach.c
@@ -213,6 +213,13 @@ static const struct dmi_system_id yc_acp_quirk_table[] = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "Alienware m17 R5 AMD"),
 		}
 	},
+	{
+		.driver_data = &acp6x_card,
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "TIMI"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Redmi Book Pro 14 2022"),
+		}
+	},
 	{}
 };
 
-- 
2.35.1



