Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A1801494DB;
	Thu,  5 Sep 2024 10:04:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725530677; cv=none; b=aabPoybvYnWY6GoNkCk4s9pI45tCG+J0TMsIRWXSc/EJ5Q9mmkLFiRfxycz9RcRT8TH+kgk+PenVbUjk87agkRMMpUpuj7mUtZBx/DEmsulgXZqiETpc9fIbcDmCy0k0A8xYJl/gPIft4yJDm4vqcgdTc91+oSQdRvTOQrWDa5w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725530677; c=relaxed/simple;
	bh=iHFAMq3xULQQcYlqSns3XDagH0sz5dwZj0+7x7HoXHQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P2oi5W3zPHS2E8fwvkh3j9ife05VOLmpNiHLWn53uCFPIC5/bQLxNsJo3/1dLjpgHjUAgx9+fEUQa0DvBj5MiCWrYHoWH/TGgT0Jtidrg47eDx9v6QlU+D7IoTBQ3VJ1R5D4mSC+U3uZz5+HQ0J5kHdBbIrkXdl+ETS8GFqMyS4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=id+NOQ2O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="id+NOQ2O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 903A2C4CEC3;
	Thu,  5 Sep 2024 10:04:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725530677;
	bh=iHFAMq3xULQQcYlqSns3XDagH0sz5dwZj0+7x7HoXHQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=id+NOQ2OUcyU+LkYGeF3PtEv8D5ICZZT/JDSzs/EyW//I2Py/sWpUXWiMS+BXQPeq
	 05ZZLZZ8XYv6s36lDaVbuBA/+/LbVZlCWS7EEvBn6FRUZe1CdRGrL0vyITOjZs+KmE
	 n0B521GAYrtVuxzZ5McpENVPKZF3oP5l6bD0KjU4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jerry Zuo <jerry.zuo@amd.com>,
	Zaeem Mohamed <zaeem.mohamed@amd.com>,
	Wayne Lin <wayne.lin@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 091/101] drm/amd/display: Correct the defined value for AMDGPU_DMUB_NOTIFICATION_MAX
Date: Thu,  5 Sep 2024 11:42:03 +0200
Message-ID: <20240905093719.686701666@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240905093716.075835938@linuxfoundation.org>
References: <20240905093716.075835938@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wayne Lin <wayne.lin@amd.com>

[ Upstream commit ad28d7c3d989fc5689581664653879d664da76f0 ]

[Why & How]
It actually exposes '6' types in enum dmub_notification_type. Not 5. Using smaller
number to create array dmub_callback & dmub_thread_offload has potential to access
item out of array bound. Fix it.

Reviewed-by: Jerry Zuo <jerry.zuo@amd.com>
Acked-by: Zaeem Mohamed <zaeem.mohamed@amd.com>
Signed-off-by: Wayne Lin <wayne.lin@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.h b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.h
index 2c9a33c80c81..df18b4df1f2c 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.h
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.h
@@ -49,7 +49,7 @@
 
 #define AMDGPU_DM_MAX_NUM_EDP 2
 
-#define AMDGPU_DMUB_NOTIFICATION_MAX 5
+#define AMDGPU_DMUB_NOTIFICATION_MAX 6
 
 /*
 #include "include/amdgpu_dal_power_if.h"
-- 
2.43.0



