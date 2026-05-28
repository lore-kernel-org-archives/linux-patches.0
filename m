Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B33132F260C;
	Thu, 28 May 2026 20:07:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779998826; cv=none; b=lQqlbiuAEO1a4R3KNdgH6rzhQd0AjwX/v509RTpw9SNLAhhdShNNYOoGxZ+KaQzfTxDbMNzF6os3YBcpRHuIbdqOFhNDBSpHPw0pUixHnZ0Y7sB3K/409+ZNpTtGNaQsLa4XMx3q29sS2sBXYGSENR2PRpTDS5UFN0B0YCBt5/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779998826; c=relaxed/simple;
	bh=S68+FKaDiOdUCOx2dB+N8T3c+V3D020WnGtlSja2R2o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nFdc1Bc+OdMAjy0wXHguQ2au3VNwdbHz0nvdtFf+qr3iB2bFuGTJLmrx00ApQr+FLfDPTWUGt/323i+8mxzG+hh92Li5LpkPgyh10WISSV/p1QOTw5NT0fVYGtpkFwRRraw47SzUqLh9Xlt1jC6AXcJ+KdHnrFNJmBl9mSR6zcM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h8XgxRjU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h8XgxRjU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1BC61F000E9;
	Thu, 28 May 2026 20:07:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779998825;
	bh=Bb3wS6BZyGL+7f/viP4JN4X5cILEHJIenWmHrrMrX74=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=h8XgxRjUseKK/LDPK4sM3QG86RmGub15i2WdwZcHgdXbt48DeZuQ629IjaLoJ6CKi
	 LtF4IIs10jDd6KNGnjSKdFA3pjEsNgpiRtQ4x/zlBJL2KfHqNPqYVRsyq+RAmSSfqq
	 ObJkqFaqkrmddgvJPD2a7ARX8K2G612jaeiMjHKA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Ni <nichen@iscas.ac.cn>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Akhil P Oommen <akhilpo@oss.qualcomm.com>,
	Rob Clark <robin.clark@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 310/461] drm/msm/a6xx: Check kzalloc return in a8xx_hfi_send_perf_table
Date: Thu, 28 May 2026 21:47:19 +0200
Message-ID: <20260528194656.260430379@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194646.819809818@linuxfoundation.org>
References: <20260528194646.819809818@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chen Ni <nichen@iscas.ac.cn>

[ Upstream commit b5c7a7f452b885bfbe102bd3a057a5f496802f8b ]

Check the return value of kzalloc() to prevent a NULL pointer
dereference on allocation failure.

Fixes: 06cfbca0e1c6 ("drm/msm/a6xx: Share dependency vote table with GMU")
Signed-off-by: Chen Ni <nichen@iscas.ac.cn>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Reviewed-by: Akhil P Oommen <akhilpo@oss.qualcomm.com>
Patchwork: https://patchwork.freedesktop.org/patch/721342/
Message-ID: <20260428073558.1234238-1-nichen@iscas.ac.cn>
Signed-off-by: Rob Clark <robin.clark@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/adreno/a6xx_hfi.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/msm/adreno/a6xx_hfi.c b/drivers/gpu/drm/msm/adreno/a6xx_hfi.c
index 4f5dbf46132ba..b40148b754207 100644
--- a/drivers/gpu/drm/msm/adreno/a6xx_hfi.c
+++ b/drivers/gpu/drm/msm/adreno/a6xx_hfi.c
@@ -289,6 +289,8 @@ static int a8xx_hfi_send_perf_table(struct a6xx_gmu *gmu)
 		(gmu->nr_gpu_freqs * num_gx_votes * sizeof(gmu->gx_arc_votes[0])) +
 		(gmu->nr_gmu_freqs * num_cx_votes * sizeof(gmu->cx_arc_votes[0]));
 	tbl = kzalloc(size, GFP_KERNEL);
+	if (!tbl)
+		return -ENOMEM;
 	tbl->type = HFI_TABLE_GPU_PERF;
 
 	/* First fill GX votes */
-- 
2.53.0



