Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 400DA34CD3
	for <patches@lists.linux.dev>; Wed,  7 Jun 2023 20:40:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D09EC433EF;
	Wed,  7 Jun 2023 20:40:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686170438;
	bh=AYDdix689I2vU8jOnY205uFQHxEJIW8WzC6bopMeBTM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IOTYoj3V6OtbrvyWb9C90W9XudxJ5ga+5Qk49H+CcjNLWhgQTePl7dqy1kkHbUsV2
	 JYO4wFpRWiWvTNEA7kkfRWgY6GHqWX9IXMeq0Q1bsUZw9mCF+fzHW4iDWABJR4j4Zu
	 gRBq3BL53byZZc0WwpH3MB4n7v7EV70hUPdVK+QM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 083/225] ASoC: amd: yc: Add DMI entry to support System76 Pangolin 12
Date: Wed,  7 Jun 2023 22:14:36 +0200
Message-ID: <20230607200917.090135828@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230607200913.334991024@linuxfoundation.org>
References: <20230607200913.334991024@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jeremy Soller <jeremy@system76.com>

[ Upstream commit 7b9891ad25246b18b5ccc19518da7abc7763aa0a ]

Add pang12 quirk to enable the internal microphone.

Signed-off-by: Jeremy Soller <jeremy@system76.com
Signed-off-by: Tim Crawford <tcrawford@system76.com
Link: https://lore.kernel.org/r/20230505161458.19676-1-tcrawford@system76.com
Signed-off-by: Mark Brown <broonie@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/amd/yc/acp6x-mach.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/sound/soc/amd/yc/acp6x-mach.c b/sound/soc/amd/yc/acp6x-mach.c
index b9958e5553674..84b401b685f7f 100644
--- a/sound/soc/amd/yc/acp6x-mach.c
+++ b/sound/soc/amd/yc/acp6x-mach.c
@@ -297,6 +297,13 @@ static const struct dmi_system_id yc_acp_quirk_table[] = {
 			DMI_MATCH(DMI_BOARD_NAME, "8A22"),
 		}
 	},
+	{
+		.driver_data = &acp6x_card,
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "System76"),
+			DMI_MATCH(DMI_PRODUCT_VERSION, "pang12"),
+		}
+	},
 	{}
 };
 
-- 
2.39.2



