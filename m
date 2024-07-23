Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A469F13C3F5;
	Tue, 23 Jul 2024 18:37:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721759875; cv=none; b=gIzDkmaKGWPk717audbapte8FeS6rDuE3QBlCpQPW+zwOA2VtOAraphPcRWFzHLEHg1CgCEuVJA8E9fy9U+ZUsdHsewLWLSnUYT33l8QXWlUAJiIVUOO98tROJB8V6d7W+v0Hm1lUKFGtzwtMxLgPKUOKAm5haLa2WwtlG8NB9I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721759875; c=relaxed/simple;
	bh=bPByfWGBaJyKAgP1i2xj8ezuqxJVXoMwBF1qC+QbCf8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TUGC1WOYjhnSXNiTtXmcN0FAS7zKxo5oKfY5HQCn+BipLisax1gsFTxLM8XWYkguWnOtqrEaYB1gsOXVL9U0Kg9Ni8LIcR0/k3lkLFLXCCUcDm0ZZf2OpVqmkbqKkDi0lHxmZdnRTY639QuYhMT1YeDs/OHCgF+2a+Hwal3NByo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rwIQeDzb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rwIQeDzb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24876C4AF09;
	Tue, 23 Jul 2024 18:37:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721759875;
	bh=bPByfWGBaJyKAgP1i2xj8ezuqxJVXoMwBF1qC+QbCf8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rwIQeDzbLvaWp+pMjd42aqJzH4YaB7LAFgQWUmJIn2774ImcEa0CuBs0O4aBKZb3w
	 LJUSpaOGHMDDc3FWyyfWMOl6plt1iws84L5JiXqkWP0CXHy9m7QvYlr/MAP7ujaFnF
	 UDLIO8C+pcvYo1OjDycHOPjbdpwY/f158LkCVfrE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Ellerman <mpe@ellerman.id.au>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 027/163] selftests/overlayfs: Fix build error on ppc64
Date: Tue, 23 Jul 2024 20:22:36 +0200
Message-ID: <20240723180144.522775996@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240723180143.461739294@linuxfoundation.org>
References: <20240723180143.461739294@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Ellerman <mpe@ellerman.id.au>

[ Upstream commit e8b8c5264d4ebd248f60a5cef077fe615806e7a0 ]

Fix build error on ppc64:
  dev_in_maps.c: In function ‘get_file_dev_and_inode’:
  dev_in_maps.c:60:59: error: format ‘%llu’ expects argument of type
  ‘long long unsigned int *’, but argument 7 has type ‘__u64 *’ {aka ‘long
  unsigned int *’} [-Werror=format=]

By switching to unsigned long long for u64 for ppc64 builds.

Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/filesystems/overlayfs/dev_in_maps.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/filesystems/overlayfs/dev_in_maps.c b/tools/testing/selftests/filesystems/overlayfs/dev_in_maps.c
index 759f86e7d263e..2862aae58b79a 100644
--- a/tools/testing/selftests/filesystems/overlayfs/dev_in_maps.c
+++ b/tools/testing/selftests/filesystems/overlayfs/dev_in_maps.c
@@ -1,5 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0
 #define _GNU_SOURCE
+#define __SANE_USERSPACE_TYPES__ // Use ll64
 
 #include <inttypes.h>
 #include <unistd.h>
-- 
2.43.0



