Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4691D7C
	for <patches@lists.linux.dev>; Mon, 24 Apr 2023 13:27:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE439C4339B;
	Mon, 24 Apr 2023 13:27:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1682342859;
	bh=YimFVwDeaW+TGuGRJmmcI1SbAKhZF5qTQM8vXf4U8XY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rnzDYhf3LVRvuivigppt+AtbnGBVpGQEiLCRQ0aImwqtXdm2+376N6PM6Kb+eskxs
	 oxYSpPbiBcbp+O4gmtcZT7dXF/hw+bCaavsumshEXCS9oXDxYM41qbpwmAROeBabZY
	 sHKanSrFuGeUR4hdGDzgjBXWH3ow3NsdRug5kuNQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Brandon Nielsen <nielsenb@jetfuse.net>,
	Hans de Goede <hdegoede@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 46/98] platform/x86: gigabyte-wmi: add support for X570S AORUS ELITE
Date: Mon, 24 Apr 2023 15:17:09 +0200
Message-Id: <20230424131135.656203901@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230424131133.829259077@linuxfoundation.org>
References: <20230424131133.829259077@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit 52f91e51944808d83dfe2d5582601b5e84e472cc ]

Add "X570S AORUS ELITE" to known working boards

Reported-by: Brandon Nielsen <nielsenb@jetfuse.net>
Link: https://lore.kernel.org/r/20230331014902.7864-1-nielsenb@jetfuse.net
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/gigabyte-wmi.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/platform/x86/gigabyte-wmi.c b/drivers/platform/x86/gigabyte-wmi.c
index 5e5b17c50eb67..2a426040f749e 100644
--- a/drivers/platform/x86/gigabyte-wmi.c
+++ b/drivers/platform/x86/gigabyte-wmi.c
@@ -161,6 +161,7 @@ static const struct dmi_system_id gigabyte_wmi_known_working_platforms[] = {
 	DMI_EXACT_MATCH_GIGABYTE_BOARD_NAME("X570 GAMING X"),
 	DMI_EXACT_MATCH_GIGABYTE_BOARD_NAME("X570 I AORUS PRO WIFI"),
 	DMI_EXACT_MATCH_GIGABYTE_BOARD_NAME("X570 UD"),
+	DMI_EXACT_MATCH_GIGABYTE_BOARD_NAME("X570S AORUS ELITE"),
 	DMI_EXACT_MATCH_GIGABYTE_BOARD_NAME("Z690M AORUS ELITE AX DDR4"),
 	{ }
 };
-- 
2.39.2



