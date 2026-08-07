Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51640470440;
	Fri,  7 Aug 2026 15:05:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786115146; cv=none; b=R9czs313iOw1rEkbaPbgtHlRK9p/b2mXNkZ8/fLDSGm56bkLaFcchurgamH8OiDQ7a+a+0EOFSt8uUOAQqQQwSMQuTy+mPsoDAharpZs5mZQ1FfvuGqP4DGPD9gLhqeiBC0x8qSjUCrKKonEzSRrsmDYBZElGhFEScqAeYwVmuU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786115146; c=relaxed/simple;
	bh=bwOxQz3diH7U1Ld9BhA4IqeZZMzA4oW3C1yt5DpKRfk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BFzxl2f+Jwk/sVBIoUJTR6UIYEcKIVjBXPKt4yoSLudi7XxAQufbmaJsQ9DhOFO2/aDv7RDQbAtaRqmQhoaW+YiYxHmHmZ6vm8196vj8JbbQ3EvxyT19JnpjQZiMclYLenKNJe+zYkHw6Hj1/c8yjc/xW148RuKmmOUHtTCvE0c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0T8Ebssw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0T8Ebssw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA2E21F00A3A;
	Fri,  7 Aug 2026 15:05:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786115141;
	bh=F+JvrGAejw+xW+skp+LdFuJXo496abwOBe3NovogI0A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0T8EbsswHzRLyKwDdv+LEqRkO97v1jEPBQ3p21/bfGttmlAk6YADph8jT03YXRSwe
	 UUuTc5M7KZ89YMMU9W7J9yegqTLNWcicAR0QXFugWQUmnIx1PqaiLxOc8TzWLbqLs4
	 NpBxXkjuMR8dxl6FOF/JNI/0BAWTwLO4SK4MW1Kc=
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
Subject: [PATCH 6.18 171/396] selftest: fix headers in fclog.c
Date: Fri,  7 Aug 2026 16:35:31 +0200
Message-ID: <20260807143427.989175106@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143424.272339768@linuxfoundation.org>
References: <20260807143424.272339768@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
 


