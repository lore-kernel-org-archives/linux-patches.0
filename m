Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05F021F543D;
	Tue, 21 Jan 2025 18:10:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737483052; cv=none; b=av0NJOpMZ8t7FLm1MucnjpPZh+NfOaEGPFupgYVTdEzbT/qCaNpOVLM62eITBVVZWTpPOfmvWXtKLMjYrXJcQYSUL//p/zg/xektHLnqRGnorsl8WFewXlv0SNw3fatuOB3csCrl6ZMVPRjkqMk6zWChM3IghF/U9uWPG405aTI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737483052; c=relaxed/simple;
	bh=Jm6stD9c5kK+pRkQXIpHsijJRe77ikp2ltyQOQ5eENM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LGu6PH0rSSkybK9992in5m1Vqsv42+/i5m9m4CSQjB1oOCNcNSu3HQ33eieOPmIfuttGBS0tNqWn4JI7P7wNiaVhT4e6QXnepJa0tgyyyJSvsh5/d/8vwsO70O0UhI2WAyf9ELDUix47Fui/XHffROLyMUrzyjB4V7D6XTtHsxs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K1dPmuaZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K1dPmuaZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F1A1C4CEDF;
	Tue, 21 Jan 2025 18:10:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1737483051;
	bh=Jm6stD9c5kK+pRkQXIpHsijJRe77ikp2ltyQOQ5eENM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K1dPmuaZuDCS1ihxrjtQANGHrR2McIZAndVGGk6cEPi7WDLv6CpRt2A5Cz4QEMWJ0
	 KB1ku0iJLMGvkyBG1eeqjujozjzY4Tw3qvfGJydtQwvt1m5fM+SZ/ktCHdN0zDvxg3
	 MKNngufDPMgHBWERnagRvooD+gjcYjjfM9Cz8Io0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Kunbo <zhangkunbo@huawei.com>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 098/127] fs: fix missing declaration of init_files
Date: Tue, 21 Jan 2025 18:52:50 +0100
Message-ID: <20250121174533.433944097@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250121174529.674452028@linuxfoundation.org>
References: <20250121174529.674452028@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhang Kunbo <zhangkunbo@huawei.com>

[ Upstream commit 2b2fc0be98a828cf33a88a28e9745e8599fb05cf ]

fs/file.c should include include/linux/init_task.h  for
 declaration of init_files. This fixes the sparse warning:

fs/file.c:501:21: warning: symbol 'init_files' was not declared. Should it be static?

Signed-off-by: Zhang Kunbo <zhangkunbo@huawei.com>
Link: https://lore.kernel.org/r/20241217071836.2634868-1-zhangkunbo@huawei.com
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/file.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/file.c b/fs/file.c
index b4194ee5c4d4f..386968003030f 100644
--- a/fs/file.c
+++ b/fs/file.c
@@ -21,6 +21,7 @@
 #include <linux/rcupdate.h>
 #include <linux/close_range.h>
 #include <net/sock.h>
+#include <linux/init_task.h>
 
 #include "internal.h"
 
-- 
2.39.5



