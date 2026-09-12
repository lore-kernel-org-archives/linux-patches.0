Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 539A4369D56;
	Sat, 12 Sep 2026 09:27:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789205239; cv=none; b=ZoaPoOG6gLUkbOIyKK4zPtmURWdazERwozUvcy+bubEvJ03ppcnxXKcEURHqF7xb1as11br2OWecbOMd6g3qtC5WM+jSNttwEib0EMMkfyDlk7aY/BbLQmbNgB5+aplckRJiIC9Dw/6GlS5gahfenVw6khV2wWcK7FEk2K6YiJo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789205239; c=relaxed/simple;
	bh=XTJ70YP/957rhaDvide3x5MgpiBXLlnr/3wxeCmnU+o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gVMLBVrriz7HLNCz0Wd4aak8vj1ynSFfjAYpL8DkPhlTMdxmKUdWjSP0plPQw+RN+OdTOrOinMX96h4Pd4aNpowuqwbre/090AY9tXzy3iOP8R/hPJCGYmm/tnBa9CIhu0nsBtYEW1Pd78EfM8L3o3bLcf2NJuNxqAAO16MESNU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QPrUU6D7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QPrUU6D7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA19D1F000FF;
	Sat, 12 Sep 2026 09:27:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789205238;
	bh=hhmX/zzmgl1QiqbsJ7FILH/8Lrio3aKBmkWO1Av12f4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QPrUU6D7MV3QdkqWMODiMKTbIoZZ6snvLUpt3FZUCjq/J6fAUprlbVHkQsB3M3mzQ
	 GVGVLCo9k+fkNIrCq1kbMF7jBSc+E+4AJrIe+MGvmNEfx7li2t0o1/vn/0B0es4+YU
	 Pr04ZWaCmX2vFctcVcoTVnXjePveNGlL54d9ok/Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shengyu Qu <wiagn@4d2.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1776/1815] ASoC: amd: acp-config: change quirks to cover all ASUS FA401EA variants
Date: Sat, 12 Sep 2026 08:58:46 +0200
Message-ID: <20260912065730.705458447@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shengyu Qu <wiagn@4d2.org>

[ Upstream commit 15596a87fcc6fa07a162858e5fd00ba31752096b ]

Existing quirk doesn't cover all known existing FA401EA devices, so use
"FA401EA" to cover all of them.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=221310#c49
Fixes: 27d090f3ccd4 ("ASoC: amd: acp: add ACP70 DMI override for new ASUS TUF platforms")
Signed-off-by: Shengyu Qu <wiagn@4d2.org>
Link: https://patch.msgid.link/20260826172050.15686-1-wiagn@4d2.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/amd/acp-config.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/amd/acp-config.c b/sound/soc/amd/acp-config.c
index 88e4230d66c3d..8e1563824a97b 100644
--- a/sound/soc/amd/acp-config.c
+++ b/sound/soc/amd/acp-config.c
@@ -54,7 +54,7 @@ static const struct dmi_system_id acp70_acpi_flag_override_table[] = {
 	{
 		.matches = {
 			DMI_MATCH(DMI_BOARD_VENDOR, "ASUSTeK COMPUTER INC"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "TUF Gaming A14 FA401EA"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "FA401EA"),
 		},
 	},
 	{
-- 
2.53.0



