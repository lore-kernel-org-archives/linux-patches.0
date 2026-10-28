Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793211240;
	b=azloLMLooRtxI2+L0wMmFJ58ikL/XlvZMdKPIdDIYW51Sn+1VkXgoxYpEJMKPgy4OWtV
	 nSjO2xM8cr0NrBtdG8rmqzgePrW6LQqznm5U9ntk9NcTR5Zx9LygbbEgRypWwiBTfZOAE
	 RZq8+VAxGjCcbJEff2wzhEE9Jiq5b5+qhFt9t+XC6RZ1X9fgyPuR8mvt3vqtG/agSV4mE
	 Q0h2iI1h3KWJ2VGKXHHEBbVORJQ1yBViHTRT5t671eoKETc5ySmJ+9iVnKhCLdCSzwgmC
	 KuTfrqCLALy/YASemzCjw8Ab4U4iOTEncpOWnkMtGHeeyhJV6w6tp2SjVgiT/d9fFXQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793211240;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=oYuFwPF3pOBIpQ+Eke9KX+Nz55MJWTDXsyg51GozVJY=;
	b=Y1yyQdaJLxrbWOyxfnCKQo0LP8LrLivwIgZOOIqUmSkVMAUOtnkoMfPhZbMkc3MZpt5e
	 2MEd/eSNNJh0RlAln1GXzvj7V1rmqrj0TM3t4MKEmZvlmJwHu8RmCXmMY/z4OMp1USXeV
	 GiJH5L+TuFcQNsiP3ju78bxZ3wwHwRZ9TPqBofVpRjSkaajBQz6nthiKFECmamxHBgo4t
	 4w2OcwHCxDT1FQNsFhNZvfY2zXsn23+vwELZWYXLaBW45OOZTc4wO9uBKVoTClXorId24
	 5pLAH5IWSh1rMMfDaDv5jBrR1z/P6KO/Z255njsntajNPD8Ebazxmn5AX4ssTPLfymA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vgIYW+vx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3884560A261D;
	Wed, 28 Oct 2026 18:14:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vgIYW+vx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 701CA1F01825;
	Wed, 28 Oct 2026 18:13:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793211240;
	bh=oYuFwPF3pOBIpQ+Eke9KX+Nz55MJWTDXsyg51GozVJY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vgIYW+vxgvimjjig7mOeMEYGTDNjXTFVAoi9bGacCxTuj1LLjs/6seF64AgM6rc8w
	 AtOZ9tmt5OXOocTJ90qih6AwwZVfynVwaA7Ap9IVlrIOQU+vdNRZkJkVRvKiGhq41n
	 AjFW0U8HVegzvCi6mpC5KyD4Cqw3swwIeLGVbi8U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Ni <nichen@iscas.ac.cn>,
	Alan Stern <stern@rowland.harvard.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 307/571] usb: ohci-spear: Remove unnecessary NULL check before clk_disable_unprepare()
Date: Wed, 28 Oct 2026 17:57:34 +0100
Message-ID: <20261028170015.283701837@linuxfoundation.org>
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

From: Chen Ni <nichen@iscas.ac.cn>

[ Upstream commit a891b9aebcc7406fe2f439d184bac3948fb08645 ]

clk_disable_unprepare() already checks NULL by using IS_ERR_OR_NULL.
Remove unneeded NULL check for clk here.

Signed-off-by: Chen Ni <nichen@iscas.ac.cn>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
Link: https://lore.kernel.org/r/20250617042050.1930940-1-nichen@iscas.ac.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: b1b0f8bdbbc8 ("usb: ohci-spear: disable controller wakeup on removal")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/host/ohci-spear.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/usb/host/ohci-spear.c b/drivers/usb/host/ohci-spear.c
index b4cd9e6c72fd0..986406f7aeb15 100644
--- a/drivers/usb/host/ohci-spear.c
+++ b/drivers/usb/host/ohci-spear.c
@@ -105,8 +105,7 @@ static int spear_ohci_hcd_drv_remove(struct platform_device *pdev)
 	struct spear_ohci *sohci_p = to_spear_ohci(hcd);
 
 	usb_remove_hcd(hcd);
-	if (sohci_p->clk)
-		clk_disable_unprepare(sohci_p->clk);
+	clk_disable_unprepare(sohci_p->clk);
 
 	usb_put_hcd(hcd);
 	return 0;
-- 
2.53.0



