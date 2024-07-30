Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C848F1A6160;
	Tue, 30 Jul 2024 16:26:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722356764; cv=none; b=sGTmsjuavjfzghjz+7Q0a3ButtSVLQmozXaXhjojTXxvUC0XIz0YamUWUu5G50f4bfGlG0UODuOrzPudjWRDix1gQU/8zbzcUDKfaDO50UQuBbbrAmcSr8O7o4nMU+DD7aTQVc7imV8ehlH/wIe7Vu4/jjEdFo2rlhqedJuCxbE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722356764; c=relaxed/simple;
	bh=qpBGTrT+zPIf4w2PvpiFYlhqPRrnCtJDrvFUwf0rh6s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=db5EU+PO1zsVgD3G/uXYD7kXpsAGz6hzqlvNTScOYVmJfdDzwv+qLG3mUTm7dOKz8hUuvaNBahEFMIhjOhcpIE5JctZZ2FnM1LI8d+TZjlpA96BfxJju6bXZCrFEtYiFd4GiCT35VDuClzC5z1DibkDq0YId7ZXr5deqTavOzFE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W8z/G3Xk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W8z/G3Xk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 507B4C32782;
	Tue, 30 Jul 2024 16:26:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722356764;
	bh=qpBGTrT+zPIf4w2PvpiFYlhqPRrnCtJDrvFUwf0rh6s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W8z/G3XkjnP+Mn/Ph/mGCAiWlY+C1q8o6sbYtge25ipe3fcnWtYYgN6V3X4f6IHUm
	 3pnyNETzBdwxU9m3+keNil/4PPYmvZyLDxCvKNUbZc7LdgKdHvY1fn6Xa8G9+6j+M2
	 fCgLnUzX9P5xKoK1gJIjcSXeGotkotGtREeLHMkc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Friedrich Vock <friedrich.vock@gmx.de>,
	Alex Deucher <alexander.deucher@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 182/568] drm/amdgpu: Check if NBIO funcs are NULL in amdgpu_device_baco_exit
Date: Tue, 30 Jul 2024 17:44:49 +0200
Message-ID: <20240730151646.991895518@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Friedrich Vock <friedrich.vock@gmx.de>

[ Upstream commit 0cdb3f9740844b9d95ca413e3fcff11f81223ecf ]

The special case for VM passthrough doesn't check adev->nbio.funcs
before dereferencing it. If GPUs that don't have an NBIO block are
passed through, this leads to a NULL pointer dereference on startup.

Signed-off-by: Friedrich Vock <friedrich.vock@gmx.de>
Fixes: 1bece222eabe ("drm/amdgpu: Clear doorbell interrupt status for Sienna Cichlid")
Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: Christian König <christian.koenig@amd.com>
Acked-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
index e1227b7c71b16..ea1bce13db941 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -5645,7 +5645,7 @@ int amdgpu_device_baco_exit(struct drm_device *dev)
 	    adev->nbio.funcs->enable_doorbell_interrupt)
 		adev->nbio.funcs->enable_doorbell_interrupt(adev, true);
 
-	if (amdgpu_passthrough(adev) &&
+	if (amdgpu_passthrough(adev) && adev->nbio.funcs &&
 	    adev->nbio.funcs->clear_doorbell_interrupt)
 		adev->nbio.funcs->clear_doorbell_interrupt(adev);
 
-- 
2.43.0



