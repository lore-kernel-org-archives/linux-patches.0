Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DDDD17A2E8;
	Mon, 10 Mar 2025 18:00:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741629629; cv=none; b=akXCUE0XJ88xCa54/t3G6Vy0grDP4XGP7wtaGyFoc5RqbjKDxA5ODceUFczjZqmj9KcnyKB1pZGHG+hs3mamTr2LwWCeQrUcUUjhaWiGBDYHe25fcwqUIuadXU+GPWsVeHsiNX0pbqJdYBhW6jCzNe53FFzf/Krn1ZawGlGbQ7E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741629629; c=relaxed/simple;
	bh=of7iNaOIDExX/hkqEo6z21W1mim+FP6WdnksGsJd6G4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FyRhpqcl//NkR+r0cmSd4FhD7dYXk546QP9LJJw5wNKVsPrWbcutH9WFg9TixBR/XYbvC3Exb3oeS/QYEWFoGAcGVTO0qlE6JTtimVNIWSkWIEUweQ3GG5uy4d1/4/CkWvtBw70CFaPqrvOEt9o5Jucf21aHwEKk4mXGGldyIrs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1B1EG5zc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1B1EG5zc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E755FC4CEE5;
	Mon, 10 Mar 2025 18:00:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741629629;
	bh=of7iNaOIDExX/hkqEo6z21W1mim+FP6WdnksGsJd6G4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1B1EG5zcLjNee9UmFlXA5mOww9lgrF+bJ/jYvDEbkw5tWjTnJ13cwaHRggv3zqDnf
	 33qkjcgg/YuPFHq/0wzNg3AHHUjeqW8KKCTP31Y0t87DwkQMQtIiVwOAbmc0xFVreK
	 ajsuV1yBGDyBnW3s44ffvAKSLieJ/v8ajT1edKP8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Guo Ren <guoren@linux.alibaba.com>
Subject: [PATCH 5.15 361/620] usb: gadget: udc: renesas_usb3: Fix compiler warning
Date: Mon, 10 Mar 2025 18:03:27 +0100
Message-ID: <20250310170559.858940212@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guo Ren <guoren@linux.alibaba.com>

commit 335a1fc1193481f8027f176649c72868172f6f8b upstream.

drivers/usb/gadget/udc/renesas_usb3.c: In function 'renesas_usb3_probe':
drivers/usb/gadget/udc/renesas_usb3.c:2638:73: warning: '%d'
directive output may be truncated writing between 1 and 11 bytes into a
region of size 6 [-Wformat-truncation=]
2638 |   snprintf(usb3_ep->ep_name, sizeof(usb3_ep->ep_name), "ep%d", i);
                                    ^~~~~~~~~~~~~~~~~~~~~~~~     ^~   ^

Fixes: 746bfe63bba3 ("usb: gadget: renesas_usb3: add support for Renesas USB3.0 peripheral controller")
Cc: stable@vger.kernel.org
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202501201409.BIQPtkeB-lkp@intel.com/
Signed-off-by: Guo Ren <guoren@linux.alibaba.com>
Link: https://lore.kernel.org/r/20250122081231.47594-1-guoren@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/udc/renesas_usb3.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/gadget/udc/renesas_usb3.c
+++ b/drivers/usb/gadget/udc/renesas_usb3.c
@@ -306,7 +306,7 @@ struct renesas_usb3_request {
 	struct list_head	queue;
 };
 
-#define USB3_EP_NAME_SIZE	8
+#define USB3_EP_NAME_SIZE	16
 struct renesas_usb3_ep {
 	struct usb_ep ep;
 	struct renesas_usb3 *usb3;


