Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 905943446D3;
	Wed,  3 Dec 2025 15:58:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764777508; cv=none; b=pE/MgWBC4rDONoIKjQV0xMiTsD8nkMt2U9wqJuhIu96HPWiC96pxJVQbSVBfWDc2lDgOamUU+0XHIsnwbUaT6s97mlpDTTUfqOzdg5UlOnaLmb/mIQvPOevjfSkPdXZ92vsv3JBzb7JzA+UignM8R8pjg5EVNNiHo0Wp4UP6C0E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764777508; c=relaxed/simple;
	bh=RHFfZbU1//L6R2I7QTkkmgfwcLI8D3n+/fPmsq8VJQ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uTX4IeLdqsafKXGjt+O1JFSnxUaW+axpvcju9OmtHotDEEzYZEMu/zPHsEPbgHLicBUlSGstuHmewwn+0M5vSXeqm50Kamt9D7p2vwMWBx4ZeFF9k8rht0sEW5H0f8xugdGPfI/s+N4pOYCU+10OuCGo8HIfMZlTBNUZO6I0jV8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lofbNsq/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lofbNsq/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83FE3C4CEF5;
	Wed,  3 Dec 2025 15:58:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764777507;
	bh=RHFfZbU1//L6R2I7QTkkmgfwcLI8D3n+/fPmsq8VJQ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lofbNsq/XQOIIac5A1sd6G0DkmYOBI+BQkboLbQ5hFs7KnX3eRCLFSs0GMxcklHf4
	 UYcWlNCk8D8EYrhICLPN45g12DS/sGrcRZd9KfI77cdnQncGlIQ+HbpLoRHBKnJM2U
	 8v8RhWGFMGWuV2YrBmfaeE3ea7ogKwGbLKWpY4xo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Wang <kevinyang.wang@amd.com>,
	Hawking Zhang <Hawking.Zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 027/392] drm/amd/pm: fix smu table id bound check issue in smu_cmn_update_table()
Date: Wed,  3 Dec 2025 16:22:57 +0100
Message-ID: <20251203152415.100020024@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152414.082328008@linuxfoundation.org>
References: <20251203152414.082328008@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 843d2cbfc71d4..fbbbea75c52d4 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/smu_cmn.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu_cmn.c
@@ -883,7 +883,7 @@ int smu_cmn_update_table(struct smu_context *smu,
 						      table_index);
 	uint32_t table_size;
 	int ret = 0;
-	if (!table_data || table_id >= SMU_TABLE_COUNT || table_id < 0)
+	if (!table_data || table_index >= SMU_TABLE_COUNT || table_id < 0)
 		return -EINVAL;
 
 	table_size = smu_table->tables[table_index].size;
-- 
2.51.0



