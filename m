Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE94D284B35;
	Wed, 23 Apr 2025 15:21:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745421672; cv=none; b=uS/6hOBbHD3QcUgYN75UnsrIxKBVBZNNbInONPPL6ycvhgzGkb23OP8vrN7nHk5SdEtAgst9GZmO0/yC7WZ43lytKsQ1qfp7EVzzZTPXl/NcleBV0MCkHSyxcvC7x28kY0JLP0zal0ufKWmIrBAsZZnBrMHE2y+Ui6GuL0QVyWs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745421672; c=relaxed/simple;
	bh=iGFFPZMkXRC6W7SjEcomS+WFVrwtqzpbjwdK/SiogQU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RNfCshqBZ6o5blsIzkXfMmFAhwsRJpaMTEqpu3VT+qAIz0FQ4HBt6RKQDM67Wnoqz/fYJH6dEzLUc5UeT2jeIOo6GCXFphqWyXb8K5aaYNQoWEX6l9AmKTj8oDN0jju8eQMfuacipe4vnW7rpXkSiPGBsPrYhaMq4xi7K8K+T1U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0Wr7W4H/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0Wr7W4H/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15B72C4CEE2;
	Wed, 23 Apr 2025 15:21:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745421671;
	bh=iGFFPZMkXRC6W7SjEcomS+WFVrwtqzpbjwdK/SiogQU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0Wr7W4H/sKjYp/+73JrdWKnjVY+avs8hZqSApfyEHNcNu1I/Df3jv1s6KtiMsumON
	 UTr/1Bu9jHzH/rH4buKXfriNnI8OnDtx5ByOyTzoEbjC/VdMIpowjGHfPQzZuibRPL
	 Xv0anSWiVHhJi8TZBc93jUAcVtiUeHuwu8+hsLdw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	ZhenGuo Yin <zhenguo.yin@amd.com>
Subject: [PATCH 6.14 218/241] drm/amdgpu: fix warning of drm_mm_clean
Date: Wed, 23 Apr 2025 16:44:42 +0200
Message-ID: <20250423142629.466208746@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142620.525425242@linuxfoundation.org>
References: <20250423142620.525425242@linuxfoundation.org>
User-Agent: quilt/0.68
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: ZhenGuo Yin <zhenguo.yin@amd.com>

commit e7afa85a0d0eba5bf2c0a446ff622ebdbc9812d6 upstream.

Kernel doorbell BOs needs to be freed before ttm_fini.

Closes: https://gitlab.freedesktop.org/drm/amd/-/issues/4145
Fixes: 54c30d2a8def ("drm/amdgpu: create kernel doorbell pages")
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: ZhenGuo Yin <zhenguo.yin@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 39938a8ed979e398faa3791a47e282c82bcc6f04)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -3442,6 +3442,7 @@ static int amdgpu_device_ip_fini(struct
 			amdgpu_device_mem_scratch_fini(adev);
 			amdgpu_ib_pool_fini(adev);
 			amdgpu_seq64_fini(adev);
+			amdgpu_doorbell_fini(adev);
 		}
 		if (adev->ip_blocks[i].version->funcs->sw_fini) {
 			r = adev->ip_blocks[i].version->funcs->sw_fini(&adev->ip_blocks[i]);
@@ -4770,7 +4771,6 @@ void amdgpu_device_fini_sw(struct amdgpu
 
 		iounmap(adev->rmmio);
 		adev->rmmio = NULL;
-		amdgpu_doorbell_fini(adev);
 		drm_dev_exit(idx);
 	}
 


