Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46F9C1A6192;
	Tue, 30 Jul 2024 16:40:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722357643; cv=none; b=GAjEw11rNXpl3jbZdpoIuADkUQZiEJOxaclO9dHN9t7slveTwkEVhWVc+3eLQ5LIvrASPzAsRqsD+BhqTEuKcL4rPcwmG9PONYA9bdUOexWgLnHP3pUj2T86bo3eWoVKRkwV1a9b22hpyZQ3Chjc4KTM9ywzu34oxu53ImSG+Fo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722357643; c=relaxed/simple;
	bh=CrJ7qIzU+lRXvnfFYZahqfCk+no86Bne4/d9JR2WHMg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PgWW+Q45uCp9hq+vy5knlFh72pt/h3tIrCz8MQaCNV+BPLrtmApghJ6KXvO27flKW5czdSST5Q6nrkA//9EqTQvtsW0vI11KvZCuurXPRQOe/rKANHmA4umqNJ1llRx/H0fMP80pKu3kmYZYgTwo+fj37n3SRJ5rFl0jkCFO1Y8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xIFJ3wzt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xIFJ3wzt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCCFFC32782;
	Tue, 30 Jul 2024 16:40:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722357643;
	bh=CrJ7qIzU+lRXvnfFYZahqfCk+no86Bne4/d9JR2WHMg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xIFJ3wztzkFJqSUvVyi6XfrQC2tAYoiiuNYz0Y5YNSgBkzeXsAE5XXTq1iGdLlIxZ
	 cId7kCAk+b4pOlmDCWy3f0jpFhWOJ6SHdXGoEWdDBO6ZXL3ASTnxhUDwi+L96eMqaD
	 t2DLCRCle8e02VELreXFN5lVQ5KUm7qrm4ydbvLQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Friedrich Vock <friedrich.vock@gmx.de>,
	Alex Deucher <alexander.deucher@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 275/809] drm/amdgpu: Check if NBIO funcs are NULL in amdgpu_device_baco_exit
Date: Tue, 30 Jul 2024 17:42:31 +0200
Message-ID: <20240730151735.455268249@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
index 33f791d92ddf3..ee7df1d84e028 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -6173,7 +6173,7 @@ int amdgpu_device_baco_exit(struct drm_device *dev)
 	    adev->nbio.funcs->enable_doorbell_interrupt)
 		adev->nbio.funcs->enable_doorbell_interrupt(adev, true);
 
-	if (amdgpu_passthrough(adev) &&
+	if (amdgpu_passthrough(adev) && adev->nbio.funcs &&
 	    adev->nbio.funcs->clear_doorbell_interrupt)
 		adev->nbio.funcs->clear_doorbell_interrupt(adev);
 
-- 
2.43.0



