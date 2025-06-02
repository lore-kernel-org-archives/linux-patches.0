Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC9B5226D02;
	Mon,  2 Jun 2025 15:12:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748877126; cv=none; b=PZtyJkwNUfAAqbTAvFqvBjJM1uS/+A7ciqYvi91zCM9hS4QeLr7c6auIXMwaXevYDG7LEhL0emSmzzacE+pKWTCm1mGWhJTEq5ZerF0H2Y8sADwuIyD4F9YuIP9YolTC+la5kp++pX6THoATtwUNn8dP8G8zABIlIda2MxdBq7E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748877126; c=relaxed/simple;
	bh=UoI6/I6w4tUR4sk4a/CFU/5nqigBmbGBakYEP2h+8P0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SanY3Kin7Pb7mQ+y/a/+/jvMGT4NuB1a57yAzvpafgKh6y7UN5peQEDLFCfclMh6K5Iw2NhMg8zZItKnG1WTsPvJFxGM4s1n36mxKDBM/sAuOXyZlq/SJwp+UzW4sg/GmOhPij4I2aR81QJsRLXmbavf+dsoa9uL3CbdBTV72g4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PqNu0wvD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PqNu0wvD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D1C1C4CEEB;
	Mon,  2 Jun 2025 15:12:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748877126;
	bh=UoI6/I6w4tUR4sk4a/CFU/5nqigBmbGBakYEP2h+8P0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PqNu0wvDEeiOx8j3GxNGSFy9BUuGIQ93lp6iDXExTmZpE8vKFfEzDmoE3zTHXRsKG
	 Y5S6nmHcTC83UxcBlmInwNWjMZHdg4TCD40BjnfSdZqT4aJpAdmUKPoyev776htUUC
	 AE/9j4YvDgXutUfe1mknPajrmvmKTqknTo/KH5cc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shiwu Zhang <shiwu.zhang@amd.com>,
	Hawking Zhang <Hawking.Zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 181/325] drm/amdgpu: enlarge the VBIOS binary size limit
Date: Mon,  2 Jun 2025 15:47:37 +0200
Message-ID: <20250602134327.167656889@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134319.723650984@linuxfoundation.org>
References: <20250602134319.723650984@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index a176b1da03bd3..ae6643c8ade6c 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c
@@ -43,7 +43,7 @@
 #include "amdgpu_securedisplay.h"
 #include "amdgpu_atomfirmware.h"
 
-#define AMD_VBIOS_FILE_MAX_SIZE_B      (1024*1024*3)
+#define AMD_VBIOS_FILE_MAX_SIZE_B      (1024*1024*16)
 
 static int psp_sysfs_init(struct amdgpu_device *adev);
 static void psp_sysfs_fini(struct amdgpu_device *adev);
-- 
2.39.5



