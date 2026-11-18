Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795027019;
	b=NvPyalPxZXvooXgWVCYxUmXPfKg/AjH85IUMK0E571MSV8nvWPs44ZqAE90KPod5S18Q
	 4aatuMXHGWYlCR1D2y0bx9O05c6EudsuFxUyQB+gWruVgaqtMNiqXKHVNLB1xbMziW5lt
	 NBj09HNHzGU7T6JNJHjVIEgUsQa2eFlqa6LtG5MejCJMY2gEMd6Vlw45qpfsvHdTfz2xZ
	 PGtz42Vpu+prUUUrKFYT92zYA39KuOfWv5LmGTvrcsHep1y6200Y62RV9AKDaHLfzah7T
	 pW3GVrrG9pb6SziBpve+sEYsanultZoBaBtkRygr3jY+MaFq5CpDzgqBgJdqfUrtHLg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795027019;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=IQvqvp+zVwcq1oQ+Sh/jlxYy5x0sHbLuBJ7QbM76N6I=;
	b=sblE+ZiyzTUOAA/NqGZ9tt7V8D1W6jCNeKguLGty8bdhDCIAlwjV5wg+Iioz3iRJN4zh
	 MUmmlno8p9vTbZ4L+5ag8n7RGlyrZuqrcE6UKP6pPFfPHFd3Z/w23PlxgVGORndNDP0qJ
	 HhLLQ0ktWrNBPEwMhkylu8eQ3OLj8Xf4eJnCxq7sJbJI9NwAs4ULcrze3+PJ+9CeU041r
	 LIYm03MUVw66VuGtD6kdxMGmdqWPTw6CGI+ZrkO5AImRU5KffmJBuR1XoGjIr1ZwiOD3p
	 gHj8jFSOLn/NdT7r/UbocBFK2keKTR+BnUu8QoGnPR9fgid4//mJGDtm3gdi/Scdg/A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="AR/PBATc";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DF72606A325;
	Wed, 18 Nov 2026 18:36:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AR/PBATc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CE661F000C7;
	Wed, 18 Nov 2026 18:36:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795027019;
	bh=IQvqvp+zVwcq1oQ+Sh/jlxYy5x0sHbLuBJ7QbM76N6I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AR/PBATc0NJv5koaMaddF+B1fraMJNfSsIEhLkDUOy6TNNiFra1fsXQ9dQQoPKJzW
	 1KWu+mFGFI14fOCTYbmVzMsmSo2wAyYTeZx8CHxzmYlMWAS/dWWeiqiguSetAQzP8b
	 CHCeMF5ui1/woc+SjypDumIsh1+BajEzvovuGN/Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ajay Kumar Nandam <ajay.nandam@oss.qualcomm.com>,
	bui duc phuc <phucduc.bui@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1639/2151] ASoC: mediatek: mt8195: Propagate IRQ lookup errors
Date: Wed, 18 Nov 2026 15:56:14 +0100
Message-ID: <20261118150221.570019263@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: bui duc phuc <phucduc.bui@gmail.com>

[ Upstream commit 9d5dedb285fb61a40e04f337d9e06fc59c065857 ]

Propagate the error returned by platform_get_irq() instead of
replacing it with -ENXIO.

This preserves errors such as -EPROBE_DEFER for proper handling
by the caller.

Fixes: 6746cc858259 ("ASoC: mediatek: mt8195: add platform driver")
Reviewed-by: Ajay Kumar Nandam <ajay.nandam@oss.qualcomm.com>
Signed-off-by: bui duc phuc <phucduc.bui@gmail.com>
Link: https://patch.msgid.link/20261014112752.683032-12-phucduc.bui@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/mediatek/mt8195/mt8195-afe-pcm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/mediatek/mt8195/mt8195-afe-pcm.c b/sound/soc/mediatek/mt8195/mt8195-afe-pcm.c
index 6de510ea33cd3..6197d31688b97 100644
--- a/sound/soc/mediatek/mt8195/mt8195-afe-pcm.c
+++ b/sound/soc/mediatek/mt8195/mt8195-afe-pcm.c
@@ -3134,7 +3134,7 @@ static int mt8195_afe_pcm_dev_probe(struct platform_device *pdev)
 	/* request irq */
 	irq_id = platform_get_irq(pdev, 0);
 	if (irq_id < 0)
-		return -ENXIO;
+		return irq_id;
 
 	ret = devm_request_irq(dev, irq_id, mt8195_afe_irq_handler,
 			       IRQF_TRIGGER_NONE, "asys-isr", (void *)afe);
-- 
2.53.0



