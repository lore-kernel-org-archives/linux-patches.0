Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A9FA264F9C;
	Tue,  8 Jul 2025 16:49:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751993347; cv=none; b=jtj05HOqlEVgXVkXuqkdycU3dQSWEiTr/BmmLTvsvl3JkVRCHPcjyWVhbbMvVSKE259W5JzyFffqnF15dxkbz2FVbPE4lXGq8KaPkZqA8YT1DseV8VesN7S6uIZJyVrrsP94wguAnBVsCSn9A5loEC3iTtIDBvTb1Iku+bWBnd0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751993347; c=relaxed/simple;
	bh=TTrCvHW5pHh2Iuxj9jpffNu2w1D4BYuhM6ZyvkGzuvQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=foxdfDSXBdOCgm7KlOKeKCDDzM//suQrn+fM3LQIxnPeTu2XIjcdd7r5u1T567HMRUQ2u5aRRnroL9z722Phercys6rrZyumrOQ9Tp7LReMVeHLCJEza14Ta6sCGtVGNZtl8UVztpI3mtec4bOTndT4NyjkF9ThHkjvZJlcnkBE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GdS0FMUy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GdS0FMUy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21145C4CEED;
	Tue,  8 Jul 2025 16:49:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751993347;
	bh=TTrCvHW5pHh2Iuxj9jpffNu2w1D4BYuhM6ZyvkGzuvQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GdS0FMUy9V5AI1HHno0qvF3i4rVoLR7KqDKEbO658KSpA7Dlhyrdrv+lX2vjx4JWm
	 ielo8kkmftbjpFFK4q1efck/uh0ScmdYo08IkqDWZcfm2iXg58XtXu/A7HhjU/n51f
	 XUnD9ID4/69YJ74Ax8VGXXVrQpleVkkl/PxwbWBw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Gunthorpe <jgg@nvidia.com>,
	Nicolin Chen <nicolinc@nvidia.com>
Subject: [PATCH 6.15 012/178] iommufd/selftest: Add asserts testing global mfd
Date: Tue,  8 Jul 2025 18:20:49 +0200
Message-ID: <20250708162236.866056338@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162236.549307806@linuxfoundation.org>
References: <20250708162236.549307806@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicolin Chen <nicolinc@nvidia.com>

commit a9bf67ee170514b17541038c60bb94cb2cf5732f upstream.

The mfd and mfd_buffer will be used in the tests directly without an extra
check. Test them in setup_sizes() to ensure they are safe to use.

Fixes: 0bcceb1f51c7 ("iommufd: Selftest coverage for IOMMU_IOAS_MAP_FILE")
Link: https://patch.msgid.link/r/94bdc11d2b6d5db337b1361c5e5fce0ed494bb40.1750787928.git.nicolinc@nvidia.com
Cc: stable@vger.kernel.org
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/iommu/iommufd.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/tools/testing/selftests/iommu/iommufd.c
+++ b/tools/testing/selftests/iommu/iommufd.c
@@ -54,6 +54,8 @@ static __attribute__((constructor)) void
 
 	mfd_buffer = memfd_mmap(BUFFER_SIZE, PROT_READ | PROT_WRITE, MAP_SHARED,
 				&mfd);
+	assert(mfd_buffer != MAP_FAILED);
+	assert(mfd > 0);
 }
 
 FIXTURE(iommufd)


