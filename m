Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793212308;
	b=if06ylFG3J+UkuSs2dPnOoL1oXTLWzwuVJlrT8zaN1yfWJDZEDPZ64jViLIbdo92eAuT
	 LpshovfJWg7ihh4NNYTD5mV5GcXI6+BzpwK3SvX3ETCVzcDwthIjr97Dht+BBxMtlDdOu
	 GCTIF82mzunfYJdM7XLvWwgTfusx0qCKheAZX2EuXpH9k79idYfnTBhDZJ2EG8HW61ZDo
	 ZATN7afupNivyzUPxC8YrVxusGSnCdisWHXAzRyu48XZu5OEPrvqDQKtM0NSPXX8+tQgL
	 ZJ2Og9xmOg6fuDt7nM8PjzsKo9o0hfaRo+FqevRYLU1KoFg6wrX8oAvEOFVp1l7Dr0w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793212308;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=EJxBTjYfLDQhTDTRdxquYgCPQ1LCpwGtrPBzuq1cjLc=;
	b=gkIgwscITf9YZIMTOSxhyNHizwflNsNajOMi9QAjIH7y7zTm8gwbsPD2rUNkkrr+AIL8
	 U+1A4uEnnF7M5VCbH8L/EDPJs6zwvCHOB7zWwynGG0rBE/EKOJEQxj+EoFxXDxDrUkxQk
	 au+zhITv2RLM82YH1AFT5E305teMmTTZuiNZ1z5gxv9NT1K3+/PpzCoJx3HjuFLjo8NV4
	 sxZMCGKNHORoz0jScmjxC/R4zwnxv+U7d2REmSlg6OLonZPMAw2HDXJIklC0KKnUzHOqZ
	 xRvd+tzqrC2XU2iSlB8wL7EGAPDtCf3uP/VTdJz/X08m7UJEGGY0uCm3oh3KmfDwh0w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="oewl8nT/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E07E606A320;
	Wed, 28 Oct 2026 18:31:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oewl8nT/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CA921F031E3;
	Wed, 28 Oct 2026 18:31:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793212307;
	bh=EJxBTjYfLDQhTDTRdxquYgCPQ1LCpwGtrPBzuq1cjLc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oewl8nT/0ifuSLOZf8YxscZLkExUolA+/zJyReKbqaeYnXYeG9Q9nefY9MnuuaxUx
	 mKh5HPeX/1bzP/VtBtni6K1bXN+uZZ9YBzu0UQfg7GHxQEBZhkuL13fWsSwHnUmgdh
	 RIAP8iBpAaV4wgeFEowm+pb5/4HVpRDj55F4CvBc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Narasimharao Vadlamudi <ahmisaranrao@gmail.com>,
	Detlev Casanova <detlev.casanova@collabora.com>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0107/1887] media: rkvdec: Propagate platform_get_irq() errors
Date: Wed, 28 Oct 2026 17:36:43 +0100
Message-ID: <20261028170501.669181418@linuxfoundation.org>
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

From: Narasimharao Vadlamudi <ahmisaranrao@gmail.com>

[ Upstream commit c37aca64206fafe938119e801a3fd10a537a051f ]

platform_get_irq() returns a positive IRQ number on success and a
negative error code on failure. It no longer returns zero. The driver
currently returns -ENXIO for all failures, which loses useful errors
such as -EPROBE_DEFER.

Return the error from platform_get_irq() directly.

Fixes: cd33c830448b ("media: rkvdec: Add the rkvdec driver")
Cc: stable@vger.kernel.org
Signed-off-by: Narasimharao Vadlamudi <ahmisaranrao@gmail.com>
Reviewed-by: Detlev Casanova <detlev.casanova@collabora.com>
Signed-off-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
[ adjusted the patch path to drivers/staging/media/rkvdec/rkvdec.c. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/media/rkvdec/rkvdec.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/media/rkvdec/rkvdec.c b/drivers/staging/media/rkvdec/rkvdec.c
index b5847259f4541..0b19a089e56ca 100644
--- a/drivers/staging/media/rkvdec/rkvdec.c
+++ b/drivers/staging/media/rkvdec/rkvdec.c
@@ -1044,8 +1044,8 @@ static int rkvdec_probe(struct platform_device *pdev)
 	vb2_dma_contig_set_max_seg_size(&pdev->dev, DMA_BIT_MASK(32));
 
 	irq = platform_get_irq(pdev, 0);
-	if (irq <= 0)
-		return -ENXIO;
+	if (irq < 0)
+		return irq;
 
 	ret = devm_request_threaded_irq(&pdev->dev, irq, NULL,
 					rkvdec_irq_handler, IRQF_ONESHOT,
-- 
2.53.0



