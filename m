Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795059700;
	b=mWfiRD/K1K/GnByXc0OLMkphK3Nim5YXs2pilgCtaLwV3tjwgQqrzoOdgSQWLZVE8dH2
	 kNIqggAdBy0E28P5CMv2k2C5SoTA3xjrx+x7MzZ8RWVcyxhks32+ThRAJ3d/oomvA73pj
	 w3CfNLaOorMliAAYFaTNfi3zENvuIZQnZ/e59E8gRqdrnekWfzFbr7IV3JJwq/tCDMxDT
	 IjLEix/xD0FzkS/fwNxypq9ThUDYJCPWAzfhxtS85nxFP4TbDXBZQ5Dd8QplzLLIBhJUx
	 llCD7HyrS50DLUMlfy2F+/kYISi5+3wCaOqHvIFqTOSZaTtF3KHqWBmB+txMQHz/Mlg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795059700;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zsHWGCdBq8VZkqmot3I59lmddRh22vDdpcq6uwYZQMc=;
	b=HFTibmYJ+SHdRX5gtDoNJZM643KFkmTE6SD0vsZ2jIQk7UTBUOScq/wsQC8gV8s6W+KH
	 ijqHevpPRUJUh0KY/JihsRTjflRq0dxwYneyMjzvwYF4LTx7gNxBHVc021ooAALedeEP2
	 cIwaMtm8cfkiVtZM+ojY0EUJO/0grgPqZC9OncNywAtCs5SJgwVl1+fjXXrLqW0Kt6Cn3
	 ifK+u86JqoQt9jm/dZUQ1jQPv2QdH1dH1Dr7yH7dOZUaql6TpWwpMcpHSRs9dDEd+wCLy
	 yv5XAcWI/8UnMcHn4dbNbvjQTrkufxOqLKvbWGvOirsyZnzks3bNCX1dcY6+LXsIh3g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DEcooPLV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EEAD606A334;
	Thu, 19 Nov 2026 03:41:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DEcooPLV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91BAD1F000C4;
	Thu, 19 Nov 2026 03:41:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795059700;
	bh=zsHWGCdBq8VZkqmot3I59lmddRh22vDdpcq6uwYZQMc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DEcooPLVDVmUrrdjE0E5pm9WW/HUYmKPfDSeNszRgMYOZ+p4chOdAM50Thb2iwhwf
	 bRe6HfENbl0M6RBF4kLxYEi3IjhV3i/d8/+GJNwnpjY7NJZ3f58QQJT0ZlxipYhA7B
	 yK3lCWsz7epiKBu/eZRIf2JjqBbsJaQZPDdBptpc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fan Wu <fanwu01@zju.edu.cn>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0894/1848] media: rockchip: rga: quiesce IRQ before releasing m2m state
Date: Wed, 18 Nov 2026 15:48:52 +0100
Message-ID: <20261118145953.998638116@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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



