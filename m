Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 145E17472;
	Tue, 23 Jan 2024 00:26:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969611; cv=none; b=sOADxZ2L1ZIzaZqatK5eRfaom9QsemAFsuLTmnCdFLBhM99BPh0JtE6ifPTzKx8putPBsKPqyvXa/aBuUEylnGZ32nGPK7jcX0AYj7zBn0K0gHeoFYnJ3OtO1ZDX2cebW3XBVwF74HLquth+MQHKXGE/JO2XZtxt15kD8VZN3WQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969611; c=relaxed/simple;
	bh=VhY+IKKpABJEa4o0QkdORIaBK6GMXEkADTUlqHEfEC4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gxNQZpl+Nr6vq+98gEcmNvsnxpqBZEmrIGcA3uRiugZY+NQUP99Jh3on/aV1X2VeBDK+Cd3K232NfC6V8DRlWsh2CtuOIDhaJ2Nq4E87/UZXgk0sL75WO3WjQe/ZzekTQP8CP+GJEQ5uSdUl7briUSVs92gnbfXc87Z8kVVQSkM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iQWJLZs3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iQWJLZs3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B79FBC433F1;
	Tue, 23 Jan 2024 00:26:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969610;
	bh=VhY+IKKpABJEa4o0QkdORIaBK6GMXEkADTUlqHEfEC4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iQWJLZs383Xd9VQUuHsqLnOlSWomOkwgdkkgQpBNs50JXhCNL4LJYk4FYDfK0wd25
	 brashLo/TyJct8sAnyd4uPQTSHeION6wgcGi1vmxU/NLqmF4x3jM5f+lIqZ38leEcE
	 EvBB5eSdPbS2sPAlPr9jcdPz4JSGw5nEwnn1/nbM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Chiu <chiu@endlessos.org>,
	Hans de Goede <hdegoede@redhat.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 357/641] ASoC: rt5645: Drop double EF20 entry from dmi_platform_data[]
Date: Mon, 22 Jan 2024 15:54:21 -0800
Message-ID: <20240122235829.102991904@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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



