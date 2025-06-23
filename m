Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14321223DEA;
	Mon, 23 Jun 2025 21:52:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750715531; cv=none; b=acpRVuHDIPhE1DToaZ6+1i+kfixIqhDwmk0BI2KJI3wt4jth1Ou/bVWzWPXqK0hGZVyGhtVuP3znXxBWs20rF7DK8LAPM/M0LkjuV6cKidrDoKxuJdzhPixkeFoqOrBMQVwgV9cQJkc0e/G42JAFkbj7Rjk01Udb90ytuXwKNgs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750715531; c=relaxed/simple;
	bh=kwbe4nB+NhrPNroktFFl1SUcyRCn37LERCJgUpI3DRk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sM+ZY+Oe1VBBDa3+1GCqGDOLlFUMX7p85LoLDCoDSfVIy4ynTrBB+408dXfr9XcQKazdIqu5rJ341tDaMzSip3dayXJd0jTv1GtTzS1z4wOAUoQKE7N3YXyMVF5VVb8tYv5XE6R5QM9cyeqkROOmgGpPF7Xs/1y2tnqqO3NrT2Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a5Knxqx0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a5Knxqx0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0C1DC4CEEA;
	Mon, 23 Jun 2025 21:52:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750715531;
	bh=kwbe4nB+NhrPNroktFFl1SUcyRCn37LERCJgUpI3DRk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a5Knxqx0IQ+6+FAQ195d5orlOgdTzmYkGPPNMw+F2Rkj0VvRgHGa+QmwiEZE3M0yK
	 I04S/fX1+Ora4dhAlwav/VAUvHvjO9U8xhaRuAtI/UhaFbslcwF+Mg9BuSPpWf6g8P
	 HGSwvvZe5M5pTi2Mh/vnng3TqzBpxyZB79SMnDk0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rodrigo Siqueira <siqueira@igalia.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 283/411] drm/amdgpu/gfx10: fix CSIB handling
Date: Mon, 23 Jun 2025 15:07:07 +0200
Message-ID: <20250623130640.772562884@linuxfoundation.org>
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
index 938f13956aeef..d8926d510b3c6 100644
--- a/drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c
@@ -4438,8 +4438,6 @@ static void gfx_v10_0_get_csb_buffer(struct amdgpu_device *adev,
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



