Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062193;
	b=Cok0qi7jc/WCTnSNoPPMort3n77m5LmZOUpNuIo0areyDIttO2EgI1EdCaEbWgEYBFfg
	 RCiumYjgKN6+D+tdpynRuljn5xGWjkjozuMFxbZYw5nJyW95jyLjwQldDE6OMlrDWbP0s
	 xpLuX2QHxt2IY8xaH2u8nH1/qfFtcxaKLZy8qq9S+/QfJAR5zc/nmhkEIWczIQP02Re4j
	 v+KwHimS8WIyI0SLCAqm3zm4YfODWh5PUZ9JC+cQwNzVMxa5Ir+nNe6RKECAyc7nEVMtB
	 mR+an4YwG0leB7rBsuz5xBoGz0CHYe40BOFGhI0yyOLC2CekKkh9VE2s6ibRGRlFhww==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062193;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=q4czuSOYbkrLSshntGMJYZoHS+aLPioH0PBlbfFy0r4=;
	b=TrqHCwb7HD8+HTUVm26wJbfjzaoGJtkFgUbfOBevNTlTPlUrzt9HSg/opEHzDHYJ04rx
	 D/o3PbRnhnY1GRRMS6vY51cIadvOI3y9apjKkJxCmanyBX2e8gf72GBtmWZ8feA799CK1
	 QMctEh/HAPW+4Q4rQ/4JZdIymiVsOXYX+G0J8QybDMbjf/ITRD9ioeRoBZOVFl9gX+fLv
	 taxNWzMI28C0FFAepmowSgky1rv3/fRpV24IFZqzOyVPzWYR4LvXjHdnDZUzvmEtWMGzF
	 iw1z162tGaE7UsEzEVSRKz7EwvRzXpz6UXU+7Egf9zwPTxi2htuRzMletrDcL3kdqXg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xd7mOjp9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40E8E606A326;
	Sat,  7 Nov 2026 14:36:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xd7mOjp9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E38DC1F008A7;
	Sat,  7 Nov 2026 14:36:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062193;
	bh=q4czuSOYbkrLSshntGMJYZoHS+aLPioH0PBlbfFy0r4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xd7mOjp912SWf7ba8kmXwIVDYdU163g25+YbZovs9yhBr9TkrkdO6nFsdWv1foTVh
	 RHn9EXo/Ch5ytQ6bBLWaPftzgL1MnqcYMp+T3v1P11kSSYWVqNOFgCZV5cfO7C2TSc
	 5QVAXMHnBcx5yXvF3u8DTIwNpEC4cdSFovThs5CU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1149/1536] media: mediatek: vpu: release reserved memory on remove
Date: Sat,  7 Nov 2026 08:52:45 -0500
Message-ID: <20261107135029.997176770@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guangshuo Li <lgs201920130244@gmail.com>

[ Upstream commit 8af0e2bdd9791848d9caf3761825ac51a67c2b9c ]

mtk_vpu_probe() may assign a reserved memory region to the VPU device
with of_reserved_mem_device_init(). The probe failure path releases the
assignment with of_reserved_mem_device_release(), but the normal remove
path does not perform the corresponding cleanup.

As a result, removing the VPU driver after a successful probe can leave
the reserved memory assignment associated with the device after its
lifetime has ended.

Release the reserved memory assignment after freeing the VPU external
firmware memory, matching the cleanup performed by the probe failure
path.

This issue was found by manual code inspection.

Fixes: 3003a180ef6b ("[media] VPU: mediatek: support Mediatek VPU")
Cc: stable@vger.kernel.org
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
Reviewed-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Signed-off-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/mediatek/vpu/mtk_vpu.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/platform/mediatek/vpu/mtk_vpu.c b/drivers/media/platform/mediatek/vpu/mtk_vpu.c
index 3d437898e1f47..e0357dd21a427 100644
--- a/drivers/media/platform/mediatek/vpu/mtk_vpu.c
+++ b/drivers/media/platform/mediatek/vpu/mtk_vpu.c
@@ -967,6 +967,7 @@ static void mtk_vpu_remove(struct platform_device *pdev)
 		destroy_workqueue(vpu->wdt.wq);
 	vpu_free_ext_mem(vpu, P_FW);
 	vpu_free_ext_mem(vpu, D_FW);
+	of_reserved_mem_device_release(&pdev->dev);
 	mutex_destroy(&vpu->vpu_mutex);
 	clk_unprepare(vpu->clk);
 }
-- 
2.53.0



