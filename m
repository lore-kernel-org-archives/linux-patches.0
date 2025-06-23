Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48AA1219E0;
	Mon, 23 Jun 2025 21:06:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750712800; cv=none; b=IaOqHFK87AE2E9cPZXJQltDytteuVAV8h9QQvsjTcNp1WHF1JBduoKIEr1XDjCcsWIjaJ3G+EkRoFH0XoNjXrZMIndqXCAE+GhLaP1fuwFoPqHX1vLwEXvrtXHuM0u/hAbCh7qkXySnq2JdF2zxVG19veKq3faresuW9NEUrNkY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750712800; c=relaxed/simple;
	bh=AZgS98R8PjjQnzb4Q1B22d+lOC6u++fnUHE+u3m/ksQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jD7TaK1v2weotEiucGXxXHqUr4c6dNUbNf91r68r5J6zptKS82WJK3Wpqk7QIJk4mSAOXPHcWrHlaY0pzQhDRMHoRy+f/W5IbE+pEYfpDFKMPBH42wPK/T0FZz5GANjSQicNm3f5yKSLxY7b7MuknhRPkzAKrlmQomCVjBu96hQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZIOZR9fM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZIOZR9fM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D38FAC4CEED;
	Mon, 23 Jun 2025 21:06:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750712800;
	bh=AZgS98R8PjjQnzb4Q1B22d+lOC6u++fnUHE+u3m/ksQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZIOZR9fMzV4tet0wCyzK48BZW1ELIC6jUj8GatGu2nZ8NOphxhHc8X+vMnMrMKKUP
	 7J5GLRuBtG+mQEkfBsN9wYrXqbYYvxgT8sxn84EUFQ9cognANA7LGifwm0e1bWaQr0
	 uzVvg7hbupZNciaMn+asxEPj9sizhL8dxuFwCadM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rodrigo Siqueira <siqueira@igalia.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 149/222] drm/amdgpu/gfx7: fix CSIB handling
Date: Mon, 23 Jun 2025 15:08:04 +0200
Message-ID: <20250623130616.569366552@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130611.896514667@linuxfoundation.org>
References: <20250623130611.896514667@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

[ Upstream commit be7652c23d833d1ab2c67b16e173b1a4e69d1ae6 ]

We shouldn't return after the last section.
We need to update the rest of the CSIB.

Reviewed-by: Rodrigo Siqueira <siqueira@igalia.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/gfx_v7_0.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/gfx_v7_0.c b/drivers/gpu/drm/amd/amdgpu/gfx_v7_0.c
index d92e92e5d50b7..c1c3fb4d283d7 100644
--- a/drivers/gpu/drm/amd/amdgpu/gfx_v7_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v7_0.c
@@ -3992,8 +3992,6 @@ static void gfx_v7_0_get_csb_buffer(struct amdgpu_device *adev,
 				buffer[count++] = cpu_to_le32(ext->reg_index - PACKET3_SET_CONTEXT_REG_START);
 				for (i = 0; i < ext->reg_count; i++)
 					buffer[count++] = cpu_to_le32(ext->extent[i]);
-			} else {
-				return;
 			}
 		}
 	}
-- 
2.39.5



