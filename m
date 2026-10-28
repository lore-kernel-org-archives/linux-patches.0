Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793210646;
	b=dtfW6JnHfg4aVjT2q5Wj5ak4g1Nga0ziwx4tJfTIeHnQ8/o4UriFJcwAQwjokEj8bCp6
	 K5WIqjwSeOScn1DWYmNCIkvX0Bn2+0+CGIW9FeUqpltaZXlO0DGA9NyjWWfK1caQWYiZo
	 BhgqhsaTXSIeUz03U6h4odilbGcDDlOZDAWfFLitKIykUsNdhvbFLWHtwttxd1jqR0Yh7
	 z7wZR+VinekqjYaFn0T2o/EJyMHjFLbPyCFxayxu6Ztli0TwhMRz1gkYpl21h8U9nDVxE
	 5TM32TQuzfqFnDsm48utlrVlFEdIG28kzddpE0Ucq4bGpY82Y1nsbaVhMbMlVZtmL5g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793210646;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=YZbC+Ap8ifkO7rYK6Nff3NzsnM9S/IEwRR5+KPoHZRY=;
	b=Emcc16ipOM1S2ASV5fd8dL5XNJEA66zI8FONZnMt56AlVV4+13vqNU6zal2S2DV2ZrBW
	 J2hRhnvW3o25r2jS1CWkTyCB9SesPa4x7wnaVIwIYTUjDkdWCxfCFMfvxwCOMIDpSyqC/
	 sO2taSYgELkStKXee3u2w5h3hAqYQlzKN7/4Rx5g4WmStV4GN6x4fHFIWmOdtV1jmY4Jx
	 oTwSuz4Oxhhc4yzhkuxRQYCOOmN48WX7ic+4n7c/e0l1WWGOHhAogvFOkOw/ejkIhWNSv
	 b7jK5KGXYQ//tKGSfULWw4TifJLiPCk91HRfCy3e/xwBdaeu6vWDe4XwGGH+Pwp553Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=roAP8rL2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1B64606A31A;
	Wed, 28 Oct 2026 18:04:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=roAP8rL2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F16FE1F01825;
	Wed, 28 Oct 2026 18:04:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793210646;
	bh=YZbC+Ap8ifkO7rYK6Nff3NzsnM9S/IEwRR5+KPoHZRY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=roAP8rL2jyRpFb2oTJQGpTi95WxY2eBd8q0ai5Otq/q3SQ/syFYMfsTXEyxaHP55O
	 VGRKbCzsZZqxB7LNc10sj6vLFPNDaaNPHZLMG8Ae35bXDjFyhnvVvMUOQHh9TCt7A/
	 NLbRNO2cjyt+EgyVqwEM45a/uPSB1Mu4ErdHBTbY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Narasimharao Vadlamudi <ahmisaranrao@gmail.com>,
	Detlev Casanova <detlev.casanova@collabora.com>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 082/571] media: rkvdec: Propagate platform_get_irq() errors
Date: Wed, 28 Oct 2026 17:53:49 +0100
Message-ID: <20261028170009.973018337@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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
index 41b93f09e6df0..8b87213f69a70 100644
--- a/drivers/staging/media/rkvdec/rkvdec.c
+++ b/drivers/staging/media/rkvdec/rkvdec.c
@@ -1017,8 +1017,8 @@ static int rkvdec_probe(struct platform_device *pdev)
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



