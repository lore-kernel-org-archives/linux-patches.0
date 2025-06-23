Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BC03219E0;
	Mon, 23 Jun 2025 21:06:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750712784; cv=none; b=G0+htnwizPHKiLCV+nBmwXyzmy54TPF4Iaz4Akn73c4XWPqvllQmH4Sn9dY14/Wl1SlPsWJUXyDlcYff2kwm+pBPA15ohdpA+0QMNJxMmDPKpIWhrZIzshsAf/R+USa/xC8yZz1kFEmXq8IkCPe3c369i5N1z04WnX1MhQywvDg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750712784; c=relaxed/simple;
	bh=xtooUyOPRY/TJ5kASzT2uml8zWG6QT96xA1yQEUXQsc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HnBBUgUceYL/5jh2TeIi63dvn0QJ6heZIZIpuWFbQ8jorraxSdIb+RyvaxjUF0TPTe1qHS1boVoqzOTEqT/F+TkBPgkodYYN6zM0pOeIKdnrLP40GVkZTt2dB40KEgXStrlpFlY3B1t3KEple/leQEK5gGnfWUslVzJygtEGOZw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TaHhg7zf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TaHhg7zf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 029F2C4CEED;
	Mon, 23 Jun 2025 21:06:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750712784;
	bh=xtooUyOPRY/TJ5kASzT2uml8zWG6QT96xA1yQEUXQsc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TaHhg7zfInrvx8wsf6BQkSQ8A46cejoFT6iqva+C+smqOyho3EUBdqk75QZXQ6hqY
	 z9ugoV+jqRqXvFAF+5hXn6nqwxt6Kh0tUkEQ0B+FeygFpAHAMUJ8IoS6RQd+tGtNfN
	 70yeIxY0LPZHdkI+plP6K7Sn1o50ftLnrRW6/6K4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rodrigo Siqueira <siqueira@igalia.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 148/222] drm/amdgpu/gfx10: fix CSIB handling
Date: Mon, 23 Jun 2025 15:08:03 +0200
Message-ID: <20250623130616.539431148@linuxfoundation.org>
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
index a84deb3c79a30..44380923b01c8 100644
--- a/drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c
@@ -944,8 +944,6 @@ static void gfx_v10_0_get_csb_buffer(struct amdgpu_device *adev,
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



