Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0E713B9D84;
	Fri, 15 May 2026 16:11:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778861498; cv=none; b=h4EFW73FGpSjbgkYjFvcrGrNdSgDK4HtfkcKo5pqeK7eDEvNK1YRpy0wtnkaV1BqBCpcAwa10T94xIa9doIXQr1CxamwoIe4EWy/FaB1cByM8RL0jt6+xKDAFKOY6+9lKybpp7G0KUMp8E9SCVQ/MvELxP08I0NNPHipayvgrx8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778861498; c=relaxed/simple;
	bh=qUox0UbT16xspYvt0d8qXu4b1+dWVaozQVrCXuLfcC8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pcHSfdtuR/533i2BScauKT1ITv5kfpqBMjQ1069plxpydVW9zyB2zneerI81SmwcsRqTv5VUveWwonOXdyVJwShXOf49akA3/B7kBg9CBAlG4rVRs2NXYshQeidBv5p6yLigqlZqQX1MCO66aOh3/hEk7hTxhABHq7DvFckMw5E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OrCDex5t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OrCDex5t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55BB5C2BCB0;
	Fri, 15 May 2026 16:11:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778861498;
	bh=qUox0UbT16xspYvt0d8qXu4b1+dWVaozQVrCXuLfcC8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OrCDex5tRZSvhXhdybpmyJ5FUhoGPiOWgoqfo1pgpzhhDYLLevW07F3frX9QbBKAA
	 q1U/CH9jiWKodBXwAxvIhGZ3wnRzoc9t/70UQApZvPVL9MgmgBdt7v28lHmoeg/Ge8
	 2oFsCj6oNgEpXkwOHjhiax+gQX3VJQ6A2vx0Yii0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Timur=20Krist=C3=B3f?= <timur.kristof@gmail.com>,
	Kent Russell <kent.russell@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.6 353/474] drm/amdgpu/pm: add missing revision check for CI
Date: Fri, 15 May 2026 17:47:42 +0200
Message-ID: <20260515154722.654240326@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154715.053014143@linuxfoundation.org>
References: <20260515154715.053014143@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 2a561b361b7681509710f3cfc3d95d54c87ac69f upstream.

The ci_populate_all_memory_levels() workaround only
applies to revision 0 SKUs.

Link: https://gitlab.freedesktop.org/drm/amd/-/work_items/1816
Fixes: 9f4b35411cfe ("drm/amd/powerplay: add CI asics support to smumgr (v3)")
Reviewed-by: Timur Kristóf <timur.kristof@gmail.com>
Reviewed-by: Kent Russell <kent.russell@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 1db15ba8f72f400bbad8ae0ce24fafc43429d4bd)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/pm/powerplay/smumgr/ci_smumgr.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/amd/pm/powerplay/smumgr/ci_smumgr.c
+++ b/drivers/gpu/drm/amd/pm/powerplay/smumgr/ci_smumgr.c
@@ -1326,8 +1326,9 @@ static int ci_populate_all_memory_levels
 
 	dev_id = adev->pdev->device;
 
-	if ((dpm_table->mclk_table.count >= 2)
-		&& ((dev_id == 0x67B0) ||  (dev_id == 0x67B1))) {
+	if ((dpm_table->mclk_table.count >= 2) &&
+	    ((dev_id == 0x67B0) ||  (dev_id == 0x67B1)) &&
+	    (adev->pdev->revision == 0)) {
 		smu_data->smc_state_table.MemoryLevel[1].MinVddci =
 				smu_data->smc_state_table.MemoryLevel[0].MinVddci;
 		smu_data->smc_state_table.MemoryLevel[1].MinMvdd =


