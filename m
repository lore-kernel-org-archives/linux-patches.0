Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 901002590
	for <patches@lists.linux.dev>; Sun, 22 Jan 2023 15:18:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17687C433D2;
	Sun, 22 Jan 2023 15:18:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1674400702;
	bh=RB5461b5Ysqa7Gf70x+9pUy40oBsumD3xjaFjQaQyZ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Mk8enNlqbO+QbWZtTU8PAcRDXrzGnzXcfUAJizFSLafwQ5AXAjZBsATiEeNtBnQCa
	 BJHrFyjJ254B+zcq2mtlkkGGSS4b2aiALFRnX4Tlsmerl5VpqHDQlRCgf/h50E94KI
	 YwX7h0ZmbsTLsYkCY0zvuaii2Vb8s4+h9nUCxiJw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Alexander Stein <alexander.stein@ew.tq-group.com>
Subject: [PATCH 5.15 077/117] usb: host: ehci-fsl: Fix module alias
Date: Sun, 22 Jan 2023 16:04:27 +0100
Message-Id: <20230122150235.989741727@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230122150232.736358800@linuxfoundation.org>
References: <20230122150232.736358800@linuxfoundation.org>
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
@@ -29,7 +29,7 @@
 #include "ehci-fsl.h"
 
 #define DRIVER_DESC "Freescale EHCI Host controller driver"
-#define DRV_NAME "ehci-fsl"
+#define DRV_NAME "fsl-ehci"
 
 static struct hc_driver __read_mostly fsl_ehci_hc_driver;
 


