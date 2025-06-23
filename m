Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84C711ACEDA;
	Mon, 23 Jun 2025 21:07:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750712861; cv=none; b=a6L8un0qKY3zWvZIRI+7qMoQKOz+aGzFOW1yRNw3McgaqJy28ltKINhJMaAoDppSxZdViC+jRp5eGsSGY0W5s+0cd6rPjBJ0vYVBnlYIqTd1GTR+MXyZ0i1N3VcbfhMwIIduH/WwlfGXOm2dVRYJq1L0qOD3NorYyy5V4w53xPM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750712861; c=relaxed/simple;
	bh=pi4S3PyJXmcyBppW1miKd80g8Uko0vCY5PfHeLoacIk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QPHxpp4GeGVgdWKq/U056eUvEj++hwdNeHKRmsub8pko8JJ9TvG7HkD7Foj7eovwWjWMvPIk7KOefsjB/1bL3qBsM6uwktT8XFeBEoCYupK5dpeMcMlLUko82mmZPPu8pYGIgOIViYzhJUsnfrUo2enkds/Q1YHZwb+R99rpaRI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fFX2E7gu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fFX2E7gu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D298C4CEEA;
	Mon, 23 Jun 2025 21:07:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750712861;
	bh=pi4S3PyJXmcyBppW1miKd80g8Uko0vCY5PfHeLoacIk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fFX2E7gutSWJCRQbTvxxjnOB6Ng4loU3TK8EeNb1G6OKZLN81tYd3FRkYLV9MP189
	 GGL+S7zT8jCGZGVsJHrdAmQmbAqVC2BT8y/epNjOGRAw7L/gVG28LOX95zdxyP38gZ
	 w3mzPbt5YE4DjVVgX/7P/fn37Cc/2UyioUaHl0bk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rodrigo Siqueira <siqueira@igalia.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 152/222] drm/amdgpu/gfx9: fix CSIB handling
Date: Mon, 23 Jun 2025 15:08:07 +0200
Message-ID: <20250623130616.656113654@linuxfoundation.org>
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
index 4eba6b2d9cdec..3e2fe8f2ccae3 100644
--- a/drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c
@@ -1472,8 +1472,6 @@ static void gfx_v9_0_get_csb_buffer(struct amdgpu_device *adev,
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



