Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EEFB37BE87;
	Mon,  9 Feb 2026 14:40:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770648045; cv=none; b=ZQPNI7ywnT++qv+fZyHP8vzjYPwCl64AE9ScZca04xTC+Hen+SuxWtSSQVZNHHuzoKgIIfUj2lFPcZQyUnN8BggOKjjr83+LvTi/e4/2lRKC4s85Xu7vHP7U6kQe15AmHFfASsVZpnIPN8r0rD7Fbs5NE83rWOhoncU50Zy0soU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770648045; c=relaxed/simple;
	bh=8uBnzPx6Xz3aET56qQHemLgSmQB/4T6Nk8gytr2LBRw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ra7uDby+jbJVzOZazc/AY+EZj71mDwaweBRi+nSyyyOXEDcA98+tGCelz5MjB5VOLJVcM8oZxGw9RB61SE4YAM1IgdCZx+RGDlPasHXrKrydq9wI2/9Hb7uuyT04F+BxCztprjzv9zwluEAJS+AszB9P8Q4BsQBgEFiF8eArYoI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AJonPMiE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AJonPMiE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CEC6C116C6;
	Mon,  9 Feb 2026 14:40:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770648044;
	bh=8uBnzPx6Xz3aET56qQHemLgSmQB/4T6Nk8gytr2LBRw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AJonPMiEAp/aDMBO+KEm89vXff5qgtZq1iJxF4PF57E4Ne/Ibp5+FI+8EktrKOrW8
	 KcMc2Nwtg2zhyRY017Xuf/8V2SNzbQVcBuydOFFb6FWABxn4lO2t0OGcWh7XxG8EKW
	 q1YKlFTNKk+6DRKX0c6icopyID62Z0uybNqjTqOo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Radhi Bajahaw <bajahawradhi@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 061/113] ASoC: amd: yc: Fix microphone on ASUS M6500RE
Date: Mon,  9 Feb 2026 15:23:30 +0100
Message-ID: <20260209142312.388275989@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260209142310.204833231@linuxfoundation.org>
References: <20260209142310.204833231@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Radhi Bajahaw <bajahawradhi@gmail.com>

[ Upstream commit 8e29db1b08808f709231e6fd4c79dcdee5b17a17 ]

Add DMI match for ASUSTeK COMPUTER INC. M6500RE to enable the
internal microphone.

Signed-off-by: Radhi Bajahaw <bajahawradhi@gmail.com>
Link: https://patch.msgid.link/20260112203814.155-1-bajahawradhi@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/amd/yc/acp6x-mach.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/sound/soc/amd/yc/acp6x-mach.c b/sound/soc/amd/yc/acp6x-mach.c
index 85b3310fdaaa3..346e200613031 100644
--- a/sound/soc/amd/yc/acp6x-mach.c
+++ b/sound/soc/amd/yc/acp6x-mach.c
@@ -409,6 +409,13 @@ static const struct dmi_system_id yc_acp_quirk_table[] = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "M6500RC"),
 		}
 	},
+	{
+		.driver_data = &acp6x_card,
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "ASUSTeK COMPUTER INC."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "M6500RE"),
+		}
+	},
 	{
 		.driver_data = &acp6x_card,
 		.matches = {
-- 
2.51.0



