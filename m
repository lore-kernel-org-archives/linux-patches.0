Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795620108;
	b=X0sGWkMWY9JWPIn7+feXVtWFfWGX+ys773bvdchT05hxCI/OOF9jCVH3ZNDUPFV0LlMd
	 tPb77naAqpbjpvvkOsbdpSj1e2Cj1RF5+SmV7BI01KW1KWeCGgu/bi7Sqkr7hec7FcPOr
	 xOCJZNPDyGBpa+gaC3zjhn840Zqn5MCXF06CaPVpi8b/Xw2e3eRryBwuNhWbkqBSHJxaM
	 zf65U8XxW4MUa+y+9/02BP76mWgNxfovyiyCq9/9HDBiT7DvgXADZfoJ5d1FCAXrDnyV1
	 2Qbpg9Jj5PWNTeuXkJmpJ0Xnl+K/fZ7Lvsm5O2r9drKfVov8TB4mpJBOD4ZkpMCbR5A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795620108;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Zskb5R3sr7hZHLZlIWJHOUergTVG7ELIkApqkezu/w4=;
	b=z7idZdFgx8xX5UdHy37vuGxgb3fPGf4vJod9dhCG6LSVzwYwO4zx7J6ySf3lh1NEF2WW
	 m/ph3lco8MeFy1vR+MJNFl+lxsCJBbyrDMXqkDPq1iSr/o9YAo202/0i/3bgXa3HGY4ID
	 6y/bZLbinWwQw52CQzDG59nk6HNA45Ha/bOgTxU+oWV1hsYc+GJld7l1DFWwb0Lfet2EW
	 Rlwhw0jXHA4skEaYthKz/r8bRTldsl1W+yNYGWL2zehSXL10fRufvNjExKxPrOxVCnE/f
	 G/x5h98EkHynHcs4IF28gqvohckc8GJhMal3RvV1qhDj4IJq9iCN9+5kyH9k8rynvIA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0bwDgqq0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AFF8606A31E;
	Wed, 25 Nov 2026 15:21:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0bwDgqq0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FE7F1F000CA;
	Wed, 25 Nov 2026 15:21:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795620107;
	bh=Zskb5R3sr7hZHLZlIWJHOUergTVG7ELIkApqkezu/w4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0bwDgqq0VlTUjiJZGv5IIdriEOWe79UO87pmR++D3n64pVYnn2LE2pnKb6KJwsm+z
	 LIf+O69GxBIWw1Uo4vp+aDuXcSJakjoCLXMBwamvCqEdfNnvlImTRoBZnh5k+xSvpQ
	 VMawE/jnroZrhkcEdBaNZ8OT4PIQSkKgDgEPi69g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Subject: [PATCH 7.3 0811/1005] gpio: brcmstb: fix UAF after IRQ domain setup failure
Date: Wed, 25 Nov 2026 15:35:49 +0100
Message-ID: <20261125143840.727056958@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

From: Guangshuo Li <lgs201920130244@gmail.com>

commit baa14758afb3e2828de1f76511edc1de50216f39 upstream.

When devm_request_irq() fails in brcmstb_gpio_irq_setup(), the error
path removes the IRQ domain but leaves priv->irq_domain non-NULL.

The probe error path subsequently calls brcmstb_gpio_remove(), which
checks priv->irq_domain and attempts to access the already-freed
domain through irq_find_mapping(). It also attempts to remove the
domain again, resulting in a use-after-free and potentially further
memory corruption.

Set priv->irq_domain to NULL after removing it so that the common
cleanup path skips the already-freed IRQ domain.

This issue was found by our static analysis tool under development.

Fixes: 0ba31dc201de ("gpio: brcmstb: consolidate interrupt domains")
Cc: stable@vger.kernel.org
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
Reviewed-by: Florian Fainelli <florian.fainelli@broadcom.com>
Link: https://patch.msgid.link/20261026115227.41779-1-lgs201920130244@gmail.com
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpio/gpio-brcmstb.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/gpio/gpio-brcmstb.c
+++ b/drivers/gpio/gpio-brcmstb.c
@@ -513,6 +513,7 @@ static int brcmstb_gpio_irq_setup(struct
 
 out_free_domain:
 	irq_domain_remove(priv->irq_domain);
+	priv->irq_domain = NULL;
 
 	return err;
 }


