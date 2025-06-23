Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5306E1E22E6;
	Mon, 23 Jun 2025 21:54:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750715685; cv=none; b=YLDnfTO3v/ZqqjdvrEFhSLW+zJmeArqbiWjWrKW0iR3vl+rNvLCvIL4FcbXKTvZNABszuBhn6z03fvEwrvUewzpB6zXmG+jvHZAzV7BlFzCnv+D119GR8RUzYgjfkIw/4Jtkuib77+mNPSbh0ZGngPAA8CMw2C5gJwNzolDThgQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750715685; c=relaxed/simple;
	bh=4+rCPzgeO4qcYZQmquDI9VH0PEmU0kHjb8FDhFJsiQs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ep5PXicJzXGXCWtz9JzuQdq/cemlCsd9cbe20owFgwWsSIuRsS1cCJwzaI/G9wdbi0D5CL9lV827StvsVxNs7KeLOgBqeK433m8OZCtPz+mrECPylGNpq6tahIanI+qEmykFGDG33R7ByHEs21ty17xJHYcKspOLcexCOFi3j0g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S5tnZtf4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S5tnZtf4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0B69C4CEEA;
	Mon, 23 Jun 2025 21:54:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750715685;
	bh=4+rCPzgeO4qcYZQmquDI9VH0PEmU0kHjb8FDhFJsiQs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S5tnZtf4NLmKf1GIxBnK84+5fdCKAO+fYiRMqLaWe1N4Ck6/+zMqWVOEGxOMYQZMf
	 WZFceJRhwK5hHbtTjFbrFWly/kELJMIq0eV22+qwQ6BcS+LmT8yqyqakeABiqPZmHc
	 jnpDwc6xQSmrC+id/4xw24Ke381u3T+ctaENE8JI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rodrigo Siqueira <siqueira@igalia.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 272/411] drm/amdgpu/gfx6: fix CSIB handling
Date: Mon, 23 Jun 2025 15:06:56 +0200
Message-ID: <20250623130640.502276211@linuxfoundation.org>
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

[ Upstream commit 8307ebc15c1ea98a8a0b7837af1faa6c01514577 ]

We shouldn't return after the last section.
We need to update the rest of the CSIB.

Reviewed-by: Rodrigo Siqueira <siqueira@igalia.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/gfx_v6_0.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/gfx_v6_0.c b/drivers/gpu/drm/amd/amdgpu/gfx_v6_0.c
index 6a8dadea40f92..79074d22959b9 100644
--- a/drivers/gpu/drm/amd/amdgpu/gfx_v6_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v6_0.c
@@ -2897,8 +2897,6 @@ static void gfx_v6_0_get_csb_buffer(struct amdgpu_device *adev,
 				buffer[count++] = cpu_to_le32(ext->reg_index - 0xa000);
 				for (i = 0; i < ext->reg_count; i++)
 					buffer[count++] = cpu_to_le32(ext->extent[i]);
-			} else {
-				return;
 			}
 		}
 	}
-- 
2.39.5



