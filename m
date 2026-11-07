Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064366;
	b=qZyvWugpDDpePjpAT7wsddeYnQj3j7x08y4cvjX0zgYTeMUc5Mi6yyFoG8S1jEWI4wbk
	 N6w6Sab+7Yb2W6a4N4kzh6XLYNGPfGNZTgiHoDmrlKIkTlzQw9OA4VS+Glcv2yzsYc/Pd
	 NWRvL1XlfFsX8e5OibndIyHbVZC1Bq3tPdoytfLLz2v+qbKH+KweTXYolCwbvmt7j9WMf
	 aZgH5m8eU9yRh6vfyCLAm31LitrcuQnY+dv3hQvDQcZabaLMKciuPcRt4tO25moTO4Zpl
	 pjbfQi2KI4i1/xlWwVRDUQId+B/rYecgxwIg6hgWzG84wcMxyB90jQizn+NiG3ZjVww==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064366;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=DWECRZ2hPU01LyTMHh8xfCahdLWkenv0IXw6l0QS20A=;
	b=ejcDFAHy+/fEpWUUliT6HdIpLQbBS253brdVZ8S4w3BAPPnvjlNWn5OZD4xhF51F3fo0
	 fCIpIJ+rkra8l28LxOjFrUj8TpTbwqoiKGS26bptgT1K61lMAi/kO/jE7PwDnh9PdV+ch
	 Koaeo+WhAeovayUfu3bNzsld7xrxmKWAeeSpRkTFtf/tLNHArkxdUJ7UWrVnMU44CFw0/
	 AfmyP478OxKaO46XnL6Q+oXGZ9lTAEj/wGCDW7iDQeNuxoLnflizFC3TP7ll/KG5bqkO8
	 77bnlYuden7vQ1/5s1XL+s5KdeilUzZ6AIrtl/mOPc0OtUn/rEyxZqq95avHoZgM/QQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QnZbsKtV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D661606B899;
	Sat,  7 Nov 2026 15:12:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QnZbsKtV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B3741F0089F;
	Sat,  7 Nov 2026 15:12:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064366;
	bh=DWECRZ2hPU01LyTMHh8xfCahdLWkenv0IXw6l0QS20A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QnZbsKtVYqb9ARJTwQYqrHTED8KEyCvn1EyIrpXkdzLv1mBdwPsFqLC50f3EB7VyE
	 fhwYelM3OyyHHA4Rtwst44A42gn9/qA+sDlLa2+KaKaWbuyrZvcJHkjJiygXlQz8fq
	 Eb8Ci29G2Ryl3a00KlHEUxLfV2pfIP+/yQBd6i70=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fan Wu <fanwu01@zju.edu.cn>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0447/1257] media: rockchip: rga: quiesce IRQ before releasing m2m state
Date: Sat,  7 Nov 2026 08:45:43 -0500
Message-ID: <20261107134951.825256391@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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
index b3cb6bf8eb863..fbc99462dce28 100644
--- a/drivers/media/platform/rockchip/rga/rga.c
+++ b/drivers/media/platform/rockchip/rga/rga.c
@@ -797,6 +797,7 @@ static int rga_probe(struct platform_device *pdev)
 		ret = irq;
 		goto err_put_clk;
 	}
+	rga->irq = irq;
 
 	ret = devm_request_irq(rga->dev, irq, rga_isr,
 			       rga_has_internal_iommu(rga) ? 0 : IRQF_SHARED,
@@ -876,8 +877,9 @@ static void rga_remove(struct platform_device *pdev)
 
 	v4l2_info(&rga->v4l2_dev, "Removing\n");
 
-	v4l2_m2m_release(rga->m2m_dev);
 	video_unregister_device(rga->vfd);
+	devm_free_irq(rga->dev, rga->irq, rga);
+	v4l2_m2m_release(rga->m2m_dev);
 	v4l2_device_unregister(&rga->v4l2_dev);
 
 	pm_runtime_disable(rga->dev);
diff --git a/drivers/media/platform/rockchip/rga/rga.h b/drivers/media/platform/rockchip/rga/rga.h
index bd431534d0d39..7bcdf36c11b4d 100644
--- a/drivers/media/platform/rockchip/rga/rga.h
+++ b/drivers/media/platform/rockchip/rga/rga.h
@@ -73,6 +73,7 @@ struct rockchip_rga {
 	struct device *dev;
 	struct regmap *grf;
 	void __iomem *regs;
+	int irq;
 	struct clk_bulk_data *clks;
 	int num_clks;
 	struct rockchip_rga_version version;
-- 
2.53.0



