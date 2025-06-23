Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 791522571C7;
	Mon, 23 Jun 2025 13:36:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750685779; cv=none; b=Ltd5RnPJtZY/m+hf9h3AbPQ2UBxMTW1BDs2hlNmYbpH3rk+ySo/6/ENmRtQWbh34UqziySAzeqvcCmRcMp7zUShUfqUJlKZ23V3TJ3SiTniSJ+aOouzro9Fqm4bWNeXmWn0coJu6FVa4yaXmzx96Ig7Edn3vLvqYGIfgRzCHOfY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750685779; c=relaxed/simple;
	bh=y54MY31lJJrf4MWyDIgqb68yhj+IGeSRkpZJb3+WSrg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DzXt4b9zKf378L77f+nKk1LpLbsbGBQ17t0v0/+bBLkkOcJHsz57bob2qOjOcKgmWe/CXdJ6Z45OW7sVn2FrNC/M9B07eK9+V8gMyClhlP3Tfy0n3UqeIHAZbVbgsHFQdawON58kb6pEaSFZrusxcCDyUSCcxp+gnSWkVk3qxtI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SQiSjzhH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SQiSjzhH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06CB0C4CEEA;
	Mon, 23 Jun 2025 13:36:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750685779;
	bh=y54MY31lJJrf4MWyDIgqb68yhj+IGeSRkpZJb3+WSrg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SQiSjzhHwZP9B7lxgwbBONHxBVhE8K9eN9+tqHmRV9nTILOzjGH57YFEf07f92zuZ
	 YSjKY/aqon8giZ4TW6bJ3c+b2r1yYmETxrSZTVO+GiP6URrt2a09Kv4j+068KIg/Ia
	 8nBxmmNYbamG2BPlgtXzEg1K0EXRXq7UGOjb5CVA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rodrigo Siqueira <siqueira@igalia.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 141/222] drm/amdgpu/gfx6: fix CSIB handling
Date: Mon, 23 Jun 2025 15:07:56 +0200
Message-ID: <20250623130616.330663363@linuxfoundation.org>
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
index 7f0a63628c43a..eac329fe27902 100644
--- a/drivers/gpu/drm/amd/amdgpu/gfx_v6_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v6_0.c
@@ -2901,8 +2901,6 @@ static void gfx_v6_0_get_csb_buffer(struct amdgpu_device *adev,
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



