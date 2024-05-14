Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 940801CFB2;
	Tue, 14 May 2024 11:59:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715687979; cv=none; b=dco2ti4KpFHNA89osWgM1pnqYw7j50Ln1lO9FkXQls29sl6WEcVQbN25eQhQaLgLf4O1UX40Vwj+S34ktz4/M2n7rMtqa1EH8wjmwaGAnpGeUscxo73qYqlOZvpc75TAiXb3uRKHTYTxRF4xScfl7jx7vc959Zt7GxBiYhBbIGM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715687979; c=relaxed/simple;
	bh=0Ylsqt4JjEkHKgnjzH8x8rWZS5s3O2fxhtPJ4Xa7AcM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nSkPpj8MStqQaPUlRTqj4VX7VT2kWLbTYjFZSYU0czOHBm0NENG4Qy2Z4AnAKi3KkHXdiVgFPgz4srY7L+CdkO1Qzf1nNR+xQnDIQ4FBHvE4SOnWJhJLuzLVZxpxtqewUzJTOeEuMyfRceVrDmxSReh8etyMdD3hPpBgd59yTgg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a5GhvaLU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a5GhvaLU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A21FC2BD10;
	Tue, 14 May 2024 11:59:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715687979;
	bh=0Ylsqt4JjEkHKgnjzH8x8rWZS5s3O2fxhtPJ4Xa7AcM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a5GhvaLU5tEQx83B3pcPe5oo1ld/61qQHVQvgXno5bW7QWkcP2+5wOFUWXDteCxjk
	 OJLW/OWiknNq/p0K4sHk1eWdiObuH9TOdnUO2vB1BBIh9gdYX3ds/UAfSMBRiTm/rz
	 yZ9Wws4bD6UmanCmyVVDrsiyM0FEgZn8LoeXNi9w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Subject: [PATCH 5.15 147/168] usb: xhci-plat: Dont include xhci.h
Date: Tue, 14 May 2024 12:20:45 +0200
Message-ID: <20240514101012.313045685@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101006.678521560@linuxfoundation.org>
References: <20240514101006.678521560@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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


