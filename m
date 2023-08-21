Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E73B1171A
	for <patches@lists.linux.dev>; Mon, 21 Aug 2023 20:08:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B0FBC433C9;
	Mon, 21 Aug 2023 20:08:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1692648491;
	bh=QW7zRVwCjzQAVUPL0SSz0nOOhoT0O1hoYQ2wqhlP4Fg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xZCYzA944nj1x0ZBfrASj9UmPAYY/a0gzEhlsW/52ZJDBrChtV3hCshmH3pxLnsAu
	 4yPLrR1Agbav/w8vyHS0AQN+tn0tgm3ZdPh6QZQ/x+MvXszhvcVGfbmWQoNcNVdfRE
	 rSlq0KbmRd9EJaCUHl+J0CWccNV4rTlXcLADgBSg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zev Weiss <zev@bewilderbeest.net>,
	Joel Stanley <joel@jms.id.au>,
	Arnd Bergmann <arnd@arndb.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 195/234] soc: aspeed: uart-routing: Use __sysfs_match_string
Date: Mon, 21 Aug 2023 21:42:38 +0200
Message-ID: <20230821194137.447371978@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230821194128.754601642@linuxfoundation.org>
References: <20230821194128.754601642@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Zev Weiss <zev@bewilderbeest.net>

[ Upstream commit e4ad279ae345413d900d791f2f618d0a1cd0d791 ]

The existing use of match_string() caused it to reject 'echo foo' due
to the implicitly appended newline, which was somewhat ergonomically
awkward and inconsistent with typical sysfs behavior.  Using the
__sysfs_* variant instead provides more convenient and consistent
linefeed-agnostic behavior.

Signed-off-by: Zev Weiss <zev@bewilderbeest.net>
Fixes: c6807970c3bc ("soc: aspeed: Add UART routing support")
Reviewed-by: Joel Stanley <joel@jms.id.au>
Link: https://lore.kernel.org/r/20230628083735.19946-2-zev@bewilderbeest.net
Signed-off-by: Joel Stanley <joel@jms.id.au>
Link: https://lore.kernel.org/r/20230810122941.231085-1-joel@jms.id.au
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/aspeed/aspeed-uart-routing.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/soc/aspeed/aspeed-uart-routing.c b/drivers/soc/aspeed/aspeed-uart-routing.c
index ef8b24fd18518..59123e1f27acb 100644
--- a/drivers/soc/aspeed/aspeed-uart-routing.c
+++ b/drivers/soc/aspeed/aspeed-uart-routing.c
@@ -524,7 +524,7 @@ static ssize_t aspeed_uart_routing_store(struct device *dev,
 	struct aspeed_uart_routing_selector *sel = to_routing_selector(attr);
 	int val;
 
-	val = match_string(sel->options, -1, buf);
+	val = __sysfs_match_string(sel->options, -1, buf);
 	if (val < 0) {
 		dev_err(dev, "invalid value \"%s\"\n", buf);
 		return -EINVAL;
-- 
2.40.1



