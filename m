Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D37134D3B5;
	Fri, 21 Nov 2025 13:36:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763732201; cv=none; b=DJQ7Z4fj48KmR5MLTYvG/39g2r6Y7anrkewQ2KKEuvHnWF1sDZfKvaaUKKOV5eIS1jI4WB5gN1Y618juaauSobJ63Xn8dtPedGfIMm8rLPviOtAVf2tT1GYBMSRgFtmB5t4jDierZNDREr+JmMGS6PqHaQLy1RhE0+9FtBAYsQs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763732201; c=relaxed/simple;
	bh=m9wSIVrTud9iSBo496Q0IxfGoL1mzXekIsAV624K3Kc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JVSzOYHy9CdSoEmPWud/l+n/0OtlUPMRGDAL/0f2n7RlW19yxUzjaG6ixzyX2wkpxp/UBvd47hoguyY2E1lmKX6VQYw+PSeXJBWfNj1sZDyHCq8QB6T0ssVvOUW1NbZ7HSM84eqJQBHWTorx2dskACYzUyDNQ1/Ms4osxQmzXq8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TlK5Uagc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TlK5Uagc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9AD8C4CEF1;
	Fri, 21 Nov 2025 13:36:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763732201;
	bh=m9wSIVrTud9iSBo496Q0IxfGoL1mzXekIsAV624K3Kc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TlK5UagccldSoca8VgJ0HBYVE3SGV7OZ0IAFYVYSnGbq/LIr1W+TvM2Bz5O6UYsUz
	 neqVfzo9FmhNnhHl67iXuHMW+je6A+p2kx/IItbx6hVnzHcyICJUfHXhEqkopIVOsS
	 +8qqWhfIsTOhh7/BtdVBgWzYsHcz67Pe19h26o2U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Wang <kevinyang.wang@amd.com>,
	Hawking Zhang <Hawking.Zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 039/529] drm/amd/pm: fix smu table id bound check issue in smu_cmn_update_table()
Date: Fri, 21 Nov 2025 14:05:38 +0100
Message-ID: <20251121130232.392068260@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index c1962f1974c6f..2c9612b5f1568 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/smu_cmn.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu_cmn.c
@@ -870,7 +870,7 @@ int smu_cmn_update_table(struct smu_context *smu,
 						      table_index);
 	uint32_t table_size;
 	int ret = 0;
-	if (!table_data || table_id >= SMU_TABLE_COUNT || table_id < 0)
+	if (!table_data || table_index >= SMU_TABLE_COUNT || table_id < 0)
 		return -EINVAL;
 
 	table_size = smu_table->tables[table_index].size;
-- 
2.51.0



