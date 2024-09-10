Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E579817C220;
	Tue, 10 Sep 2024 10:38:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725964724; cv=none; b=BLbSfXNJDQtaiBdrOc21LZ7fNlxReVFjfll7ALHs+bDYrJKxwzMiQDQwQMKLZVSnpBoLRORNsQP8AHxtu2KjoO3ONEIE55K2A4iCdqvHTQG3nQ3+dR52ork/Rlc6bghYT0BreSkCzqbp9ublNSU00mjjSp9twLpwo94vjJE+NF8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725964724; c=relaxed/simple;
	bh=0coZBcE/4g7HhRNS4dr/Lh3HWkdqEW2s42f8OGqkiX8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fPfX3tvOua/mZLFM2q7y0ZESes0y8BSELlmJEh0rDr146KORG6MmGRANud1oFzH6sdxYH9/brKBkdT4rIm7OxrgrAx8qzWXosj6lc8k6Ai4mfMMmx8F8j3eUiwGluv5Oy3EoxOfu3i4nRiDUslFhUVJxDUWbbHiQd3+SO1QPE9E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mg4+Tyyw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mg4+Tyyw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E01EC4CEC3;
	Tue, 10 Sep 2024 10:38:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725964723;
	bh=0coZBcE/4g7HhRNS4dr/Lh3HWkdqEW2s42f8OGqkiX8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mg4+Tyyw+uvQdM07dqufdOJCTDmqiO7A51hvaMhUC6gnDPuJy5WG0PAQ48dmWx0YR
	 9NnFfQkYheY4KJVsOZnmqafFNtd01UUzOeel0/99AuxPs+2laZ8kDAriIcrKGV5XaA
	 9U0Ejpv997eLgRWP0PkKnkJx8j8bnkt5PyG1kHQE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jesse Zhang <Jesse.Zhang@amd.com>,
	Tim Huang <Tim.Huang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 010/186] drm/amd/pm: fix warning using uninitialized value of max_vid_step
Date: Tue, 10 Sep 2024 11:31:45 +0200
Message-ID: <20240910092555.082127237@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092554.645718780@linuxfoundation.org>
References: <20240910092554.645718780@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jesse Zhang <jesse.zhang@amd.com>

[ Upstream commit 17e3bea65cdc453695b2fe4ff26d25d17f5339e9 ]

Check the return of pp_atomfwctrl_get_Voltage_table_v4
as it may fail to initialize max_vid_step
V2: change the check condition (Tim Huang)

Signed-off-by: Jesse Zhang <Jesse.Zhang@amd.com>
Reviewed-by: Tim Huang <Tim.Huang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega10_hwmgr.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega10_hwmgr.c b/drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega10_hwmgr.c
index 10678b519995..e4a8f1aabd78 100644
--- a/drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega10_hwmgr.c
+++ b/drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega10_hwmgr.c
@@ -2572,8 +2572,11 @@ static int vega10_init_smc_table(struct pp_hwmgr *hwmgr)
 		}
 	}
 
-	pp_atomfwctrl_get_voltage_table_v4(hwmgr, VOLTAGE_TYPE_VDDC,
+	result = pp_atomfwctrl_get_voltage_table_v4(hwmgr, VOLTAGE_TYPE_VDDC,
 			VOLTAGE_OBJ_SVID2,  &voltage_table);
+	PP_ASSERT_WITH_CODE(!result,
+			"Failed to get voltage table!",
+			return result);
 	pp_table->MaxVidStep = voltage_table.max_vid_step;
 
 	pp_table->GfxDpmVoltageMode =
-- 
2.43.0



