Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AF3279C0
	for <patches@lists.linux.dev>; Wed, 30 Nov 2022 18:52:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0901C433C1;
	Wed, 30 Nov 2022 18:52:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669834362;
	bh=wwNQnLOKV3Su2JrpkBV2pkUxadD8MRYDCSxAHiGhqx4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YlXiIgMxHik97faPPEY8exuGyTIaflWtyEl0/27SiQJQeE0MPIWTev76qDic01l4+
	 VWeHwD8SI2gAKpWBw4vJ0hlJtLE9sjb0MpdAsPCHiNtSxzFBNBSF1iJ0L0+N0ofuZA
	 J+xyqKBQNut+m96IPyr6ulNebGywg/r5TiCDppQg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Brent Mendelsohn <mendiebm@gmail.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 225/289] ASoC: amd: yc: Add Alienware m17 R5 AMD into DMI table
Date: Wed, 30 Nov 2022 19:23:30 +0100
Message-Id: <20221130180549.216179012@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180544.105550592@linuxfoundation.org>
References: <20221130180544.105550592@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Brent Mendelsohn <mendiebm@gmail.com>

[ Upstream commit d40b6529c6269cd5afddb1116a383cab9f126694 ]

This model requires an additional detection quirk to enable the
internal microphone - BIOS doesn't seem to support AcpDmicConnected
(nothing in acpidump output).

Link: https://bugzilla.kernel.org/show_bug.cgi?id=216590
Signed-off-by: Brent Mendelsohn <mendiebm@gmail.com>
Reviewed-by: Mario Limonciello <mario.limonciello@amd.com>
Link: https://lore.kernel.org/r/20221024174227.4160-1-mendiebm@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/amd/yc/acp6x-mach.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/sound/soc/amd/yc/acp6x-mach.c b/sound/soc/amd/yc/acp6x-mach.c
index 6c0f1de10429..d9715bea965e 100644
--- a/sound/soc/amd/yc/acp6x-mach.c
+++ b/sound/soc/amd/yc/acp6x-mach.c
@@ -206,6 +206,13 @@ static const struct dmi_system_id yc_acp_quirk_table[] = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "UM5302TA"),
 		}
 	},
+	{
+		.driver_data = &acp6x_card,
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "Alienware"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Alienware m17 R5 AMD"),
+		}
+	},
 	{}
 };
 
-- 
2.35.1



