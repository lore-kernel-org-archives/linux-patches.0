Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9973B1448EF;
	Thu, 11 Apr 2024 10:12:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712830357; cv=none; b=sGUCV8g95Qt/eeF1XXO4bYbBBLWOyhNU+ScgSH5s0dzUKvtZWKVIzVbuQJ9gvygPCV5Iv+44cpc/XKkNMbXW2iOgDLShuocOdQQrAGsy8+ADEspjwxUQ9LS79gNr/8R1It+hb0DSgNOR65wYCUnG+9w29PL4DQv7z+woHIfQhAM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712830357; c=relaxed/simple;
	bh=B350X+Vr+rkEP1k4wSmkDF9YQu3ieBqPuLvHVM4h4+k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Yz2ceAPGjfpJz7eI2UVHFpA9m7m5FjRyEkA3ot0Az1/bMIzWQtHubk0PELgvtLEyWZ0xkYtLE4YoQAQlrMRjRwEMKlSrfZkIrtMEZrDZnw+g7pFvQlx3dOT304XZhXhkjneJIRUWEyoEErVq/erEz/a9OJ7tUsZJYfg0RBYCwMQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V0QSKje4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V0QSKje4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 242CAC433C7;
	Thu, 11 Apr 2024 10:12:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712830357;
	bh=B350X+Vr+rkEP1k4wSmkDF9YQu3ieBqPuLvHVM4h4+k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V0QSKje4EvpMrT6QdzilBImoyki9mFw1UT1HZ7C8D222qxWK0R6UuBKZB71T+GVpy
	 BLGvgk/zhnNLr2yiM7fulsgX3oJRiZrO+kmY35T92qaWFbzU0AtvgBdyRAxQ5a0iYh
	 efkuHvWpum9KSAs8PuZgTYUOqVHUATNNYm3y9zD4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mitch Cooley <m.cooley.198@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 120/143] ASoC: amd: yc: Fix non-functional mic on ASUS M7600RE
Date: Thu, 11 Apr 2024 11:56:28 +0200
Message-ID: <20240411095424.518771122@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095420.903937140@linuxfoundation.org>
References: <20240411095420.903937140@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: M Cooley <m.cooley.198@gmail.com>

[ Upstream commit db185362fca554b201e2c62beb15a02bb39a064b ]

The ASUS M7600RE (Vivobook Pro 16X OLED) needs a quirks-table entry for the
internal microphone to function properly.

Signed-off-by: Mitch Cooley <m.cooley.198@gmail.com>

Link: https://msgid.link/r/CALijGznExWW4fujNWwMzmn_K=wo96sGzV_2VkT7NjvEUdkg7Gw@mail.gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/amd/yc/acp6x-mach.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/sound/soc/amd/yc/acp6x-mach.c b/sound/soc/amd/yc/acp6x-mach.c
index 1d1452c29ed02..69c68d8e7a6b5 100644
--- a/sound/soc/amd/yc/acp6x-mach.c
+++ b/sound/soc/amd/yc/acp6x-mach.c
@@ -311,6 +311,13 @@ static const struct dmi_system_id yc_acp_quirk_table[] = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "E1504FA"),
 		}
 	},
+	{
+		.driver_data = &acp6x_card,
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "ASUSTeK COMPUTER INC."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "M7600RE"),
+		}
+	},
 	{
 		.driver_data = &acp6x_card,
 		.matches = {
-- 
2.43.0



