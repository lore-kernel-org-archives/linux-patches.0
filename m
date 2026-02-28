Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CA8A3446BC
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:00:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301620; cv=none; b=PNQRQJm0OZPcmsAMeF6DcjmtAwn94MFSK05rA3jMcbB9f+7zgfYeAm8HuvRtLf8pBjlVkbdhTteihyiz8h0ZTcS+lwiE/QAIlpTXEye9eHcqMXyW7IK7pLQUUspt7o4xd71iJonV4R2MN0kN7j9+1B7Ihj7vUcvXhatN8CCgJUU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301620; c=relaxed/simple;
	bh=uXDZBFBlCh9JEKa0Z6uBDUSQ7GEP1F5gk/R6iPyXv8c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YTqHNeXDH0g/OkcAXEBLx9ZlN9soDXe7ozONRTePyJ5IL/s7+69pV/r8dxyaGyrvoaPKSis9zkzi7Fl4Q44nNTsNbuaMdLELsKoQOMGwxZ9sEa39xb218tprNVCD077mK8mDBqAiyAzZFCfoPGaZDdfe4GJ6AJrjhmcRmryI+cw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EHBJ29/J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EHBJ29/J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E54DAC116D0;
	Sat, 28 Feb 2026 18:00:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301620;
	bh=uXDZBFBlCh9JEKa0Z6uBDUSQ7GEP1F5gk/R6iPyXv8c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EHBJ29/JyQB5jxFlubKiqKJFwMF30qWc6ZZiCUgSCC13ZGmO1kLq+S5WYBjw9KIX7
	 l4H6dak2X+iOSDqCGbEqXWI8ATB8AxU8b0hNq30zBPY1if9VeivDcmUKSLUDKN1LuP
	 C2wE/xCqGsczYT6T/aa6wxbz8vZnQxI7rv3ptYZToPrqmVdFQAmr0D1en0rUlz/mfO
	 6mF1Cyon4+uUXrkwMrHaGxQGX6NZSL+/6klADr6xgQs+V0OHiy5iJ175tCSB7iSgza
	 lq3pAp9PaAYUs3hi0usXLWw35WAsh/f5BEN775KoYEky2Nj7mAaBWk4lEm2BHvb1Mg
	 OjF2jkZh9Ebyg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Ben Dooks <ben.dooks@codethink.co.uk>,
	Jan Kara <jack@suse.cz>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 010/385] fs: add <linux/init_task.h> for 'init_fs'
Date: Sat, 28 Feb 2026 12:53:52 -0500
Message-ID: <20260228180011.1568201-10-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180011.1568201-1-sashal@kernel.org>
References: <20260228180011.1568201-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Ben Dooks <ben.dooks@codethink.co.uk>

[ Upstream commit 589cff4975afe1a4eaaa1d961652f50b1628d78d ]

The init_fs symbol is defined in <linux/init_task.h> but was
not included in fs/fs_struct.c so fix by adding the include.

Fixes the following sparse warning:
fs/fs_struct.c:150:18: warning: symbol 'init_fs' was not declared. Should it be static?

Fixes: 3e93cd671813e ("Take fs_struct handling to new file")
Signed-off-by: Ben Dooks <ben.dooks@codethink.co.uk>
Link: https://patch.msgid.link/20260108115856.238027-1-ben.dooks@codethink.co.uk
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/fs_struct.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/fs_struct.c b/fs/fs_struct.c
index 64c2d0814ed68..100bd3474476b 100644
--- a/fs/fs_struct.c
+++ b/fs/fs_struct.c
@@ -6,6 +6,7 @@
 #include <linux/path.h>
 #include <linux/slab.h>
 #include <linux/fs_struct.h>
+#include <linux/init_task.h>
 #include "internal.h"
 
 /*
-- 
2.51.0

