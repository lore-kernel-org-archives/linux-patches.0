Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A3E953FD2B;
	Wed,  9 Sep 2026 13:55:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788962160; cv=none; b=tzbilGoVFjER8Lj1SEbLpRAZJmpt9QH1OS3dgYz66ohRlkLcTTPRQ/lsYiDr2hZjp3SCE8GJ46XVDeWURB4yFQdJXV/Etds90kcOptKQ9AEDt2KOCG/rk+DVOHb6PexZhao3gVZqAA3Yny9bvZXVQm4iJK/OLErMM3ENv5ut7cE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788962160; c=relaxed/simple;
	bh=EDbPf2V7pyau4ki0MsIYy5wzZl3naDsHYgEjsXUtqbw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WIqwBQgY/q1nZICOQh/DJ9MJs3HIN+X8EvpwWva5OYcUp27DI11alQ31QoUcFUdUh/9Iqw3EkunrX9Z/g8uhIWthhiGR9oEWlH6ASaWz8MQjmsZXYTizJ4qrTTgWPxkmjmIysVriIdb1jEdAJ2cDQbb6DtsLYaaxSykmtzpe/rY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0L0ntzS7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0L0ntzS7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CA2E1F00A3A;
	Wed,  9 Sep 2026 13:55:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788962158;
	bh=pPwTYetqdP83vT26LedEZDC/hFjRPaXgRhQ+yT3Jyr4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0L0ntzS7kFZm5oSc6/mqszZAUhzTqyHgn09i7zMkld5WV3HWlE+VaCuvJqPTKfbJe
	 Vwz7oTw+L5EuZ0rKsxJVsh9oIupZWgKMyMjxMc0q8DrZ1tputvE6A8h0S8LeE6bDSR
	 wM9xgfDSPUZQ9/UVkR8MDqaiLseE8og+1ldLl7qc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 7.2 194/556] mtd: nand: realtek-ecc: add missing MODULE_DEVICE_TABLE()
Date: Wed,  9 Sep 2026 15:37:54 +0200
Message-ID: <20260909134237.227462031@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

commit 5b2444b4d575d8117809c57801562ef37ca2d4af upstream.

The Realtek external ECC engine driver has an OF match table wired into
its platform driver, but the table is not exported with
MODULE_DEVICE_TABLE().

When the driver is built as a module, the missing OF module alias
prevents automatic module loading from the compatible string.

Add the missing MODULE_DEVICE_TABLE() entry.

Fixes: 3148d0e5b1c5 ("mtd: nand: realtek-ecc: Add Realtek external ECC engine support")
Cc: stable@vger.kernel.org
Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mtd/nand/ecc-realtek.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/mtd/nand/ecc-realtek.c
+++ b/drivers/mtd/nand/ecc-realtek.c
@@ -450,6 +450,7 @@ static const struct of_device_id rtl_ecc
 	},
 	{ /* sentinel */ },
 };
+MODULE_DEVICE_TABLE(of, rtl_ecc_of_ids);
 
 static struct platform_driver rtl_ecc_driver = {
 	.driver	= {


