Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585836;
	b=zNn0/DdxQFvpVr3xESLGUbjgMpbd3ATd3JgIRDoZT/fAFznCXzt43OdQxsLG++yMvPjz
	 7LZQ4yPm8n1iQ5q7IgL5X0JpWHJLjJyP48CzaijMGMqMpNOE+QCOkozair0kY6cNl0RrR
	 l2YP/nYD0O1MUdG7ciabTghaPFPn4L5LPn5n4yniP0NT6M0CeVMtnFd75TR65NdykMyBO
	 DrYEN0iAuvEPqEXSYrwBAuV9Gz9qyyfYsRS5Z3DW03TICLy3Jv2rlyl8y3kV/es1zHNyC
	 P2Ajmcuw1jPlpg6w+SsIi9SMh+N3Fa5Ws+W09XO+UjO631m8vFGiURLbZ/ShilYT5Ng==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585836;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Unilo7NIqYgcW2P4QrT+w/MaGhz5jRARxc6TScr0apg=;
	b=bm0Wg0DWqFzHNNKhjpQ1pvHS7rr7PNlc2apwRQXZHCw1qRsDRobLPCKjms21wBuuZhjW
	 lyy/0Ub7LmU4a2ZfFulaq73tspLFziIgwVi0WTWQa2Q5G3rxpe+F4HLtqWScCvkoTtQZe
	 FPKtWwp7QT5flbv7FLRv5oMr4H7C6ikvWqCiSL8QveXxZDUQ19mYBnDnIbiGF5/+5G/eT
	 bzGSlW1S6URGN0h/729yqX7kjClWIBb8+fKNlT3Q9KuLxchPRegsZ5NA6WDZ6eGK+6dzs
	 9xM65bKrfHeMfrvMryiRp7ecAehSZ2vlViYtGC6l4zrx6tcDxdp4AwXC1OOYYaCSQcg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bOkvVuM9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BBCF606D2CF;
	Fri, 13 Nov 2026 16:03:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bOkvVuM9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27AD41F000C4;
	Fri, 13 Nov 2026 16:03:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585836;
	bh=Unilo7NIqYgcW2P4QrT+w/MaGhz5jRARxc6TScr0apg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bOkvVuM9Wz8DojFAjGPTKxU12n6cin9QlpQfzseC0ljQWuWwhsD0JlqGNWAktihTB
	 H0nh5Ig8dcLw5wzvWmVjn24gS0+9MobuMGx+k3IG7IRkkMIIe/eak9yQ7Jij6VWDwF
	 l0vF0CIULzS8aI3IHdimCqZeIX9EblCnJMKIJFgk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>,
	Erhan Bilgili <erhan.bilgili@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 373/507] drm/amdgpu: Report MES ring wait timeouts.
Date: Fri, 13 Nov 2026 10:51:17 -0500
Message-ID: <20261113153808.795926410@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index c57bcb9a98b19..10bed6f38f309 100644
--- a/drivers/gpu/drm/amd/amdgpu/mes_v11_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/mes_v11_0.c
@@ -218,8 +218,10 @@ static int mes_v11_0_submit_pkt_and_poll_completion(struct amdgpu_mes *mes,
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
index ee72afdb0a1d3..bb9892d1bd051 100644
--- a/drivers/gpu/drm/amd/amdgpu/mes_v12_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/mes_v12_0.c
@@ -195,8 +195,10 @@ static int mes_v12_0_submit_pkt_and_poll_completion(struct amdgpu_mes *mes,
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



