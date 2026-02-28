Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1B0E333447
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:53:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301206; cv=none; b=aUJMeuBswu/XqhTJlfA4JKwJ5MMl+fvjhbiOLzTL8gaP53igQGIprZou0l2rObMMTO3n94S1PMaE3Ug6BRgM3KMo6sAXuLSoN3fwnlXrE07k+2I668DwPXuLrJuz+jlW8pZM45zAmlkfNGAQB04xQQtYEiT9oH6+X3snyOZ8rYk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301206; c=relaxed/simple;
	bh=LHbUj7Ij4wiBwfmOj5iHqHNdftn+GgC3HXG0hLidOro=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dkK+zys9rnG9UiR78jwHCfowgB8G5OGk9fabC4P6IcwAjQFCOE3OpHKz9EnsStykqEvPzIPocUPlQhSh72XVs2gxf5gDw+F6U3Bn1Ay0aLdRS7V1oj6BGM5R764TZdsztb0/833wPnmAq6pPklVWj5hHEXokHtzyy2e6F91d2n0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Gkrvro/d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Gkrvro/d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A74AC19423;
	Sat, 28 Feb 2026 17:53:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301205;
	bh=LHbUj7Ij4wiBwfmOj5iHqHNdftn+GgC3HXG0hLidOro=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Gkrvro/dN+81LbQDObEhqMJ6Jk/IYWYXH7TjXXY8+aZA6CooTvxKCUoMNpn4yy0ge
	 3LUylhTEySuDKk2qTbd7zItC3anyjQnz5fxrEvHX0V3HscAUcAr1Vel/F/ce/c8V2u
	 /iRQ50pBarhltWNifjTLx3oWYU+jZ3M470hKBLQ25A/er1K4jQMi81d4QyMwOqn2cO
	 cJ14mU767N5B37oyd/zvRpY+Vxi98V7vDjlklWnT72wLE9RQrKzT04M713X+ZW2jut
	 pYtfMsRlUsq7U5K9EoPpjkTfeYkj0MYjL5RuM/vGFHikEL4wn0+oQyKwM0gnLxM+Xo
	 IMkQPog4sXWHA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Ce Sun <cesun102@amd.com>,
	Lijo Lazar <lijo.lazar@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 379/752] drm/amdgpu: Adjust usleep_range in fence wait
Date: Sat, 28 Feb 2026 12:41:30 -0500
Message-ID: <20260228174750.1542406-379-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Ce Sun <cesun102@amd.com>

[ Upstream commit 3ee1c72606bd2842f0f377fd4b118362af0323ae ]

Tune the sleep interval in the PSP fence wait loop from 10-100us to
60-100us.This adjustment results in an overall wait window of 1.2s
(60us * 20000 iterations) to 2 seconds (100us * 20000 iterations),
which guarantees that we can retrieve the correct fence value

Signed-off-by: Ce Sun <cesun102@amd.com>
Reviewed-by: Lijo Lazar <lijo.lazar@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c
index aa7987d0806c6..5f7aa840b2151 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c
@@ -726,7 +726,7 @@ psp_cmd_submit_buf(struct psp_context *psp,
 		ras_intr = amdgpu_ras_intr_triggered();
 		if (ras_intr)
 			break;
-		usleep_range(10, 100);
+		usleep_range(60, 100);
 		amdgpu_device_invalidate_hdp(psp->adev, NULL);
 	}
 
-- 
2.51.0

