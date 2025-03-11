Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98EB125E832;
	Tue, 11 Mar 2025 15:38:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741707496; cv=none; b=jRcCe2EfoQ5G17liHhyimfKDcOQ4hgAdm5sOzjpMcQtH641YrYxbQKWypOeM/k9l2wms74eU8+wbmTJ9GrCZs8+nM90i7jbkvmf+9Ks/FhcBPvjSbEEQXFAUIbK14OQcIVmJWYcgIMYtA3gyobey7EyU9QU6TnjTdHlerRFgwUE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741707496; c=relaxed/simple;
	bh=ynFvqCgiHRHzXAy63w2ufwlfqt1O48IUas6Et+xflJw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=maoRvF27PBHuvbR8as++Ue3Z7UF2qFDRj/hYRpwJMWtYIPdXL5V4XV16mD0ONa8vaFZyK/HQbDfVvtdDIrUI+Vn0APUln73g4rzBO5mR2gFCy9IvXmHHFSTQG1nGF8YNsQHAhCKPk1mT2fj3W1rwofj7dSiiHYfgIsZDNIGROVE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HLsZRnCe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HLsZRnCe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FF29C4CEE9;
	Tue, 11 Mar 2025 15:38:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741707496;
	bh=ynFvqCgiHRHzXAy63w2ufwlfqt1O48IUas6Et+xflJw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HLsZRnCeDWDTRtbPAC1rn/SlbItv7k55fjEHjtgpwY9LBLd0w9DSoASs7q7SxpX66
	 gWodpRAo+q9Y0JYSnuMpS36UNE4dAoOlJWp2rz2O+h3HXupcWscMTtPrF9//W4o4xa
	 QoBro/4JNqYanAcVfgG+L0kypIGz1XW7Dpsiqu3A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hui Su <sh_def@163.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 381/462] kernel/acct.c: use #elif instead of #end and #elif
Date: Tue, 11 Mar 2025 16:00:47 +0100
Message-ID: <20250311145813.399214019@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145758.343076290@linuxfoundation.org>
References: <20250311145758.343076290@linuxfoundation.org>
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

From: Hui Su <sh_def@163.com>

[ Upstream commit 35189b8ff18ee0c6f7c04f4c674584d1149d5c55 ]

Cleanup: use #elif instead of #end and #elif.

Link: https://lkml.kernel.org/r/20201015150736.GA91603@rlk
Signed-off-by: Hui Su <sh_def@163.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Stable-dep-of: 56d5f3eba3f5 ("acct: perform last write from workqueue")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/acct.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/kernel/acct.c b/kernel/acct.c
index 6552eb22dd1e4..a7e29ca8f3591 100644
--- a/kernel/acct.c
+++ b/kernel/acct.c
@@ -397,9 +397,7 @@ static comp2_t encode_comp2_t(u64 value)
 		return (value & (MAXFRACT2>>1)) | (exp << (MANTSIZE2-1));
 	}
 }
-#endif
-
-#if ACCT_VERSION == 3
+#elif ACCT_VERSION == 3
 /*
  * encode an u64 into a 32 bit IEEE float
  */
@@ -516,8 +514,7 @@ static void do_acct_process(struct bsd_acct_struct *acct)
 	/* backward-compatible 16 bit fields */
 	ac.ac_uid16 = ac.ac_uid;
 	ac.ac_gid16 = ac.ac_gid;
-#endif
-#if ACCT_VERSION == 3
+#elif ACCT_VERSION == 3
 	{
 		struct pid_namespace *ns = acct->ns;
 
-- 
2.39.5



