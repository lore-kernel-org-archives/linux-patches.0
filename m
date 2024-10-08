Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 328891DACBE;
	Tue,  8 Oct 2024 12:12:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728389539; cv=none; b=ihJie4UbZZUHDWBb4PA8gUlgyEReMJaGyBN7HcELe9oCTeoeS8dphmdbWqW8t/3rGqO1kC/bOhLxrFsx+2feqvE4eZtPyb1R2/pAQgctad4XBBqNfbrrIV3z4Zx3iJglVa9NkGhvUWochgiH/vuZpvJPifBW0u2yl2CEVKKqG48=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728389539; c=relaxed/simple;
	bh=hapVboiJmDrgGHxcQsg3BfV5lUQYDZ7fM4dzJhlEVqU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sfGavOpKCHbAjSNwWTfnNUirRKO+f7E4y9F9Prw9d3HHemC+Z6tte3WTBPHYOrDlomTqorLqAAVgMmQeRgo/2EZY3VDuAms8EYGjvSrVDnCEslNAicTLbL1I8PJ2qGbM3zVjbnN9wVph4LtYCVwA8JCF4X/xJf8t/ehoCD+/YAs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dtnSFXut; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dtnSFXut"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96943C4CEC7;
	Tue,  8 Oct 2024 12:12:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728389539;
	bh=hapVboiJmDrgGHxcQsg3BfV5lUQYDZ7fM4dzJhlEVqU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dtnSFXuth5UADh04ZxPZMswO/6zTxNk7iNhmZ3ZeF4DfD/7iWwV1sAFb696Lu16ek
	 3DdRZxQpBfQS7lAlb7h3fLRoCMNpJhHWPOC3YbhvLhzONskv/AhzLUfAu2RsHaWju4
	 zCvWZNPaxbhGHrEIJMwTITUbwrR1QHrBnDyfiGKo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Asad Kamal <asad.kamal@amd.com>,
	Lijo Lazar <lijo.lazar@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 008/482] drm/amdgpu: Fix get each xcp macro
Date: Tue,  8 Oct 2024 14:01:11 +0200
Message-ID: <20241008115648.624207918@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115648.280954295@linuxfoundation.org>
References: <20241008115648.280954295@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Asad Kamal <asad.kamal@amd.com>

[ Upstream commit ef126c06a98bde1a41303970eb0fc0ac33c3cc02 ]

Fix get each xcp macro to loop over each partition correctly

Fixes: 4bdca2057933 ("drm/amdgpu: Add utility functions for xcp")
Signed-off-by: Asad Kamal <asad.kamal@amd.com>
Reviewed-by: Lijo Lazar <lijo.lazar@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_xcp.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_xcp.h b/drivers/gpu/drm/amd/amdgpu/amdgpu_xcp.h
index 90138bc5f03d1..32775260556f4 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_xcp.h
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_xcp.h
@@ -180,6 +180,6 @@ amdgpu_get_next_xcp(struct amdgpu_xcp_mgr *xcp_mgr, int *from)
 
 #define for_each_xcp(xcp_mgr, xcp, i)                            \
 	for (i = 0, xcp = amdgpu_get_next_xcp(xcp_mgr, &i); xcp; \
-	     xcp = amdgpu_get_next_xcp(xcp_mgr, &i))
+	     ++i, xcp = amdgpu_get_next_xcp(xcp_mgr, &i))
 
 #endif
-- 
2.43.0



