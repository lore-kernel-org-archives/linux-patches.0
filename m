Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDB812110E;
	Tue, 27 May 2025 17:05:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748365519; cv=none; b=NoIGwVwmV0JNFJx1z3FtG3gPkggO9IAGMZIx6PpQ3AU+pf9iGIXDvVbzEP7GrZjeAviqoB0C3GHYORVx/UFzGetht842zMa4p3xTnkk6dK1b8S1rlXbwcBDsHvkUYCzuSkpkskXEDHtYhruevDbI2gfxZdPSZackvYSjgxIhnsY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748365519; c=relaxed/simple;
	bh=FLzWMGg4e3Lr/EaEBLJ4oFSL6g6Vwyw2JOUUT2Sra+s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FjsnZ/YvFUWZ8LZpYWYr6fVDqiKw3qc6S2i+UNhMrPR5JQjO2isSy70D0ib5NgPxXO6ywU5hhPeLyPUGsqz95omI/0pBnBkTGZ3oFUcHAwWgEPCL75wBGI9c6LHUiRdlj+dugc3IAGx8ouLZqY6elKEfSbUM2ORrmuyCjaSg4fk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y3pYvF7G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y3pYvF7G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AF24C4CEE9;
	Tue, 27 May 2025 17:05:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748365519;
	bh=FLzWMGg4e3Lr/EaEBLJ4oFSL6g6Vwyw2JOUUT2Sra+s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y3pYvF7G6qXG7th+qxQlrljHpoVIoSwC7TD7Q7aSzw6gB7HwEry0QWhklA5Rks9ll
	 928zB4ij9NpoCU3uYNs/M8El5iKgGJ15n5unLRTRD+OQs/CYMPPOdr0+GMS9uRZ17u
	 yoszwvy6dsI7c1aQCc/DhryQFGC70WmiBvGTEUb4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shiwu Zhang <shiwu.zhang@amd.com>,
	Hawking Zhang <Hawking.Zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 402/626] drm/amdgpu: enlarge the VBIOS binary size limit
Date: Tue, 27 May 2025 18:24:55 +0200
Message-ID: <20250527162501.353038817@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shiwu Zhang <shiwu.zhang@amd.com>

[ Upstream commit 667b96134c9e206aebe40985650bf478935cbe04 ]

Some chips have a larger VBIOS file so raise the size limit to support
the flashing tool.

Signed-off-by: Shiwu Zhang <shiwu.zhang@amd.com>
Reviewed-by: Hawking Zhang <Hawking.Zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c
index 31a376f2742a2..48e30e5f83389 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c
@@ -44,7 +44,7 @@
 #include "amdgpu_securedisplay.h"
 #include "amdgpu_atomfirmware.h"
 
-#define AMD_VBIOS_FILE_MAX_SIZE_B      (1024*1024*3)
+#define AMD_VBIOS_FILE_MAX_SIZE_B      (1024*1024*16)
 
 static int psp_load_smu_fw(struct psp_context *psp);
 static int psp_rap_terminate(struct psp_context *psp);
-- 
2.39.5



