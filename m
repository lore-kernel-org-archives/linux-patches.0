Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B5477E
	for <patches@lists.linux.dev>; Sun, 22 Jan 2023 15:06:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98880C433D2;
	Sun, 22 Jan 2023 15:06:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1674399974;
	bh=sraj/R9T0L5lkBn4o8YI8QB2nJIGZa0svr/c/RCOddc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h+07fUI5m4zxW2rZGaeQpDbEV+QVJALaPB1aVhLiYPn40tzqgqL8cO67ff8TFuWVV
	 abezgnWRijJRG9SP/po00JuR70XZns7BSHwZ0eEiUNODUMIjbxiS667dImg7d+OYbk
	 Td1OovdS0/vgnbbnyffJluZABQiUFgtFTHdLQ8Qw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Alexander Stein <alexander.stein@ew.tq-group.com>
Subject: [PATCH 4.14 18/25] usb: host: ehci-fsl: Fix module alias
Date: Sun, 22 Jan 2023 16:04:18 +0100
Message-Id: <20230122150218.584203112@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230122150217.788215473@linuxfoundation.org>
References: <20230122150217.788215473@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Alexander Stein <alexander.stein@ew.tq-group.com>

commit 5d3d01ae15d2f37ed0325c99ab47ef0ae5d05f3c upstream.

Commit ca07e1c1e4a6 ("drivers:usb:fsl:Make fsl ehci drv an independent
driver module") changed DRV_NAME which was used for MODULE_ALIAS as well.
Starting from this the module alias didn't match the platform device
name created in fsl-mph-dr-of.c
Change DRV_NAME to match the driver name for host mode in fsl-mph-dr-of.
This is needed for module autoloading on ls1021a.

Fixes: ca07e1c1e4a6 ("drivers:usb:fsl:Make fsl ehci drv an independent driver module")
Cc: stable <stable@kernel.org>
Signed-off-by: Alexander Stein <alexander.stein@ew.tq-group.com>
Link: https://lore.kernel.org/r/20230120122714.3848784-1-alexander.stein@ew.tq-group.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/ehci-fsl.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/host/ehci-fsl.c
+++ b/drivers/usb/host/ehci-fsl.c
@@ -41,7 +41,7 @@
 #include "ehci-fsl.h"
 
 #define DRIVER_DESC "Freescale EHCI Host controller driver"
-#define DRV_NAME "ehci-fsl"
+#define DRV_NAME "fsl-ehci"
 
 static struct hc_driver __read_mostly fsl_ehci_hc_driver;
 


