Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 827491F707B;
	Tue, 21 Jan 2025 17:56:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737482169; cv=none; b=XnD/pX5v70lVNSAgZ+14oD7eGzam/phAqX0c2Qxt5e6LJWVNTqu2scGYylgphb8FNdRm40RdYDPYtBjxfTEZp/z4lhwQDZYo9AQ7uJqLsjX1CduFPYR/Znz7AIFWG+Yzxkqg2oOTc7pdaczXBhYzAVuWLJVIsKHDXbg6bmq1VMU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737482169; c=relaxed/simple;
	bh=KH5kbK1yarY4xJSGM9o9ckyrzkKxFvWoLrWFtE0x4Qo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dr33LPuTCEeP7IdMJiwT8UoLdMKExSUXlABC1zxqfFsjQy15Q8LzWBl17WhQl83NeKxp6sC+U7LS+q+omA0N7L4DrfMGM18fafw69NsFMdiWiEBr0zLFDFBZljRQL+IWgksiKdjiOGXAqOo8DLUwldulJ8/9JN3FYRJR99Gcbik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MqabWjD/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MqabWjD/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C419C4CEDF;
	Tue, 21 Jan 2025 17:56:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1737482169;
	bh=KH5kbK1yarY4xJSGM9o9ckyrzkKxFvWoLrWFtE0x4Qo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MqabWjD/wg0etUANHR7NAVl9V7VqgSDABZ5UNm00lV5yY8XenINiw14WaJ8YUScS3
	 GNH0yAosDdjL58cmAieQMrmWhVgKprSPcOvRief/wrTb7FPYUxwXjGZIT9ZG+jO6Mx
	 NZ8Rndz6GB2B7GigUNNB+9mTDT4oNVtoaie7oH0Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Kunbo <zhangkunbo@huawei.com>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 27/72] fs: fix missing declaration of init_files
Date: Tue, 21 Jan 2025 18:51:53 +0100
Message-ID: <20250121174524.471714393@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250121174523.429119852@linuxfoundation.org>
References: <20250121174523.429119852@linuxfoundation.org>
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
index bd817e31d7986..a178efc8cf4b5 100644
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



