Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E9B64086A;
	Tue, 11 Nov 2025 00:53:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762822393; cv=none; b=cp7x/61ApLkNny/Rk0YSczb6ztD0YSO2OH7bVgmN5XbeGWXezjfCC2n9PHoAieoxXhr8/FFvVgtEv49/mFLKghDpCJyT9G6Buwkq2JJOv9AYnGrcovFAcJ3UwZtCg4tL6XfXoiA1hIGJy/1As78dPsxiNgr+v0ulo0hDAGYi5ow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762822393; c=relaxed/simple;
	bh=nbgD7VqkARK16xAYvnTGZplul+nBaMRoG2IXoRc5Ipw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z0nqsbi4bWOTxZLawq7FB/j//RX3F+XjzC11SZemG8nQpB2zdOMEpiTyBoH0bKDVGpksWmZwSNfLY6WGkf65KuFT7seQ+/e81NJC7Vdh+goUXz169EAtIoz1Z3GTAsOCXFgHTcHWD16/U9nchgQQ/leRtgt5vpw9b2fUtiFDvyI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WoUVFbQB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WoUVFbQB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 893F3C19424;
	Tue, 11 Nov 2025 00:53:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762822392;
	bh=nbgD7VqkARK16xAYvnTGZplul+nBaMRoG2IXoRc5Ipw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WoUVFbQBwnTpN1VkGqz1gbThb9l8i280/4df1VeFtwcyPNWY2vUpVUdUceA/am1S2
	 Iv1SZ0r5kGuFi7wcCAvErEH9ha87UXZhRvpXk7jGT3Lov9yAGk+PZ7yHsJlzxLT7bL
	 mxo372q0q8yNF3JvjufI94ktumH11AnXskUo7KXA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Wang <kevinyang.wang@amd.com>,
	Hawking Zhang <Hawking.Zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 081/849] drm/amd/pm: fix smu table id bound check issue in smu_cmn_update_table()
Date: Tue, 11 Nov 2025 09:34:11 +0900
Message-ID: <20251111004538.377466739@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
index 59f9abd0f7b8c..00f6c6acc3e68 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/smu_cmn.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu_cmn.c
@@ -965,7 +965,7 @@ int smu_cmn_update_table(struct smu_context *smu,
 						      table_index);
 	uint32_t table_size;
 	int ret = 0;
-	if (!table_data || table_id >= SMU_TABLE_COUNT || table_id < 0)
+	if (!table_data || table_index >= SMU_TABLE_COUNT || table_id < 0)
 		return -EINVAL;
 
 	table_size = smu_table->tables[table_index].size;
-- 
2.51.0



