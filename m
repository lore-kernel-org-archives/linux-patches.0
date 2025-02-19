Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EC701B4F21;
	Wed, 19 Feb 2025 09:00:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739955613; cv=none; b=gmslRHoh4+WqWlhdUi2CCt5cyTBYwphqlLqFjEbpj1a+N92hsfc0REksggfb5eY3VmNIyPKkwTCnPZhDd29yhy/M9fjmdMXgpkzNHO9SXUg27S0EiZYGs5kUF3PIHN/mg0HPPtYCnpQt788JdtHg5bhbJN7D85QsS7DsI2yOVbU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739955613; c=relaxed/simple;
	bh=7vZm+Sox3wGk3saf2NsqJlesMcMSMsgWLmhruT2T4S0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CoQySS/1wSRxLqZPINkUb0wAm3cOc6aFAQr8mb8C2tbrr2dO0+jX0MTijx+UjVFSw/OtALYLT+2rrbO3ZHSSdHcBTwErSuNBeSrOK6HrFJ0vL51DtpryeCJ7toNDDU0G+Ta2T63InHsotEqFFdxM3mV2BEjW0X+m3GW7G9wW5Q4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bDHYCuqR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bDHYCuqR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7012C4CED1;
	Wed, 19 Feb 2025 09:00:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739955613;
	bh=7vZm+Sox3wGk3saf2NsqJlesMcMSMsgWLmhruT2T4S0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bDHYCuqRAmGfSMLNxKo3poYTovrcB3WT2RIiz+7lI5svmA9ImuqqBzhIQY+t0/yf0
	 DjSnHNJxGDIuP6J+0Xd+87WTf4nW5oxfzEN6hW5Kdqkh37jOCtuiJ9hZKGTx2NhZpG
	 98RiE10iAnu3dFPWzRHYIDbJ0t6qZZrKUYCvN/7U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Guo Ren <guoren@linux.alibaba.com>
Subject: [PATCH 6.6 059/152] usb: gadget: udc: renesas_usb3: Fix compiler warning
Date: Wed, 19 Feb 2025 09:27:52 +0100
Message-ID: <20250219082552.380437669@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082550.014812078@linuxfoundation.org>
References: <20250219082550.014812078@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


