Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCDA1269B0E;
	Tue,  8 Apr 2025 12:00:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744113609; cv=none; b=D1YI4guj3vVwcIeq57RlqaGjIYL82Qis0/s9R3G67PNcspVpth6oPAkMB7hIQCuXrysXF3dW4VCsLBfGz+7rOO8LJm3PY519znlv+yFfMCiwBBpMxgZN6YU06D02XnXFVGS/3KSuL+zO3O7/V0tKWDnvQNc1kIX8GwKrVe0fNxo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744113609; c=relaxed/simple;
	bh=hTLULycph9HDdsauMotpAjaTa1IzXWRNsS+AXHQGhU4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dcb+lcRmnAy8j33VODXOxGzyUhfYc7v9o0DrcB3H+SHoLzps8hnHVzWCxnbgwre1Z0qYbTXSI6vVFVuYm3BM64C7Uiq2vol2/8tA6YaMVw29mHGHbWAyQD5hR+f57UM6/GPtlCx+jR0pvaF40LwOPX5k/SojsqhJJ18HRMfZl64=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s/ooySD3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s/ooySD3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AD96C4CEEC;
	Tue,  8 Apr 2025 12:00:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744113609;
	bh=hTLULycph9HDdsauMotpAjaTa1IzXWRNsS+AXHQGhU4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s/ooySD3XbRV5Q10ei+pYhBeriJ/ekqy3rQalrvTYgvP12SQ7Ft40Kgj2JS5d+KmP
	 UANiXnPjyMrBl48hV4g2+j3YWn6mv4CmoPtUuI/IrC66Q+avlRX8FqJWfiBfZa0o1n
	 LBbNYw4+Swe5f8nYUlVnmr/VU2vDESqDq1ZglVX0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sunil Khatri <sunil.khatri@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 222/268] drm/amdgpu/gfx11: fix num_mec
Date: Tue,  8 Apr 2025 12:50:33 +0200
Message-ID: <20250408104834.572648399@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104828.499967190@linuxfoundation.org>
References: <20250408104828.499967190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 54ec9b32562c2..480d718d09cb6 100644
--- a/drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c
@@ -1318,7 +1318,7 @@ static int gfx_v11_0_sw_init(void *handle)
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



