Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5EE21F3B96;
	Mon, 23 Jun 2025 21:35:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750714504; cv=none; b=rPaJTly32JN9CMdiJpwwd3DVt0qs/CTn3HjeBhPwxG9Tbo7ujuVKqVuDWBbc+yv7GAXWukNZXF6yE+VXYKeXgeS0PNgbLeThmk/QMtZBPj6KmmhfJvXnCQSqFXqLVBMZwaff8WxvJbV1Vc3AGGHn4cYUaMicBPzFXSQwajEzRM8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750714504; c=relaxed/simple;
	bh=O/nBWYeeEoCLrBPV0sfSmN8LymdF6wMKCmaKGeyEL34=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g92cXOubrrFcMNMrGqpoDhh0IHOtB79oWRW91M2CA+N2FthaGiwpVA0rcGsDIwVU3fgYb8ycKgMqDXqHiutB48JFsEEok4uqC/d7PgDwL6n7oa8KiKCVolJLDTqzUtT6w+5NtmWcSwE34q4836ozT77NI3mKQ2/g4y2nwAA0bUA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fQ6DKwzN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fQ6DKwzN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E154C4CEEA;
	Mon, 23 Jun 2025 21:35:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750714504;
	bh=O/nBWYeeEoCLrBPV0sfSmN8LymdF6wMKCmaKGeyEL34=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fQ6DKwzNPR1m4+c1oQO3mP/+PP9aZxgh/fr/MUNpNJCS+xylVTn8dgqlidI1yz2AZ
	 6FFXisw54sQIASHPzOZCJPHQnfbU7fFQQ0JJtNueC6g3XfPwTTh9dhT2RsPHRpPNeJ
	 OV1txYW5chRpSpWnOaWpVBlW8sBtnD0fB8FMR3eo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rodrigo Siqueira <siqueira@igalia.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 232/355] drm/amdgpu/gfx7: fix CSIB handling
Date: Mon, 23 Jun 2025 15:07:13 +0200
Message-ID: <20250623130633.725214664@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130626.716971725@linuxfoundation.org>
References: <20250623130626.716971725@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 04eaf3a8fddba..d6f3d3cfc19ff 100644
--- a/drivers/gpu/drm/amd/amdgpu/gfx_v7_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v7_0.c
@@ -4000,8 +4000,6 @@ static void gfx_v7_0_get_csb_buffer(struct amdgpu_device *adev,
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



