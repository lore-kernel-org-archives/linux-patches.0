Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F397D42067;
	Tue, 23 Jul 2024 18:31:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721759477; cv=none; b=Hcbo25VXbj/PA9AIeUxXqhTrEFD7ojL7ykTFFG0dRH1NcdFXdakL0q0OY7Jv3+mCYYTFV26H+K2VhYCJu10eTLW5D5XjACTYBlKdnLGkF54YB1xWd06nHRq+asn4gwhxZMRj+jWPN0W6vPy/NY/nDzkMGUGsaPD34DBan8I2Aos=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721759477; c=relaxed/simple;
	bh=56ZOs9AdXaD0oxFhaJpZCx/1/LWgDbblDIU7zRnxZpo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gtQj9mC9gsRw459amIfd/PAfpGM5i4XYZPq4I27WCARbGWqjhl6elSlt/422fE5WI+ybMoUxhQdOvoHNyufPOTqkLPCZgWRSR8JTvBFNS7QrePKZ911UvzFhlbwVYxJwvRKCB9nmBfzwuyJHgEDbNfQaqwXCHnVxe6IxK2W0ZgI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=glXMekr5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="glXMekr5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A150C4AF0A;
	Tue, 23 Jul 2024 18:31:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721759476;
	bh=56ZOs9AdXaD0oxFhaJpZCx/1/LWgDbblDIU7zRnxZpo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=glXMekr5pXYeljdCS+RlLt9/XYc2ybGQimf34vVNNTs682lHu/QD93aHL4h2qimtU
	 AkrDry3O7yqHVYdNwKwLTDUvPGVBz135T6Jy9d2BGTO3SenoDx/B4XJjS0ChogbNJ5
	 zYNP2qMvCNYYIIpz33R7TPpW5WHPlpw8/MTTcT2I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Ellerman <mpe@ellerman.id.au>,
	Muhammad Usama Anjum <usama.anjum@collabora.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 023/129] selftests/openat2: Fix build warnings on ppc64
Date: Tue, 23 Jul 2024 20:22:51 +0200
Message-ID: <20240723180405.686196483@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240723180404.759900207@linuxfoundation.org>
References: <20240723180404.759900207@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



