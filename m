Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793212459;
	b=AQn1FvpI/l7b7pOzb6nTcgbaBUXLRpuAzEFU5ZnQlXt0FOuuNYICps8i9rGx+DWnIA/w
	 IONvXs2DUWOjbi1tL6QIb2610vFoyJAzGXv7BjhjA8atq0L9ZqZh+pubmU/D77s/t6JfO
	 B57fYqJdJVoVHoy26Hie3N1Euei1Bzs9Nfev7dvhsObcBQtrbdWRCHjNstOUPlPI2x1+5
	 6+Edy8kO6DXO10dmATdgbruRq7djzzpk2Rif8jBwKV9Z8d1+qT2oBMQB6n5VGjbtrR5Cy
	 IEZQWOXG5TAxvcwXA6uACabqrPRnsJowQ7He3QpXzyOeHKQSMF1TlbNU1YR/+YdyyCQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793212459;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=z4op6fHlkvYKfPAN0WoQB53zhgCXnc1iQlObspgKWnQ=;
	b=Om08dP12/E7iHxJ1m3rl+t+mfB8ah4r7kJ9n/cHMyAxsUt3Y6m3V9Dg+ULQJgvMubLf2
	 +2kvpk8IJ6e7anypiLNmhyLHhoqm4tA9EVPqMp4JJys2P33V/zcJjPOIJ4a6ZKyCvN9sj
	 RZidk3muu2GDU9CY8EmvQj9ajxQ+HozkDZM0yIYe7NgV7PRgAl2hGQDJlrWqQD+tVJUKn
	 2GIaXIAkQSH8crqa4pcLVzqy2hJcjBvPCGAnFhRk/onQo64MbIZeNbS0V90jx14vlLk8U
	 b4QIxSAqEUuYgHJ+I8JiC3uxrVi5rS9/7gxfAGnmhqkHAWx55wUgRW1pzwyvrVq8+Bg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FiQkDSj8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 146F5606A31E;
	Wed, 28 Oct 2026 18:34:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FiQkDSj8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 257321F01825;
	Wed, 28 Oct 2026 18:34:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793212458;
	bh=z4op6fHlkvYKfPAN0WoQB53zhgCXnc1iQlObspgKWnQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FiQkDSj8GJ1yfhDaJ/+7HdczhbDQzqKpXTnGPsBr1cG49gUbxa5gdeMhtKpnF+E/W
	 Iv/uRqOoakFGL+rEeTUJ9ou00ENonwmlEIPtjpflXFOHVKBBrFtsxKHaiB4oZ5Ocba
	 UCkFXgPSVE5HzDDhvCbITEvL33HxFX9uWWYQe27U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-dev@google.com>,
	Nilesh Javali <njavali@marvell.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0108/1887] scsi: qla2xxx: Null out freed pointers in qla2x00_mem_alloc() error path
Date: Wed, 28 Oct 2026 17:36:44 +0100
Message-ID: <20261028170501.692912104@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nilesh Javali <njavali@marvell.com>

[ Upstream commit 6d90f0feb929f6c0f3010f9af4747c7230b75993 ]

When qla2x00_mem_alloc() fails, qla2x00_probe_one() jumps to
probe_hw_failed and calls qla2x00_mem_free(). Several error labels in
qla2x00_mem_alloc() freed adapter members (elsrej.c, purex_dma_pool,
flt, sfp_data, loop_id_map, async_pd, sf_init_cb, ex_init_cb, npiv_info)
but left the pointers dangling. qla2x00_mem_free() then freed them a
second time. Worse, for the dma_pool members it issued
dma_pool_free(ha->s_dma_pool, ...) after s_dma_pool had already been
destroyed and set to NULL at fail_s_dma_pool, dereferencing a NULL pool.

Clear each freed pointer (and its DMA handle) in the error labels so the
subsequent qla2x00_mem_free() skips them.

Cc: stable@vger.kernel.org
Reported-by: Sashiko <sashiko-dev@google.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Link: https://patch.msgid.link/20260730155838.2119230-13-njavali@marvell.com
Signed-off-by: Martin K. Petersen (Oracle) <mkp@kernel.org>
[ adapted cleanup changes for missing fail_lsrjt and fail_flt_data blocks. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qla2xxx/qla_os.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index e1578808e27ee..0b21fb29a9fc5 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -4464,23 +4464,36 @@ qla2x00_mem_alloc(struct qla_hw_data *ha, uint16_t req_len, uint16_t rsp_len,
 
 fail_elsrej:
 	dma_pool_destroy(ha->purex_dma_pool);
+	ha->purex_dma_pool = NULL;
 fail_flt:
 	dma_free_coherent(&ha->pdev->dev, sizeof(struct qla_flt_header) + FLT_REGIONS_SIZE,
 	    ha->flt, ha->flt_dma);
+	ha->flt = NULL;
+	ha->flt_dma = 0;
 
 fail_flt_buffer:
 	dma_free_coherent(&ha->pdev->dev, SFP_DEV_SIZE,
 	    ha->sfp_data, ha->sfp_data_dma);
+	ha->sfp_data = NULL;
+	ha->sfp_data_dma = 0;
 fail_sfp_data:
 	kfree(ha->loop_id_map);
+	ha->loop_id_map = NULL;
 fail_loop_id_map:
 	dma_pool_free(ha->s_dma_pool, ha->async_pd, ha->async_pd_dma);
+	ha->async_pd = NULL;
+	ha->async_pd_dma = 0;
 fail_async_pd:
 	dma_pool_free(ha->s_dma_pool, ha->sf_init_cb, ha->sf_init_cb_dma);
+	ha->sf_init_cb = NULL;
+	ha->sf_init_cb_dma = 0;
 fail_sf_init_cb:
 	dma_pool_free(ha->s_dma_pool, ha->ex_init_cb, ha->ex_init_cb_dma);
+	ha->ex_init_cb = NULL;
+	ha->ex_init_cb_dma = 0;
 fail_ex_init_cb:
 	kfree(ha->npiv_info);
+	ha->npiv_info = NULL;
 fail_npiv_info:
 	dma_free_coherent(&ha->pdev->dev, ((*rsp)->length + 1) *
 		sizeof(response_t), (*rsp)->ring, (*rsp)->dma);
-- 
2.53.0



