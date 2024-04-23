Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BD3A20B3E;
	Tue, 23 Apr 2024 21:41:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713908489; cv=none; b=StAU7RFlc1zxtVu0AU54tlbs+ZK25xjDZcxSnKAnAKoAIdWmj+7FsQ9l7fQTQM14DAMc5cnvC6+e8G0y063Z0MVDveXx/OVeum5HNdUIKn/TML9VwPDjMUuo7LIRBGork6rSyCW/A8Oy81XDuaD3syGRz371FoGXxFBvcYuIX10=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713908489; c=relaxed/simple;
	bh=lVe6zENi5AgVqtgGuFg7MdyPYjcVU75gltkJT/UYReY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gJL0UKyhS2aPk8T49r9qOUWbyK9JLcdMchPN9cLjCe4L0cWLX4o8qjwGzM+PaYDykKASEKeNzSTumcZSdZ4+OoFHfvefvk3N3TkVe3dJYPNbBBUjzaSrVqO8gJ+AP532+y2USF1tUPTMU/o3gT4T6XjkLTh8DAxI8Y6DO/rIBug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k/Guwoh/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k/Guwoh/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E24D5C116B1;
	Tue, 23 Apr 2024 21:41:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713908489;
	bh=lVe6zENi5AgVqtgGuFg7MdyPYjcVU75gltkJT/UYReY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k/Guwoh/cnc1Tp7vIx3InyXjNWrGhWkEGLOikyAgGQZQ8VkxPv9toNT+0RI2lMFlS
	 F3gZRTjyAWjETXjnrxHjGOxDzbuqWYKlG/P7f16slUOuC49Zm8xpUNwOochoHnHOX4
	 TRZjqP619aYNeKQzgyB0QhX33I7jWi4ofNf1NNRQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Muhammad Usama Anjum <usama.anjum@collabora.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 063/158] iommufd: Add config needed for iommufd_fail_nth
Date: Tue, 23 Apr 2024 14:38:05 -0700
Message-ID: <20240423213858.007773657@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240423213855.824778126@linuxfoundation.org>
References: <20240423213855.824778126@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Muhammad Usama Anjum <usama.anjum@collabora.com>

[ Upstream commit 2760c51b8040d7cffedc337939e7475a17cc4b19 ]

Add FAULT_INJECTION_DEBUG_FS and FAILSLAB configurations to the kconfig
fragment for the iommfd selftests. These kconfigs are needed by the
iommufd_fail_nth test.

Fixes: a9af47e382a4 ("iommufd/selftest: Test IOMMU_HWPT_GET_DIRTY_BITMAP")
Link: https://lore.kernel.org/r/20240325090048.1423908-1-usama.anjum@collabora.com
Signed-off-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/iommu/config | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/testing/selftests/iommu/config b/tools/testing/selftests/iommu/config
index 110d73917615d..02a2a1b267c1e 100644
--- a/tools/testing/selftests/iommu/config
+++ b/tools/testing/selftests/iommu/config
@@ -1,3 +1,5 @@
 CONFIG_IOMMUFD=y
+CONFIG_FAULT_INJECTION_DEBUG_FS=y
 CONFIG_FAULT_INJECTION=y
 CONFIG_IOMMUFD_TEST=y
+CONFIG_FAILSLAB=y
-- 
2.43.0



