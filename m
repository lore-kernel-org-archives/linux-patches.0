Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23B5A3BA253;
	Wed, 30 Sep 2026 18:59:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790794769; cv=none; b=i/HstckvN/413rr+96o+W2/Zs+Kq5AevYoeZ/2worArcGfipnL2IufLMWr+ew3CmcDAez+miy51qQnCU32DwLIdHka62l56Xni1rvC3CxZukhXfppEXEFdlLrAwORE5uIAkXPKi9kwznPLDjRi8HiZt540kveSJt+m3rrrFA0B0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790794769; c=relaxed/simple;
	bh=CAv5maL8xpul1nTuSg7Eq9lf6K18KM7pPbAm0VZaMNk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m1EM5JefoX3T/HRRY9HLQZu37onw20WZliIM7Pqq0G04LtFN2uAOflY5M4OHXPH2WzXJRwRW+/r2iE0zQdmFCHQd1XI+SyqkfJ2vYKqnsAjbKllBmwlx+w2jEHsn6mPNFpakMoToAQZdAB/qYFa4Ggo9ntU5PsLni3c/7E9SPSc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iRKGHDBQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iRKGHDBQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 776A31F000FF;
	Wed, 30 Sep 2026 18:59:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790794768;
	bh=r6jJct9okdfpRy14f3tiCDRYQJ+q47+HhPZxieJcjZg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iRKGHDBQfwDzqpvK621GqB9+bBPm1KjqjtHSDbibdgrAjcynrgf8nA4NmY4xUGlzE
	 P2lkuLUNP/+0uDEqOtIHtiTewMGSfAsCTdjFVAHAgtQvAziwT4qZvIZDrCeRvTTjJ7
	 0z/QV+a26gCYqmtnpGOgdEIONOMhWg3/ZiF4x6TM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jetha Chan <jethachan@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0282/1193] ASoC: amd: yc: Add Alienware m15 R7 AMD to DMIC quirk table
Date: Wed, 30 Sep 2026 17:16:06 +0200
Message-ID: <20260930152440.431363008@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jetha Chan <jethachan@gmail.com>

[ Upstream commit e782d687d2f5bf8b8113dc48ba22cca4b472c252 ]

The Alienware m15 R7 AMD exposes an ACP6x DMIC path, but its DMI
product name is not present in the Yellow Carp ACP quirk table. As a
result, the ACP machine driver does not enable the DMIC card on this
system.

Add the DMI product name for this machine. With this quirk applied, the
kernel reports:

  acp_yc_mach acp_yc_mach.0: Enabling ACP DMIC support via DMI

and ALSA exposes the ACP DMIC capture device:

  card 3: acp6x
  device 0: DMIC capture dmic-hifi-0

Tested on an Alienware m15 R7 AMD with product SKU 0B59.

Link: https://jethachan.net/dev/2026/03/21/fixing-internal-microphone-alienware-linux.html
Assisted-by: OpenAI-Codex:gpt-5.5
Signed-off-by: Jetha Chan <jethachan@gmail.com>
Link: https://patch.msgid.link/20260630003328.15675-1-jethachan@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/amd/yc/acp6x-mach.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/sound/soc/amd/yc/acp6x-mach.c b/sound/soc/amd/yc/acp6x-mach.c
index da25433986eff..8699ad79f060e 100644
--- a/sound/soc/amd/yc/acp6x-mach.c
+++ b/sound/soc/amd/yc/acp6x-mach.c
@@ -493,6 +493,13 @@ static const struct dmi_system_id yc_acp_quirk_table[] = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "Bravo 17 D7VF"),
 		}
 	},
+	{
+		.driver_data = &acp6x_card,
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "Alienware"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Alienware m15 R7 AMD"),
+		}
+	},
 	{
 		.driver_data = &acp6x_card,
 		.matches = {
-- 
2.53.0



