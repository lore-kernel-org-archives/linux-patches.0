Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F407125B2;
	Sun,  7 Sep 2025 20:46:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757277996; cv=none; b=T1zO7al4vvlesYiTHTVU8wdbKwC5h+409l4EU9URRJQp35D3tG6gPeT+xH8HSJmvvV9u9OMqLmSqMzkAYol4M5wp/oOAqfsULzsI4D3CiWEd7FpWlAvJpTUc5nKSm66ogNVspvDHkrFHUQx2qL1/F4DrYgOWR4xis5Rcj4AdEHg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757277996; c=relaxed/simple;
	bh=4+V4FMHZPH6mf5v7vipKsT6WZH8r0vEYqPDW7Vth+oQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xo/HNF2AWPREI5pU/cEnyiqUa8VYbAJ/k83ZCPsgRmIWjJpEjRgmIVz2yUisXq3dL3B9cB4TLBLBOM0JOD7JXnjko+LqUJ83x3AaEkpu9nQCKnzu2EJb2l07YKwrTyZ5DlJJYnqiYhS33tLollRDFmKgM9uv/r3q8+hZT8M/Lj8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cLPmRpQ3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cLPmRpQ3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8F59C4CEF0;
	Sun,  7 Sep 2025 20:46:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757277996;
	bh=4+V4FMHZPH6mf5v7vipKsT6WZH8r0vEYqPDW7Vth+oQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cLPmRpQ3z7O3jFOQ4Kj9wUun7HlziHT4B/gwJA2zk8UU3RmDmQLVjj3kTZM8DlJau
	 zBZIMZPNi2BavHJTF8fTI12RSmYxd78pIzdg7Z1d1TZeN5vXW0cSNfm5wQC0EruIfm
	 3xqHzV93bEmV2GD0q2kGdVU4/0wya1UoYz4J1lao=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Colin Ian King <colin.i.king@gmail.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 168/183] drm/amd/amdgpu: Fix missing error return on kzalloc failure
Date: Sun,  7 Sep 2025 21:59:55 +0200
Message-ID: <20250907195619.808529159@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195615.802693401@linuxfoundation.org>
References: <20250907195615.802693401@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Colin Ian King <colin.i.king@gmail.com>

[ Upstream commit 467e00b30dfe75c4cfc2197ceef1fddca06adc25 ]

Currently the kzalloc failure check just sets reports the failure
and sets the variable ret to -ENOMEM, which is not checked later
for this specific error. Fix this by just returning -ENOMEM rather
than setting ret.

Fixes: 4fb930715468 ("drm/amd/amdgpu: remove redundant host to psp cmd buf allocations")
Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 1ee9d1a0962c13ba5ab7e47d33a80e3b8dc4b52e)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c
index 7d8b98aa5271c..f9ceda7861f1b 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c
@@ -447,7 +447,7 @@ static int psp_sw_init(struct amdgpu_ip_block *ip_block)
 	psp->cmd = kzalloc(sizeof(struct psp_gfx_cmd_resp), GFP_KERNEL);
 	if (!psp->cmd) {
 		dev_err(adev->dev, "Failed to allocate memory to command buffer!\n");
-		ret = -ENOMEM;
+		return -ENOMEM;
 	}
 
 	adev->psp.xgmi_context.supports_extended_data =
-- 
2.51.0



