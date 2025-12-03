Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E0E030C606;
	Wed,  3 Dec 2025 15:31:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764775899; cv=none; b=IgLe5mZWDwuu4Joe7p7iWt8oJicrbcTlY41W8mq/r2udy370RAR47T3TP4cOAEpluW5AFu+Wj2w/SQcVDyDyTMhY/RNhrjD52IwCyYKXv9ITdJRZ+69OpzdnIaOwZISwYioWAnpjv77BJcYhUM6k5sw8aVWJ7iUC4Z3NG9BMwFc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764775899; c=relaxed/simple;
	bh=Hy5a7dFtAQjcVIpFz9xEjzS2q0vHRBWXdLG7LyeTE7U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q9Ib7On5KGrlYcOAs+NdQKi4Hp4moH0ndFG/2OZokpTZ0xJNEeOaHcEe0EElMruylwif8cqUtbB9Isb0QZ0+rjULNzl6JaMsTLv38mDsNelVBgPVukH6+3/VPCsw4IHdpGqbOIbPC68yRCa5fBZQRRmUH/vJd4YdDf827O58cEk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eLQY6dvd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eLQY6dvd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86506C4CEF5;
	Wed,  3 Dec 2025 15:31:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764775898;
	bh=Hy5a7dFtAQjcVIpFz9xEjzS2q0vHRBWXdLG7LyeTE7U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eLQY6dvd7F13Eg9o6na+xG9y/a42JTv3FTzJpwwtVecU2N+wPoxkECGwjZsiP7mnC
	 KZaoufW542HBnFyrvnllK38umBZTKbfTz9SG/zTd4+DXgDU8bXQJdznl32sMXTdg1w
	 25KHjS9JVfJhdlNHMkzbWBld0TpRIfhllSk4vP2A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Wang <kevinyang.wang@amd.com>,
	Hawking Zhang <Hawking.Zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 020/300] drm/amd/pm: fix smu table id bound check issue in smu_cmn_update_table()
Date: Wed,  3 Dec 2025 16:23:44 +0100
Message-ID: <20251203152401.206743524@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152400.447697997@linuxfoundation.org>
References: <20251203152400.447697997@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 92b2ea4c197b8..5219eb685c88e 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/smu_cmn.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu_cmn.c
@@ -587,7 +587,7 @@ int smu_cmn_update_table(struct smu_context *smu,
 						      table_index);
 	uint32_t table_size;
 	int ret = 0;
-	if (!table_data || table_id >= SMU_TABLE_COUNT || table_id < 0)
+	if (!table_data || table_index >= SMU_TABLE_COUNT || table_id < 0)
 		return -EINVAL;
 
 	table_size = smu_table->tables[table_index].size;
-- 
2.51.0



