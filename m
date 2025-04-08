Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5BB4268C6B;
	Tue,  8 Apr 2025 12:25:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744115103; cv=none; b=UYKdLDLgBdOH4OKAjh6SX/EQTK2tWd4AgJVWOI+J2q0AXr6EK0bK3XpBD+RPKdkCknh9nrJD3yf7+2qn7y/zQ7oW2mO1nFIC2Njje2Z0D8Y2QgfROAqSmrC+yRAu+cBomqfFEg3ENIxbRUy2yRKhjgGa++5exVmAoFKvnzk1imA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744115103; c=relaxed/simple;
	bh=4K9NdPqZhTd3xDErFqLC72zq3f9TnH3WEWG2t8UOsJ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FBP1pULw8Utc25+eaDx3Je4WBd2wg8+qyy9IRKZbk25ODACpKfZYwi8ziG1bA6AjGQetypby60ZJHXnUNAA+2XvB/zxCuGHCCyVnWzzwpFuGJ4qbs37zN9wu4MMwqCS0hxRO6XWWIJdUknmb3Q98xAQ3xO2Uy8Q+doOru8/Aafo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZTL4yFj2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZTL4yFj2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAACCC4CEE5;
	Tue,  8 Apr 2025 12:25:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744115102;
	bh=4K9NdPqZhTd3xDErFqLC72zq3f9TnH3WEWG2t8UOsJ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZTL4yFj2AnOM7ZuWWNASnHLSPb+uZiLVlaPHG8gnYFW8hG7P4OiVZ2XgVUNSa2Eod
	 wIFyxUtBpLS6SxVkF2Tguj0WNiGkgHA4TmBLi3NKJ57Pl8BMNl6RM7oFknWyS6/kL3
	 z/S2/I5FZ+CfBAdKDpNuRWi2BcZDpZfl81LWLGRE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>,
	Lo-an Chen <lo-an.chen@amd.com>,
	Alex Hung <alex.hung@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 351/499] drm/amd/display: Fix incorrect fw_state address in dmub_srv
Date: Tue,  8 Apr 2025 12:49:23 +0200
Message-ID: <20250408104859.980632220@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104851.256868745@linuxfoundation.org>
References: <20250408104851.256868745@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lo-an Chen <lo-an.chen@amd.com>

[ Upstream commit d60073294cc3b46b73d6de247e0e5ae8684a6241 ]

[WHY]
The fw_state in dmub_srv was assigned with wrong address.
The address was pointed to the firmware region.

[HOW]
Fix the firmware state by using DMUB_DEBUG_FW_STATE_OFFSET
in dmub_cmd.h.

Reviewed-by: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
Signed-off-by: Lo-an Chen <lo-an.chen@amd.com>
Signed-off-by: Alex Hung <alex.hung@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit f57b38ac85a01bf03020cc0a9761d63e5c0ce197)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dmub/src/dmub_srv.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dmub/src/dmub_srv.c b/drivers/gpu/drm/amd/display/dmub/src/dmub_srv.c
index a3f3ff5d49ace..9d2250d84f291 100644
--- a/drivers/gpu/drm/amd/display/dmub/src/dmub_srv.c
+++ b/drivers/gpu/drm/amd/display/dmub/src/dmub_srv.c
@@ -708,7 +708,7 @@ enum dmub_status dmub_srv_hw_init(struct dmub_srv *dmub,
 	cw6.region.base = DMUB_CW6_BASE;
 	cw6.region.top = cw6.region.base + fw_state_fb->size;
 
-	dmub->fw_state = fw_state_fb->cpu_addr;
+	dmub->fw_state = (void *)((uintptr_t)(fw_state_fb->cpu_addr) + DMUB_DEBUG_FW_STATE_OFFSET);
 
 	region6.offset.quad_part = shared_state_fb->gpu_addr;
 	region6.region.base = DMUB_CW6_BASE;
-- 
2.39.5



