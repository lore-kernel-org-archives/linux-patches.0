Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829297;
	b=3nfZ/R69CCB+C8Z+iCF9+5zV9YCxNkZ9u/oue9/tGDhYlFvi23DX11Rp/DO6EjGhvAdI
	 vut3/zoHuR0EXJRu0EzW3WfXbgNc+ofchNXu3uD2k6qpgXvGaYbiFFu7EEKPv0WZsZSgn
	 lm7gA/vVrfJyTqnBD1+y9Sh837wAr+LOlABGXczeVfE/bCVMVX0191Vlswdatm5bMiVIN
	 n5MlkR+9Wb6Ghu6jUJ1vTofvdjPintDFG+fb4W7K01X5S+3e0U5f2Dnvl+JdXfJucz0ep
	 zUXSl5AQtS3yghJnj9kWNoe84+2Kefia+wmH4WLkHR7P9+Tw8fCsOXm70/Z72gKiing==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829297;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=PvXI1huFwtARieC0xNL0jn4OzJBZsmJR8GA2hOXy4W0=;
	b=WeCAjFrdZ11jjCTUhuOYdQ0ZbGrdmxP9vk4CkQ9ranW+PiLC+idstCDEqbQpiOYwvTnE
	 8CltHo1M35UPqEWJgdELFhIQBWKmP6gXHoXFVOGCgsF/ttxZKUgN1kjC4b84P5o3IASwQ
	 fAqeUtEup7YntSp2d6792ygScKCG/P7gTYckUeT4LA1Rl6wJxXIIZpCL3mk+nV3NvXVIa
	 YaVZvHSm++Egi76rsMU7bM4t4hhaixnHOdC84PJmPpHI/ilc17MsJ7+LQei6YQHWe2/Vx
	 wfPmPBO/UTtjRQ+R1EFyNybWI4RSv2tYjD37zlcROBYn/Bi9ZXX3EtMOiXVTDl4LnxA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BcDQLl4e;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADCB16086606;
	Wed,  4 Nov 2026 21:54:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BcDQLl4e
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E76F1F00919;
	Wed,  4 Nov 2026 21:54:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829296;
	bh=PvXI1huFwtARieC0xNL0jn4OzJBZsmJR8GA2hOXy4W0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BcDQLl4epQMURT3KwYqiVBMx4w/38Z9rXtIY1qoFLnWA3VmshUN7bM1aLpobd39HS
	 yB2n0FUbwas+aSi4Z6oXh0try7NtLgcacH8flejw832kXQGTUEs9qq7OI/QTxa5Vhd
	 72e6P2ugUXapq6WvBLP6E8IVqFKChiRpgPbI3ktk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Chen <michael.chen@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Shaoyun Liu <shaoyun.liu@amd.com>,
	Jesse Zhang <jesse.zhang@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0018/1005] drm/amdgpu/mes_v12_0: use mes schedule pipe for legacy queues on unified MES
Date: Wed,  4 Nov 2026 15:55:51 -0500
Message-ID: <20261104211044.056643931@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

From: Jesse Zhang <Jesse.Zhang@amd.com>

[ Upstream commit 5ec4cc91708370847772f2a2397316dbd8d8f066 ]

when suspend_all_gangs is issued to pipe0 MES during system suspend or runtime PM, pipe0 can only suspend and resume queues it has tracked.
KCQs registered with a non-zero pipe slot may not be correctly handled, leaving them in an inconsistent state after resume.

v3: fix the schedule pipe issue
v4: use schedule pipe for KQ resets

Reviewed-by: Michael Chen <michael.chen@amd.com>
Suggested-by: Michael Chen <michael.chen@amd.com>
Suggested-by: Alex Deucher <alexander.deucher@amd.com>
Suggested-by: Shaoyun Liu <shaoyun.liu@amd.com>
Signed-off-by: Jesse Zhang <jesse.zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/mes_v12_0.c | 27 ++++++++++++++++----------
 1 file changed, 17 insertions(+), 10 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/mes_v12_0.c b/drivers/gpu/drm/amd/amdgpu/mes_v12_0.c
index c40aed5a8fc21..7d7bcf1c69f27 100644
--- a/drivers/gpu/drm/amd/amdgpu/mes_v12_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/mes_v12_0.c
@@ -524,10 +524,15 @@ static int mes_v12_0_map_legacy_queue(struct amdgpu_mes *mes,
 		convert_to_mes_queue_type(input->queue_type);
 	mes_add_queue_pkt.map_legacy_kq = 1;
 
-	if (mes->adev->enable_uni_mes)
-		pipe = AMDGPU_MES_KIQ_PIPE;
-	else
+	if (mes->adev->enable_uni_mes) {
+		/* Keep scheduler queue on KIQ pipe; map all other kernel queues on sched pipe. */
+		if (input->queue_type == AMDGPU_RING_TYPE_MES)
+			pipe = AMDGPU_MES_KIQ_PIPE;
+		else
+			pipe = AMDGPU_MES_SCHED_PIPE;
+	} else {
 		pipe = AMDGPU_MES_SCHED_PIPE;
+	}
 
 	return mes_v12_0_submit_pkt_and_poll_completion(mes, pipe,
 			&mes_add_queue_pkt, sizeof(mes_add_queue_pkt),
@@ -563,10 +568,15 @@ static int mes_v12_0_unmap_legacy_queue(struct amdgpu_mes *mes,
 			convert_to_mes_queue_type(input->queue_type);
 	}
 
-	if (mes->adev->enable_uni_mes)
-		pipe = AMDGPU_MES_KIQ_PIPE;
-	else
+	if (mes->adev->enable_uni_mes) {
+		/* Keep scheduler queue on KIQ pipe; unmap all other kernel queues on sched pipe. */
+		if (input->queue_type == AMDGPU_RING_TYPE_MES)
+			pipe = AMDGPU_MES_KIQ_PIPE;
+		else
+			pipe = AMDGPU_MES_SCHED_PIPE;
+	} else {
 		pipe = AMDGPU_MES_SCHED_PIPE;
+	}
 
 	return mes_v12_0_submit_pkt_and_poll_completion(mes, pipe,
 			&mes_remove_queue_pkt, sizeof(mes_remove_queue_pkt),
@@ -909,10 +919,7 @@ static int mes_v12_0_reset_hw_queue(struct amdgpu_mes *mes,
 		mes_reset_queue_pkt.doorbell_offset = input->doorbell_offset;
 	}
 
-	if (input->is_kq)
-		pipe = AMDGPU_MES_KIQ_PIPE;
-	else
-		pipe = AMDGPU_MES_SCHED_PIPE;
+	pipe = AMDGPU_MES_SCHED_PIPE;
 
 	return mes_v12_0_submit_pkt_and_poll_completion(mes, pipe,
 			&mes_reset_queue_pkt, sizeof(mes_reset_queue_pkt),
-- 
2.53.0



