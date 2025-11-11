Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38F411D6DB5;
	Tue, 11 Nov 2025 00:54:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762822468; cv=none; b=RFpObU0rDXMBeAt04jr0cN/00hfNb7H6wK4Zeqyy33Qz+Yvrntf+7nTysUMBA8eL8r/Rakeqs7PzgLCJhxbHNYjmLX4GRtGJRL/0UtptV11/dkspbG1HNXtWZbM9jGagFmT0kQDg0q82V+8Mdt7e8jlbwcyHUZ6k9YAHFB9keHc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762822468; c=relaxed/simple;
	bh=96UUxEHosG32pE5b/+gAwanwuZumthYfHq02XqtC2XQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K4KDRCwRiHtKWtjxNoyIDzo9S4+toyvhvHIivkCOYiwjvQNCE0mhgNlvxE30s6X7USMI7iqdD8gLi3GUv0h3el/jyHSuZgo5M31pqg1zlWsyW07l5Mdwj9wZxdHLbHKKyLDHdujbL7eLYB3vzkAZE4f0JEOkbl3NeaW2GktSwIc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jV3bjYNP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jV3bjYNP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88A4EC4CEF5;
	Tue, 11 Nov 2025 00:54:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762822467;
	bh=96UUxEHosG32pE5b/+gAwanwuZumthYfHq02XqtC2XQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jV3bjYNPWNltxA0eAjGcxJKcFwbSgW0lc/qDSlYyckA+i3cDtnAXRnZXMhE5mAvK3
	 osjGSRqx6KMy6a7LEHiZRIySR7NIXlmSeuxt6MIkcDKUrinI3UGvhuXiSzJ6beEFby
	 wkTqf7Ra2x9o0bjaDJ5sNrOVAu7o1lLiVBjJM5AM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Wang <kevinyang.wang@amd.com>,
	Hawking Zhang <Hawking.Zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 056/565] drm/amd/pm: fix smu table id bound check issue in smu_cmn_update_table()
Date: Tue, 11 Nov 2025 09:38:32 +0900
Message-ID: <20251111004528.181163718@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yang Wang <kevinyang.wang@amd.com>

[ Upstream commit 238d468d3ed18a324bb9d8c99f18c665dbac0511 ]

'table_index' is a variable defined by the smu driver (kmd)
'table_id' is a variable defined by the hw smu (pmfw)

This code should use table_index as a bounds check.

Fixes: caad2613dc4bd ("drm/amd/powerplay: move table setting common code to smu_cmn.c")
Signed-off-by: Yang Wang <kevinyang.wang@amd.com>
Reviewed-by: Hawking Zhang <Hawking.Zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit fca0c66b22303de0d1d6313059baf4dc960a4753)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/pm/swsmu/smu_cmn.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/pm/swsmu/smu_cmn.c b/drivers/gpu/drm/amd/pm/swsmu/smu_cmn.c
index 0ce1766c859f5..d2f11d82312f0 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/smu_cmn.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu_cmn.c
@@ -955,7 +955,7 @@ int smu_cmn_update_table(struct smu_context *smu,
 						      table_index);
 	uint32_t table_size;
 	int ret = 0;
-	if (!table_data || table_id >= SMU_TABLE_COUNT || table_id < 0)
+	if (!table_data || table_index >= SMU_TABLE_COUNT || table_id < 0)
 		return -EINVAL;
 
 	table_size = smu_table->tables[table_index].size;
-- 
2.51.0



