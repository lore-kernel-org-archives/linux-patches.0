Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208358;
	b=wpOecM+RnJxJddlxwkcBfYgWtIRgVCuPeQtD9esSqhiGrfr7eVIKBHIV/8+3us07BHcG
	 HzU3rxz3waUUUjow4hK1PL+HtKywqbncXpdT6jG5Ljk9WrIBk/UhMzspUYSaeqxg/KWbP
	 eXhzjHtF4Rb2DWYfvnkQv6S/OwvbumcXtQn7eZh9aMpPPu93du3Z/bLU0/xyg4v7Q0L0v
	 YcjwqTLCMkpGhLepjGAllCisQy16UowPRjYWL5TCcwCY5mZFitb79TahPYPbtadXDznIf
	 ru4TJqjkr8nnFdoiZgzOQvqhAmzOHoPouKnPsyt4svjdFmDtdnkuX8B6pU4icXpO0nA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208358;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=AaYL5J+JsmDMT/gnXP+tik3AziXb03VBSvhRih10l18=;
	b=yX7GGpQ2pJl8zyfkWNYNDIXxbArue16/jy6mWTRVPFssjhcov1FGFELhonAOUIZOqyFD
	 UoS4lDEyxkL2UPWid0piyErG7x0tfyD19w610/HqCDzl3iRgoqI4eGGG06LzTJacMaJ30
	 73TkVqEE6QSnvQmOa0BLh1iZTK/NaXLiG3wpYaZe+ry+2qgNBsgNqxY/6cAewOcHbv5ht
	 uKehjSA6PX8M/5b+i5AWJ+i9mD1/YyXwQspXv5V4yA+gfL1hXPBaJM+GdrI6gKylr5n8P
	 POQNJIBfmj1Vrf7gzxWT8ozRi1e58CxjTWoqsUbB/3i35uQjVzaiO60Rn8P3gLox2Kg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=o+vEILRb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE96B606A31C;
	Wed, 28 Oct 2026 17:25:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=o+vEILRb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD3B11F01829;
	Wed, 28 Oct 2026 17:25:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793208357;
	bh=AaYL5J+JsmDMT/gnXP+tik3AziXb03VBSvhRih10l18=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=o+vEILRbhRC13DLMZQC965Xv64pPdxAhZq7C8h0m8N7t60t6E1NsmrcxA26v4TBV6
	 aZYi+rRCeUFB7xh+zS8oWmlNJYtQXIgfauXPWJStVaM+eWo6SogQT6wE0v1iYwKLFa
	 FzBJtoOtCfG9CCrwCt7QTL9CxB2MUcvqCgGXlk58=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-dev@google.com>,
	Nilesh Javali <njavali@marvell.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 089/516] scsi: qla2xxx: Null out freed pointers in qla2x00_mem_alloc() error path
Date: Wed, 28 Oct 2026 17:54:01 +0100
Message-ID: <20261028170005.628476378@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
[ omitted the upstream cleanup block for allocation paths absent from Linux 5.10. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qla2xxx/qla_os.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 05d204b8f125c..eacf6e234e34b 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -4259,16 +4259,26 @@ qla2x00_mem_alloc(struct qla_hw_data *ha, uint16_t req_len, uint16_t rsp_len,
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



