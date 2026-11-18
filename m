Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795038332;
	b=WjgOyoOVa5TaExGIjPPapuQlFMhyaw9V3KE6fBVProv7UxVe3YCibT4uXD7PfJ14Xhs+
	 SHqy31uaJJWFyax/eiJQtjFnqgogIjb3m2Aho5P4QA8msAFhv+2FFf95xpKtwNVZJSc5n
	 0MdudWijefOL5e/TPzVPdFNQ6MaSubfN3EvW6goXxEI3cbdUVqAYCH35DGR7wDD1VnQAu
	 OB0+hsJTp1aV3aLLOH3QdyWUHAWz5VliiIXc4ahLu8zrDzzR44CxrRGowFxNHkuj1/A1a
	 kJ45XqcKjC/1C+a+T+r4lCCv15Rww6PoANPC9tfzKsXw37lEqCoyG0vh0/TShqzYo2Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795038332;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=BqTQi1X4f/s6xk/+ZvRnZMvgbkNjjn3wPVkhIacckN4=;
	b=HhCqGpvyv3YPA9VAzOnR8qwlMDfy+ih2w0yauJT/5ruPPS903u1tQ+ByEhC0xXkWU+Kp
	 AEx9w5u4jeksyqJ24k5z+bh2W2Ywff2oDJEWH5WaIwwEItvL29jov/MmwOYW5Qu6lO6rd
	 EQubiL2T8Ww4i2JvJXX0GkUcDnZ9T9GwzWCmADXfMnnhvhOYaGs4lVuTqyrOL4q8rSPfk
	 ptvfSvwssGOScIE5GsBs1oQakeAU3z12C68Ueq1LKlKtD2HA300EBzAfgZ+ZkQd0jprNS
	 QKaBlqqtvkc+N0G60vA8fsghl4wWQHMDpxXaol3WQBP7Wt4WNMQ0ZSMQhStn1+6xOlw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tmMONmsd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FA83606A32C;
	Wed, 18 Nov 2026 21:45:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tmMONmsd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D1CD1F000C5;
	Wed, 18 Nov 2026 21:45:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795038332;
	bh=BqTQi1X4f/s6xk/+ZvRnZMvgbkNjjn3wPVkhIacckN4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tmMONmsdQsjshiS1NQpXuaceSPv1fGouT4z0L7uBm1NdvkzMDRAts4mUm16+B03Xr
	 sEtIDQL+dOebPeitzuOxVg6WyQNMF6LxehCpgQqSvYOcV87JkHSE53tCzl4Hxq4mC7
	 /PIygdlOpB5GRNEoKX+1ip3/vWJpQSlv6hTbEE54=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fan Wu <fanwu01@zju.edu.cn>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1708/3318] media: rockchip: rga: quiesce IRQ before releasing m2m state
Date: Wed, 18 Nov 2026 15:38:50 +0100
Message-ID: <20261118150413.105130633@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 85c9eb6027c32..be5b3c7c54b33 100644
--- a/drivers/media/platform/rockchip/rga/rga.c
+++ b/drivers/media/platform/rockchip/rga/rga.c
@@ -770,6 +770,7 @@ static int rga_probe(struct platform_device *pdev)
 		ret = irq;
 		goto err_put_clk;
 	}
+	rga->irq = irq;
 
 	ret = devm_request_irq(rga->dev, irq, rga_isr, 0,
 			       dev_name(rga->dev), rga);
@@ -881,8 +882,9 @@ static void rga_remove(struct platform_device *pdev)
 
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



