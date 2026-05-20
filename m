Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A7A2272E56;
	Wed, 20 May 2026 18:36:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779302181; cv=none; b=L19Y5B9UVN6I58pUxEt38Wbsz7+0WeY20+3IbzaghGnZemI6LJ+LRVoyxEI8d1O7lyp/YAUOsv7mE1rilA9p7jFZA5X9XZJo69y5oTO/7Vh5g9a+L/nuz0TUmXVxlB9WeEUm3EKVfwca/BvKmwcEynomxPsc3AKiulC47RgQmog=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779302181; c=relaxed/simple;
	bh=veWEe7tRXzhka6mQBJKLzJnm+8D8KkbsR6yTHbRGtNo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YmElOxp0L/K4ojEmQbaKYSaCPh8vEYItrxQed9n1rIBLOSS1KGPkMdLX4KGtOWB60KEqyJ+icVJ+Jux0D0jxGeTJB6G4Y9aMjTn5aOSLliA9MNDe/W+7ULQvaFtdJvS8+eBCS16AQ6ztqOlmvVj/WycYJdHOKjDLX4DOZTU4gaU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jvyOnLwb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jvyOnLwb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD4FD1F000E9;
	Wed, 20 May 2026 18:36:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779302180;
	bh=qjX1uOAUcgcpWrEc80PPdtTjSZucHf3FoWN6eC9GG5g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jvyOnLwbmdghZC2nO14SntQ+gOWl85O15JJqjhZO8hi3JHsUre0WIwUJsX1gX5z6u
	 ScomjTaKDSlJQXUUMmYYHfqrRkeuj65RZf6vtJqzNjtueU+U/ePPmElyndDRsneRBU
	 wD9CLSMcbM1Kd+APSmja41FSnXG6QJU+gT5g1ddw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Timur=20Krist=C3=B3f?= <timur.kristof@gmail.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 127/508] drm/amd/pm/ci: Fill DW8 fields from SMC
Date: Wed, 20 May 2026 18:19:10 +0200
Message-ID: <20260520162101.380356450@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162058.573354582@linuxfoundation.org>
References: <20260520162058.573354582@linuxfoundation.org>
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

From: Timur Kristóf <timur.kristof@gmail.com>

[ Upstream commit baf28ec5795c077406d6f52b8ad39e614153bce6 ]

In ci_populate_dw8() we currently just read a value from the SMU
and then throw it away. Instead of throwing away the value,
we should use it to fill other fields in DW8 (like radeon).

Otherwise the value of the other fiels is just cleared when
we copy this data to the SMU later.

Fixes: 9f4b35411cfe ("drm/amd/powerplay: add CI asics support to smumgr (v3)")
Signed-off-by: Timur Kristóf <timur.kristof@gmail.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/pm/powerplay/smumgr/ci_smumgr.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/pm/powerplay/smumgr/ci_smumgr.c b/drivers/gpu/drm/amd/pm/powerplay/smumgr/ci_smumgr.c
index 4a0e8887fa74b..741ebeb276b84 100644
--- a/drivers/gpu/drm/amd/pm/powerplay/smumgr/ci_smumgr.c
+++ b/drivers/gpu/drm/amd/pm/powerplay/smumgr/ci_smumgr.c
@@ -543,12 +543,11 @@ static int ci_populate_dw8(struct pp_hwmgr *hwmgr, uint32_t fuse_table_offset)
 {
 	struct ci_smumgr *smu_data = (struct ci_smumgr *)(hwmgr->smu_backend);
 	const struct ci_pt_defaults *defaults = smu_data->power_tune_defaults;
-	uint32_t temp;
 
 	if (ci_read_smc_sram_dword(hwmgr,
 			fuse_table_offset +
 			offsetof(SMU7_Discrete_PmFuses, TdcWaterfallCtl),
-			(uint32_t *)&temp, SMC_RAM_END))
+			(uint32_t *)&smu_data->power_tune_table.TdcWaterfallCtl, SMC_RAM_END))
 		PP_ASSERT_WITH_CODE(false,
 				"Attempt to read PmFuses.DW6 (SviLoadLineEn) from SMC Failed!",
 				return -EINVAL);
-- 
2.53.0



