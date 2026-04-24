Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B65C38837E;
	Fri, 24 Apr 2026 13:33:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777037634; cv=none; b=i3oTQhdCWSgf1mgSg8bXOu97wPawez0yLnrW7ShXFuXYvrRll4GuIK6KXgRWwzv86ri3mAat65NLXczaFCsWFMdio6pqHwXtdNA5NjMK4NT36PMUOP7MExmT9VrlYoPpc1ymmYISn3WmsUZY+RYh/RE612EPfzCZEBoUClYEDFs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777037634; c=relaxed/simple;
	bh=gCIvdFhD5YzdQ4FNy2Qijg/SUiySjV2vKc+0ORQb8e4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qZu84F6diM9n8jvJO8nasipruHbMlPV2JU5WsAxDEUgrWo5Vycgb3AEar6nigMvxMdGyh/G83AhKVnBZ0hOIjTBobmc1FWrwNJLpouOfSkJoawUDSz9KZHVIQbuBUBd2fmBZMsh7fCQtOgdHktwuqnOqDbB8G8bWAl+BeAtinxY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d6AaUoP3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d6AaUoP3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C432CC19425;
	Fri, 24 Apr 2026 13:33:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777037634;
	bh=gCIvdFhD5YzdQ4FNy2Qijg/SUiySjV2vKc+0ORQb8e4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d6AaUoP3//uGWVkJ+bHpyGrK8fPd4n9oqy+6mn77mh8aRNyiKxdc8VGxh++Y3UIOy
	 XP9ackXxBymrzLjD7NasflztETRty8rAvDh2+KNqqgPZ7+xmqGjlkPlsGwk9Qhb3d5
	 81rw9HZrr9AAmVCPaz75/4nZk3rDYtlkXP44WQ9U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vee Satayamas <vsatayamas@gmail.com>,
	Zhang Heng <zhangheng@kylinos.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 002/166] ASoC: amd: yc: Add DMI quirk for ASUS EXPERTBOOK BM1403CDA
Date: Fri, 24 Apr 2026 15:28:36 +0200
Message-ID: <20260424132533.297962517@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260424132532.812258529@linuxfoundation.org>
References: <20260424132532.812258529@linuxfoundation.org>
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

From: Vee Satayamas <vsatayamas@gmail.com>

[ Upstream commit f200b2f9a810c440c6750b56fc647b73337749a1 ]

Add a DMI quirk for the Asus Expertbook BM1403CDA to resolve the issue of the
internal microphone not being detected.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=221236
Signed-off-by: Vee Satayamas <vsatayamas@gmail.com>
Reviewed-by: Zhang Heng <zhangheng@kylinos.cn>
Link: https://patch.msgid.link/20260315142511.66029-2-vsatayamas@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/amd/yc/acp6x-mach.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/sound/soc/amd/yc/acp6x-mach.c b/sound/soc/amd/yc/acp6x-mach.c
index ab75349d1063d..8a666989a8f3d 100644
--- a/sound/soc/amd/yc/acp6x-mach.c
+++ b/sound/soc/amd/yc/acp6x-mach.c
@@ -710,6 +710,13 @@ static const struct dmi_system_id yc_acp_quirk_table[] = {
 			DMI_MATCH(DMI_BOARD_NAME, "PM1503CDA"),
 		}
 	},
+	{
+		.driver_data = &acp6x_card,
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "ASUSTeK COMPUTER INC."),
+			DMI_MATCH(DMI_BOARD_NAME, "BM1403CDA"),
+		}
+	},
 	{}
 };
 
-- 
2.53.0



