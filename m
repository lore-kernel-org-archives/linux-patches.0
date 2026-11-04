Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829354;
	b=EM67JsXaL8aqS3b1uegsruswTPfDjHbJw9FZ7AsHQyhCHYtPRD07U3NyR/HVPelKoSn5
	 thyaX4faOiy1BFZ8RwG69bBThHoiEq1JUR4CW9CP1LqPxAA7fr5jpGjOLR8aFe+TQ/tRf
	 eXba+MYxoh73o8mjxpYWhxbxl9WGk8/ZVppZxfTBYwX1PVETPARBOJ/vU74i6Iawaxd/m
	 iUYLRnyTHkT83Z7xdmpDAMGvyap2eifnlXHQ7jRarOg/fYZYnL3qF1hseJHGZdDfUiQqR
	 VlwazOnE+CuntDTpNEsoxBhR57oKmtsO6/UTZjmAdHg+MJ315V7MDfCfh2SnWIWAsiA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829354;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=IoxJdNRK0ypjM3x5Ktuju9dGMbp85sTbYQSeeY2Th/g=;
	b=Q3jgAkS1NPgcwes6/rWlkKfFVuO5fuEZmLXB60tabc49QRcovOmlXZFxEtw4+CBvsZqn
	 IvuSVagl3kxi08FUD8nt/7z7OClCamygqFYhxG44YjOfnZDbZmsx8Ug5/KDk6eYbOuHiB
	 1KJfLH6yo8YX24R6t9YNUA7l7p+TPi75E275dBrJETtbx+vSPAoSqe3YeXJcwKLOEIxsQ
	 hk+B+1LW+K1i4FbG5qXrBjZa16jwqiWs8f4OjswDPbEj27r17Fxxx/8R8w23qxp53jJz0
	 O9Y66xV7k8JKVzemS5uZxzn0txox8rIzFbYO2cHKI/Ny+92g5I7jlQj6BK+ojWbMTzQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cClPR79d;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 230AC6074908;
	Wed,  4 Nov 2026 21:55:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cClPR79d
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B899F1F00A15;
	Wed,  4 Nov 2026 21:55:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829354;
	bh=IoxJdNRK0ypjM3x5Ktuju9dGMbp85sTbYQSeeY2Th/g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cClPR79dcXIlE6ko0e5XzqhdOSMcWTd472MMtroKhthh79fI+RUbV1HoJQqwCJALW
	 luVweH1V7Sy7R/dtRTs/1xe12DqZZHuTOBVimhtCd8yCbEAGfG8i4J5NKioxt19dml
	 ulsqbOLBRwME1hZ9/r4WwN77XoIasqV0jDi0L63k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yongqiang Sun <Yongqiang.Sun@amd.com>,
	David Francis <David.Francis@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0073/1005] drm/amdkfd: use node XCC count for v9 CRIU control stack restore
Date: Wed,  4 Nov 2026 15:56:46 -0500
Message-ID: <20261104211045.660741308@linuxfoundation.org>
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

From: Yongqiang Sun <Yongqiang.Sun@amd.com>

[ Upstream commit 1a0aa3c4cb207fcbf7ebd2d9ed9f1cfb4560bd2c ]

set_queue_properties_from_criu() divided the checkpointed control stack
size by NUM_XCC(adev->gfx.xcc_mask) (whole GPU), while the checkpoint
size was recorded, the MQD buffer allocated, and the control stack
restored using the per-node mask NUM_XCC(mm->dev->xcc_mask). On spatially
partitioned GFX9.4.3 (CPX/QPX) these differ, so the per-XCC control stack
size used for the restore memcpy could exceed the region sized for the
MQD allocation, writing past the BO into adjacent kernel memory; it also
broke legitimate restore on partitioned parts.

Divide by the per-node XCC count so allocation and copy agree,
leaving kfd_queue_acquire_buffers() to bound the size against
the node's advertised control stack size.

Signed-off-by: Yongqiang Sun <Yongqiang.Sun@amd.com>
Reviewed-by: David Francis <David.Francis@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_process_queue_manager.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_process_queue_manager.c b/drivers/gpu/drm/amd/amdkfd/kfd_process_queue_manager.c
index 912c4ebd30405..99a47f2a45e7a 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_process_queue_manager.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_process_queue_manager.c
@@ -1062,7 +1062,7 @@ int kfd_criu_restore_queue(struct kfd_process *p,
 	ctl_stack = mqd + q_data->mqd_size;
 
 	memset(&qp, 0, sizeof(qp));
-	set_queue_properties_from_criu(&qp, q_data, NUM_XCC(pdd->dev->adev->gfx.xcc_mask));
+	set_queue_properties_from_criu(&qp, q_data, NUM_XCC(pdd->dev->xcc_mask));
 
 	ret = kfd_queue_acquire_buffers(pdd, &qp);
 	if (ret) {
-- 
2.53.0



