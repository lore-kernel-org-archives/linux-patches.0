Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48FCC1E25E3;
	Wed, 19 Feb 2025 08:36:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739954216; cv=none; b=MrtbSIKUR0q/NvgyWnp8sx9HideoQmEFfj7gLpSrk5F7JcY76b/pCRF7WH+Gjm7/JoHzwtonSLaHhCOyy+5QTrU3dG9g3UMUVOh/5Z014B6J1/FAIx8zqM5kJhoAoK1qxZmvmosHr70nT33E4IV5v19tN69Ic0xuM2DEkxk+fcg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739954216; c=relaxed/simple;
	bh=IMzcdlYoqGxWAddJV7yjZKLEw7JNxQsRMIUyx5ymK1M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=njprH6SR5/f5Sb5v1BlVtcIuN3va/ges/gcMEx8pwiMqgTQC1uqC+iJxngsnwRXp9bbzHvH6N4os+35vxXrRZddrNplXSRuzVk0g+Dxp6CcG1sP77XQJlW+ATek8J0zdfjX4zRmdI5xrN6vBvwL+X9bG+tRz34keV026iDm7H1E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P5ZMSL+5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P5ZMSL+5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA08CC4CEE6;
	Wed, 19 Feb 2025 08:36:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739954216;
	bh=IMzcdlYoqGxWAddJV7yjZKLEw7JNxQsRMIUyx5ymK1M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P5ZMSL+5BMvatrYuC7Rp8y7dJMHiGgxfCBWoDpEwo0WsaWJCLuUW5ffLNuuSvGgPd
	 +y0qexstEJeZ+Zfbyi/ylnuW5K+rltsNf7RpNlXJ0aaATpy6zF9lkNlm29VZI5tQ5Z
	 gF4zEC0DIC+4zeIZ4GELZPgDxZczXEcCCrr/Lo/0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Guo Ren <guoren@linux.alibaba.com>
Subject: [PATCH 6.13 132/274] usb: gadget: udc: renesas_usb3: Fix compiler warning
Date: Wed, 19 Feb 2025 09:26:26 +0100
Message-ID: <20250219082614.774324813@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082609.533585153@linuxfoundation.org>
References: <20250219082609.533585153@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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


