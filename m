Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 982151F5611;
	Tue, 21 Jan 2025 17:59:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737482367; cv=none; b=c7HJrDOb9aGKvp2Mw1XBwY6hp00wuylhYkWddw8raH9gxSF112Gl5PD7b5q5yQkcKkQmGz2Es+WTb8bBmS0rFExJion/duioPVTP5yLOShlhAX09gvs+JwKb6q+gYiILUvZW1vAVO/i53K+3/kyR6WBrcSPjgBfTvmwAGW+QvyI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737482367; c=relaxed/simple;
	bh=HUYEMp6Fvw3z3m3AxGCt0ARdfh/XLMqqcL1XEyi4Xt0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=djbs+oWlW8b0T0KThVmAZKhR0Q5WqytXVZ9y0SPXjuGukVHC65rhhBqzpZoLLdTAqJs3fw9QH1lIzWSPwjJPLPXzWA0Fcf8WASRKxAqZVjmRE9t8EuTVzFvha4gJBtoThkqmj6mPaoBQ/d0CjFRWQOpUsJTdaQ+35CEtNi15Q/c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Tgzoqvth; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Tgzoqvth"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A621C4CEDF;
	Tue, 21 Jan 2025 17:59:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1737482367;
	bh=HUYEMp6Fvw3z3m3AxGCt0ARdfh/XLMqqcL1XEyi4Xt0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Tgzoqvth2PNPk82Tk4KDL/rX3Dad3OLIlWAA3IsNGyeBglNZ1ri7L2NBFelAC9NFK
	 KYDErpRIzx5QyAQ2J1ePXn/Dawv24p4chJXEeNQYtNpFoj9FwcwklURAk6Jx4rCPIy
	 /xuvE4+GW92iX2DKnUPEeRJWdakEAASDyXPQNl8w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Kunbo <zhangkunbo@huawei.com>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 052/122] fs: fix missing declaration of init_files
Date: Tue, 21 Jan 2025 18:51:40 +0100
Message-ID: <20250121174534.996352664@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250121174532.991109301@linuxfoundation.org>
References: <20250121174532.991109301@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index eb093e7369720..4cb952541dd03 100644
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



