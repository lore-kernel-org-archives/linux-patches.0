Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5C3116419;
	Mon, 23 Jun 2025 13:38:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750685893; cv=none; b=rXtznGN2P+Z/1sOnhZbYTLKKjQCyvd+XSn3jLyhNJsQ0XBgsIpyYmyYtgvcJMmI4d8x7wzOL7dpw28BFARljWaXkUinBS8Q+EqsxfIBIQmxUrQ5MMs/UlSnc+Ot6BhvXd39W0+S8S/zAudkXuezlCNGPW58Dm2a3ARGz5nXbN4s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750685893; c=relaxed/simple;
	bh=ui/ZYNbkycVknKeDnAZOvk2CdsCo8aw9jEzh7Rx4WVU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lyAg2I439RXYdwJ0e/C3sdYFIGnsCmMNloAQKfroSgcHF3TDKTori7V6BHsspcOi4koEqfx0gPOYcFg7FOpUOFWFjCenl3mu7M0/SYWmCZxnVCf65WhzJzKnyM6QsXgmMt8NVPUMBQKRBfaEwFsB4Aj9cgqg3nwRTJnQWT08fWY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uzBBYXeE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uzBBYXeE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7970CC4CEEA;
	Mon, 23 Jun 2025 13:38:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750685892;
	bh=ui/ZYNbkycVknKeDnAZOvk2CdsCo8aw9jEzh7Rx4WVU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uzBBYXeErN33AZbP+rbBY+yv4htHT8EttU1UN8RYGdTkvXKBItMMtIqYNXhRaSB0F
	 NSVnvfuGmur+4rq1BVH5G36voS2HtDZmut2wUP0JtHxwtKOHPHVR+8TFwnPAbOXi9l
	 9Ps6AZAHcThVAkkayrns91+nPrKkwISzMqC9JgvQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rodrigo Siqueira <siqueira@igalia.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 269/592] drm/amdgpu/gfx10: fix CSIB handling
Date: Mon, 23 Jun 2025 15:03:47 +0200
Message-ID: <20250623130706.719235295@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

[ Upstream commit 683308af030cd9b8d3f1de5cbc1ee51788878feb ]

We shouldn't return after the last section.
We need to update the rest of the CSIB.

Reviewed-by: Rodrigo Siqueira <siqueira@igalia.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c b/drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c
index c68c2e2f4d61a..2144d124c9108 100644
--- a/drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c
@@ -4322,8 +4322,6 @@ static void gfx_v10_0_get_csb_buffer(struct amdgpu_device *adev,
 						PACKET3_SET_CONTEXT_REG_START);
 				for (i = 0; i < ext->reg_count; i++)
 					buffer[count++] = cpu_to_le32(ext->extent[i]);
-			} else {
-				return;
 			}
 		}
 	}
-- 
2.39.5



