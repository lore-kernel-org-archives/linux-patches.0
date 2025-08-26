Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 210F32D7BF;
	Tue, 26 Aug 2025 13:01:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756213299; cv=none; b=A6nW5nOqbv6imz0xmRsoOYK2n3FSirAY2GXSob94ISGncUsJxLYyYxpj+XgIo3selE750V8AVbZMCz0swhEDqg3boREPReNfU5gHBTaerVsyyNFCN7iofTjrQDtYyXtoyQShmS2ghCznIQzULbltTuRXxyB92bQ5eUu8kz8utQ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756213299; c=relaxed/simple;
	bh=3JzunmjMjNkfFWphWjvP2/xTJfkTf0AjbXSUB1wU0Ks=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JSG7STZoCzUmbEpyDUSymikg+8w6BAhzkzcFDIIOcyXUsJZjCabWqoNcZma1TLpCL5giQuz6E5tsX0VCQlXg5yeJnGJzTE9oQKBa7+yCXrOEPRDJVJ4rVI2lM6fsMMQ+AWt2ND7SU8JAFavW1n7H5wSPLSqH9BSJmmmtL85Tagg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UL0LRaaJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UL0LRaaJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3996C4CEF1;
	Tue, 26 Aug 2025 13:01:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756213299;
	bh=3JzunmjMjNkfFWphWjvP2/xTJfkTf0AjbXSUB1wU0Ks=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UL0LRaaJZ2JhMCsLYwBTmGbZajNrTIhfQsmEO6ZyYyc0sS/gC5fsUNvv8emDmxkz6
	 zrUK8JkksgPxKbsWjdEWHQiTvv4wAL8IzSWbD2O1SzbMWsIGTxRZJZ3EIivMSOLyjF
	 upRYKUn+ZB0TBsm5cqqf/H/Un10H0reD7x9tHbmE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Wolfram Sang <wsa+renesas@sang-engineering.com>,
	Frank Li <Frank.Li@nxp.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 263/587] i3c: add missing include to internal header
Date: Tue, 26 Aug 2025 13:06:52 +0200
Message-ID: <20250826110959.620427044@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110952.942403671@linuxfoundation.org>
References: <20250826110952.942403671@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 908a807badaf..e267ea5ec5b9 100644
--- a/drivers/i3c/internals.h
+++ b/drivers/i3c/internals.h
@@ -9,6 +9,7 @@
 #define I3C_INTERNALS_H
 
 #include <linux/i3c/master.h>
+#include <linux/io.h>
 
 extern struct bus_type i3c_bus_type;
 
-- 
2.39.5



