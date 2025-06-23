Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FC714409;
	Mon, 23 Jun 2025 21:37:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750714679; cv=none; b=XjoaacVWLoP0NoJ6TYLwv2S51IpahI/K8WKIapE0V+LMeK4mf96b9T7EGwMU+kR4iqeqU+6So0bYTlN0vJXfNGtp1TRG4gRHV+AMHBt61SC1mKekJp/wTFTq///QKX97E94i3PqncGtideGVhbBBgjzfI3GNXT9cBAIGjZoocuQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750714679; c=relaxed/simple;
	bh=16dpxD8lAsO60ECWFUqm2srvFDxIVScKXuijJ0A14h0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OyHkqiMcK/IpQxjPG4xiaYdQJYy6wqJmhSyRynnMF5OMYBTBYXSAM/fwIXTqhFhesxh+lMP6SmKaLlE1bkMK8SyqoKMiALL7vLWXu+wgITmRFhO2rwap5wPwBL/zQkbjqL5QnLjLu7aJfMMQk257XPtePu7sKfgDqBXBzfEZTUM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lScSkHFa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lScSkHFa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16B69C4CEEA;
	Mon, 23 Jun 2025 21:37:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750714679;
	bh=16dpxD8lAsO60ECWFUqm2srvFDxIVScKXuijJ0A14h0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lScSkHFaRHMh51cmOmzTGHHRyTxZ/JwZ+08et9xDgSsfl1s5lFqM+CJKRNFe6yoOG
	 kW/Kr5rUAZ7ioS+Jpe7FAxWlZiwQiYj162fO4AtBAhE0P3bs9P30oAGwohablBBbTA
	 +be5LVwjXj7E+HwP/JiZnq08aEknX5o86Z3vShyA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rodrigo Siqueira <siqueira@igalia.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 222/355] drm/amdgpu/gfx6: fix CSIB handling
Date: Mon, 23 Jun 2025 15:07:03 +0200
Message-ID: <20250623130633.413942173@linuxfoundation.org>
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
index 79c52c7a02e3a..d447b2416b98b 100644
--- a/drivers/gpu/drm/amd/amdgpu/gfx_v6_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v6_0.c
@@ -2896,8 +2896,6 @@ static void gfx_v6_0_get_csb_buffer(struct amdgpu_device *adev,
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



