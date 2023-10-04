Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 335291DA24
	for <patches@lists.linux.dev>; Wed,  4 Oct 2023 18:29:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yVdlKf3i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A96C8C433C7;
	Wed,  4 Oct 2023 18:29:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696444188;
	bh=Gr8a7nWgW2w6duQfCTT4F6P7byNmxVWIuEQPHd+nSUg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yVdlKf3iBSzaI9WX3YVMwv5xXCyOa0TvUgVvP/aVcteuh0EfyDOLLXgfThbld5wam
	 uTgZE3sdvRDAyeKRscYJ3fwqOXuP0tQOsodgCHrUSVHrNyrYA9gUvapw0rSe9dhA8X
	 21FOcxw8qANRoKpWjtij2qwXvShqU2rrOts73Dak=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shubh <shubhisroking@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 162/321] ASoC: amd: yc: Add DMI entries to support Victus by HP Gaming Laptop 15-fb0xxx (8A3E)
Date: Wed,  4 Oct 2023 19:55:07 +0200
Message-ID: <20231004175236.760373816@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231004175229.211487444@linuxfoundation.org>
References: <20231004175229.211487444@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shubh <shubhisroking@gmail.com>

[ Upstream commit d1cf5d30b43f1a331032ebf3e11d9e366ab0f885 ]

This model requires an additional detection quirk to
enable the internal microphone.

Signed-off-by: Shubh <shubhisroking@gmail.com>
Link: https://lore.kernel.org/r/20230902150807.133523-1-shubhisroking@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/amd/yc/acp6x-mach.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/sound/soc/amd/yc/acp6x-mach.c b/sound/soc/amd/yc/acp6x-mach.c
index b304b3562c82b..f7ee792bd1be9 100644
--- a/sound/soc/amd/yc/acp6x-mach.c
+++ b/sound/soc/amd/yc/acp6x-mach.c
@@ -325,6 +325,13 @@ static const struct dmi_system_id yc_acp_quirk_table[] = {
 			DMI_MATCH(DMI_BOARD_NAME, "8A22"),
 		}
 	},
+	{
+		.driver_data = &acp6x_card,
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "HP"),
+			DMI_MATCH(DMI_BOARD_NAME, "8A3E"),
+		}
+	},
 	{
 		.driver_data = &acp6x_card,
 		.matches = {
-- 
2.40.1



