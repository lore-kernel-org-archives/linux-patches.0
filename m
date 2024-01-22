Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74CA34E1AD;
	Tue, 23 Jan 2024 00:56:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705971372; cv=none; b=alcsT4qYTwScGSkbNsOxp544fYq7qi9Ke0LbXCv9F+H22RzLqceFDbXpwclrYrM3U9Aj2+ExMZJROP0NO6LvfASgy4R498x/iSYiocKQ//SFTxLNKiB2G8I6s6AGqP8LhC6pWj+P2hviJVcxAAlFIogSxzMwMTzSchlDfLT17qk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705971372; c=relaxed/simple;
	bh=NUjSgafIWC60Lc6mwGhSfEGpsLHWJtcn1OH77MjMvZ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t+U5cvgqBLYHU/kWqojeidcIIlHU0FQ9cYBt+lO9k5hK2I+so70GnQYCvdebz1yad4P+O2cgE9bqJb8j5hK8PTcz7dJi0ZSehzh2R55OKpZtLbAWDUAZRkCLfHtBGBuhU89NviEWp55wG1ZDUZepfF5ESdZkg70jPenrDyo6Amo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tv4TW2mZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tv4TW2mZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57FE6C433F1;
	Tue, 23 Jan 2024 00:56:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705971372;
	bh=NUjSgafIWC60Lc6mwGhSfEGpsLHWJtcn1OH77MjMvZ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tv4TW2mZDTywK4op5NVk+W1DLxYMWNR5ChIHILS33viR7vl1+mOhFHrHPWRqzazK/
	 7zrSQFi4mOhZkYsZTRlVVmF2dywXbHELgJGrI7lHiWpOj+NhpeeSYeGo3JYhFCIx+Y
	 b7aiCIADCuXaIFAwjaPgf+rBTHfoeuiHrBCEB2DI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Chiu <chiu@endlessos.org>,
	Hans de Goede <hdegoede@redhat.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 231/417] ASoC: rt5645: Drop double EF20 entry from dmi_platform_data[]
Date: Mon, 22 Jan 2024 15:56:39 -0800
Message-ID: <20240122235759.903457434@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235751.480367507@linuxfoundation.org>
References: <20240122235751.480367507@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit 51add1687f39292af626ac3c2046f49241713273 ]

dmi_platform_data[] first contains a DMI entry matching:

   DMI_MATCH(DMI_PRODUCT_NAME, "EF20"),

and then contains an identical entry except for the match being:

   DMI_MATCH(DMI_PRODUCT_NAME, "EF20EA"),

Since these are partial (non exact) DMI matches the first match
will also match any board with "EF20EA" in their DMI product-name,
drop the second, redundant, entry.

Fixes: a4dae468cfdd ("ASoC: rt5645: Add ACPI-defined GPIO for ECS EF20 series")
Cc: Chris Chiu <chiu@endlessos.org>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Link: https://msgid.link/r/20231126214024.300505-2-hdegoede@redhat.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/rt5645.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/sound/soc/codecs/rt5645.c b/sound/soc/codecs/rt5645.c
index 60518ee5a86e..fd3dca08460b 100644
--- a/sound/soc/codecs/rt5645.c
+++ b/sound/soc/codecs/rt5645.c
@@ -3827,14 +3827,6 @@ static const struct dmi_system_id dmi_platform_data[] = {
 		},
 		.driver_data = (void *)&ecs_ef20_platform_data,
 	},
-	{
-		.ident = "EF20EA",
-		.callback = cht_rt5645_ef20_quirk_cb,
-		.matches = {
-			DMI_MATCH(DMI_PRODUCT_NAME, "EF20EA"),
-		},
-		.driver_data = (void *)&ecs_ef20_platform_data,
-	},
 	{ }
 };
 
-- 
2.43.0



