Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B9FF19D078;
	Thu,  6 Jun 2024 14:17:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683474; cv=none; b=SSjKTa47XctEmbdaO5QBV4+EWdreNEaMHM2SMJBGv3tqHftvuSOzyb4/KYKmAFvvFvcyUV8i12XQBkrjCD7evW04jxjv7vF6eAWFKts9vPCkALmC4nd2bG0UaDIrg2GinP7a9mHVEoHUlk38XP92rpyQKc5GVUhjrgG/BYIq7ko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683474; c=relaxed/simple;
	bh=aVT+wJ2MiQyrDA4EcF3vUCStkfKoFBbPhVeA33TO6BQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q6PKGL48mgyxVlhMqfUolMBNyQ4W8lbVbYwkFI05lSFR6xA6nmXdIKkna5BShnZK6UQGJNSYxJYxdKoJCWDjG1Ox9n7LaQdvhgjiCUU9jz/hnWg41GHCFCtzvwzBkT0w9PSZ3LIjapJUWjfACXFooTpz1IrIQmzzN6KNnY3UZdI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GHKL3xjk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GHKL3xjk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C78CC32781;
	Thu,  6 Jun 2024 14:17:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683474;
	bh=aVT+wJ2MiQyrDA4EcF3vUCStkfKoFBbPhVeA33TO6BQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GHKL3xjkh1JPBQ2BuYmkmEFhRdi2vSoWW2Fxg83cH5PBZBXQgXsf7h5esnJIfB2Uf
	 AsUaFzI5NckoCN1HWjIfxiZK6x3HO2MkiOq9bPeEx0xxtxxEPrYKDC3T0LgTgKOjyH
	 fQsrHUW7rc9BINMah6pKrxxTB14U5lG9Am6psVtY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 417/744] serial: max3100: Fix bitwise types
Date: Thu,  6 Jun 2024 16:01:29 +0200
Message-ID: <20240606131745.848621524@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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
index b3e63b6a402e1..3d2b83d6ab51a 100644
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



