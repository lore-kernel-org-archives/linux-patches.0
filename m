Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D76603019D8;
	Sat, 12 Sep 2026 14:42:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789224125; cv=none; b=iHGDj+tEt/svWFDbZeyVRWK420HaLSwDf6JZ081iPUvoABKowd/95fRhvxEaV4wpOjlO6jPxamGGMorLKH0pYY1mZOA5wJOLBLqfJvjqQQWnKoWUqTAzqRuqjTd4qUrt8n21shR6ejEBnv6WzOSJobXM+vL4bTR97RPzHQ7kX9s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789224125; c=relaxed/simple;
	bh=9NLnFAiBDZotKb7xbgGs9ddVdcFmKh6O/Y+wvD8RdOw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EzbFCX7CJCek3v2N7CeNG2NmXn1pYbXgCXfmiK9GafFuSfYm6IIjSVnG9Y8gHfWWzHkp5mgLHdoqw8llwXwLq1Qlw66SHzTXVASW6uROieyT6t0Fk0f4SSUXLHhq1i4WsrE8iariJiPbdZH6PUWVCiU4qnyoB5ysVG/whAzv4aY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=muaD/aUO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="muaD/aUO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC3A91F00893;
	Sat, 12 Sep 2026 14:42:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789224123;
	bh=jzt4VqN3hg7397v1S4KGo6vToGP1EfCtynKUN38tWLQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=muaD/aUOjMsRbvJyNjazgHMQR49ME3kPgpvdYTJ+2JqymSStmE8lIVkOe+574GJK8
	 WnFUKiRPCqT4e5xSFC9zThhoRw0lMeEnjpGMxRQC0vCSM9oZzMNQtTRy+a0y0CA+Wv
	 qrZkZhHBs8DyfRUkGqBD5xsAlwIMh+GjfBGVHpJk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hongyan Xu <getshell@seu.edu.cn>,
	Tzung-Bi Shih <tzungbi@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0929/1424] platform/chrome: cros_ec_debugfs: Clean up console log on probe failure
Date: Sat, 12 Sep 2026 08:56:01 +0200
Message-ID: <20260912065628.127648459@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

From: Hongyan Xu <getshell@seu.edu.cn>

[ Upstream commit 5d187600c4603b8f7812b12ce359a11ad7a7fd3a ]

Add a dedicated error label for failures after successful console log
setup.

Fixes: d90fa2c64d59 ("platform/chrome: cros_ec: Poll EC log on EC panic")
Signed-off-by: Hongyan Xu <getshell@seu.edu.cn>
Link: https://lore.kernel.org/r/c00974953a1b952f51f0f021d7f9fad134159909.1785320940.git.getshell@seu.edu.cn
Signed-off-by: Tzung-Bi Shih <tzungbi@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/chrome/cros_ec_debugfs.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/platform/chrome/cros_ec_debugfs.c b/drivers/platform/chrome/cros_ec_debugfs.c
index 793c8c4bf35ba..0c01ffd72de26 100644
--- a/drivers/platform/chrome/cros_ec_debugfs.c
+++ b/drivers/platform/chrome/cros_ec_debugfs.c
@@ -521,7 +521,7 @@ static int cros_ec_debugfs_probe(struct platform_device *pd)
 	ret = blocking_notifier_chain_register(&ec->ec_dev->panic_notifier,
 					       &debug_info->notifier_panic);
 	if (ret)
-		goto remove_debugfs;
+		goto cleanup_console_log;
 
 	ec->debug_info = debug_info;
 
@@ -529,6 +529,8 @@ static int cros_ec_debugfs_probe(struct platform_device *pd)
 
 	return 0;
 
+cleanup_console_log:
+	cros_ec_cleanup_console_log(debug_info);
 remove_debugfs:
 	debugfs_remove_recursive(debug_info->dir);
 	return ret;
-- 
2.53.0



