Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C29D51F429B;
	Tue,  3 Dec 2024 15:00:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733238011; cv=none; b=NSPdnEHDOp2cnlkw7p/PFWpeBBYEHNd/w3PSVxYVD/ToCcg3+A26wzlNZlAPE65kdE1HBd6nUXx9NtfkQKz7tZ0S1ZRvj8IOiqpYEGdv5sfdHFOzOaIv1cRY3ZxJIpgvyi1eHbY8/0iW3nPCA9oBwkNhxAXv+L4p6QvIcRnrwzc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733238011; c=relaxed/simple;
	bh=9yFLTcLkWByatu727sir8ZY2RrNa6yMVauMx9l+EJro=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bR3pTjtRnBQCkD7+iZc4dg/ltSoct3htCxpzwobinSSi89WwlAePeCkoc/pPRWs92aMbmxC6I0Ps2+qMqqpACLv0I3cFefmt1i495+y69ypCkvye8foJZj63uBq3lQLqNVnA9EI8YH3fFhcuOQjGjzY+TX+47XEN7HsK+QRNXs8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ng9P/oAy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ng9P/oAy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49780C4CED6;
	Tue,  3 Dec 2024 15:00:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733238011;
	bh=9yFLTcLkWByatu727sir8ZY2RrNa6yMVauMx9l+EJro=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ng9P/oAyNSats7Wweb4npYu3n9rzNLVkzIDbiMpr3N0F6Lgfud9yHtEceay2IYI1j
	 R6k2kYXcbQgsg5levKqo7Hvd0QfAqvzp/zMEtiqXCGDqOyhAVRN9ELZDSHkGQQrQVt
	 mcYQECsmE8V207y2WiIB/1l3GesQ9uOZCnrt4mMQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miguel Ojeda <ojeda@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 132/817] time: Partially revert cleanup on msecs_to_jiffies() documentation
Date: Tue,  3 Dec 2024 15:35:04 +0100
Message-ID: <20241203144000.874780436@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miguel Ojeda <ojeda@kernel.org>

[ Upstream commit b05aefc1f5886c8aece650c9c1639c87b976191a ]

The documentation's intention is to compare msecs_to_jiffies() (first
sentence) with __msecs_to_jiffies() (second sentence), which is what the
original documentation did. One of the cleanups in commit f3cb80804b82
("time: Fix various kernel-doc problems") may have thought the paragraph
was talking about the latter since that is what it is being documented.

Thus revert that part of the change.

Fixes: f3cb80804b82 ("time: Fix various kernel-doc problems")
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Link: https://lore.kernel.org/all/20241025110141.157205-1-ojeda@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/time/time.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/time/time.c b/kernel/time/time.c
index 642647f5046be..e1879ca321033 100644
--- a/kernel/time/time.c
+++ b/kernel/time/time.c
@@ -558,7 +558,7 @@ EXPORT_SYMBOL(ns_to_timespec64);
  *   handling any 32-bit overflows.
  *   for the details see __msecs_to_jiffies()
  *
- * __msecs_to_jiffies() checks for the passed in value being a constant
+ * msecs_to_jiffies() checks for the passed in value being a constant
  * via __builtin_constant_p() allowing gcc to eliminate most of the
  * code, __msecs_to_jiffies() is called if the value passed does not
  * allow constant folding and the actual conversion must be done at
-- 
2.43.0



