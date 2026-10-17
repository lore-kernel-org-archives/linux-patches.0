Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91C023A7D63;
	Sat, 17 Oct 2026 17:31:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792258263; cv=none; b=I34fuMJ4Cu2wFFXJFDMK197zjQqs1SWCt0vYNR7i3uDB6MXo6i2hXeBUw75c+G6Y1TppGZXZZZR/NTZV2KlDrU8i1Xy/1WZMmJ8pMVsvq8WCoEcFU5Q3gI9zQDTShm4+eSZ8ZOwk/i4W8UvQox3xZevttCByCwzb81qg9GwcSgc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792258263; c=relaxed/simple;
	bh=D9DcC2AF5kMDOLqEaJr/NZlTE9PPNCmFpSFQ/9UKQmc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LJHNtJuHtJIygQ6P07zpaJj58dfqDB27brSyeIAPAV9BaFvwzTqx2E0rm9072E9XCnt/cd6fu6qZNN1mHlwEiALpzk5FCvyEr8XkhY9k4jmlXr6Z2UuuksMS6fsvV++tGu5KK8X4cbWD+I2gnjdiyjFhc5qfETlVOLl5r9N28ho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kW4iyleN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kW4iyleN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDE631F000C4;
	Sat, 17 Oct 2026 17:31:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792258262;
	bh=cYmHx+YrHkfAvS8Ndvqd6BDhKJ3pUZgE2IBnwD8kSbM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kW4iyleNBD9yctwqEPalZzN0nVLxbzO5CSAttJYCE+1xVH2CndGWxTBeWxKfqffAi
	 OkG67U2iUxRbGZLe0HFuG94tvhzhoUaYoX1Un0LWMfq02uT8OHwqQAdBtGMqO9scMF
	 5GQ/Vg6zjKyi+I0M1URttAADAtVltRZGsmBQqP0o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+94d20db923b9f51be0df@syzkaller.appspotmail.com,
	I Viswanath <viswanathiyyappan@gmail.com>,
	Richard Cochran <richardcochran@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0799/1674] ptp: Add a upper bound on max_vclocks
Date: Sat, 17 Oct 2026 17:51:11 +0200
Message-ID: <20261017160451.620236167@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: I Viswanath <viswanathiyyappan@gmail.com>

[ Upstream commit e9f35294e18da82162004a2f35976e7031aaf7f9 ]

syzbot reported WARNING in max_vclocks_store.

This occurs when the argument max is too large for kcalloc to handle.

Extend the guard to guard against values that are too large for
kcalloc

Reported-by: syzbot+94d20db923b9f51be0df@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=94d20db923b9f51be0df
Tested-by: syzbot+94d20db923b9f51be0df@syzkaller.appspotmail.com
Fixes: 73f37068d540 ("ptp: support ptp physical/virtual clocks conversion")
Signed-off-by: I Viswanath <viswanathiyyappan@gmail.com>
Acked-by: Richard Cochran <richardcochran@gmail.com>
Link: https://patch.msgid.link/20250925155908.5034-1-viswanathiyyappan@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ptp/ptp_private.h | 1 +
 drivers/ptp/ptp_sysfs.c   | 2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/ptp/ptp_private.h b/drivers/ptp/ptp_private.h
index baf05d55376dd..855dddee694f5 100644
--- a/drivers/ptp/ptp_private.h
+++ b/drivers/ptp/ptp_private.h
@@ -20,6 +20,7 @@
 #define PTP_MAX_TIMESTAMPS 128
 #define PTP_BUF_TIMESTAMPS 30
 #define PTP_DEFAULT_MAX_VCLOCKS 20
+#define PTP_MAX_VCLOCKS_LIMIT (KMALLOC_MAX_SIZE/(sizeof(int)))
 
 enum {
 	PTP_LOCK_PHYSICAL = 0,
diff --git a/drivers/ptp/ptp_sysfs.c b/drivers/ptp/ptp_sysfs.c
index 952d3e968bdf9..d975531f290d8 100644
--- a/drivers/ptp/ptp_sysfs.c
+++ b/drivers/ptp/ptp_sysfs.c
@@ -286,7 +286,7 @@ static ssize_t max_vclocks_store(struct device *dev,
 	size_t size;
 	u32 max;
 
-	if (kstrtou32(buf, 0, &max) || max == 0)
+	if (kstrtou32(buf, 0, &max) || max == 0 || max > PTP_MAX_VCLOCKS_LIMIT)
 		return -EINVAL;
 
 	if (max == ptp->max_vclocks)
-- 
2.53.0



