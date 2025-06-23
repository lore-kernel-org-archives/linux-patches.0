Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 601511AD3FA;
	Mon, 23 Jun 2025 21:56:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750715807; cv=none; b=fDQB/hUHTdrVoiL8WZp9dctwt59azTD2Wp7LZWxxoa1XB86NyyQ9G4hzAUXHMybQQ+ZbmT9uFpQlWqQVwwnlAM7k3PlqWbQELRXh2ZAVKENHO4x9f74fcs4nDabYo4HIkTdQgLj1Df38O9NYxXjazRC72TqJ3SsUg5ilQ7p6gIc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750715807; c=relaxed/simple;
	bh=DpTXsGOY8YcZoPv+/aD4FF8I9T/638ihWlTQdmpITdE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jXAnqcBHNg2SP4SH4vH3btstNZaw6TI2P0usCV6OHJWjBncFkwvkhA/akpzreilz4lDAnIi9wdFunkJX4S51u08xwKFNrdMKLQgcis+Mme3RGeyXYZCPGR/5y8+i9gqbdAgVvhHl+awEkzfG0zdBUsDeKEvPoQjHyRoxxqnsZ4M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fxC6OIf0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fxC6OIf0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDFAAC4CEEA;
	Mon, 23 Jun 2025 21:56:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750715807;
	bh=DpTXsGOY8YcZoPv+/aD4FF8I9T/638ihWlTQdmpITdE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fxC6OIf0phDrMO/8xOihUUjozHbOY9+6DcyS6ctWrw3XyttdPrtDsOd4GXaK6Bxlt
	 DDlNukZr07xYfNrn8c+yUYajHZNkl3czi66u+yJe/js2vxX0fIIX7dNurJXK8P7t9d
	 /QM2yrtS4ueeiavD7RlCTlOrmHMmIguydwym7zac=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rodrigo Siqueira <siqueira@igalia.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 286/411] drm/amdgpu/gfx7: fix CSIB handling
Date: Mon, 23 Jun 2025 15:07:10 +0200
Message-ID: <20250623130640.847515289@linuxfoundation.org>
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
index 37b4a3db63602..b6e5599c8b3cd 100644
--- a/drivers/gpu/drm/amd/amdgpu/gfx_v7_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v7_0.c
@@ -4005,8 +4005,6 @@ static void gfx_v7_0_get_csb_buffer(struct amdgpu_device *adev,
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



