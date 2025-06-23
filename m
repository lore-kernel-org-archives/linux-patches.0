Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71D7C30E84D;
	Mon, 23 Jun 2025 13:34:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750685693; cv=none; b=XSIumo3JQTY29G+gRj8MGc1lkBiFfdIa6K4CCQ76md40n+VZHXhGFT0rh3mcDY9yfUSYO7gDcuWg0R3ZrVrAgF2Sb7UXkvCWL6t9LjfDU3ZEjUnk4OyVPepYgTsKKgCkqrEJ9DGdK6Zd8zH/4BvMoI6ogEJpJv8SvaHfXZGhz1Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750685693; c=relaxed/simple;
	bh=f5EPCf15JFrzC0M26dDpyY2vNVp07lJKu3c44nTeamc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qinUndzaaVdSpy/9JhFS2blViWZBBHm4GdcrZTmuW9MM9M5Dh7C/EvR8SFfNPqof41NaLG5fPkVkFr7HBAaDr7xZs1upSeIJ21OF+tPz/GpS20/I+XvP9k0eBlwf3vIDN5f1dbmnHi79i36+UyLPQ0+dc3VBpJHuOpX1FOqeimA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=03OaZYa/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="03OaZYa/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A41C7C4CEEA;
	Mon, 23 Jun 2025 13:34:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750685693;
	bh=f5EPCf15JFrzC0M26dDpyY2vNVp07lJKu3c44nTeamc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=03OaZYa/TpZqsJ/+/PxM+3Om8CmH/2bocVCB2jpN3PzO9STLQG3VtOnSSUqIglY4f
	 cKrfsQsIO4y0LJjpzxC4KIWXZ/QcUGxeOJirFRgHUzyOF7sz1susYg0zRPxxCcapTf
	 oEf9ALkbJJqaevw6Sn89tnJ8KdM5IGjTGKDbp8Eg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rodrigo Siqueira <siqueira@igalia.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 253/592] drm/amdgpu/gfx11: fix CSIB handling
Date: Mon, 23 Jun 2025 15:03:31 +0200
Message-ID: <20250623130706.315012143@linuxfoundation.org>
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

[ Upstream commit a9a8bccaa3ba64d509cf7df387cf0b5e1cd06499 ]

We shouldn't return after the last section.
We need to update the rest of the CSIB.

Reviewed-by: Rodrigo Siqueira <siqueira@igalia.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c b/drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c
index 2a5c2a1ae3c74..914c18f48e8e1 100644
--- a/drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c
@@ -859,8 +859,6 @@ static void gfx_v11_0_get_csb_buffer(struct amdgpu_device *adev,
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



