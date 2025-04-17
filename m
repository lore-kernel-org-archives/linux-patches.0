Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A7131A5BBB;
	Thu, 17 Apr 2025 18:41:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744915291; cv=none; b=ndLQk1P6dMs7Pbn7DEIyuZV1Cdlxe2viCRiEWRAI7k1L4cz/YB65WI1yp7AkLjCwHvSgqR/Vsb90fqyEtOID3b7OeEQEQEk4lzKpXt03dfcyfH5ZV2x4c5OfEm1gPvrXs922db6/SiSprFQtOlDO/waihD/EcrDFOSFqBy/sLoI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744915291; c=relaxed/simple;
	bh=afvn3Whe0Bny62VMHGQhdvnDl/5lRD35L0OnDJ/llQQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HlONRPJF1gVidSrT9AUpcUv27hv6z6B6dbE5ES3SPLFZRigHKU4GOaRq1VAzx2LGOLGvWHsTJdHHl0TqLoPIOxlS0kis4XQpnF1J2XjocYUH+0gIKJYWL622EAVedJ6VjHvBucvyekrcH8kJpZnWrHYLM/WjA9c5B8dWTlKuPDg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eMlYQcrX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eMlYQcrX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E67AC4CEE4;
	Thu, 17 Apr 2025 18:41:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744915290;
	bh=afvn3Whe0Bny62VMHGQhdvnDl/5lRD35L0OnDJ/llQQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eMlYQcrXi73zegxFTgmBKWk4dcZU9BwKJdxsfPu8J81GJVuiUiv950ucIZS+mpc+C
	 XruXBRf8UtJvmGOtfDD1ONv3xhDT9/tki/47QZ3dj14XIN2QKua6LMS0S8JRg7fNuw
	 ew01JkQK36FEg0uYDxKm9SLm5XiT2cwrbKC8raNg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Syed Saba kareem <syed.sabakareem@amd.com>,
	Reiner <Reiner.Proels@gmail.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 080/393] ASoC: amd: yc: update quirk data for new Lenovo model
Date: Thu, 17 Apr 2025 19:48:09 +0200
Message-ID: <20250417175110.819373733@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175107.546547190@linuxfoundation.org>
References: <20250417175107.546547190@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Syed Saba kareem <syed.sabakareem@amd.com>

[ Upstream commit 5a4dd520ef8a94ecf81ac77b90d6a03e91c100a9 ]

Update Quirk data for new Lenovo model 83J2 for YC platform.

Signed-off-by: Syed Saba kareem <syed.sabakareem@amd.com>
Link: https://patch.msgid.link/20250321122507.190193-1-syed.sabakareem@amd.com
Reported-by: Reiner <Reiner.Proels@gmail.com>
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=219887
Tested-by: Reiner <Reiner.Proels@gmail.com>
Reviewed-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/amd/yc/acp6x-mach.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/sound/soc/amd/yc/acp6x-mach.c b/sound/soc/amd/yc/acp6x-mach.c
index bd3808f98ec9e..e632f16c91025 100644
--- a/sound/soc/amd/yc/acp6x-mach.c
+++ b/sound/soc/amd/yc/acp6x-mach.c
@@ -339,6 +339,13 @@ static const struct dmi_system_id yc_acp_quirk_table[] = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "83Q3"),
 		}
 	},
+	{
+		.driver_data = &acp6x_card,
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "LENOVO"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "83J2"),
+		}
+	},
 	{
 		.driver_data = &acp6x_card,
 		.matches = {
-- 
2.39.5



