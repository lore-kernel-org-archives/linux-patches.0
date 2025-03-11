Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43BA425EF8A;
	Tue, 11 Mar 2025 15:31:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741707117; cv=none; b=UvCmpVoox783haqDHhxhxbcJaLZc4mea7Ee5VaQBMDYRdQHqZY/+tmbZ8JrE17noe1/ipiNhhQ3ebqO7bRQl4STyAwZDN/zHYP2jLUQUPcnvgg1wTysLBnXkm9jqHeqIE/awRoyoJGxRsFy0Rp8i7QZFjIoS4QQVxXi1PtNF6EI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741707117; c=relaxed/simple;
	bh=8jX767ZrEacb4mhXxpgDLIxrog1GgSexNIEsM2tGo+M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fKHBeI5WCrK+d3/Yr3C+jdBREzy/i6LVWBTmJqoykjnSBXcUB+UZyXI3945+geS5lENoHmkNAKwBxDYnWWorBaC7m1N4RNePghOIH3/P7MdRvCUGJCnne9L9qBLognLTm2DgKQ9WbR/zXeycY3xT4ZgC0DOvTHkHQXBKx5bRQe4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wLgqRPf2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wLgqRPf2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC78BC4CEE9;
	Tue, 11 Mar 2025 15:31:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741707117;
	bh=8jX767ZrEacb4mhXxpgDLIxrog1GgSexNIEsM2tGo+M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wLgqRPf2jVz8xa8DbX9ibdWJMi5LiiBvhM+WjykQEejpmeOCrJvz/tzGbZwgOa0V6
	 0D/Mno1Ni3mnY+xX1bv/C6n3F+4PDSDtNBpxnCU7uuxinnlY17wA9NhKPrU4fV6MW2
	 YbhqbUT4roSbvi+kWuNypuDCWIs4px64OEQreP+o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Guo Ren <guoren@linux.alibaba.com>
Subject: [PATCH 5.10 248/462] usb: gadget: udc: renesas_usb3: Fix compiler warning
Date: Tue, 11 Mar 2025 15:58:34 +0100
Message-ID: <20250311145808.161942774@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145758.343076290@linuxfoundation.org>
References: <20250311145758.343076290@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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


