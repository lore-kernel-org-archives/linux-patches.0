Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAFAE20B02
	for <patches@lists.linux.dev>; Wed,  4 Oct 2023 18:31:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T6PWbf4K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BD2CC433CC;
	Wed,  4 Oct 2023 18:31:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696444306;
	bh=KuSfT05nLnC9AddAE8rrk0fr4nVkN7ZY/mF/bfa/mAk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T6PWbf4KIf+AopJ3YZdZnk7CCz4W8okvi6zNB2ZcZP7xaYhJgSvs54BKC/mMOiRVD
	 XztMKBYYM+9DDXAbRevEDGTRhSHnfRTaLhLCf2dgRy14BungTtoQ/UAHmXaYWjaE+M
	 AFtxRYwWIycTVH8/1LHqV2MlMyNnIcXoZO8hjUhQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Walt Holman <waltholman09@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 203/321] Add DMI ID for MSI Bravo 15 B7ED
Date: Wed,  4 Oct 2023 19:55:48 +0200
Message-ID: <20231004175238.646877368@linuxfoundation.org>
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

From: Walt Holman <waltholman09@gmail.com>

[ Upstream commit e616a916fe8431ebd5eb3cf4ac224d143c57083c ]

Signed-off-by: Walt Holman <waltholman09@gmail.com>
Link: https://lore.kernel.org/r/20230910185433.13677-1-waltholman09@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/amd/yc/acp6x-mach.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/sound/soc/amd/yc/acp6x-mach.c b/sound/soc/amd/yc/acp6x-mach.c
index f7ee792bd1be9..ba3094b1e90a0 100644
--- a/sound/soc/amd/yc/acp6x-mach.c
+++ b/sound/soc/amd/yc/acp6x-mach.c
@@ -255,6 +255,13 @@ static const struct dmi_system_id yc_acp_quirk_table[] = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "M6500RC"),
 		}
 	},
+	{
+		.driver_data = &acp6x_card,
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "Micro-Star International Co., Ltd."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Bravo 15 B7ED"),
+		}
+	},
 	{
 		.driver_data = &acp6x_card,
 		.matches = {
-- 
2.40.1



