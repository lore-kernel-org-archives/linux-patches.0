Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B559D1DED5E;
	Wed, 19 Feb 2025 08:50:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739955040; cv=none; b=aq/mUM7IxXbtyvzDcP0moJfWdaf0ORDSdEpWwFZPdhDGCguZR5gkBmnuRDtsGGIZdzyrUgGlpjx8+OPYq/74avfzjQmKLFV+H7Ro44BYE6QNqZus05yGYOUnXdeTS1TNLA0+Si7felR41VdG+JjI1e2r1+POU1FSuJ+H/qu4P+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739955040; c=relaxed/simple;
	bh=32W734hV7tquQPfOoM+RLnLgTmrC5rUIfb39DRj4TGg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kHp0MygPXaWglcjVPeq+c++yHK+qnM1vR2hysPdjFyts/EC1vZJCdJnouQrqKxJID6j/LNNfGRil2R7QJLm4ln4NnfgLGWS+YhyPH7H8NJrwlJ0qoEJM1RGmH6wHQRypAMRyLxhIcFILPgL8nd2qm/UVl+xeCiOwYwRfsnEOb2E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nlTx8oxG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nlTx8oxG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE86BC4CED1;
	Wed, 19 Feb 2025 08:50:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739955040;
	bh=32W734hV7tquQPfOoM+RLnLgTmrC5rUIfb39DRj4TGg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nlTx8oxGc0zBk4iCVvuSAzUV14uh4SsM6XlFZUBfEw6LXuG2r5q3D1Eo1cczQcLoD
	 pFo8XEMLYyKjGmE3QDg2/DLLTEccc0zw+h8nDm7JgSNXeiDlsopefMFeJHe65vJV7b
	 7aD6F6j+TGyqnYf9Bk5Osac6Hfw4g7GfomjjIRHY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Guo Ren <guoren@linux.alibaba.com>
Subject: [PATCH 6.12 112/230] usb: gadget: udc: renesas_usb3: Fix compiler warning
Date: Wed, 19 Feb 2025 09:27:09 +0100
Message-ID: <20250219082606.070724895@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082601.683263930@linuxfoundation.org>
References: <20250219082601.683263930@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -310,7 +310,7 @@ struct renesas_usb3_request {
 	struct list_head	queue;
 };
 
-#define USB3_EP_NAME_SIZE	8
+#define USB3_EP_NAME_SIZE	16
 struct renesas_usb3_ep {
 	struct usb_ep ep;
 	struct renesas_usb3 *usb3;


