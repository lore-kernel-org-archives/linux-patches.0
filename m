Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11F3154704C;
	Thu, 17 Sep 2026 18:05:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789668316; cv=none; b=ZEtebGDDE1Q3QUkykmZ19t/A5C0fbLwlOikwjdixIiDsBUU8UJYfV+Q+1qDeY5zKA1cKXiRbNzceYTXTP9twm/dF4fh0UXy49V4jPs8oZ0zaZ746wsuKq9SNLE3ixau+uf+uR+8mQrlm2O2iUGR5Krl4lVwDwoB7Oqn85U5OtQ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789668316; c=relaxed/simple;
	bh=FT8MccD0XfHQd8RT6witnzObUHmu98fCNLYlseUqZpc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ckvbRgSPFNcw2SS4KvTXKqBCcf0zDKtMuzFOZxYUXcQwctcuxYJ0o/jqyvYzntrdbeW3F+EWpGhp+13puFTfZjM7g2D89TmnGSugLOuIOVxvne9tdi4n+5+M7vt4MjG7BBSCXgqITyB64qG89AocfRrxafs8LqiVT+mqcukPOVM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rgxgIMRo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rgxgIMRo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54E641F000FF;
	Thu, 17 Sep 2026 18:05:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789668314;
	bh=ZcRAEjvgQ7ZQfGDVKKmfVFned4mn5SiHyAf70eb7+kM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rgxgIMRoOw3+8Dj5rcwiZVrGCLZEMt8wm9wTK9vdj0rMbUQlWvhobqjyBJEapzNXW
	 YMcDH6vjvJSDUpe+UOMXnny6Gh8bO78Q6EX0pRs7rT+2NhSWHB/ABCkWNx2f6oEUbH
	 RN0XLniYOMXTIO4gxa0b9Uk9XLBGt8bAJbeAl7to=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jetha Chan <jethachan@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0384/1102] ASoC: amd: yc: Add Alienware m15 R7 AMD to DMIC quirk table
Date: Thu, 17 Sep 2026 16:05:27 +0100
Message-ID: <20260917151549.296724692@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 13e6e6e5137b0..4a7f421b9da29 100644
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



