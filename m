Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795049574;
	b=fFxRUGCc8DKDzmvrAFXI9moP1UEqB5NHKMmHtWN5JH9/O/ZQOoQTSjDErdUT5j//ojNv
	 lgpuAUfc7/22HEug45KZ3EXlBWkaQa1bnklI/BfZyow0EtKgYvzc3u523rrxk7qumZjs/
	 tgqRqAQ34AOnQrtJn4aCS+zefc9dGgA8AmdeqPTJ+7yTrf/pn+2fa5tsDumzowMxk3AMW
	 pc80k13mQOPG7eLYwWoC/+8+2PXLLGjWnvOO4bP+2JFy0zn6WWq3KUMzaGhUkJ8jbZfbj
	 LX8nQyklvOhTj0Xo2RJj7FSMrBLXGtKHJOQzLwnFaYTI/mqqrv9ZVyGXNVmmDGORHFQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795049574;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=8LOlZLjhHoJ5Q/wBLcPBTHpXezqwRFpnoawH+xG79rg=;
	b=eBBMYrPsgcGy9iw7kepf2JfeS531sPHKNij/kw3i88qL3NaAn1Jt1QreXyfRba0pF9ge
	 z8y7GS4EvDaCZKzwT4Ba9wUO4dPGZdMNe6hJPBumIkaCUc4i4nihwCiTTeIORJEtNZGk1
	 zwyg4ZBADYH7hNEVGE+XjQW7E9cJGieDDtbhLcf8Kj+U3V0G8Ab6Xy4y+rF5FUPo5FTIa
	 C7od3H2NdGwez6TVQaa3/IA//XIaz+qdzcAaDLvKcdNu+J174/DRhrqDRh8DzWmQIgaLK
	 m7UsdnWxMZGRls2SEF4n4s4BVDD1U+v2l/gImmZsIUhTKDuSakIFHMoZZasZW08slRA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uh6lucU4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7035F606A32F;
	Thu, 19 Nov 2026 00:52:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uh6lucU4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEFFD1F000C5;
	Thu, 19 Nov 2026 00:52:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795049574;
	bh=8LOlZLjhHoJ5Q/wBLcPBTHpXezqwRFpnoawH+xG79rg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uh6lucU4+Zz09V8Jk6iXPLnES8d5tdbdy+3pJ2HZiQbmhm75JfTT+KPVNOjj9/JDP
	 2detuVuvyq2H4cWMqdBFQ9b6OULYRdHfBgw8M8FSYWMlKfK7ePti8s38F07rfP+P1T
	 KPkyAABfiNrfR1K4Xuev3F2eN3WfbPlNPyqMAPSs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Prathamesh Deshpande <prathameshdeshpande7@gmail.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2363/2857] RDMA/mlx5: Cancel software CQ notifications before teardown
Date: Wed, 18 Nov 2026 15:56:37 +0100
Message-ID: <20261118150326.603219775@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

From: Prathamesh Deshpande <prathameshdeshpande7@gmail.com>

[ Upstream commit a0ab2bb269e7fd8523f87950b91a42a36c7f8f2a ]

GSI completions queue notify_work to invoke the CQ completion handler.
CQ destruction drains hardware events and core polling, but does not
cancel this software notifier.

Fixes: 25361e02c448 ("IB/mlx5: Generate completions in software")
Signed-off-by: Prathamesh Deshpande <prathameshdeshpande7@gmail.com>
Link: https://patch.msgid.link/20261008141209.6923-1-prathameshdeshpande7@gmail.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mlx5/cq.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/infiniband/hw/mlx5/cq.c b/drivers/infiniband/hw/mlx5/cq.c
index 3d50fd28b227f..997bb9e245979 100644
--- a/drivers/infiniband/hw/mlx5/cq.c
+++ b/drivers/infiniband/hw/mlx5/cq.c
@@ -1052,6 +1052,9 @@ int mlx5_ib_pre_destroy_cq(struct ib_cq *cq)
 	struct mlx5_ib_dev *dev = to_mdev(cq->device);
 	struct mlx5_ib_cq *mcq = to_mcq(cq);
 
+	if (!cq->uobject)
+		cancel_work_sync(&mcq->notify_work);
+
 	return mlx5_core_destroy_cq(dev->mdev, &mcq->mcq);
 }
 
-- 
2.53.0



