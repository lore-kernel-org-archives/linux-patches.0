Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214445;
	b=cxmwhfIxeqtceh5Zx6bIps0FmvtmHJZeVwQxpa+sJpvjTpZy6az8pomt81jah8KdP1f6
	 HAE7NcIp5xTDSSBaxSso3fCSmGzSFgop3B1/i/3CbPM6tOXhnRNc/Nmk5zWM3BSp3mlYC
	 tMR9FRllah54w+0sn2yZz48I3Ju2T8z4e0hr4Y8d7G/k9lWG8hlJVKgWV+co+zzMIA1RM
	 MeFd0oJrr5KQFAUIIx0P1oML7T9gbzPjDWmMrVM5WXSLm9jBUnz4y7JlmFvgYLEisErU0
	 PIe8t2ozTAL4+6F+0RKNkbHylKR0KvBcMTbUOcz4q8kfUm1h+UWHOBfqox7yIBE6tcA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214445;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=wOGzR8mb70aBgnYHTvB17dpiN2DGJMk34aZbGTAH2mo=;
	b=k80I7JGHhlxRcOOr02fK6CsebJssUIDvS3x1nBXxkoWcAWfx4+ZBSK6bV5ti2K7B+C3M
	 W23kuf6FF4ij8/gMpxw3evzTZWKbuIbzmlLdJ7hxGevUPycJH2diA6uoAWcWzxYu43iFy
	 kAtV6MNZZ+h+QCjmRZn8/fuDNJmvOWabTRNWi4w/Si+MWEPP/eEMR6E3Yr2gjYSKq3tEf
	 eZ9T4ZvpLwCZMbGbr3rjyd8J3EzIXfXOTCstd3bSt9AJ0J8Nn5GF9tSOQDbMAsQ00VG1+
	 fkQROBmx2mTUEvSrwx56mn96CtsK7nnRAL4dP6xr0q3vL9JPfp7AOhE5Fm5fe0tbjMQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DdavA9Iw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDA8B606A335;
	Wed, 28 Oct 2026 19:07:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DdavA9Iw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B9611F01825;
	Wed, 28 Oct 2026 19:07:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793214444;
	bh=wOGzR8mb70aBgnYHTvB17dpiN2DGJMk34aZbGTAH2mo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DdavA9Iws5O0l9zZM4+6a+dW7p7e0u975ssdrvZAoNr/ob9HYbDCPibW17KawyYu0
	 ftdWeiewgs5hk9XQqv0zmoBUUnvcjO+DPwwMPSfLIoBMuiIUypwKN4utqSSAIHm1n2
	 Ylfs7r9EOmYUTAu5UHmLarcZ4QlaISaqSrugpBwE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+94d20db923b9f51be0df@syzkaller.appspotmail.com,
	I Viswanath <viswanathiyyappan@gmail.com>,
	Richard Cochran <richardcochran@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0854/1887] ptp: Add a upper bound on max_vclocks
Date: Wed, 28 Oct 2026 17:49:10 +0100
Message-ID: <20261028170518.859409063@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/ptp/ptp_private.h |    1 +
 drivers/ptp/ptp_sysfs.c   |    2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/ptp/ptp_private.h
+++ b/drivers/ptp/ptp_private.h
@@ -19,6 +19,7 @@
 #define PTP_MAX_TIMESTAMPS 128
 #define PTP_BUF_TIMESTAMPS 30
 #define PTP_DEFAULT_MAX_VCLOCKS 20
+#define PTP_MAX_VCLOCKS_LIMIT (KMALLOC_MAX_SIZE/(sizeof(int)))
 
 struct timestamp_event_queue {
 	struct ptp_extts_event buf[PTP_MAX_TIMESTAMPS];
--- a/drivers/ptp/ptp_sysfs.c
+++ b/drivers/ptp/ptp_sysfs.c
@@ -271,7 +271,7 @@ static ssize_t max_vclocks_store(struct
 	size_t size;
 	u32 max;
 
-	if (kstrtou32(buf, 0, &max) || max == 0)
+	if (kstrtou32(buf, 0, &max) || max == 0 || max > PTP_MAX_VCLOCKS_LIMIT)
 		return -EINVAL;
 
 	if (max == ptp->max_vclocks)


