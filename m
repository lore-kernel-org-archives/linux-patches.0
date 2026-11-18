Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016876;
	b=wFf/oeCM6SqNeQJzZ35+ljjsBMHYZnm+IFoUAR8YJahEBznW2GJgvu9WdIQlzEFlM9AM
	 iwfU932dDpeCN5vAbjdhGExPTKN55BWYplFyAahyq0P8a6sIQ1Cq7Bnezk8FZ1l4jB3Su
	 XxemLrIaIV70GOVgfoOXGw2ply701LRnGcBJyLv6kGsP6iScXVFtNmX89j3J1pJ1NeAyo
	 3xPBRqsoO+HJ25cNo48yO9zIVFSL1b02uv+KSX4OBPtkVibI1v1z3w4F0VnSj4tGLm9dR
	 i7p3UIsMtclbCRy9f00ogOHWTsgMjAcOqazX9XGfvSntYmNzucX+YiGRsLQaIHfu5LQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016876;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=X/4LMB+ETPChtWqvjjGO42Xpu4BZO3Pq0+XSS3tdIrU=;
	b=SqLGdwWf19pDK1cNAfR5HZV7uuYvpRb5A0rhuiKTNYHO4cxkBjmCsefQreRZqddO1COm
	 vm6mLoKPvSA1cZkX0WgQaKuelSVrIcM24noE43izd+gljLn/WDHV8DG8qbgdB0GK/NHiJ
	 eTWrC0smhk4/jaO2BGhUJm07RyyH58meTmTb52SkAZqFfqo7z+aqNo3O2TQ6/y6RZuseP
	 8iXGWQr6okYKC5VDo8R2OUICfGvY92BuvZKD6HREWQgDpSWz1FVl7dWyfIFoZ9VXzH0m8
	 +6moKlMlJHmDca9iiMDOnglpYz9NlcJZqJfziRwHJSK1Gzm7deLGge4lrqCbBE0iWrw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=H8zkm9ro;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F07B3606A31C;
	Wed, 18 Nov 2026 15:47:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=H8zkm9ro
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E17D1F000C4;
	Wed, 18 Nov 2026 15:47:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016875;
	bh=X/4LMB+ETPChtWqvjjGO42Xpu4BZO3Pq0+XSS3tdIrU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=H8zkm9ro+F+sylnr8iiJdwflh4n75wNS6/ypjzIjQ506hi3eTMG6tUDY+3gFApoOj
	 IhOX4PRlKQ6txHE2ov2jYdE0T7lKsIUZXPg5HSUeZjx8NcKljVlk0SoRB0EFGVFiL3
	 yGsGCo1G4gQDjGc5vIIPojkorkJeZuitdQy4yXYA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Slavin Liu <bolin.liu@seu.edu.cn>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0683/2651] RDMA/irdma: check vport device allocation
Date: Wed, 18 Nov 2026 15:32:03 +0100
Message-ID: <20261118150312.450155781@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

From: Slavin Liu <bolin.liu@seu.edu.cn>

[ Upstream commit 2a770e6a64d66fc3a7317669ecca9773d8339ead ]

An existing RDMA function does not guarantee allocation of the new
vport device. Return -ENOMEM before initializing a NULL iwdev.

Detected by static analysis and reviewed with AI-assisted source auditing.

Fixes: 2ad49ae7330b ("RDMA/irdma: Introduce GEN3 vPort driver support")
Assisted-by: LLM
Signed-off-by: Slavin Liu <bolin.liu@seu.edu.cn>
Link: https://patch.msgid.link/20260911060909.94219-1-bolin.liu@seu.edu.cn
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/irdma/main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/infiniband/hw/irdma/main.c b/drivers/infiniband/hw/irdma/main.c
index 95957d52883dd..106915b51e7cb 100644
--- a/drivers/infiniband/hw/irdma/main.c
+++ b/drivers/infiniband/hw/irdma/main.c
@@ -80,6 +80,8 @@ static int ig3rdma_vport_probe(struct auxiliary_device *aux_dev,
 		return -ENOMEM;
 	}
 	iwdev = ib_alloc_device(irdma_device, ibdev);
+	if (!iwdev)
+		return -ENOMEM;
 	/* Fill iwdev info */
 	iwdev->is_vport = true;
 	iwdev->rf = rf;
-- 
2.53.0



