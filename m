Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50840481DD;
	Sat, 30 May 2026 17:05:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780160712; cv=none; b=lb3ncwSayqoA3ojEd6pB7F3pmBW0dX1RL1lQfObwnLZMbEeuoVEbQn1FIBdpSdzjtNHPC7wuvFDmKr92tsA8LadBGIMq/UKKILNjablubZZsDMisOu9OL9dn+O8kHv2lwX5LHYgGp/i22KL6xqNl1Dm7oXKoPaeFRKAzptkI8QM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780160712; c=relaxed/simple;
	bh=qZGkwNvkbywwZ1gTi97Cq004bsTl9c+ENEo62PGv99w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Mnh7GnKFH7LiLBXJB+76noVr8wY9DTCbR2O+Lag/tIiMB0GRCzOcaLv/yb657goO1ht+uB7tITsqeuIFfb8GPk/j6PHAjE26kUqUvz5TQhoH3wvB1wbsc0A/2jEzQatYCZjfkqwvt9ntPkVw9+BNYSfCIEHru/GCXPK4OnQl/mY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1dPfe6m/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1dPfe6m/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E0A61F00893;
	Sat, 30 May 2026 17:05:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780160711;
	bh=JcBpyIU9SoiLFBN1H8qJ5TS9/y0t2pa3W6DPhVASyTQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1dPfe6m/b+HWgu6+ovScjO4DCzjBOcdzHeFAmlnKr2AAv8zFVrwkehZmckAFx/P6Y
	 jqt8TDw4CnxBPOFB5bYtTBVYfXPhaJAMn6TAPzBWh/cj+gSMXzA9+0Uuasx39wTAlM
	 I9ytt2ry1gLPPECSGXd4WgHpdScE/xwccNbdS2rU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Timur=20Krist=C3=B3f?= <timur.kristof@gmail.com>,
	Kent Russell <kent.russell@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.1 414/969] drm/amdgpu/pm: align Hawaii mclk workaround with radeon
Date: Sat, 30 May 2026 17:58:58 +0200
Message-ID: <20260530160311.708429886@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 1987c79b4fe5789dfa14423e78b5c25f6acf3e9d upstream.

Align the hawaii mclk workaround with radeon and windows.

Link: https://gitlab.freedesktop.org/drm/amd/-/work_items/1816
Fixes: 9f4b35411cfe ("drm/amd/powerplay: add CI asics support to smumgr (v3)")
Reviewed-by: Timur Kristóf <timur.kristof@gmail.com>
Reviewed-by: Kent Russell <kent.russell@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 9649528b637f668c5af9f2b83ca4ad8576ae2121)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/pm/powerplay/smumgr/ci_smumgr.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/gpu/drm/amd/pm/powerplay/smumgr/ci_smumgr.c
+++ b/drivers/gpu/drm/amd/pm/powerplay/smumgr/ci_smumgr.c
@@ -1330,10 +1330,10 @@ static int ci_populate_all_memory_levels
 	if ((dpm_table->mclk_table.count >= 2) &&
 	    ((dev_id == 0x67B0) ||  (dev_id == 0x67B1)) &&
 	    (adev->pdev->revision == 0)) {
-		smu_data->smc_state_table.MemoryLevel[1].MinVddci =
-				smu_data->smc_state_table.MemoryLevel[0].MinVddci;
-		smu_data->smc_state_table.MemoryLevel[1].MinMvdd =
-				smu_data->smc_state_table.MemoryLevel[0].MinMvdd;
+		smu_data->smc_state_table.MemoryLevel[1].MinVddc =
+				smu_data->smc_state_table.MemoryLevel[0].MinVddc;
+		smu_data->smc_state_table.MemoryLevel[1].MinVddcPhases =
+				smu_data->smc_state_table.MemoryLevel[0].MinVddcPhases;
 	}
 	smu_data->smc_state_table.MemoryLevel[0].ActivityLevel = 0x1F;
 	CONVERT_FROM_HOST_TO_SMC_US(smu_data->smc_state_table.MemoryLevel[0].ActivityLevel);


