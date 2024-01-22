Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 053146A354;
	Tue, 23 Jan 2024 02:02:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705975356; cv=none; b=LCF5W8+xji76KVT7rmptBqnVmgXBzNZpF4J1R/CmnIJXsUFtRtCnWtPg76K5z7K3kaVx1X3qdgnbCG7+tOJ2DIy06YeT9YxvqYYECwu7ncG8LBSe6FhOpIauPvk920DCkgRv99b8oDazMU9vIYozPr9aMNQwgeonbo3/uzwRCGE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705975356; c=relaxed/simple;
	bh=ZPb9mf9KBkRMHOOKCLqj/hOYkxSkj5hgjoqDN2oShhI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BDiBnuxKpgbLnv+0U8J5Vk6nlo1pdSBlKy1Hi4Bq951sUBsFCX9R5bVQoY1ItXM0pp8i+SEd7O781XOgKTh6iG9DMKhaajJFdCWGRx4B0BpQaQkwAc7wVlzBQBoS+fldE5lmP0KPLd3nem9zrliBMC7vX0LCFMMtOBTSV2gcMBI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Vpo+R3Lf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Vpo+R3Lf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB537C433B1;
	Tue, 23 Jan 2024 02:02:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705975355;
	bh=ZPb9mf9KBkRMHOOKCLqj/hOYkxSkj5hgjoqDN2oShhI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Vpo+R3LfDB8FGVQAH1AjU+yJXkOcafsUZuLswqWFn7FcSBAYvJPg34zedwJQrrfbk
	 In7op9//sKQGbAC6Z/4Vs2CLcqJu+RV6YPVnOMNjpOQBVROzjw6NdFJNRxxv/kIn5J
	 Z5uZwP6FJ5RSRE5/WAYBtkAjpFuj38GZHEhKROE0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Chiu <chiu@endlessos.org>,
	Hans de Goede <hdegoede@redhat.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 318/583] ASoC: rt5645: Drop double EF20 entry from dmi_platform_data[]
Date: Mon, 22 Jan 2024 15:56:09 -0800
Message-ID: <20240122235821.770897720@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index a0d01d71d8b5..edcb85bd8ea7 100644
--- a/sound/soc/codecs/rt5645.c
+++ b/sound/soc/codecs/rt5645.c
@@ -3854,14 +3854,6 @@ static const struct dmi_system_id dmi_platform_data[] = {
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



