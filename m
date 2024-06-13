Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD7ED143C59;
	Thu, 13 Jun 2024 11:41:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718278861; cv=none; b=Iw8qlUvBGtV+16W2u5kwPgVhrabMy8NU7aBSj9BfgPra7Z4bveMk8hzr+mK/PVGyvK8gUo6CETvMyGGfj+9w2dVKw9mXpXteq8Yqlq0HVsW+ypo4I6GCELKPmDaI8KkTfAs44jBg+eDGVJGgl139naZ5QTRuh8YxGsF0DgR1FSU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718278861; c=relaxed/simple;
	bh=DLwW2lpaNBiQrGGNC2cj2STjmF9MCWM0Ug5jQxKJghY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=afMvpTUZ8drWyxICryqDcT77f9b3iUBZrqnha6MWbpEC7daFU+CVEzuWFwStKtQAMgw3l1VE2oBY7L6GZ2TrWTSRwwtYgUeObJ0VBxiKNsdXNnWS/Jca9Xz2RJwLFMdYYiZ8sFQZkjzOBHyG69twCa7ZkHboRthDosKdQ1nKmmQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i0/XPHNo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i0/XPHNo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42EEBC2BBFC;
	Thu, 13 Jun 2024 11:41:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718278861;
	bh=DLwW2lpaNBiQrGGNC2cj2STjmF9MCWM0Ug5jQxKJghY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i0/XPHNoSltfRgsY9zfmvI+qfQMoFR3PrPwT5FHg065tpesWG+kdDaLXIRgE1bLOh
	 y/gqvC2FATL/BKElfMX5EQqoue1VHrRDR8nk9UADxck5teooNhyDQ7nztqWuyur0S6
	 FnETt0klnJpGMRJgM73yDG5+SpFkku7+X6GW+q2s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 095/213] serial: max3100: Fix bitwise types
Date: Thu, 13 Jun 2024 13:32:23 +0200
Message-ID: <20240613113231.674180391@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113227.969123070@linuxfoundation.org>
References: <20240613113227.969123070@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit e60955dbecb97f080848a57524827e2db29c70fd ]

Sparse is not happy about misuse of bitwise types:

  .../max3100.c:194:13: warning: incorrect type in assignment (different base types)
  .../max3100.c:194:13:    expected unsigned short [addressable] [usertype] etx
  .../max3100.c:194:13:    got restricted __be16 [usertype]
  .../max3100.c:202:15: warning: cast to restricted __be16

Fix this by choosing proper types for the respective variables.

Fixes: 7831d56b0a35 ("tty: MAX3100")
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://lore.kernel.org/r/20240402195306.269276-4-andriy.shevchenko@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/max3100.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/tty/serial/max3100.c b/drivers/tty/serial/max3100.c
index c1ee88f530334..17b6f4a872d6a 100644
--- a/drivers/tty/serial/max3100.c
+++ b/drivers/tty/serial/max3100.c
@@ -45,6 +45,9 @@
 #include <linux/freezer.h>
 #include <linux/tty.h>
 #include <linux/tty_flip.h>
+#include <linux/types.h>
+
+#include <asm/unaligned.h>
 
 #include <linux/serial_max3100.h>
 
@@ -191,7 +194,7 @@ static void max3100_timeout(struct timer_list *t)
 static int max3100_sr(struct max3100_port *s, u16 tx, u16 *rx)
 {
 	struct spi_message message;
-	u16 etx, erx;
+	__be16 etx, erx;
 	int status;
 	struct spi_transfer tran = {
 		.tx_buf = &etx,
-- 
2.43.0



