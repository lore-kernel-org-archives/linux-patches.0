Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C8A3604D9;
	Tue, 23 Jan 2024 01:51:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705974682; cv=none; b=FrZsoynDadZTaAmvq9dElcOF+lBExK86vkZDRfHHT+Hn6Yd0Wuqcl0+NN/A0qo9AcR8/IXLWsYR6OfHhKbd0YnNGCyLtlO6LSEcnqtHlFdkmyoh071dR3AiUqq07TVtY7mnvXfFFy2GxrRytpntbNGJUKBIyfJXcgje1PhIejkA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705974682; c=relaxed/simple;
	bh=CtrMdcLzEKXbnKu4HVEKtjuU0v88+WrowJLOv0XVfYM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oNaMAEFnYj9Oq6/Ba2EwF9i/nuknsGxWcigKVDU/Pc7TKTEMsYg+u2lPk5Bpd1u7IE4pqBVZDV872CZVWXI6ijXscn4MDgkl7HeRKXKjq9HeCh+Wcnmt8T9HQf/xcXivRYmgg18mLISwAwoiUO/+q2UaV+bX/wvSnQJ13zm9rVw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kr+TGyvq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kr+TGyvq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C495C43394;
	Tue, 23 Jan 2024 01:51:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705974682;
	bh=CtrMdcLzEKXbnKu4HVEKtjuU0v88+WrowJLOv0XVfYM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kr+TGyvqJTdajMkiP9Fzdcw56mgk2S2+HDsHdiZFZiPHNVq9dY4uYmh+9TBbF7FL7
	 gJIRICLwdrOvmgQy1r9iUVX57NTD6sXCjo7LxJb7I4au5/ci1a1VwxLIfu+EM03f8R
	 2EaxC40cozdVxMUuS6dZFEd48H9kj//v3M3htn+s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Chiu <chiu@endlessos.org>,
	Hans de Goede <hdegoede@redhat.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 230/374] ASoC: rt5645: Drop double EF20 entry from dmi_platform_data[]
Date: Mon, 22 Jan 2024 15:58:06 -0800
Message-ID: <20240122235752.700626416@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235744.598274724@linuxfoundation.org>
References: <20240122235744.598274724@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index e7009f704b99..2fdfec505192 100644
--- a/sound/soc/codecs/rt5645.c
+++ b/sound/soc/codecs/rt5645.c
@@ -3828,14 +3828,6 @@ static const struct dmi_system_id dmi_platform_data[] = {
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



