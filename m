Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795053847;
	b=0voQlGS3V8+OGKrU7iAUSnUYeAqYEaAOVfMxBcDWMCSyynX/hek2X4HOM1Z5yHV8jLru
	 WcofEOR5FayyGPJzHhRdaxeJfy5RGuhwLzV4pRttKX1L2V+Vn/DSyxksYqF5x//Uypfno
	 RO7zrV58x0Yo02Bxkw2mbTCZfB6xuj9DdCkLNZet8n4QRSir5tXSiZR2q121ZUe1vfaUq
	 HrJpdQIHIR6cDoOphsiezxfAUHBCYcYgpk59DxZkQJCdAI5c3uNZIkdkChK3zvvY6QaIR
	 kKKquhCVGmo1b1MiOdLrp2oNMD1L8BJgdyJzxwPWk5V/hs/rCNkVbVufXiZLLx8IFeA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795053847;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=cuft+kOMvY9NxArNT+D9e2tTbM5sdc0SLXNiKIp19EE=;
	b=003a7zSrdreIFfJW3XkjxENnnk+cxUf7kFz30HYX4ewOwILKimZKUm63yfBDgQY6GJgI
	 D4O9zRhWL9v8KvTf7WTDBg4XTblVnoD4sopD8OQeQ/sAZF110sY2HppojLQdzoaJ4XuMO
	 N967nWqwJkNOgU3J+gO+JNAbgPbWWBWbLLxMjvPlmtLGLsyz0VdkkOuq3WeyLsFvZ/4QY
	 aaNcj+mjKZzgV8oZYx5DVN8G3a1kMKJ52WmyxN6f2sKfax6PauBZVwVvHjW1AhkeMCDy2
	 g7jI2BuET/YePKA6RFa6GMemS1NjBkpkZ5FagVy4OY+9ye4pA6h3OgbCcnnh1Z/bMcA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bDVFvd2+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79A12606A325;
	Thu, 19 Nov 2026 02:04:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bDVFvd2+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE7681F000C4;
	Thu, 19 Nov 2026 02:04:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795053847;
	bh=cuft+kOMvY9NxArNT+D9e2tTbM5sdc0SLXNiKIp19EE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bDVFvd2+FjUo9MvcujooHUqqzVzsOs7C96hM05xO7AHJH19nT+gNfl2Bl9j0inOUs
	 qLWirzjuXEU1G17KWStFYUJe/jcVi2u2/+dldTkxK09uZRmNwKipJMTeeS/XpTP6RI
	 1j5ZHwZ1bT5i7F5cPZ64IjtfDekFwdKsGTf2/oys=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fan Wu <fanwu01@zju.edu.cn>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1062/2214] media: rockchip: rga: quiesce IRQ before releasing m2m state
Date: Wed, 18 Nov 2026 15:45:38 +0100
Message-ID: <20261118150054.781075426@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fan Wu <fanwu01@zju.edu.cn>

[ Upstream commit a875c43dd95ee4f9c4e3e5ae1cb8362cc6d7817d ]

rga_remove() releases the m2m state before the IRQ is freed. The IRQ is
devm-managed and is only released once rga_remove() returns, so rga_isr()
can still run while the m2m device state is being torn down.

Store the IRQ number in struct rockchip_rga, unregister the video device
first, and free the IRQ before releasing the m2m state so the handler
cannot run against the freed state.

Fixes: f7e7b48e6d79 ("[media] rockchip/rga: v4l2 m2m support")
Cc: stable@vger.kernel.org
Signed-off-by: Fan Wu <fanwu01@zju.edu.cn>
Reviewed-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Signed-off-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/rockchip/rga/rga.c | 4 +++-
 drivers/media/platform/rockchip/rga/rga.h | 1 +
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/rockchip/rga/rga.c b/drivers/media/platform/rockchip/rga/rga.c
index f9da4ec3eb362..6787d82d457d8 100644
--- a/drivers/media/platform/rockchip/rga/rga.c
+++ b/drivers/media/platform/rockchip/rga/rga.c
@@ -776,6 +776,7 @@ static int rga_probe(struct platform_device *pdev)
 		ret = irq;
 		goto err_put_clk;
 	}
+	rga->irq = irq;
 
 	ret = devm_request_irq(rga->dev, irq, rga_isr, 0,
 			       dev_name(rga->dev), rga);
@@ -887,8 +888,9 @@ static int rga_remove(struct platform_device *pdev)
 
 	v4l2_info(&rga->v4l2_dev, "Removing\n");
 
-	v4l2_m2m_release(rga->m2m_dev);
 	video_unregister_device(rga->vfd);
+	devm_free_irq(rga->dev, rga->irq, rga);
+	v4l2_m2m_release(rga->m2m_dev);
 	v4l2_device_unregister(&rga->v4l2_dev);
 
 	pm_runtime_disable(rga->dev);
diff --git a/drivers/media/platform/rockchip/rga/rga.h b/drivers/media/platform/rockchip/rga/rga.h
index 0825622526c7b..a940919d4394a 100644
--- a/drivers/media/platform/rockchip/rga/rga.h
+++ b/drivers/media/platform/rockchip/rga/rga.h
@@ -69,6 +69,7 @@ struct rockchip_rga {
 	struct device *dev;
 	struct regmap *grf;
 	void __iomem *regs;
+	int irq;
 	struct clk_bulk_data *clks;
 	int num_clks;
 	struct rockchip_rga_version version;
-- 
2.53.0



