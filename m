Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA92E188CCA;
	Wed, 19 Feb 2025 09:29:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739957379; cv=none; b=Z8Z+400tNtiDICeHFlo6VVOUw1YnE9uyUt59DCB/STiO8Ulq2pwcR8U4sL5Qv8d97tB/lFM67/HOg5VTQPnaaEhB6iMgoL/SiFUpvixLe7KvDRLjpNy5iMpwxYJBs/6YyCMEo8A2XHNc4rYA0wQSk9nmkD6LOj70zV3C40oVgXE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739957379; c=relaxed/simple;
	bh=gx5sg+jWN1pcXsqrJftznF+hm0RFKe/AMy4b3uEJJMs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eOnzDK0tXBkyigyXAIgREUthf5SA8VQS8h8ursDGdwLP4vB/zGlB2vuBXuhxezxH65ya1Z3XgpUxNMRVtBhNa79GLbd4RqgAaTqWcqkQuz6SIRvgojQRmwWH2KOd4yVirfmRdQeLFrutkbNe0oI8p7l0H1YHStP+Ho/VCmv0AAw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eVDJqJYd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eVDJqJYd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEF68C4CED1;
	Wed, 19 Feb 2025 09:29:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739957379;
	bh=gx5sg+jWN1pcXsqrJftznF+hm0RFKe/AMy4b3uEJJMs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eVDJqJYd4MMqbOy9Y/LK8tzGI6GAQfp/utzZlF9zaaSalkkXSFwTQyARjgzqtkXBx
	 lPIwmSRXp/8YOZAENxvpgtKa1+IMoEmvUPlIoA8xv9p88cjWsnGL0nwlcmU0k2Opg4
	 SOT52B7eYO9LCvk1IW/lnlaqUpgiIvr+RwtJeolg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Guo Ren <guoren@linux.alibaba.com>
Subject: [PATCH 6.1 505/578] usb: gadget: udc: renesas_usb3: Fix compiler warning
Date: Wed, 19 Feb 2025 09:28:29 +0100
Message-ID: <20250219082712.850266322@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -309,7 +309,7 @@ struct renesas_usb3_request {
 	struct list_head	queue;
 };
 
-#define USB3_EP_NAME_SIZE	8
+#define USB3_EP_NAME_SIZE	16
 struct renesas_usb3_ep {
 	struct usb_ep ep;
 	struct renesas_usb3 *usb3;


