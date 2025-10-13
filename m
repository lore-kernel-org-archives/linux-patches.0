Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E94423B616;
	Mon, 13 Oct 2025 15:00:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760367610; cv=none; b=FtebP/8qoIcclf+a4dfpTPZPoTeuMEeN2sj37z8zw7r7NhqdBzu3ZyA3BhF5DCd5zIXNYYiSEkb1baWbIBjK4FOzMZj7BoR/NvyZhu/r/Rp+bRROkob8vB/lgcKNHzkEr9DFuTiK5QsrJAMKkJCspQa205e6wojNrBO5mPs3ySs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760367610; c=relaxed/simple;
	bh=tALJ+MzZHsZL8Uf274h6k3gjlRiY+MCDcc5UAwqpezM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KjDVWsMeNeAVkdO/hKbm8oCepzuMfxAeq2suTsCRtdPdQiOU4bgwlY7YOtltxarF9WIvLxmbVT3kF58v/jtDlvGqlFWb6vEjaoJBCAEoQOxWSEXhF2Yx5EOZVi1D9L9wSvGvW5ZI/LEXs/fwv7LR2L4n2BidgSurzQ+LGDbNqac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xTElc4RL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xTElc4RL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFFF5C4CEE7;
	Mon, 13 Oct 2025 15:00:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760367610;
	bh=tALJ+MzZHsZL8Uf274h6k3gjlRiY+MCDcc5UAwqpezM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xTElc4RL0diefP2x/QkERGMADqsRuGKhCW+wI7ma45CSpaTg6jutIQ9jfx3QnzJcw
	 XHmGviDA1sqj8BiEIC9rXWth/f91mVWyIJqZ+3tpkp3SOfEKD7gMIkUrrGbjCn7ByP
	 YwHnMagPO3O05Dapbc9nYzWR2Ze9f45KCib0yMjM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Berg <benjamin.berg@intel.com>,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 028/196] selftests/nolibc: fix EXPECT_NZ macro
Date: Mon, 13 Oct 2025 16:43:39 +0200
Message-ID: <20251013144316.214083578@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144315.184275491@linuxfoundation.org>
References: <20251013144315.184275491@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Benjamin Berg <benjamin.berg@intel.com>

[ Upstream commit 6d33ce3634f99e0c6c9ce9fc111261f2c411cb48 ]

The expect non-zero macro was incorrect and never used. Fix its
definition.

Fixes: 362aecb2d8cfa ("selftests/nolibc: add basic infrastructure to ease creation of nolibc tests")
Signed-off-by: Benjamin Berg <benjamin.berg@intel.com>
Link: https://lore.kernel.org/r/20250731201225.323254-2-benjamin@sipsolutions.net
Signed-off-by: Thomas Weißschuh <linux@weissschuh.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/nolibc/nolibc-test.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/nolibc/nolibc-test.c b/tools/testing/selftests/nolibc/nolibc-test.c
index 4aaafbfc2f973..a019de995e5df 100644
--- a/tools/testing/selftests/nolibc/nolibc-test.c
+++ b/tools/testing/selftests/nolibc/nolibc-test.c
@@ -176,8 +176,8 @@ int expect_zr(int expr, int llen)
 }
 
 
-#define EXPECT_NZ(cond, expr, val)			\
-	do { if (!(cond)) result(llen, SKIPPED); else ret += expect_nz(expr, llen; } while (0)
+#define EXPECT_NZ(cond, expr)				\
+	do { if (!(cond)) result(llen, SKIPPED); else ret += expect_nz(expr, llen); } while (0)
 
 static __attribute__((unused))
 int expect_nz(int expr, int llen)
-- 
2.51.0



