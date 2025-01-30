Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADBC51E522;
	Thu, 30 Jan 2025 14:25:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738247115; cv=none; b=TmriIC73gqywAt46GHJ9Sh60xCDFAf/THLnodc2eZf3GIcwm0h5+ONn/EdTFy60GxF19Xeww8u5hIkToTvEFSbOnDBpwrPenZNR1PCLGuDG3ja1hhvSw7nZuKZS1AW2aGmmCwBTp7QlUAeuTRPmO66YCQOATiSb+Z14221JiI1E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738247115; c=relaxed/simple;
	bh=diP1WdGfgCYj72zzxwiPP54UOl0HhLlj22iTFQorBFw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IjDY6Cegia4MBnag+eWRVIz/L/w/4C88OsecVN+UwkPZLzb8dAguy6T4+niCujonmI170m5nQhag5fLc+LEavX41MuvaBy9GlaLnXtRRGAK+c6P8Ynu0qb5Y0rYan6e9yvJ4ujPi2e2kxi8Tg+M95bT8SsfbdMiM/20Br2dsqyM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TklKE2b9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TklKE2b9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 390F9C4CED2;
	Thu, 30 Jan 2025 14:25:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738247115;
	bh=diP1WdGfgCYj72zzxwiPP54UOl0HhLlj22iTFQorBFw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TklKE2b9OfB6fRnQs6+hAJS339Po4gjLu46dY5HVB+Djaf7TQG9zVawRPUiPRRXEo
	 FpMaKsKGewb/V+ED17z6uxQGwuA9ZG2/uyONS1eADuBQ9CP3Rdgeur1+qYSb1p6Xin
	 LONbH4aecQSGagQ8eftnaARlF4mUYO36VYyFxWKw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Kunbo <zhangkunbo@huawei.com>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 087/133] fs: fix missing declaration of init_files
Date: Thu, 30 Jan 2025 15:01:16 +0100
Message-ID: <20250130140146.022322323@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250130140142.491490528@linuxfoundation.org>
References: <20250130140142.491490528@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 40a7fc127f37a..975b1227a2f6d 100644
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



