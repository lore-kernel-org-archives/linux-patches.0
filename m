Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF57B146A67;
	Tue, 25 Jun 2024 09:57:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719309467; cv=none; b=sd08jxNlmageea/BLNSUK7bss0Fq5L0K9mypJX0FCL454oKo89O6IKlhLCpFS8AMrr8do3FhWeLZwr+mrLdZTspQmImzNMFNy7CAbZa4ZUoRUG+bt3Ks8No9bOiP+LNKKbmhuyoXPloGDC7jEAt9dM5jjZLrU3v9lqeWJkyKZVA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719309467; c=relaxed/simple;
	bh=M9w1yk4FNa5oR9BoS/NaIyPKRmkRIRTZaxrQzCeoUNI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F7X9A9BWyhZAHR29Kf2TUs8L48GcqvjJH9zQ1Fv09AhtHbAlOa+hG2nqj67vJC+bzjgc1ZuJ60Pfb/yslwFNuxKyilk4XOnxjgCan/79t6R8lhzL/8qt3I8VnJq+F292Xi9krIvV7pzH0UE5v2zFO2wWUGoPrCOdjOZkiRAI0mY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I2s/LimZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I2s/LimZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3400DC32781;
	Tue, 25 Jun 2024 09:57:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719309467;
	bh=M9w1yk4FNa5oR9BoS/NaIyPKRmkRIRTZaxrQzCeoUNI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I2s/LimZzDDoaXOHtZdthXmxaZj5EkdWHriP0EaAmYzJOnbZlVHXdU3l+nEMwGwIa
	 iRKzjxriyMdbZVY2QlrAMaXJAnnmUtR5NPC2nPI4GY/XZdTtR3Ay+0InapqvGlsYoE
	 TMNTTVtFTwDj7P0/pTvb9pVbBvogHkUp8YKrBc84=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 025/131] ASoC: Intel: sof_sdw: add JD2 quirk for HP Omen 14
Date: Tue, 25 Jun 2024 11:33:00 +0200
Message-ID: <20240625085526.905707776@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085525.931079317@linuxfoundation.org>
References: <20240625085525.931079317@linuxfoundation.org>
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

From: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>

[ Upstream commit 4fee07fbf47d2a5f1065d985459e5ce7bf7969f0 ]

The default JD1 does not seem to work, use JD2 instead.

Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Link: https://lore.kernel.org/r/20240411220347.131267-4-pierre-louis.bossart@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/boards/sof_sdw.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/sound/soc/intel/boards/sof_sdw.c b/sound/soc/intel/boards/sof_sdw.c
index d1e6e4208c376..d03de37e3578c 100644
--- a/sound/soc/intel/boards/sof_sdw.c
+++ b/sound/soc/intel/boards/sof_sdw.c
@@ -413,6 +413,15 @@ static const struct dmi_system_id sof_sdw_quirk_table[] = {
 					SOF_BT_OFFLOAD_SSP(1) |
 					SOF_SSP_BT_OFFLOAD_PRESENT),
 	},
+	{
+		.callback = sof_sdw_quirk_cb,
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "HP"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "OMEN Transcend Gaming Laptop"),
+		},
+		.driver_data = (void *)(RT711_JD2),
+	},
+
 	/* LunarLake devices */
 	{
 		.callback = sof_sdw_quirk_cb,
-- 
2.43.0



