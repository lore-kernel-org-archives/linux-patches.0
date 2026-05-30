Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D926A349CCF;
	Sat, 30 May 2026 18:35:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780166139; cv=none; b=sdgA2T9YqVuxD+Ydp60SrwqyPoajQYcI3JUx28JjWcqSKt/NVf+p7zJYipn2ThdUV+Eqb1zz/LhUnjZ8bjTTVmt3OcIYsoIOfU1BUov2GvNmk8o81tp+mpiplF6qvfukENFAfHfvc0Rb0ewv1TkmSpMfmsLWs9PEoF1I7/54DcM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780166139; c=relaxed/simple;
	bh=La0SF364UgPzOHa9wmC2iax3ZKY3OxHU2bQYhLj3DSc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nUlcVJkeKzJhXjS/fYRF9wu/uMZD/ZkMSbopzFf4BnziEsJgYrAFs/wnQJ4r3Mi1nvW0YihkZ3wkNqEatcKlycAXflUG5yITq1XPETZtySOd3KtHiFkzjnVssFA/H6p317kcsNeYerNB9jprrsHnIdV3flmnsz+RPlV9KF1g6rk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2uJYSPqc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2uJYSPqc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A5951F00893;
	Sat, 30 May 2026 18:35:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780166138;
	bh=tniqwabaStQX02iAjBsSoG/P5sVC0usNjq8+hE05ztQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2uJYSPqcSYm2Un2HZQEktGra5Vs+Pn/yw2uetMuVQkfHUb7Yxs1ZUKsiYdCtvK63W
	 ntcH1n5/WIeBzP65lfN8t+f4nWMzdGmphBWrXGwyO4j9rUcqfv9e1gp+ozfKIgVjZe
	 db/FJ9ZUD43bY7BIUgTYlUh+BG79IaQsWXQdPTOo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Timur=20Krist=C3=B3f?= <timur.kristof@gmail.com>,
	Kent Russell <kent.russell@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.10 278/589] drm/amdgpu/pm: add missing revision check for CI
Date: Sat, 30 May 2026 18:02:39 +0200
Message-ID: <20260530160232.269699446@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160224.570625122@linuxfoundation.org>
References: <20260530160224.570625122@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1325,8 +1325,9 @@ static int ci_populate_all_memory_levels
 
 	dev_id = adev->pdev->device;
 
-	if ((dpm_table->mclk_table.count >= 2)
-		&& ((dev_id == 0x67B0) ||  (dev_id == 0x67B1))) {
+	if ((dpm_table->mclk_table.count >= 2) &&
+	    ((dev_id == 0x67B0) ||  (dev_id == 0x67B1)) &&
+	    (adev->pdev->revision == 0)) {
 		smu_data->smc_state_table.MemoryLevel[1].MinVddci =
 				smu_data->smc_state_table.MemoryLevel[0].MinVddci;
 		smu_data->smc_state_table.MemoryLevel[1].MinMvdd =


