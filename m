Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061885;
	b=GZxOU3gNvd3JZFZDXVH51CBmMzZRpzYOmBZrxQQP07P0jA4dW9I6YBvK3ThkcdOnQSRl
	 CV9iEWRO+gOtsjGzvN7YV77Nltkp8XJ3JQelOc/Azs7NQWPvXd05DlNnkJ9k0YPf3JtTu
	 qTv6LugcOOlumKMdP4OCSOsOlXO+FZmelzZoaBeun2CRODfXDQpZAv32KU2bv8U8KGOZ7
	 IfzY9O8UDB5j4u3bCnPBDOwFg0Fb1ZqRtdSJXPb2Qo+HICL/sPLxnTaeshtICGQgeKDiM
	 e6FWTIWfJcqukg9S/4uL/9bp0KumPF40EX9ChTDclkhIKNqqTfILEZ6EzdAtwhZ17hg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061885;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=jz+NT9BtLIVUmP3ehnJ8x5Zwqz0CQ1P4s07ySr+bjO4=;
	b=vb+/vLYxuAoBcOJXdCLmSvi14JAjwYkS0i82s6hB4kcXl/kxO5hnDkM9Ez/finj2ue40
	 2p+Rcr9OUc/Xbs5RU+g9OPO4AhZCoYrLa1wwc4720WZTq8iYqCs65g0REjVCLUyEWaVT0
	 ZVyDpWXtPZzHoeD9yBigc+b0naO2Qgqv8uJiodAmIYB8IeMcW8QV/rj5ouy4CVlnxbuRF
	 mMrXEN+KkJMxw2YyX1jqf74wNS3T9d54MR9jHg6dxt2aZBfPyffzTrt2TXtdMGRp8mErC
	 ga/OkAWRrLacy8pQTnLIwmJct5CMCW3ahQUwx5COJwp3jMT+s5ElA5mn5n3CikLXLPQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=D5oCtlap;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DABC4606A32E;
	Sat,  7 Nov 2026 14:31:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=D5oCtlap
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 597521F008A1;
	Sat,  7 Nov 2026 14:31:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061884;
	bh=jz+NT9BtLIVUmP3ehnJ8x5Zwqz0CQ1P4s07ySr+bjO4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=D5oCtlapUOZurWHUdRt7jVZiCy8qHjZWcF0VZfS3/tyOzoFGMTD7yT+zcZABJXPMP
	 +yDLzWuvYnkvJGaMOI/6kOdcVqk8ONozjdE7i65+xTk5BBIvQrHQVu04WA5TyPVDb2
	 wB1hfy6Hr3vPC6M+6WtAn9NSYqFouvye1cFbx40g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Young <sean@mess.org>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0896/1536] media: sunxi-cir: Ensure no more interrupts can occur before free
Date: Sat,  7 Nov 2026 08:48:32 -0500
Message-ID: <20261107135022.797404280@linuxfoundation.org>
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

From: Sean Young <sean@mess.org>

[ Upstream commit f9b33ec404200c03dd490ec133b8f9bf599c5444 ]

Only call rc_free_device() once the hardware has been stopped.

Fixes: dccc0c3ddf8f ("media: rc: fix race between unregister and urb/irq callbacks")
Signed-off-by: Sean Young <sean@mess.org>
Cc: stable@vger.kernel.org
Reviewed-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/rc/sunxi-cir.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/rc/sunxi-cir.c b/drivers/media/rc/sunxi-cir.c
index 77dbff77b5397..e00b1353db0be 100644
--- a/drivers/media/rc/sunxi-cir.c
+++ b/drivers/media/rc/sunxi-cir.c
@@ -374,8 +374,8 @@ static void sunxi_ir_remove(struct platform_device *pdev)
 	struct sunxi_ir *ir = platform_get_drvdata(pdev);
 
 	rc_unregister_device(ir->rc);
-	rc_free_device(ir->rc);
 	sunxi_ir_hw_exit(&pdev->dev);
+	rc_free_device(ir->rc);
 }
 
 static void sunxi_ir_shutdown(struct platform_device *pdev)
-- 
2.53.0



