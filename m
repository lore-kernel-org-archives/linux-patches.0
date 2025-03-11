Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3BDF25D90F;
	Tue, 11 Mar 2025 15:11:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741705860; cv=none; b=F10IBPlih0lbm6RF6mNJS57HnbdpkobOH04fsK9ftpmtnCimFYZUZQsHt/r1ocFOmDMTeWTxWXQxXQ1FPfYK+ok9Ri9PhoqN/TQzxKswKTnmnsxBorXPvgKZjoZ6rcWaQ1ILS9LFie6sCaA4ncfeLiV3juh/4aAv7xIzug2lwro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741705860; c=relaxed/simple;
	bh=MWjgLZPsTx9P/OMK0upGpTsJsJUi+uuzUEWlfQz1uzU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YzTdldR1rkb4IRT/59eiw42tL2EuPc7ARmcwditKF179JtnaayXtR6MLHl97ORF0dvxWJjuVzybdHI40Qumjw5eET/eqhE+TshPSPg/bBsKwrqje2Ty5ipfzphKQJf74qOmEu9wwkgrrEG2AxT8cn4ew8zGiBLrpQ+GB+0OKwp0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H+r1YXzD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H+r1YXzD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A7DEC4CEE9;
	Tue, 11 Mar 2025 15:11:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741705860;
	bh=MWjgLZPsTx9P/OMK0upGpTsJsJUi+uuzUEWlfQz1uzU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H+r1YXzDA2yYCPfekUgcgeGIOeoW3l/CMtXkKWCPB0S2JWaBt5WLheKEP6wusQwo4
	 Ww/p057Ne9Xb05Qnm4NklT9fmPDyNmX+VHCpdEYdHOFVt35X+REO02O2NrSRw5ez4f
	 IV61Lg7TDaSHnFIWcG9bVN43P5yviD7Fv4JWJ9hg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Guo Ren <guoren@linux.alibaba.com>
Subject: [PATCH 5.4 179/328] usb: gadget: udc: renesas_usb3: Fix compiler warning
Date: Tue, 11 Mar 2025 15:59:09 +0100
Message-ID: <20250311145722.018337685@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145714.865727435@linuxfoundation.org>
References: <20250311145714.865727435@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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


