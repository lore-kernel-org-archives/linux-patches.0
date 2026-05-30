Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B7CF3BF694;
	Sat, 30 May 2026 17:56:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780163820; cv=none; b=JViV4qPfVj+J8IiCehnfxALxyom/+tU14dbwIOij0l82uK4R0PATIjvGN1MzVbnFU7UtVcRlRWVMqd9awsQA3LWoe/2ZAONGpFoufrTg6JsqB/sprlmHKd9oyv1jqWTv72y1MzSqkmEUzQ1TIuCtFcaHarAgV93wnwlgjyRZBiY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780163820; c=relaxed/simple;
	bh=aG6Ot7X/groQWzqhyrYcRfm5nPimvYL2Tfos3cGTm3Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RHvBxxrn4tOxwDTTY3p+RANB8ajFX8C/RaKY3Bt9t56RRlx7FHV24iLrKvF1jdSSH18EvH3fMdYtf3UPT3DUr7lvjCeVkLifTmIVzK4ia7/63tlAgXzIxFSaLtPiZ1i6s41PqaJTz7vPzLfuCkqR/2CDEzMTJSIL3jWih2ulZeo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xnlVzvai; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xnlVzvai"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E9E51F00893;
	Sat, 30 May 2026 17:56:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780163818;
	bh=3xf3b0M4FOHKKhqdzApUcnGu04cEtIV7lg8AaVP0H8A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xnlVzvaihtOIZuQ7Lfpc611LXHa4FZpx+7e2RvRQtO705MCKJne8EZ3nQ7H7BGrK3
	 PAYQUnMCe40H8ZAw3WL2t25Afv/tRKIPcdTy86Vb2Gqs5hOO7lH/xwUWzNpo3ON6nG
	 KOkocBJ7RkNwzuHKjQn71a3SEr5VtcyDDS9cAM+Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Timur=20Krist=C3=B3f?= <timur.kristof@gmail.com>,
	Kent Russell <kent.russell@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.15 372/776] drm/amdgpu/pm: align Hawaii mclk workaround with radeon
Date: Sat, 30 May 2026 18:01:26 +0200
Message-ID: <20260530160250.157723384@linuxfoundation.org>
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
@@ -1328,10 +1328,10 @@ static int ci_populate_all_memory_levels
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


