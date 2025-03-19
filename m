Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81AA81C6FEE;
	Wed, 19 Mar 2025 14:37:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742395054; cv=none; b=DpuVZYCslFZ2DIsunzy/2zWg631aTPKIcdxZhuf81Nml81wff2GP+B8aPiPObEwuqgFPg643QLKsWCCIQfsmsa2P8fivCgMVy0CLbQ3y0c5Fh6DtXV3s8r+XlOTBoFQJXdo44P9b+HofuX9Bq6WMAlXpPvO35cJ2ClXreMVhu1g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742395054; c=relaxed/simple;
	bh=MUkvztyDvovwmWiN2Wg5zORPxXASIgwYENy5kUembGY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kLGyjh90uvtwKYwlyx5biDN3EIVu6nObhsGdsSNPz3p8Qy8ma45r/dSuKeoNRyPrq8BcGIojRSZQd4d3tUPMCytSdRdpmUW+BJVRxFvAaL5nWmdVOREDce3PBnZi5oTbJ0ic+a6KPln7EArhGpFkcZCPWOQoDySsea+nZkCMrrU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ketaVeWL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ketaVeWL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57790C4CEE4;
	Wed, 19 Mar 2025 14:37:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742395054;
	bh=MUkvztyDvovwmWiN2Wg5zORPxXASIgwYENy5kUembGY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ketaVeWLMg9Jg+zIfYW/xfGX/hc1hseDZnJLgqOvAgo/2Pojhwb9blK3uhMOSdYrA
	 lYKrvC6yTKmCiWUkS3vnucnPb54rT5fHpubd/IGPS3MzOFTuJCgh5FoKQ0WWlmpVKM
	 N0NTnr0XkxdzE3UcrxqYWNsDKv3lFr4jfoVpijsc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bharadwaj Raju <bharadwaj.raju777@gmail.com>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 082/231] selftests/cgroup: use bash in test_cpuset_v1_hp.sh
Date: Wed, 19 Mar 2025 07:29:35 -0700
Message-ID: <20250319143028.862311993@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143026.865956961@linuxfoundation.org>
References: <20250319143026.865956961@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



