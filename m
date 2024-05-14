Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D5AC2B9AD;
	Tue, 14 May 2024 11:50:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715687442; cv=none; b=ng4x6XsL6WuBnmkknwN7VXCdOlE6MObA4Y+xukY0+6IDTGroXvGf59RJ3duMQPHMhTPCRspJ9ia0s2SV7Lay3Ocfv8ukwWywFOI4Mr3ktOQSeVY5EjJ7CJAP0zI7WpI6Z/L+udl8nyhDhi8UAPxyHVbAeIvpde5npU9Eus9N+PE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715687442; c=relaxed/simple;
	bh=PPmGujG/noyFZq/Vs1zCFXgOyYpMBC7343JJEM/QqYs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hvykV0naZj18VFhsktXi5iaU+Vee+zH9Z5UPHjBsl8EIk5e9spo0cJSmuzWmwUdZ0rArP4Fl5FUL9A6zaodm2+2lkkHfK3napo1f7ATtwwYHwJov0ymrJK1U+dGZBywREW8sOX0PCtWJHZ5yprliMaOzkcvAo5UlmsmpjBHZctc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pnTRRkAy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pnTRRkAy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 119D8C2BD10;
	Tue, 14 May 2024 11:50:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715687442;
	bh=PPmGujG/noyFZq/Vs1zCFXgOyYpMBC7343JJEM/QqYs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pnTRRkAyo9Zl1eM9RENuK4DoKLtd2KR2BDF38veAM9Hj0IRRdwKEY5iSPtzZU098/
	 xpRlfigCLhtw5kSOXoSvKrfhmjYemSymd02JxpfMyT5lCxpwqUqE9q/Yh4dKWnwguT
	 n3sAm2WeCIoh5FK0sHd78CHeYGb30y6WLAoWPd1A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Subject: [PATCH 5.10 098/111] usb: xhci-plat: Dont include xhci.h
Date: Tue, 14 May 2024 12:20:36 +0200
Message-ID: <20240514101000.854746514@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514100957.114746054@linuxfoundation.org>
References: <20240514100957.114746054@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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


