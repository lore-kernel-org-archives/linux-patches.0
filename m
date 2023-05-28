Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EAF1569D
	for <patches@lists.linux.dev>; Sun, 28 May 2023 19:27:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C629EC433EF;
	Sun, 28 May 2023 19:27:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1685302035;
	bh=2MoMWExnZSUBjyiAeqQHwxYdgC6498XHvZRNTygb2Yo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DFg4wMz9dvCtxsf8K/+fqqS93eCJkUEKUUEDC9IQ5SQyE4OwhmQzHgXDs+e+Aizs1
	 z56NQaP3o/bAowSOkqzXeDIHubdB7IkQTuZ7XvoMeaCFZAJE6f6RToPdddb8LivScn
	 gqdj3mYQx2J4LUTe7ve7MVnD2JiSygBCPiHokiGo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hardik Garg <hargar@linux.microsoft.com>,
	"Tyler Hicks (Microsoft)" <code@tyhicks.com>
Subject: [PATCH 5.4 135/161] selftests/memfd: Fix unknown type name build failure
Date: Sun, 28 May 2023 20:10:59 +0100
Message-Id: <20230528190841.262948905@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230528190837.051205996@linuxfoundation.org>
References: <20230528190837.051205996@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Hardik Garg <hargar@linux.microsoft.com>

Partially backport v6.3 commit 11f75a01448f ("selftests/memfd: add tests
for MFD_NOEXEC_SEAL MFD_EXEC") to fix an unknown type name build error.
In some systems, the __u64 typedef is not present due to differences in
system headers, causing compilation errors like this one:

fuse_test.c:64:8: error: unknown type name '__u64'
   64 | static __u64 mfd_assert_get_seals(int fd)

This header includes the  __u64 typedef which increases the likelihood
of successful compilation on a wider variety of systems.

Signed-off-by: Hardik Garg <hargar@linux.microsoft.com>
Reviewed-by: Tyler Hicks (Microsoft) <code@tyhicks.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/memfd/fuse_test.c |    1 +
 1 file changed, 1 insertion(+)

--- a/tools/testing/selftests/memfd/fuse_test.c
+++ b/tools/testing/selftests/memfd/fuse_test.c
@@ -22,6 +22,7 @@
 #include <linux/falloc.h>
 #include <linux/fcntl.h>
 #include <linux/memfd.h>
+#include <linux/types.h>
 #include <sched.h>
 #include <stdio.h>
 #include <stdlib.h>


