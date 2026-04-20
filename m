Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C86A2C236B;
	Mon, 20 Apr 2026 15:47:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776700045; cv=none; b=fWX+o7qQJCjBL293LGYKypKvMQhS8QOLsmkhEnHYvF5doDUwhrjBBm123YWZr7+fPtjlOiVatoZs7TT/qBntu4AulhukkN4JkPEJIs5PLFV2okk33IfrGCrGbiTYoeQiU/3u366hcCwOebjVnFUS9mg0J4TEaP8U28o+kTr6tUU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776700045; c=relaxed/simple;
	bh=DJIijbvMiF/A8nsgC5CbJFqpgr7s2ysTLG9Wv7AV/0s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=leoZosjMqZtYXhFqIjCuGhEFRMyULRdsnEZnp/QABtW75fmMUMfrhCWmiILmsz/l/vT8r/rSznJ/FA30HngAjWdBtHzKKDZaLkjAXLgRkSyPUGW0g8uECocdzusSP2RbR9sWXVgdFzHG15Bc+HdOR/PcALuJXCEisXFmnPp9rpc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SlkC6nK5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SlkC6nK5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3716C19425;
	Mon, 20 Apr 2026 15:47:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776700045;
	bh=DJIijbvMiF/A8nsgC5CbJFqpgr7s2ysTLG9Wv7AV/0s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SlkC6nK5vFMza7QIXcHAgsKsLw6gERA/GRqjynPBU9zOdaaXw+uEI9ZTP8mLGi/aZ
	 IJHMt7XgleYWW8Gn0RutQTOHA4SsE70ok1+LR/5iBfdO1V+njviaXyRjiG1UL1N2Zk
	 AzCIRMJsPMpYBqiqI2TzuM55n2CCBmkyiadj9cRw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vee Satayamas <vsatayamas@gmail.com>,
	Zhang Heng <zhangheng@kylinos.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 003/220] ASoC: amd: yc: Add DMI quirk for ASUS EXPERTBOOK BM1403CDA
Date: Mon, 20 Apr 2026 17:39:04 +0200
Message-ID: <20260420153934.143214895@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420153934.013228280@linuxfoundation.org>
References: <20260420153934.013228280@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

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
index 1324543b42d72..c536de1bb94ad 100644
--- a/sound/soc/amd/yc/acp6x-mach.c
+++ b/sound/soc/amd/yc/acp6x-mach.c
@@ -717,6 +717,13 @@ static const struct dmi_system_id yc_acp_quirk_table[] = {
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



