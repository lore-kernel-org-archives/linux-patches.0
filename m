Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6E4825A627;
	Tue, 27 May 2025 17:43:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748367794; cv=none; b=YBhGKwGmCZEpgXyoqJrRdroe6SjvtDmGnbGRxeX1LboNjeiSY7uaoT3X7IcNsk72oUm24kbtJJOu+O/cpeBTLS25B6qKW8eownTlrsgOdu0ekpN2iVL2QN3FRmnIar93uxE4dS8UIdFwhjp1ulgQ3cVIDBWykW1YU2lENEe/mik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748367794; c=relaxed/simple;
	bh=DdjiYCyWnCdDqXxp528/yRE/GMqrZKF8CeBs9dt28KI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rhD58QzP0WWcWKmUhdF3qiT3Cd0o0p2L2YlVLflh6rLecvLtJDW6rOmwK0v0xK4XSwNm8BLm5EWuuWNoc7SUJOvhmGoUyFY/9zt3eEm5gzmHS40wFgEcYBAYN+F/tBP7t6P1GhKZ8mbCAjSS4GCkbPJt2NEtW4KE+Cd71rnZmKk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FyK/4IwJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FyK/4IwJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1674EC4CEE9;
	Tue, 27 May 2025 17:43:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748367794;
	bh=DdjiYCyWnCdDqXxp528/yRE/GMqrZKF8CeBs9dt28KI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FyK/4IwJLogJfzsMNItiy2Y3N8U+olD06bV68aMUjewOVx5lqXvmEXjEP0ZLYfiPV
	 Swv7bItWFG1gAAdtxR2zH5//z/kUUKwQo6EZKhfF0C0NkFWCjp81N+Ss5RqCYmIoe+
	 Rmj3L+Cmy2ugEZEpircH2AdkkwLDVojorwyANF+c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shiwu Zhang <shiwu.zhang@amd.com>,
	Hawking Zhang <Hawking.Zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 501/783] drm/amdgpu: enlarge the VBIOS binary size limit
Date: Tue, 27 May 2025 18:24:58 +0200
Message-ID: <20250527162533.541869018@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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
index 665cc277cdc05..6dded11a23acf 100644
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



