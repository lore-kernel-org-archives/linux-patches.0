Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 288EF1465AC;
	Thu, 13 Jun 2024 12:09:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718280559; cv=none; b=Qk9q+e5hCqvz7ofiVwk8Cy5Ccr7pwN4PMDtoSkrquR3nQs2tAb3tdu59DBWRPEiRSmmJP+8u+6FWZJKfUMBaclGO+w1+N4qHr8L6GLlyl7KsMgzng55rf8qTONoWMuTx7oOaAeKOYyRcyvWNO+/5PU3vGwHNtiY1iPuEL/v0g8I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718280559; c=relaxed/simple;
	bh=rc6vLa8Yzsw6iUOsPnZlbVsNL3ErUYs8mdVixnTfGTA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eZOedncNgqAGknpJ/D/Sh4Y/8n19BO0fRaYPkxYvG0g/AEVY6+wJivVja7oqD7zEpYFrpr2VbmD6OlPRq1jFRifsxUQ0fDKwWW8JPzOBmfVDIO1poH1eJWCk4ZtGdU25ZtLb3jrQOPxhbo702hNEJVno+YL1eEcZR7gITlDae9k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S+u5wBW8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S+u5wBW8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A63F5C2BBFC;
	Thu, 13 Jun 2024 12:09:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718280559;
	bh=rc6vLa8Yzsw6iUOsPnZlbVsNL3ErUYs8mdVixnTfGTA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S+u5wBW81HPQd7K/p2Sb0fmltDS/CGFJOLeCdc22xhsRM5Zw/18ZwA8tmgi2QmJBP
	 x20GxjthOeB1ZKrbL/oV6qCjjsH1NbJtjbGU5BGyh+FAfgHr77uXn9E/xlQUP7KqKp
	 TA15+F6992FmLEe0JqlN9UrtJ1V71kGuonfXSyrw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Ellerman <mpe@ellerman.id.au>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.6 094/137] selftests/mm: fix build warnings on ppc64
Date: Thu, 13 Jun 2024 13:34:34 +0200
Message-ID: <20240613113226.943309493@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113223.281378087@linuxfoundation.org>
References: <20240613113223.281378087@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Michael Ellerman <mpe@ellerman.id.au>

commit 1901472fa880e5706f90926cd85a268d2d16bf84 upstream.

Fix warnings like:

  In file included from uffd-unit-tests.c:8:
  uffd-unit-tests.c: In function `uffd_poison_handle_fault':
  uffd-common.h:45:33: warning: format `%llu' expects argument of type
  `long long unsigned int', but argument 3 has type `__u64' {aka `long
  unsigned int'} [-Wformat=]

By switching to unsigned long long for u64 for ppc64 builds.

Link: https://lkml.kernel.org/r/20240521030219.57439-1-mpe@ellerman.id.au
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/mm/gup_test.c    |    1 +
 tools/testing/selftests/mm/uffd-common.h |    1 +
 2 files changed, 2 insertions(+)

--- a/tools/testing/selftests/mm/gup_test.c
+++ b/tools/testing/selftests/mm/gup_test.c
@@ -1,3 +1,4 @@
+#define __SANE_USERSPACE_TYPES__ // Use ll64
 #include <fcntl.h>
 #include <errno.h>
 #include <stdio.h>
--- a/tools/testing/selftests/mm/uffd-common.h
+++ b/tools/testing/selftests/mm/uffd-common.h
@@ -8,6 +8,7 @@
 #define __UFFD_COMMON_H__
 
 #define _GNU_SOURCE
+#define __SANE_USERSPACE_TYPES__ // Use ll64
 #include <stdio.h>
 #include <errno.h>
 #include <unistd.h>


