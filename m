Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795041843;
	b=moyzYqp7n7ZUJ6Ehl0cF3Mr0OEeANYYd925IBQvfjXhT51KL95952Xpyqj21dNMkHobs
	 tcRFpmjRxfrkAjkFX/qOERbRmdm0f5Ir1l4BnLVnCscSq1W/GYwPZ7l2ZYjjwl//jQRQr
	 cGNtzF/rUA5oz8gqzf6ZV8Lz6OVuxc0saULEkfx8gFAVF7pkOBm6DfTb34ewptiXGOy1j
	 j7dzpGv+14yTtqFkF1u8zJODDh+I4bZvgK3jV750FPV929J+Dhh8AUEK9REYqzgBkIMN7
	 eQMGZYUi4nE8jn9qXZI8W2copv739nsvmemonJEZ3SGkAjR92iv6PBaoFra4n/cGxFQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795041843;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=MrZLu6BB6DIaTwffAEjWq/OhdzwqY4uQ0DzJjchlIYg=;
	b=HAytbC4qbN3C/suLSOtNlg6cMYQyqcwNA5M7Ih7eZ63AkI000GTV1cWqQYkYuVXMGyJz
	 lvuYKBxkxm5QXamAdGvNW2MMM2N6C8pjk8A8EI/YJDX2pjyxUgMHDWluAY/K/1Fr+Z2b3
	 gVJ7VcDNWDrJxPv/0WMYlCYacoQYujiB+pQrcrDnO4dncyCPzw3KTiF6i0gD+R5oG+ERH
	 I/IIiVmeDcbLaFwSG+4cukFD3zwGXoxhroPqjhalEiGGkn+1YuyL4YUa+LN3KD/90Ad7/
	 sisMSjoUa4jeG+By/6Hz8G1D67cYcou2kgwJOnRzHDavpkBNkgrBevJYekfjgQX1kOw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=co5livRm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8B96606A31C;
	Wed, 18 Nov 2026 22:44:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=co5livRm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 250441F000C4;
	Wed, 18 Nov 2026 22:44:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795041843;
	bh=MrZLu6BB6DIaTwffAEjWq/OhdzwqY4uQ0DzJjchlIYg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=co5livRmr0xhE5ZYACiW6a/hWONVbRIzlXHCKgIZezyZyVIAgS7S8w/xji8NgpUit
	 86xjMIeT8EYkg4yp6rFQDTxp/1XnZ9XWkNm4LIeVl71pM+j8fdKy28wC/ZnESosmDk
	 0kCdwUxGf04x/zgEder3K0hyj2+3A200lyyYgYMg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ajay Kumar Nandam <ajay.nandam@oss.qualcomm.com>,
	bui duc phuc <phucduc.bui@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2958/3318] ASoC: mediatek: mt8195: Propagate IRQ lookup errors
Date: Wed, 18 Nov 2026 15:59:40 +0100
Message-ID: <20261118150449.039824220@linuxfoundation.org>
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
index 4a866bd3801e2..b59abc9e68af1 100644
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



