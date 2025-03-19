Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5D3C1B422A;
	Wed, 19 Mar 2025 14:34:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742394884; cv=none; b=tNrnY17JiGqYas4J3EqfJrOUQEhyNNZ64sTGDGDkpp+caoexMJGdS3+p+XPO6h+Zl6fWxDQiA7VcoQvW1hwr6PR73tZ6FmFUEefZX04iAy2osVfvNHqeVUSKycn0ykohavDLVU+aiMXG6rMOZoiOrFa/s/dnqYyoFJM2fovHV+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742394884; c=relaxed/simple;
	bh=5O4+kXWPSQhm4ab77AfpeI4xvTd9drMs0PMbz0o9M7Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=holrq5dDg4wDbOVKzNgH227OVOI9HvSPOJv/h/0wXQAxuZjEdsyKnvTwoVYxd2rfcXpLuqTw5+z/HTzRKxRcdOw34Op6ylfmAlYOwe/oed9cc7gk8kaIiwzOv+jCSyBeIL2kT7IUo/bj3Gs1/5dNNC9rLItO4lu/hE7vBKKdTGQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SIViQ690; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SIViQ690"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9FBFC4CEE4;
	Wed, 19 Mar 2025 14:34:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742394883;
	bh=5O4+kXWPSQhm4ab77AfpeI4xvTd9drMs0PMbz0o9M7Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SIViQ690KXcM2K9+DFItsEQumvn2IC+iPMgm00H26ewWjmwvaStMh1KRsarTlWX3h
	 6HOERl+JA4XkrtJwASacMJAQITidLDxUiNCTb9b9fjwcp5C3URV1UkD75Fv0Uq21oj
	 9N3TQS0vGiV40PUT6HsF5JWnL3bkynbC1hzSnfc8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bharadwaj Raju <bharadwaj.raju777@gmail.com>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 084/241] selftests/cgroup: use bash in test_cpuset_v1_hp.sh
Date: Wed, 19 Mar 2025 07:29:14 -0700
Message-ID: <20250319143029.807603847@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143027.685727358@linuxfoundation.org>
References: <20250319143027.685727358@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bharadwaj Raju <bharadwaj.raju777@gmail.com>

[ Upstream commit fd079124112c6e11c1bca2e7c71470a2d60bc363 ]

The script uses non-POSIX features like `[[` for conditionals and hence
does not work when run with a POSIX /bin/sh.

Change the shebang to /bin/bash instead, like the other tests in cgroup.

Signed-off-by: Bharadwaj Raju <bharadwaj.raju777@gmail.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/cgroup/test_cpuset_v1_hp.sh | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/cgroup/test_cpuset_v1_hp.sh b/tools/testing/selftests/cgroup/test_cpuset_v1_hp.sh
index 3f45512fb512e..7406c24be1ac9 100755
--- a/tools/testing/selftests/cgroup/test_cpuset_v1_hp.sh
+++ b/tools/testing/selftests/cgroup/test_cpuset_v1_hp.sh
@@ -1,4 +1,4 @@
-#!/bin/sh
+#!/bin/bash
 # SPDX-License-Identifier: GPL-2.0
 #
 # Test the special cpuset v1 hotplug case where a cpuset become empty of
-- 
2.39.5



