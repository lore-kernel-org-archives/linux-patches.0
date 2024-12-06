Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1878253A7;
	Fri,  6 Dec 2024 15:25:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733498740; cv=none; b=gxGtM454LGrnQ7Z2Z3vqyluvhsJgjDVBE/UpAiR9y4833E9Xuio2XX8yNaaRnQNfTUgXKz3xwyPib/7r3+JZapP65xalf+BJ9lZGYhuTIwZWpteOMcpugDVI3vMgzFNvsK4cF4ICt21eSqgLqUbe2j+0aNiRr2sgMwg7HYSVGhM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733498740; c=relaxed/simple;
	bh=RvG6C5ljNHy0aKNyblGZVbSLW02QwY4VlZ7/UrxWbsI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LDAbTAepk9lY4QNpAR+d/IbANtGCEOgO01ZF89+jAiJ1Y2sD5g2Mv/9Y6vX0PM12ntENXQYngesMagrOjYijW2NjncwOgVGTsICHzrJZt3aBAbM62+oYt5C7DbI+1NFwFVpVjc2iVvgwkPELWJQXrjsN4S5aItne9CNicHXL5H0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LFF6aCXj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LFF6aCXj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 783D8C4CED1;
	Fri,  6 Dec 2024 15:25:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733498740;
	bh=RvG6C5ljNHy0aKNyblGZVbSLW02QwY4VlZ7/UrxWbsI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LFF6aCXjIdHQ90b6FpCCh+6rMOri2WS/zI3pF1soi1C2KOOZr7wHIgeHHqdhIxTJu
	 9zXUbG3LeTsK3OKouGtGOnqGAmGTOxl2Y7vEyO0kornKZeKVwWLwqv6a35Y8WquYxq
	 VxcPG60D33YERT7hVGNfPUoPkX8AzwWjpYAEYvP0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lijo Lazar <lijo.lazar@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.6 673/676] drm/amdkfd: Use the correct wptr size
Date: Fri,  6 Dec 2024 15:38:12 +0100
Message-ID: <20241206143719.657463581@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Lijo Lazar <lijo.lazar@amd.com>

commit cdc6705f98ea3f854a60ba8c9b19228e197ae384 upstream.

Write pointer could be 32-bit or 64-bit. Use the correct size during
initialization.

Signed-off-by: Lijo Lazar <lijo.lazar@amd.com>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_kernel_queue.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/amdkfd/kfd_kernel_queue.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_kernel_queue.c
@@ -123,7 +123,7 @@ static bool kq_initialize(struct kernel_
 
 	memset(kq->pq_kernel_addr, 0, queue_size);
 	memset(kq->rptr_kernel, 0, sizeof(*kq->rptr_kernel));
-	memset(kq->wptr_kernel, 0, sizeof(*kq->wptr_kernel));
+	memset(kq->wptr_kernel, 0, dev->kfd->device_info.doorbell_size);
 
 	prop.queue_size = queue_size;
 	prop.is_interop = false;


