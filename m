Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E66C403EA1;
	Tue, 21 Jul 2026 22:59:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784674746; cv=none; b=tcEQQKVeM41y06wj87jrvwoeC+4qW1BurycQXnQ/027WXxlwwH2+9znPlAeVQORg3qs/P65uiRmQGkJFw+j2Ij9a81XMfVfWJquoFs46na1E8xVGP8S9H6MJOgtVNH9RPjKQVCOPO3v/tPJp1J15zUwqa+gVf1D6Z3Q1IY5Y/1s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784674746; c=relaxed/simple;
	bh=z/oQ4IuyHlwjTMU959xvE0ynztrLa5T0AEQ2/DCLhcc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I6XUcCFGtJanRlA723E4+MB+n0J4uCXqxYP7DHhLGVolOPuLHtsdgOH7cXsjI4zweF9spcfWXoBTSBZK0if/1cXvZyHoAeqAIW8jfjaeWOWOSzt0zcan27pnpZXF5rJeJdynHZwxhfhxjQHHGU/GRIJFcs1wsAKuwyEDw2flUQM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FsLw2RAq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FsLw2RAq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE6531F000E9;
	Tue, 21 Jul 2026 22:59:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784674745;
	bh=iWckzcw2Fynn3IxgpnllM5w+Rt/XCVNiTGU9/0mLEKs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FsLw2RAqBGDlJp/2FkMknSVt2jTF37MeSMgJNeUoljN2hKPZTma8Non/ER1fiuYg7
	 y9YO+zUDla7lIKUSCYQh/goiw+VPojiMA45nsHV33lL+6ay1Q7te/guY3U44x4yVKQ
	 ZzNHmTTJh2J1hGeUOFwC39XuLazILqd9rR3/496g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	micas-opensource <zjianan156@gmail.com>,
	stable <stable@kernel.org>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 657/699] serial: 8250_mid: Disable DMA for selected platforms
Date: Tue, 21 Jul 2026 17:26:56 +0200
Message-ID: <20260721152410.583601032@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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


