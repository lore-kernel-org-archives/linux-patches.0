Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B8F144C6F;
	Thu, 13 Jun 2024 12:18:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718281119; cv=none; b=UQzqMEqAx7q11iTWOTyI1mWU85G03xG9XEF6DjoezgMH4i/Jdhk0JmZ9uAUPXTNSXjH8po4OMSHi67EcwQacFiQyu9z5lPcY4hEVpkd4AwmhrCU3ucdq+xDVSExrQKmz4H0zC76CmEYlMOb/zHmKrxcuz2kjeMLaKgPUpTuIgg8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718281119; c=relaxed/simple;
	bh=DpZVirLmrqlSh/4qw5hrl5h4qgY/dNdfl9k2StmuEt8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U2YFa4cbOslXLEFb8XvR6/8ktRKWbYmdS4l9dpuxBd6BDZTq//b3LZRD7rI0CnVFUWkWDWyBwcCndc2JArOswDtNbhBqjQnQIRo21WI4QouTQJHQq7ZZXaOxzz42zlTrsx/ksK1nmgnbUhL8bpC1d4CnJFgEY6IK17bpntT4ovc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c+bi+GEL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c+bi+GEL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1EB6C2BBFC;
	Thu, 13 Jun 2024 12:18:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718281119;
	bh=DpZVirLmrqlSh/4qw5hrl5h4qgY/dNdfl9k2StmuEt8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c+bi+GELraaHPTiGWLHdbIwCCQSdbWO2xJWR51MBi8xFan+Mwod7whfIKAd0Q8hM5
	 TCPbtJ8ZnacTAUyoET+VkFDegM+r51YKCX6VptLgoIP3wwMdTII6djWiFtJthdbNdE
	 wgVGPuPRbmksgfdzAzxXANgZFoKf1vTOhX4R8ivo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 147/317] serial: max3100: Fix bitwise types
Date: Thu, 13 Jun 2024 13:32:45 +0200
Message-ID: <20240613113253.254631125@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113247.525431100@linuxfoundation.org>
References: <20240613113247.525431100@linuxfoundation.org>
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



