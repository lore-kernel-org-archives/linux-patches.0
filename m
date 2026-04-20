Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2DC93A9632;
	Mon, 20 Apr 2026 13:16:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776690992; cv=none; b=esld1STfSPLTUFFsgcJIgePiYstO/WhlvUw1Ewn1kByMtepSZMVeYQeHuXUgjnPpJn31s5lbWZcD2iRgyAeBcHpk3W5Vkyq7HgtKkaPunBjgtmhcpyzkdGE3RaSuQojf9mYfgABsTW9Br0slETuivVV1JFiJ5U4LdqRMmB8xA18=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776690992; c=relaxed/simple;
	bh=G3vgPIuJyGHx+pbP3p2kYDmPMMfVxfTRLcgSZFSeSI8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Zdm2nC4XtsEyX4uwPntNs3sSkG2vkhc2I+UZl+gBkGb2DvNXH0AJk+sNpdP6mwWsrR/8yyEeRdO6ya09rn9DLsrdYv3mAuglSa/gEfrW5Tn/35lOKeFMcffBIaf1+6Y5NljjMybFN8obw7PhqGd+vkCGz8fGiLSy/CENpTiV9Qw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qXW0tIyd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qXW0tIyd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C0EEC2BCC4;
	Mon, 20 Apr 2026 13:16:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776690992;
	bh=G3vgPIuJyGHx+pbP3p2kYDmPMMfVxfTRLcgSZFSeSI8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qXW0tIydUgfh1ruzH5eVppKeYoI++XCokx+j8azGHd3ZFeVMz6upiivvNyFlicus/
	 IikFbQdSuFAqWrlb8NkMw3CHQxYlZEmeke1mEKcB4WNhe970nwOUJfLK24YkoFA4j1
	 Mjw8Jldvs1Arm2UxW8WOeLo3cya3ax2QVEtqn0tdb739ut/IPGKB6f32AjYOgu3Xi3
	 FesnJ71JKXv2LFwlHspiBqmBZv/K5zojHZJBtVBjnImBCZmHvi7avRnA7VkF+JB6Cs
	 ud6JUnmmI0oH90oRRRuA+vFkbgeNlNAD/oyvgPd6uwEwe1zLgBn+T6GI3AJnbuh6hc
	 v6ecs43FI9Geg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Cezary Rojewski <cezary.rojewski@intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	pierre-louis.bossart@linux.intel.com,
	liam.r.girdwood@linux.intel.com,
	peter.ujfalusi@linux.intel.com,
	yung-chuan.liao@linux.intel.com,
	ranjani.sridharan@linux.intel.com,
	kai.vehmanen@linux.intel.com,
	perex@perex.cz,
	tiwai@suse.com,
	amadeuszx.slawinski@linux.intel.com,
	alsa-devel@alsa-project.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] ASoC: Intel: avs: Fix memory leak in avs_register_i2s_test_boards()
Date: Mon, 20 Apr 2026 09:08:17 -0400
Message-ID: <20260420131539.986432-31-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420131539.986432-1-sashal@kernel.org>
References: <20260420131539.986432-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.23
Content-Transfer-Encoding: 8bit

From: Cezary Rojewski <cezary.rojewski@intel.com>

[ Upstream commit c5408d818316061d6063c11a4f47f1ba25a3a708 ]

Caller is responsible for freeing array allocated with
parse_int_array().

Found out by Coverity.

Fixes: 7d859189de13 ("ASoC: Intel: avs: Allow to specify custom configurations with i2s_test")
Signed-off-by: Cezary Rojewski <cezary.rojewski@intel.com>
Link: https://patch.msgid.link/20260407085459.400628-1-cezary.rojewski@intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Error: Failed to generate final synthesis

 sound/soc/intel/avs/board_selection.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/sound/soc/intel/avs/board_selection.c b/sound/soc/intel/avs/board_selection.c
index 52e6266a7cb86..96dc637ccb20c 100644
--- a/sound/soc/intel/avs/board_selection.c
+++ b/sound/soc/intel/avs/board_selection.c
@@ -520,7 +520,8 @@ static int avs_register_i2s_test_boards(struct avs_dev *adev)
 	if (num_elems > max_ssps) {
 		dev_err(adev->dev, "board supports only %d SSP, %d specified\n",
 			max_ssps, num_elems);
-		return -EINVAL;
+		ret = -EINVAL;
+		goto exit;
 	}
 
 	for (ssp_port = 0; ssp_port < num_elems; ssp_port++) {
@@ -528,11 +529,13 @@ static int avs_register_i2s_test_boards(struct avs_dev *adev)
 		for_each_set_bit(tdm_slot, &tdm_slots, 16) {
 			ret = avs_register_i2s_test_board(adev, ssp_port, tdm_slot);
 			if (ret)
-				return ret;
+				goto exit;
 		}
 	}
 
-	return 0;
+exit:
+	kfree(array);
+	return ret;
 }
 
 static int avs_register_i2s_board(struct avs_dev *adev, struct snd_soc_acpi_mach *mach)
-- 
2.53.0

