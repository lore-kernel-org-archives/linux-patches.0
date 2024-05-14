Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72A4612A173;
	Tue, 14 May 2024 11:36:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715686613; cv=none; b=MjZva/fXtNX90rSwMbmQ9e8yIoya8jqNxJHKA/PgicidKe/MzApWhkcg47s8rMjNu+jKu9unRCvin9DWWPxmYtvaUp6mQVL+PFN4wySIlPECBJRBDUwTOFDv1Un04rq+y/Uut4M5rCbJwzbklAJOudhlD12OEUxxHGjpv5V7cdw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715686613; c=relaxed/simple;
	bh=CHU/GJ3rFruYzrsqrSAWLH9xOGzILu+iJoEOvdtr0Eo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bFBODdUf8d2Aop573+bekJPqauRdgJZILVVybG9LyngdeGbipVVPZaoMuAi/drIds8RMNeGiOJ2g/MT75P5kT8N2BU2aEz0x6ib3syXmHTm2xIdmkneJHn6FZARxujzbN4kFvbgPd0y34KP7p2DzDKFBr3+avbK/ba43O2pSzYI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XaHSZGTR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XaHSZGTR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2775C32781;
	Tue, 14 May 2024 11:36:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715686613;
	bh=CHU/GJ3rFruYzrsqrSAWLH9xOGzILu+iJoEOvdtr0Eo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XaHSZGTRq6jS5oRQdajAUbChqv/bfGcaizFH3Lo3jdOYydBUG2MV7ec2yR4OIcACm
	 AGLD3Xob928hrFBjwrOHDAOZFe5BTkSQORZ4H8DvlXSeSG2koNw0vFK8j5V4vlhFzx
	 g5NEdUNWwxrTD+oaQ4Gaq58Bj8YBD2GVgJs82uQw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Subject: [PATCH 6.1 199/236] usb: xhci-plat: Dont include xhci.h
Date: Tue, 14 May 2024 12:19:21 +0200
Message-ID: <20240514101027.920635094@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101020.320785513@linuxfoundation.org>
References: <20240514101020.320785513@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/usb/host/xhci-plat.h |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

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


