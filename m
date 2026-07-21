Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5905B3B52FF;
	Tue, 21 Jul 2026 22:28:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784672918; cv=none; b=QhkIr44Mp+2neM839PRAZ6gfrxNpY0lj5X8aYxCGw/HHNrqlT9cW/IQy7pGs8JJd8eC1MZkhSUFlVxkKBAR6SQ8W258vL+i/2QhSPZAtLDgZAdbaHXn8E8eY/XuJ7Kyt31c9N7P9oRX/ERci9+5nvlOleB9AQ2PpXtELciLfZXY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784672918; c=relaxed/simple;
	bh=o0k05xFScDdFKI0JIkrZ+k+FJBrXNQYASB/jYHC1qMc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s7hQSwyp1MyqxR/B4l9o7oB+jae6Qjtd1RbRrDFWEfqsHdSmLBmlTF+FRATFqzxxpXj3vkS5uNjDVRPVOSqPXJWDQhOjO3pv1xSRxnzxiDKmyV/2ro0FFVAAaczU18lNaIl2tu9KmfEEnLTrW7Zwnsr7JlL0AbrX6IGDygpq3G8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yr/3eLzn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yr/3eLzn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 317C81F000E9;
	Tue, 21 Jul 2026 22:28:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784672909;
	bh=i4F+LfBinJ18GaWlMR+7iHc2xJ2yOUk5ira43YeY5kw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yr/3eLznusgF0ugROCGjwtee2zfPtwo0WVybMdjDHyWbR+lxfdbRmaLH/AT37wDHv
	 i23P2Yewif9tq6cltO6hh+FdsXq8ypvX9zE7uxOTosQxmXLeSqQSocvgm4iwp5l4pL
	 1oIPDOU7o1j6nY9Y286ScrExW6cbH8OQMgRYox0A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	micas-opensource <zjianan156@gmail.com>,
	stable <stable@kernel.org>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 802/843] serial: 8250_mid: Disable DMA for selected platforms
Date: Tue, 21 Jul 2026 17:27:17 +0200
Message-ID: <20260721152424.107089189@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit b1b4efea05a56c0995e4702a86d6624b4fdff32f ]

In accordance with Errata (specification updates)
HSUART May Stop Functioning when DMA is Active.

- Denverton document #572409, rev 3.4, DNV60
- Ice Lake Xeon D document #714070, ICXD65
- Snowridge document #731931, SNR44

For a quick fix just disable the respective callbacks during the device probe.
Depending on the future development we might remove them completely.

Reported-by: micas-opensource <zjianan156@gmail.com>
Closes: https://lore.kernel.org/linux-serial/20250625031409.2404219-1-opensource@ruijie.com.cn/
Fixes: 6ede6dcd87aa ("serial: 8250_mid: add support for DMA engine handling from UART MMIO")
Cc: stable <stable@kernel.org>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://patch.msgid.link/20260626094937.561776-1-andriy.shevchenko@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/8250/8250_mid.c |   13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

--- a/drivers/tty/serial/8250/8250_mid.c
+++ b/drivers/tty/serial/8250/8250_mid.c
@@ -10,6 +10,7 @@
 #include <linux/module.h>
 #include <linux/pci.h>
 #include <linux/rational.h>
+#include <linux/util_macros.h>
 
 #include <linux/dma/hsu.h>
 
@@ -371,8 +372,16 @@ static const struct mid8250_board dnv_bo
 	.freq = 133333333,
 	.base_baud = 115200,
 	.bar = 1,
-	.setup = dnv_setup,
-	.exit = dnv_exit,
+	/*
+	 * Errata:
+	 * HSUART May Stop Functioning when DMA is Active.
+	 *
+	 * - Denverton document #572409, rev 3.4, DNV60
+	 * - Ice Lake Xeon D document #714070, ICXD65
+	 * - Snowridge document #731931, SNR44
+	 */
+	.setup = PTR_IF(false, dnv_setup),
+	.exit = PTR_IF(false, dnv_exit),
 };
 
 #define MID_DEVICE(id, board) { PCI_VDEVICE(INTEL, id), (kernel_ulong_t)&board }


