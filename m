Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CC2A156F37;
	Tue, 23 Jul 2024 18:27:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721759226; cv=none; b=jzFaH6w+i66MWw1jUGr7/P4n4I3WjrsltiCbVJ8hIM/BxIyInmjwHNxTdcOqzJEJa3KfXvctdVvbBIfY+0zC3qlazu4bIaCK5nqRUoXnz4TQI1nnBUsu5Nt3qF0rZ1uH3Xm11jJ/AeXkpKOpa7TeqySgFxKXjJsTQIfXBHAVmyw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721759226; c=relaxed/simple;
	bh=NO6cEAmVC/c/3s0ZHb+wNk6oMa4/guCMX7EsluFAHeg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qX/x2/4wbF9yVg8PX6/d6DOwslKVzLcEFL87pga3+KMey3bZAtrblMBYFrg8cLby6Bt3BcZgj9uRSUTB01csg4rRY7zbGZ8JTZSfNEpbvkJ+8sr+RlZIPRf7tI9YCmdKUNxJXfHn7qRgTzzphKDIlXKqWDZ0Rlf/7hna8f4yGJM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fsPba0Zk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fsPba0Zk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B47EC4AF0A;
	Tue, 23 Jul 2024 18:27:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721759225;
	bh=NO6cEAmVC/c/3s0ZHb+wNk6oMa4/guCMX7EsluFAHeg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fsPba0ZkOXZkCJuNZWaMU15wT1NqhdzNsBsXV1j0KS1WIoMt0IQCG3dCYCsTrbkrx
	 bHNdmk+vxDaW3gvieELwH/f/1ypxUQT6FZX/gM8jI3/kGLktq+vJ5MxBPNDOtMM766
	 mSC8EnWRX57Jra9U6n0DgU0Sg2+goaFi56R0uSYE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Ellerman <mpe@ellerman.id.au>,
	Muhammad Usama Anjum <usama.anjum@collabora.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 027/105] selftests/openat2: Fix build warnings on ppc64
Date: Tue, 23 Jul 2024 20:23:04 +0200
Message-ID: <20240723180404.138393644@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240723180402.490567226@linuxfoundation.org>
References: <20240723180402.490567226@linuxfoundation.org>
User-Agent: quilt/0.67
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Ellerman <mpe@ellerman.id.au>

[ Upstream commit 84b6df4c49a1cc2854a16937acd5fd3e6315d083 ]

Fix warnings like:

  openat2_test.c: In function ‘test_openat2_flags’:
  openat2_test.c:303:73: warning: format ‘%llX’ expects argument of type
  ‘long long unsigned int’, but argument 5 has type ‘__u64’ {aka ‘long
  unsigned int’} [-Wformat=]

By switching to unsigned long long for u64 for ppc64 builds.

Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Reviewed-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/openat2/openat2_test.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/openat2/openat2_test.c b/tools/testing/selftests/openat2/openat2_test.c
index 7fb902099de45..f9d2b0ec77564 100644
--- a/tools/testing/selftests/openat2/openat2_test.c
+++ b/tools/testing/selftests/openat2/openat2_test.c
@@ -5,6 +5,7 @@
  */
 
 #define _GNU_SOURCE
+#define __SANE_USERSPACE_TYPES__ // Use ll64
 #include <fcntl.h>
 #include <sched.h>
 #include <sys/stat.h>
-- 
2.43.0



