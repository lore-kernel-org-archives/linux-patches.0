Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10740322DA4;
	Mon, 18 Aug 2025 13:36:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755524185; cv=none; b=pOIRtjS/zWQ+vH7tU8n7t9BdwDyJPI4KutqM4nnjkDqZ5Dq6pbGeqhCgQIuD5qKi2CC9o2Bd5HUwFuqjMkzqUNL7oiELfwYD8a0SolPV8OP2lDi1EW6lqmeXsmLTEqt19+cYKGuzmORjIxu3z33jvLuE1hM3EEASbIcCkwzs8CQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755524185; c=relaxed/simple;
	bh=AXnLjS94QTQGu5XKx82Eb9+0xDG6z2cjpFquNDkNdgY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YQoOSZJR4S69Kb6FOJRuWd1eOVIzliCkCx54M3T9ZAYX4YLvnLbazPG1yApA3wBOU+wqCf6+s0LmrIbJzw1sYqwu3gzUdJykFnDw8b2SlJ9uuZlB/Qwx9QS1qiu7yPZVhdhc4n/7rMLSCsr2cRNnGcFt3CpeFa/5fWDcXBpWWTA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FUBPPW9q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FUBPPW9q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C029C4CEEB;
	Mon, 18 Aug 2025 13:36:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755524184;
	bh=AXnLjS94QTQGu5XKx82Eb9+0xDG6z2cjpFquNDkNdgY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FUBPPW9qKoPXfQULJyo4BNR2yxoAPlgmpc5O4+j6BIeSmEnJlEQ/R51niwdZyZ1E0
	 aJspJPe8til04baAUkjJbR4Ezz2d8eqzo8Gw50rc8cRj85QXgKKozbnQEQLomMsWtG
	 85s3+q1U4u0aDBKLZ82DinYAYlhyfdk0cri8Z5ZE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Wolfram Sang <wsa+renesas@sang-engineering.com>,
	Frank Li <Frank.Li@nxp.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 392/515] i3c: add missing include to internal header
Date: Mon, 18 Aug 2025 14:46:18 +0200
Message-ID: <20250818124513.507128397@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124458.334548733@linuxfoundation.org>
References: <20250818124458.334548733@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wolfram Sang <wsa+renesas@sang-engineering.com>

[ Upstream commit 3b661ca549b9e5bb11d0bc97ada6110aac3282d2 ]

LKP found a random config which failed to build because IO accessors
were not defined:

   In file included from drivers/i3c/master.c:21:
   drivers/i3c/internals.h: In function 'i3c_writel_fifo':
>> drivers/i3c/internals.h:35:9: error: implicit declaration of function 'writesl' [-Werror=implicit-function-declaration]

Add the proper header to where the IO accessors are used.

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202507150208.BZDzzJ5E-lkp@intel.com/
Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://lore.kernel.org/r/20250717120046.9022-2-wsa+renesas@sang-engineering.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i3c/internals.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/i3c/internals.h b/drivers/i3c/internals.h
index 433f6088b7ce..ce04aa4f269e 100644
--- a/drivers/i3c/internals.h
+++ b/drivers/i3c/internals.h
@@ -9,6 +9,7 @@
 #define I3C_INTERNALS_H
 
 #include <linux/i3c/master.h>
+#include <linux/io.h>
 
 void i3c_bus_normaluse_lock(struct i3c_bus *bus);
 void i3c_bus_normaluse_unlock(struct i3c_bus *bus);
-- 
2.39.5



