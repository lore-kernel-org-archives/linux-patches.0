Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795619884;
	b=uLKibhPdGXZx1tFZ9bjDuyBfIEF+UhTyzgPaAJrwBS7yi8BPcpSKPkE9Kdl5QWPLymQR
	 wOBA484L0+rgURZHcglk9m1OuLSQ9HLJacvwoluyoUL7zmL/iXGBQtQ5u+NfdcYlIst14
	 mqy8fAXQDGK0nL6ymJ8w5c9qlLBXf2YRobcDlwFasorRUxsrqtPCunBCWu3mrnxELtlZj
	 ZxS/e3KctQxkM4TfJwKc6d9t4xZGVR4W/2a3HyrcmYY7nk9Z0i0RnQsf0p2xJZfBlprLS
	 wAgWKmr9da5OUvx7x1/yEHBvAsn7qlde2w0pY5AjvtL44qkTROHDWhLjrbFiVo580uA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795619884;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xyD4+vgKbm1UsHcUIRcxfeQQNi1ggiivgMdRJ7o4Z3k=;
	b=titx4viS1DMJlcZod00R0H/75g7TPl8Urwu7WC4Oj6/X99CUFg/Bov6kDQ8/Xtrrxj7z
	 AwDfsVXxaLO54EbavLejoVBqVXnr0XYBSZ7vAI9CGpXTfG8F1r8exY9gItbzIf5RbtkOE
	 WVmL2Vsr/eRRLWpVbwb0T2dcMyKKA0sRR4k4aNZgcriR+mYReEBY8TyF1itIzfr7Vk5ky
	 1+LsKQNh3qYD+NGO2UMavBXIPyi2MA2vIqFeZ4vewuqLv6bKiPVAStfrbtlRpH0CRARw1
	 wQMTWVXMh6V+bDqrDHLzaMrMYW84yq2VNdAbt09WsF+nlfyKhHmyXGIxGMN1fqZzS/A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sd5FHpC2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3E52606A321;
	Wed, 25 Nov 2026 15:18:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sd5FHpC2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C3391F000C6;
	Wed, 25 Nov 2026 15:18:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795619883;
	bh=xyD4+vgKbm1UsHcUIRcxfeQQNi1ggiivgMdRJ7o4Z3k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sd5FHpC2qOtc5ELWDhnmsh5npjD4mQZ1u3bkBW0p30S3N4Ofz5udZ1lkIhdn781BR
	 h0lT0jATx8zgclOa7YEPa8RDeZkDIdYeMI6Ob/yeUMDRNQKzp0zmwSok64WX9H6Crv
	 gly756Kh/x4zBSmLq3gxsSn0VgHoVxrMw+N6OEA4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
	Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 7.3 0736/1005] watchdog: rzv2h: Drop runtime PM handling from WDTDCR init
Date: Wed, 25 Nov 2026 15:34:34 +0100
Message-ID: <20261125143838.999835069@linuxfoundation.org>
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

From: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>

commit f00afd5d8d5dc03994cb67246543d5c70571ebbe upstream.

WDTDCR is located in the CPG region, outside the watchdog module, and is
accessible regardless of the watchdog's clocks and reset state.

Drop the unnecessary runtime PM handling from WDTDCR initialization and
access the register directly.

Fixes: f6febd0a30b6e ("watchdog: Add Watchdog Timer driver for RZ/V2H(P)")
Cc: stable@vger.kernel.org
Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Link: https://patch.msgid.link/20261001165201.763882-5-prabhakar.mahadev-lad.rj@bp.renesas.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/watchdog/rzv2h_wdt.c |    8 --------
 1 file changed, 8 deletions(-)

--- a/drivers/watchdog/rzv2h_wdt.c
+++ b/drivers/watchdog/rzv2h_wdt.c
@@ -256,20 +256,12 @@ static const struct watchdog_ops rzv2h_w
 static int rzt2h_wdt_wdtdcr_init(struct platform_device *pdev,
 				 struct rzv2h_wdt_priv *priv)
 {
-	int ret;
-
 	priv->wdtdcr = devm_platform_ioremap_resource(pdev, 1);
 	if (IS_ERR(priv->wdtdcr))
 		return PTR_ERR(priv->wdtdcr);
 
-	ret = pm_runtime_resume_and_get(&pdev->dev);
-	if (ret)
-		return ret;
-
 	rzt2h_wdt_wdtdcr_count_stop(priv);
 
-	pm_runtime_put_sync(&pdev->dev);
-
 	return 0;
 }
 


