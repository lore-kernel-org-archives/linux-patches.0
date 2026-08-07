Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8122A472782;
	Fri,  7 Aug 2026 15:41:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786117277; cv=none; b=VXvK99jbSvlXY2EXNaGf/Bsqo94mLrjrCG9e1S0KBUeTTeFyM5GW6UnpSPX5lLVIIXnUZ4sBMHjM9iUDhnlHc4KbBt7Eei1lBlLrtQkSo2R916Hw9yeq4sv5QLyTrdOCJhTTFCjHGAuTfgkw48gk2j6mziAK0BNjTNwnmrZ6wm8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786117277; c=relaxed/simple;
	bh=xZ8e5P9uoGxS6jAp5kBb1lbdLfzS9Tl/zxwQuZoqfAg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EPUQ1LGI5CzBAOQG7LCBU3gxatO8x/NsMyvpBo9wCvOOO67kOKI1VTJwCdDrWxvnYqrd3L20se4A46fEAKE8XAr+Rn0jB3jGzT+JvmbbTEm/ZheKgFWLW6NzFKqb5PDfhjiJJO2g6rWNeYk1iUuDF52RCWPnxtMExryJrVVGc2U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iflDQNwZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iflDQNwZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FD361F000E9;
	Fri,  7 Aug 2026 15:41:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786117276;
	bh=yCn9zqC1d2ylAD78wQROX9S/MgXlss9kCtCWPpQ1ek8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iflDQNwZjuxD06wNW/D/PK0288j88z5GQ+zXX1scmVn5OqrnL0JOoZGtXkIsPrmSe
	 0qLNDgFnjhRoSW/xW3xpvQQqBmtQxeKyxNw5qYCt/6GBFJ4QuY29wxs8nbroxmX9rY
	 QyQEYkLVPrQhsSnso5j3Q9zqlu2V4Dd6zbKZDBCs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jori Koolstra <jkoolstra@xs4all.nl>,
	Aleksa Sarai <cyphar@cyphar.com>,
	Shuah Khan <shuah@kernel.org>,
	Wei Yang <richard.weiyang@gmail.com>,
	Christian Brauner <brauner@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 7.1 217/438] selftest: fix headers in fclog.c
Date: Fri,  7 Aug 2026 16:36:53 +0200
Message-ID: <20260807143432.636719784@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143428.008222056@linuxfoundation.org>
References: <20260807143428.008222056@linuxfoundation.org>
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

From: Jori Koolstra <jkoolstra@xs4all.nl>

commit e3a0127eee04db8769e53c8102c4e76aa49be8c3 upstream.

fclog.c does not compile because it is missing fcntl.h, needed for
O_RDONLY etc.

There are also some redundant includes that are also in
kselftest_harness.h.

Link: https://lore.kernel.org/20260710171741.837308-1-jkoolstra@xs4all.nl
Signed-off-by: Jori Koolstra <jkoolstra@xs4all.nl>
Cc: Aleksa Sarai <cyphar@cyphar.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Wei Yang <richard.weiyang@gmail.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/filesystems/fclog.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/tools/testing/selftests/filesystems/fclog.c
+++ b/tools/testing/selftests/filesystems/fclog.c
@@ -6,10 +6,8 @@
 
 #include <assert.h>
 #include <errno.h>
+#include <fcntl.h>
 #include <sched.h>
-#include <stdio.h>
-#include <stdlib.h>
-#include <string.h>
 #include <unistd.h>
 #include <sys/mount.h>
 


