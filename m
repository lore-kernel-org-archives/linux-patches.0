Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28AB8171A9
	for <patches@lists.linux.dev>; Mon, 22 May 2023 19:27:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACBECC433D2;
	Mon, 22 May 2023 19:27:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684783670;
	bh=ZEidmOY0OPv8NxLA1XAIN+hIxvWIKWhk7/byheG/Gn4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XqRdCXDC1C5hrCQ7IuGeNEmOFhc9w5YAVSjt5dtx8q/fmwcOqI35TWK9zXaNLtaXT
	 tsZNnGEnbkzy17djTdsiCXgV0vI5UFf2wRAvDEn2ZmyYVJC9+q+rm26ThPCgpobRrG
	 F/AkEPhX99aPlCi4qGn+dVIkRgxh+45HNH4F7lEs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Prajna Sariputra <putr4.s@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 123/292] ASoC: amd: yc: Add DMI entries to support HP OMEN 16-n0xxx (8A42)
Date: Mon, 22 May 2023 20:08:00 +0100
Message-Id: <20230522190409.040804294@linuxfoundation.org>
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

From: Prajna Sariputra <putr4.s@gmail.com>

[ Upstream commit ee4281de4d60288b9c802bb0906061ec355ecef2 ]

This model requires an additional detection quirk to enable the internal microphone.

Signed-off-by: Prajna Sariputra <putr4.s@gmail.com>
Link: https://lore.kernel.org/r/2283110.ElGaqSPkdT@n0067ax-linux62
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/amd/yc/acp6x-mach.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/sound/soc/amd/yc/acp6x-mach.c b/sound/soc/amd/yc/acp6x-mach.c
index 0acdf0156f075..a428e17f03259 100644
--- a/sound/soc/amd/yc/acp6x-mach.c
+++ b/sound/soc/amd/yc/acp6x-mach.c
@@ -262,6 +262,13 @@ static const struct dmi_system_id yc_acp_quirk_table[] = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "OMEN by HP Gaming Laptop 16z-n000"),
 		}
 	},
+	{
+		.driver_data = &acp6x_card,
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "HP"),
+			DMI_MATCH(DMI_BOARD_NAME, "8A42"),
+		}
+	},
 	{
 		.driver_data = &acp6x_card,
 		.matches = {
-- 
2.39.2



