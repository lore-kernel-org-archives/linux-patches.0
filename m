Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795049999;
	b=c4nS7SuFvjlRA9ycp2tUSvkIW3qr/eEXT5ALN/dMtwkwmwPd8DPl0g8A5uUiMzLbZJc2
	 h2o/F37OQhSAH19yaN9+5cY0cDj0tONv5g+zDBT0Yt1wnrbj1S+6I7HjbIQgyI2jaBg8I
	 9HhF7+3DOfl69aR53kfaWT8k2To2owqFzJuxSu4+stKJkpxZgo83ZH1uMwrfBEUhLVHB+
	 NA1K6wAjGIZh/IVr6hBI5ELN2TA7Ve9plwwXU2WNKTdLIAKAWMKRuQjxzyzvEwIreiY+e
	 BmHoHWic7bCygyCkXwCo7ybMdHyF+RPn1k6frwMxQNMybRjQy6Wqodc4IFHrbpP7NaQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795049999;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ivmC+YH3WScCDKCWEQOBOnfCyCftjpb6fTFwURD7WqY=;
	b=xqGIbMiwj/RJ4ywIg/KQfH8MYty3gVQkwf/aAS4470jNjoRo2tYAHj+2mfodsJP71Ujm
	 /cw6xenVEmEh4VYVoPs41B9JzggzMMWJvSvvByKB7gZwaYK1IHoXyjtvEZ9egNw1VN3ks
	 RaFRqJCIaDBRi6xNE+QCaLJcL3+bOgbCvfbePZbd06lnrABA8BYQ20Sxq1ttX6Kf9Y1O6
	 y8NchXnSNU8qPaNaU8Gm8T94VTfuM1Q6IZ9ksRGC1V/jUGo/LMH6hy9yi4Oh0ELwFTJwp
	 YmD/oXL+m3fz4pv4NHh5HxTbGz/cvOyhH5VGM6HNms42H3I8fkf1NeJkD86veE0GWrw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YmIjLB5V;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D14D6606A331;
	Thu, 19 Nov 2026 00:59:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YmIjLB5V
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BA3A1F000CB;
	Thu, 19 Nov 2026 00:59:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795049999;
	bh=ivmC+YH3WScCDKCWEQOBOnfCyCftjpb6fTFwURD7WqY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YmIjLB5VNIl5+jjRyYVK0aofw4kUr3D4CdIKRhsDdxfL+K6/TTKKuGWFTlqsm31o8
	 cByvP+v9jUbhYxI94mH0iKmdO9MHumELD2ZGN0/RWt42IVJ7e7WFXngG42jxqwktuX
	 rxFQxkV88PywjISA59YrPE5O7KKh66hCNkmT7zyg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ajay Kumar Nandam <ajay.nandam@oss.qualcomm.com>,
	bui duc phuc <phucduc.bui@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2553/2857] ASoC: mediatek: mt8195: Propagate IRQ lookup errors
Date: Wed, 18 Nov 2026 15:59:47 +0100
Message-ID: <20261118150333.429249487@linuxfoundation.org>
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
index ab2930669568c..0093a4c59bbea 100644
--- a/sound/soc/mediatek/mt8195/mt8195-afe-pcm.c
+++ b/sound/soc/mediatek/mt8195/mt8195-afe-pcm.c
@@ -3189,7 +3189,7 @@ static int mt8195_afe_pcm_dev_probe(struct platform_device *pdev)
 	/* request irq */
 	irq_id = platform_get_irq(pdev, 0);
 	if (irq_id < 0)
-		return -ENXIO;
+		return irq_id;
 
 	ret = devm_request_irq(dev, irq_id, mt8195_afe_irq_handler,
 			       IRQF_TRIGGER_NONE, "asys-isr", (void *)afe);
-- 
2.53.0



