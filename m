Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9498646AA6B;
	Tue, 21 Jul 2026 15:36:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784648220; cv=none; b=OWD939HwASMt0BMZHAixj4/8bGjSPTiDG37ZYhdgqLVzuVnEgDTHfYnZR8loC7jK5GrQXrlUGfOiIyF++vI8U8mKd6w2MRiQ81FfHQtladegE2UFSg/UtLXT3G7Bg3II/xP4L4EZ7Jm7rNV2WgNo8lD9mH4uCqWFTFGJAZmQsOk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784648220; c=relaxed/simple;
	bh=8LIvONYQ+FNMMhcVaNnQe8rfgOBTlKg/r5BBm5ca7Kw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=stiaOx5n8/4lFlv4JvVvFdS3htyGZfkCJOUAWbS3ZjyX92REqtRnOtOtg6gqLlDSmpAoaeRGRbb/0LnqzgJI/qUQ+01AKzKaJMEq1WkRVQzXiRZB2YbSAxrUXqDikxKrK3IF5eRkORc5iQf0T/auGqCewgVe8nnUSuH4YSNsPZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a9lsJWgH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a9lsJWgH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06E771F000E9;
	Tue, 21 Jul 2026 15:36:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784648219;
	bh=E5coqulnkJkRxbAMKk0OSZ1bFrYOw5b8TIAfI8i8FNo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=a9lsJWgH9BMkHlvcy/m7y3BV0qjrkCdiAl51MdeBz1/u74YFCL7Mt0BZCXTvTUXrB
	 Z1/A/pB6+PQPi7Gu80vQwvp+XcetdbXuuQv1BpGBK2vx+HHXXZzRtgtVyLF+dfhPPl
	 uL7I7Z3z1swOaThFi3whPS5P01QWrjhNGw5+4jAg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Gu <ustc.gu@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0116/2077] watchdog: sprd_wdt: Remove redundant sprd_wdt_disable() on register failure
Date: Tue, 21 Jul 2026 16:56:29 +0200
Message-ID: <20260721152555.431543039@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Gu <ustc.gu@gmail.com>

[ Upstream commit 96b3cfc3b8ad0524d12fed1e08bc5df3ff345f64 ]

The driver uses devm_add_action_or_reset() to register sprd_wdt_disable()
as a managed cleanup action.

When devm_watchdog_register_device() fails, the devm core will invoke
the cleanup action automatically.

The explicit sprd_wdt_disable() call in the error path is therefore
redundant and results in adouble cleanup.

Fixes: 78d9bfad2e89 ("watchdog: sprd_wdt: Convert to use device managed functions and other improvements")
Signed-off-by: Felix Gu <ustc.gu@gmail.com>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Link: https://lore.kernel.org/r/20260223-sprd_wdt-v1-1-2e71f9a76ecb@gmail.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/watchdog/sprd_wdt.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/watchdog/sprd_wdt.c b/drivers/watchdog/sprd_wdt.c
index 4e689b6ff1418c..aacf04616fefe2 100644
--- a/drivers/watchdog/sprd_wdt.c
+++ b/drivers/watchdog/sprd_wdt.c
@@ -320,10 +320,9 @@ static int sprd_wdt_probe(struct platform_device *pdev)
 	watchdog_init_timeout(&wdt->wdd, 0, dev);
 
 	ret = devm_watchdog_register_device(dev, &wdt->wdd);
-	if (ret) {
-		sprd_wdt_disable(wdt);
+	if (ret)
 		return ret;
-	}
+
 	platform_set_drvdata(pdev, wdt);
 
 	return 0;
-- 
2.53.0



