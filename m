Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8445168DC
	for <patches@lists.linux.dev>; Mon, 22 May 2023 19:28:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C9A9C433EF;
	Mon, 22 May 2023 19:28:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684783687;
	bh=GDJqL3ApqS/ZnDifmDg2sYO6N0TYZCUCDJ0ATatYnFg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Op303no6XfEvRmvR435ysqy5VLaBK4GM26F3DX3/xwGnredmlcujhQOMauigeH5J7
	 p3XlsHui3mGjj1zhe5EanJqKN/623nEGqWagsc3bt+LZiIlzy7SKxC4TaJGLbu00Kx
	 ViWU4/A8XdydoHm5zfUnmE1TYaxkVu3Y2AA6t4fM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cem Kaya <cemkaya.boun@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 129/292] ASoC: amd: Add Dell G15 5525 to quirks list
Date: Mon, 22 May 2023 20:08:06 +0100
Message-Id: <20230522190409.193842021@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230522190405.880733338@linuxfoundation.org>
References: <20230522190405.880733338@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Cem Kaya <cemkaya.boun@gmail.com>

[ Upstream commit faf15233e59052f4d61cad2da6e56daf33124d96 ]

Add Dell G15 5525 Ryzen Edition to quirks list for acp6x so that
internal mic works.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=217155
Signed-off-by: Cem Kaya <cemkaya.boun@gmail.com>
Link: https://lore.kernel.org/r/20230410183814.260518-1-cemkaya.boun@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/amd/yc/acp6x-mach.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/sound/soc/amd/yc/acp6x-mach.c b/sound/soc/amd/yc/acp6x-mach.c
index a428e17f03259..1d59163a882ca 100644
--- a/sound/soc/amd/yc/acp6x-mach.c
+++ b/sound/soc/amd/yc/acp6x-mach.c
@@ -45,6 +45,13 @@ static struct snd_soc_card acp6x_card = {
 };
 
 static const struct dmi_system_id yc_acp_quirk_table[] = {
+	{
+		.driver_data = &acp6x_card,
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "Dell Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Dell G15 5525"),
+		}
+	},
 	{
 		.driver_data = &acp6x_card,
 		.matches = {
-- 
2.39.2



