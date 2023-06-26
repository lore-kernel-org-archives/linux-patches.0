Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82090134B3
	for <patches@lists.linux.dev>; Mon, 26 Jun 2023 18:23:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA386C433C0;
	Mon, 26 Jun 2023 18:23:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1687803785;
	bh=8YCPQa2X4QTcHRnnV0hdZsWBdlZBqIomQ70I0X5aPZg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C7F/xR1RH6opcg4jiAbNNjcFXjR4w7a0nRJtJrUpuqrd5HPl0IesgIohPUkzz+QRs
	 pjj0d9i7nUolg2EQWpXmlZO7EcAfFPvKAX4lVmE87zHtvvkXB664+4s+MYILLgbdBH
	 SDwPtl7ltE75ymY+pMJck24PXvtzU8h9/bx27+N0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sicong Jiang <kevin.jiangsc@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 176/199] ASoC: amd: yc: Add Thinkpad Neo14 to quirks list for acp6x
Date: Mon, 26 Jun 2023 20:11:22 +0200
Message-ID: <20230626180813.458246539@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230626180805.643662628@linuxfoundation.org>
References: <20230626180805.643662628@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Sicong Jiang <kevin.jiangsc@gmail.com>

[ Upstream commit 57d1e8900495cf1751cec74db16fe1a0fe47efbb ]

Thinkpad Neo14 Ryzen Edition uses Ryzen 6800H processor, and adding to
quirks list for acp6x will enable internal mic.

Signed-off-by: Sicong Jiang <kevin.jiangsc@gmail.com>
Link: https://lore.kernel.org/r/20230531090635.89565-1-kevin.jiangsc@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/amd/yc/acp6x-mach.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/sound/soc/amd/yc/acp6x-mach.c b/sound/soc/amd/yc/acp6x-mach.c
index 84b401b685f7f..c1ca3ceac5f2f 100644
--- a/sound/soc/amd/yc/acp6x-mach.c
+++ b/sound/soc/amd/yc/acp6x-mach.c
@@ -171,6 +171,13 @@ static const struct dmi_system_id yc_acp_quirk_table[] = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "21CL"),
 		}
 	},
+	{
+		.driver_data = &acp6x_card,
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "LENOVO"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "21EF"),
+		}
+	},
 	{
 		.driver_data = &acp6x_card,
 		.matches = {
-- 
2.39.2



