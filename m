Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 450693BD25E;
	Sat, 30 May 2026 17:56:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780163806; cv=none; b=FHm8oLmfEj5AalpJyh1Xs2L45kCmJMJare7X+lsZ27qbpRKHGyUoODBBRIKqN64EThV0ncIxGB7W1YJgK5GbqHVy6KmSNNe7FDCnGdb3eEdE5uKwM4WDTRoMTreYMB09IBLyrkQ2GdLL00sgYp2+v2Nij8iDDCos/opve5UrSsU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780163806; c=relaxed/simple;
	bh=3MWriIasgZW+VwIIQAIfug5I1Di3lXqQ/B6AV4VloF0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=d/A3Y0si8DuYr54Njt54ekTulWl7+ZnJ1k6iFTTcGmYUeTTUAxYRi3BEOO/09KcABSflzwO2uXvh0PDtLSDZ20ioZVP3a8UEUgH2d0+EAYemuYf3UK9NAUeDSmVfvcycFB6MqSfHjrxppjQ7nqdc7NOiJf+z5azZDC8nUqbLQNo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2HOHGSbU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2HOHGSbU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44CB71F00893;
	Sat, 30 May 2026 17:56:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780163804;
	bh=yzVDEE5gqx+l05KxZbs65I16f7D8z1bB8gW0H+ZhiR0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2HOHGSbUvjqaPvmBGa84EKvszytVRo3i2nfoKsTcGyCobceuXMTYx2ebJGykllx4X
	 vg8dmNNcjQ41PbKFKihBDhheciVTFsLdOIRnihdXkTdYkX4flJ96aI0vXyE/23TGvG
	 onWFbeqMJ+XrkG9ivIFRulkJKJPLPbUArr9dZs34=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Timur=20Krist=C3=B3f?= <timur.kristof@gmail.com>,
	Kent Russell <kent.russell@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.15 368/776] drm/radeon: add missing revision check for CI
Date: Sat, 30 May 2026 18:01:22 +0200
Message-ID: <20260530160250.063053870@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 17223816498f7b117d138d18eb0eba63604dc74e upstream.

The memory level workarounds only apply to revision 0 SKUs.

Link: https://gitlab.freedesktop.org/drm/amd/-/work_items/1816
Fixes: 127e056e2a82 ("drm/radeon: fix mclk vddc configuration for cards for hawaii")
Fixes: 21b8a369046f ("drm/radeon: fix dram timing for certain hawaii boards")
Fixes: 90b2fee35cb9 ("drm/radeon: fix dpm mc init for certain hawaii boards")
Reviewed-by: Timur Kristóf <timur.kristof@gmail.com>
Reviewed-by: Kent Russell <kent.russell@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 4d8dcc14311515077062b5740f39f427075de5c9)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/radeon/ci_dpm.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/drivers/gpu/drm/radeon/ci_dpm.c
+++ b/drivers/gpu/drm/radeon/ci_dpm.c
@@ -2469,7 +2469,8 @@ static void ci_register_patching_mc_arb(
 
 	if (patch &&
 	    ((rdev->pdev->device == 0x67B0) ||
-	     (rdev->pdev->device == 0x67B1))) {
+	     (rdev->pdev->device == 0x67B1)) &&
+	    (rdev->pdev->revision == 0)) {
 		if ((memory_clock > 100000) && (memory_clock <= 125000)) {
 			tmp2 = (((0x31 * engine_clock) / 125000) - 1) & 0xff;
 			*dram_timimg2 &= ~0x00ff0000;
@@ -3310,7 +3311,8 @@ static int ci_populate_all_memory_levels
 	pi->smc_state_table.MemoryLevel[0].EnabledForActivity = 1;
 
 	if ((dpm_table->mclk_table.count >= 2) &&
-	    ((rdev->pdev->device == 0x67B0) || (rdev->pdev->device == 0x67B1))) {
+	    ((rdev->pdev->device == 0x67B0) || (rdev->pdev->device == 0x67B1)) &&
+	    (rdev->pdev->revision == 0)) {
 		pi->smc_state_table.MemoryLevel[1].MinVddc =
 			pi->smc_state_table.MemoryLevel[0].MinVddc;
 		pi->smc_state_table.MemoryLevel[1].MinVddcPhases =
@@ -4507,7 +4509,8 @@ static int ci_register_patching_mc_seq(s
 
 	if (patch &&
 	    ((rdev->pdev->device == 0x67B0) ||
-	     (rdev->pdev->device == 0x67B1))) {
+	     (rdev->pdev->device == 0x67B1)) &&
+	    (rdev->pdev->revision == 0)) {
 		for (i = 0; i < table->last; i++) {
 			if (table->last >= SMU7_DISCRETE_MC_REGISTER_ARRAY_SIZE)
 				return -EINVAL;


