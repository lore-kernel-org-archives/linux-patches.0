Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4058334C9AE;
	Wed,  3 Dec 2025 16:19:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764778769; cv=none; b=HyJFcH8B/vE1q7CH4de32NZM4d4g1c+juVQ3/iNPif013J8W5vy4BknnnnM2AktkH7piPSTXlaXx2KWpggBgcws5gamMWvz/9fWEarktDBAK8Wgpvhlkje//o6t63xjFxU561Z+IbG0kY4+hzpMCah/sdBf52flDXV0a44KcczM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764778769; c=relaxed/simple;
	bh=+J8rRiv5S/1ZaCmMYd32BHaQvNajDA3WLl8XkGpO5Z4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oams3OMs9Ui7Blv5IhS+j/zVc4Tg5gAXhKD9TJxwGwDaTPG7GqnpnkqieYvP9n5JFjkPTcEpXOGa5rZkPllem/3fTtA9BLEg3LX/PzwhEjiuS0mUkD56Ff3jVvQ4H0u8MltF9pFma2tx31NSjKl0/jeNLCylwZ/rm8bDUKIuo9k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rPc1YC5w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rPc1YC5w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9EBFC4CEF5;
	Wed,  3 Dec 2025 16:19:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764778769;
	bh=+J8rRiv5S/1ZaCmMYd32BHaQvNajDA3WLl8XkGpO5Z4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rPc1YC5wR97Y+w9azyUU6mgPOFBnowp7tbyc0AeEKvVX3Nk6EWQkN6z+yMlgu0Bgi
	 btjHxbG2jsS+xEvVomKxdpe/73bmhyTzGGmJhzDLJU7U9/Y0MqDhXXyFYWRqQgl3fs
	 NBNjVh3M7r9o3tCqh9hluE0Ptua1f2fTEmEVtJgM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Wang <kevinyang.wang@amd.com>,
	Hawking Zhang <Hawking.Zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 053/568] drm/amd/pm: fix smu table id bound check issue in smu_cmn_update_table()
Date: Wed,  3 Dec 2025 16:20:55 +0100
Message-ID: <20251203152442.639247371@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index fd1faa840ec09..24b39a80481a8 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/smu_cmn.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu_cmn.c
@@ -862,7 +862,7 @@ int smu_cmn_update_table(struct smu_context *smu,
 						      table_index);
 	uint32_t table_size;
 	int ret = 0;
-	if (!table_data || table_id >= SMU_TABLE_COUNT || table_id < 0)
+	if (!table_data || table_index >= SMU_TABLE_COUNT || table_id < 0)
 		return -EINVAL;
 
 	table_size = smu_table->tables[table_index].size;
-- 
2.51.0



