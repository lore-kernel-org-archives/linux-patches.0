Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE4DA6311D;
	Tue, 14 May 2024 11:24:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715685875; cv=none; b=Po64o8nIVy5gEUufV09S8QF3nxV7d/s5veBpmDm6p8OBMDzydqr0q0turqEMR9I0vftA7XkOCOWcV89sP66arUPUWm6emOcbinu1IufZoChxyytBqnsDlapl77LWCaBtTrm3utQoCkXhwvguAmsp3G9G6dQ+j4mjSej1VAgaPpM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715685875; c=relaxed/simple;
	bh=WIsf0VGw2jsEzRxyxQNHSg7TgR3Y/ORL9nWu16taMo8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CwJikt5FbngN0j5CxYHBbJTzHWmQimUBGFHEE5DtJfGY5tXarYHcByoMUyX++vQyETBTf/dpZJBZr9ShKhAV1eIBkeCjOmlNjF8j1CdYqArysi5WeuVIsYv/K6vXnRB9O+vPFP3UbLfZ7SF9q/DYbHJlFWZgxdq7VWYgDlcY1rs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Bb554lTu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Bb554lTu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24D70C2BD10;
	Tue, 14 May 2024 11:24:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715685875;
	bh=WIsf0VGw2jsEzRxyxQNHSg7TgR3Y/ORL9nWu16taMo8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Bb554lTuY4umOcLO+yhdGrWDleL7gc6y/y8+GIhgVzw2y1cX06H625sr/sZDtssae
	 F2hBhredH68WofWrm8aPHlH1lVAU/nUaJKzwrTdGD7kJzRmoBm9mJenrT4Udkcvs69
	 dDTY9oRPo/QO9DiWkSg7iKzDEhieAtwt5hN+wMhw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Subject: [PATCH 6.6 234/301] usb: xhci-plat: Dont include xhci.h
Date: Tue, 14 May 2024 12:18:25 +0200
Message-ID: <20240514101041.089820114@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101032.219857983@linuxfoundation.org>
References: <20240514101032.219857983@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Thinh Nguyen <Thinh.Nguyen@synopsys.com>

commit 4a237d55446ff67655dc3eed2d4a41997536fc4c upstream.

The xhci_plat.h should not need to include the entire xhci.h header.
This can cause redefinition in dwc3 if it selectively includes some xHCI
definitions. This is a prerequisite change for a fix to disable suspend
during initialization for dwc3.

Cc: stable@vger.kernel.org
Signed-off-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Link: https://lore.kernel.org/r/310acfa01c957a10d9feaca3f7206269866ba2eb.1713394973.git.Thinh.Nguyen@synopsys.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/xhci-plat.h  |    4 +++-
 drivers/usb/host/xhci-rzv2m.c |    1 +
 2 files changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/usb/host/xhci-plat.h
+++ b/drivers/usb/host/xhci-plat.h
@@ -8,7 +8,9 @@
 #ifndef _XHCI_PLAT_H
 #define _XHCI_PLAT_H
 
-#include "xhci.h"	/* for hcd_to_xhci() */
+struct device;
+struct platform_device;
+struct usb_hcd;
 
 struct xhci_plat_priv {
 	const char *firmware_name;
--- a/drivers/usb/host/xhci-rzv2m.c
+++ b/drivers/usb/host/xhci-rzv2m.c
@@ -6,6 +6,7 @@
  */
 
 #include <linux/usb/rzv2m_usb3drd.h>
+#include "xhci.h"
 #include "xhci-plat.h"
 #include "xhci-rzv2m.h"
 


