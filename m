Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14C9041324B;
	Tue, 31 Mar 2026 16:33:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774974807; cv=none; b=GeRxOByjgvBrz2CDTgMqMxtSu8QUp2uvxOzKYAvpKz93oqgyYh73HYZvfp6LPUysryPD6O46Q1pwIubXfPDc2Ps3ZDuNeA7Y2EkgYkPfjzbqFeFc4oM2ta7sB9Vnqb24BzJsvGW1bJdpq/5KcAhFxZV9QZ6tOoX4k3jf6fdAJjw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774974807; c=relaxed/simple;
	bh=sA2VEVkULM0PgOKYTOHb8Kmr3A7uBvRIX8T01NAiIJE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bh9+VbJmMrqiqHtYuPTIcLPvk7gXKSKVIUz7xytnbH/1BwTSbuIO+y/HUbHCHTT9jUHnmAn/iDUgfaMUoibiyJwGeC5CZOBkpxPTjpagRic2Z5q7FypNqbzRel0UzZILS1hJ2TCJ+36OY+827lH4AXJTec8T7/EI12PAjwlCs9U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d5W8WdT9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d5W8WdT9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E654C19423;
	Tue, 31 Mar 2026 16:33:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774974807;
	bh=sA2VEVkULM0PgOKYTOHb8Kmr3A7uBvRIX8T01NAiIJE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d5W8WdT9cArIGSKa2aHV2mgmag/yJyl2posAWemoFLqdCfPmB2xSea5o4QaSZpZkG
	 xO520z6r1nwVr+EZowyESrV9X4dY6wmvMKmp2ycnfD6PAZOw4u4v6cCxqsq9usRceO
	 LYkLKeIdbbn+B3PMc017CgJDxNI+KAQAiNZ2yr1I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oliver Freyermuth <o.freyermuth@googlemail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 050/342] ASoC: Intel: sof_sdw: Add quirk for Alienware Area 51 (2025) 0CCD SKU
Date: Tue, 31 Mar 2026 18:18:03 +0200
Message-ID: <20260331161800.740362553@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161758.909578033@linuxfoundation.org>
References: <20260331161758.909578033@linuxfoundation.org>
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

From: Oliver Freyermuth <o.freyermuth@googlemail.com>

[ Upstream commit 70eddf6a0a3fc6d3ab6f77251676da97cc7f12ae ]

This adds the necessary quirk for the Alienware 18 Area 51 (2025).
Complements commit 1b03391d073d ("ASoC: Intel: sof_sdw: Add quirk
for Alienware Area 51 (2025) 0CCC SKU").

Signed-off-by: Oliver Freyermuth <o.freyermuth@googlemail.com>
Tested-by: Oliver Freyermuth <o.freyermuth@googlemail.com>
Link: https://patch.msgid.link/20260224190224.30630-1-o.freyermuth@googlemail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/boards/sof_sdw.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/sound/soc/intel/boards/sof_sdw.c b/sound/soc/intel/boards/sof_sdw.c
index 50b838be24e95..0186c281296ec 100644
--- a/sound/soc/intel/boards/sof_sdw.c
+++ b/sound/soc/intel/boards/sof_sdw.c
@@ -763,6 +763,14 @@ static const struct dmi_system_id sof_sdw_quirk_table[] = {
 		},
 		.driver_data = (void *)(SOC_SDW_CODEC_SPKR),
 	},
+	{
+		.callback = sof_sdw_quirk_cb,
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Alienware"),
+			DMI_EXACT_MATCH(DMI_PRODUCT_SKU, "0CCD")
+		},
+		.driver_data = (void *)(SOC_SDW_CODEC_SPKR),
+	},
 	/* Pantherlake devices*/
 	{
 		.callback = sof_sdw_quirk_cb,
-- 
2.51.0



