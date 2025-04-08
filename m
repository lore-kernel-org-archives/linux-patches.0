Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A2A6268C78;
	Tue,  8 Apr 2025 11:33:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744112021; cv=none; b=MxyROBAl7tLEx4vH+4WoAu1RSJ/pOFpJqk7avrm1EX9gMokKnc2dYHhCnKczbret9HAq+q8n7oMKnIcYbYHDLTebuxB04+OqUYL6NPvwF51xhRyiWTskOtPbAnS7kft0DxVmY4oddQAOD/5bFg9Gc6z6lAZ26IgIbJ82chLeWc0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744112021; c=relaxed/simple;
	bh=olfEgpTmeCJZqR7Ty7f+7yzmY9GgoIOr2D/iu9omOKM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DVcF8NlkNu/PCvPbHobqDlDBnd2Zv7qKVTYFxXWgYJMiq5t65MhoKHJEn2iV1cYLcymgQelARvpSYsmHJCHw7UG0f6hUQLocboXzxOjxIy04v3VJkmuo8hNefWBc1XOWRttBa85HdIhuVaHoE2YYfYAXgGM/nC5pgEMovERJimU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pA+jbUTa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pA+jbUTa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDCE8C4CEE5;
	Tue,  8 Apr 2025 11:33:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744112021;
	bh=olfEgpTmeCJZqR7Ty7f+7yzmY9GgoIOr2D/iu9omOKM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pA+jbUTa2a7aF6nWGUJbngNNcDuxo5V/sa/yfpMjajpSd1pq48Np5jbJ8l7y/kLPP
	 7JkyxpuaPIEmf0yyPC14le2krRZUMK3Jq78hrM+kNMEKLLTjWBkvuJy5zH4vBLbm7R
	 gPDYkXMsxx/0/T7dsUI0gjS8HpO2Dm5I7WuulpAY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sunil Khatri <sunil.khatri@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 647/731] drm/amdgpu/gfx11: fix num_mec
Date: Tue,  8 Apr 2025 12:49:04 +0200
Message-ID: <20250408104929.314836068@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

[ Upstream commit 4161050d47e1b083a7e1b0b875c9907e1a6f1f1f ]

GC11 only has 1 mec.

Fixes: 3d879e81f0f9 ("drm/amdgpu: add init support for GFX11 (v2)")
Reviewed-by: Sunil Khatri <sunil.khatri@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c b/drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c
index 56c06b72a70ac..cfb51baa581a1 100644
--- a/drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c
@@ -1559,7 +1559,7 @@ static int gfx_v11_0_sw_init(struct amdgpu_ip_block *ip_block)
 		adev->gfx.me.num_me = 1;
 		adev->gfx.me.num_pipe_per_me = 1;
 		adev->gfx.me.num_queue_per_pipe = 1;
-		adev->gfx.mec.num_mec = 2;
+		adev->gfx.mec.num_mec = 1;
 		adev->gfx.mec.num_pipe_per_mec = 4;
 		adev->gfx.mec.num_queue_per_pipe = 4;
 		break;
-- 
2.39.5



