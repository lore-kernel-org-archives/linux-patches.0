Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F19B5222576;
	Mon, 23 Jun 2025 21:59:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750715966; cv=none; b=Kj8/7cq+LKZkG5Bx+Oj8FkM9LwarcKhPKLk5oaPlHKrjJtQvVpxhaKRjpsMt79PG2ONg6lmBC0UvQeMIzFDanRydrrOIzJNjM5uRC0HFOi1hMvGNPUYW7G7dmCvlLkj01a6KVwdOJR2X8JWRIpP7Ne+RNC9iGG1jSWviLnq24ys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750715966; c=relaxed/simple;
	bh=QNXo1sKId2qqa4jx8weaWl3DlgH1ZiFyPJSmXIMn9pI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P31sALmL2O6mHflL3MncpXHo7yg6U5uk5L+IsBJCfavtHpoIqCHmSPh2lyTNkNSWVo/ro8DzOrpyAu2GwZPSQH3DkWq4vIDwgb7UBp7HqtFgb4BqOkY6eb1T5iKPUz1WP4kJBJKzOciF4MilgDLK9aZyOAZbH9mgoTeu+QZ7tNw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RNNSQpFC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RNNSQpFC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C44EC4CEEA;
	Mon, 23 Jun 2025 21:59:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750715965;
	bh=QNXo1sKId2qqa4jx8weaWl3DlgH1ZiFyPJSmXIMn9pI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RNNSQpFCfMRkcbUZJNpA8/kflpNEDGC+a1vOaYzsGPQ9EUxz8iGhodfuCMA8VbI3/
	 d+5nbXLq5c6GC1DtLcks7JIJW6X2RKlPO4IlApSxquPCtsxPiyDWEE3+A5FpGQGcx4
	 U5j1l+K4L2/0nhOjl8De2YxrvW5gN6Je6tRrDNug=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rodrigo Siqueira <siqueira@igalia.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 294/411] drm/amdgpu/gfx9: fix CSIB handling
Date: Mon, 23 Jun 2025 15:07:18 +0200
Message-ID: <20250623130641.052275261@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130632.993849527@linuxfoundation.org>
References: <20250623130632.993849527@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

[ Upstream commit a4a4c0ae6742ec7d6bf1548d2c6828de440814a0 ]

We shouldn't return after the last section.
We need to update the rest of the CSIB.

Reviewed-by: Rodrigo Siqueira <siqueira@igalia.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c b/drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c
index 811cacacc2090..6cc382197378d 100644
--- a/drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c
@@ -1782,8 +1782,6 @@ static void gfx_v9_0_get_csb_buffer(struct amdgpu_device *adev,
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



