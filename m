Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590510;
	b=AH9YKXE8Jq13Xk2eoMvdXRpBg+nTmdwVp8qIU4qKiPYsa4vxadnaU1bWuZH863CMagWA
	 PNUdHyXd4p1WqkO7PLi6H0QZpMbMpNWRt6CEORCUZAyvn6w4AloldnLmhMKc8hYgDdtui
	 Cu69DGrJBDCXnaA/dVbPIzjD/87uLAj12YRX/F0P/XTOzcR6chUizVkcPjTlCJTEuy4CM
	 wVCBH4N7DWIn9Uyjvt+c3jIle2rDzcIScteQZuxIUW0tb8N7YtCANhz3urijx5Wkn8FfK
	 k/FY0KDny4zVA0QSO0uV6uGEKF0D76Shm07gnStroiWKtKeol2Re7SoMvbcRei07cmw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590510;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=cF6UMq9iyOgHUqVIJJhdof58eFOa2c5yyR+qHXwABe4=;
	b=pYzbpt7BUESJ2lo9ukrkWY+kGTGDcWIjjHsdu1a3Clrmgbaxm1GKubzmA2Y7CL7vPRiU
	 bmLHA60Jom9auRRR2bXPKnBlh9c4otQo7JKb0+f0lGTqgfwD/5RZv+63iCq8mRh5aO/6t
	 +jFEazDHfo9njX9d4BMy6ZjDVzHWtQDOMiTUS8rqsAe2RmMWOxKKoMPDfFLqFEL/yezoF
	 EhZJsKBInU9+mxMXwKPG80AacEVBuP90ZUQUUxh5XzNBtogFOjUAgXru+ywob60ASROHF
	 Js+ILlcsxkviP+YDdmJRpftWCpbJIf/gDmYgU0mINR3Kp6PX0WSUcLJg1L+UKWHh0TQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kxbIhIin;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 099B3606B35B;
	Fri, 13 Nov 2026 17:21:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kxbIhIin
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A902B1F000C4;
	Fri, 13 Nov 2026 17:21:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590509;
	bh=cF6UMq9iyOgHUqVIJJhdof58eFOa2c5yyR+qHXwABe4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kxbIhIinbKhvhUHEf22vU/lTOoWi/27SGo6UEBc2z1fRzxTQ4zA7SFGCMyR67+eOO
	 DNYjPs+AQ6IXMfQmX7cr2q+N6vE56uoGvgsgu7a9s0XV7GCJobpEB350GQKDsn5mBT
	 1+tGtv+EAcpBOYkmPnigGi9jbgHYeUbRGFO3n8rU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>,
	Erhan Bilgili <erhan.bilgili@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 413/686] drm/amdgpu: Report MES ring wait timeouts.
Date: Fri, 13 Nov 2026 10:49:06 -0500
Message-ID: <20261113153834.966359360@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Erhan Bilgili <erhan.bilgili@gmail.com>

[ Upstream commit 122e864861144150e905012b5fb52e63ad5de68d ]

Return -ETIMEDOUT when the fence wait before submission expires instead
of reporting success without submitting the packet.

Fixes: 34e087e8920e ("drm/amdgpu/mes: fix mes ring buffer overflow")
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Erhan Bilgili <erhan.bilgili@gmail.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 34341594a87b4a3f28be41e3e70a4787f02b3d9e)
Cc: stable@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/mes_v11_0.c | 4 +++-
 drivers/gpu/drm/amd/amdgpu/mes_v12_0.c | 4 +++-
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/mes_v11_0.c b/drivers/gpu/drm/amd/amdgpu/mes_v11_0.c
index d5cc32fa78485..f73b41b4be7e3 100644
--- a/drivers/gpu/drm/amd/amdgpu/mes_v11_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/mes_v11_0.c
@@ -207,8 +207,10 @@ static int mes_v11_0_submit_pkt_and_poll_completion(struct amdgpu_mes *mes,
 	r = amdgpu_fence_wait_polling(ring,
 				      seq - ring->fence_drv.num_fences_mask,
 				      timeout);
-	if (r < 1)
+	if (r < 1) {
+		r = -ETIMEDOUT;
 		goto error_undo;
+	}
 
 	api_status = (struct MES_API_STATUS *)((char *)pkt + api_status_off);
 	api_status->api_completion_fence_addr = status_gpu_addr;
diff --git a/drivers/gpu/drm/amd/amdgpu/mes_v12_0.c b/drivers/gpu/drm/amd/amdgpu/mes_v12_0.c
index 7d7bcf1c69f27..5e438d5896df1 100644
--- a/drivers/gpu/drm/amd/amdgpu/mes_v12_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/mes_v12_0.c
@@ -192,8 +192,10 @@ static int mes_v12_0_submit_pkt_and_poll_completion(struct amdgpu_mes *mes,
 	r = amdgpu_fence_wait_polling(ring,
 				      seq - ring->fence_drv.num_fences_mask,
 				      timeout);
-	if (r < 1)
+	if (r < 1) {
+		r = -ETIMEDOUT;
 		goto error_undo;
+	}
 
 	api_status = (struct MES_API_STATUS *)((char *)pkt + api_status_off);
 	api_status->api_completion_fence_addr = status_gpu_addr;
-- 
2.53.0



