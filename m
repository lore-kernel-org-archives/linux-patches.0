Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14EA71E86F;
	Tue, 30 Jul 2024 17:04:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722359075; cv=none; b=KRECmEC+L0iimh4mX4MhO8BSSe/oN9yQAEZ9YK5CdvUQ3o2qFakCqy0Ubf50fSGOlwdSJSWd+sgW9Ou0802fckyF0iPNVCK8hT1fBdfEQ4SPl7xU4L3tDVRF+RKI7XIAeneeCcdZtsZBRXLD602VJxqzALMqmLBu+vZvDQw5OGo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722359075; c=relaxed/simple;
	bh=4H+Gvd/XUxU8LnvCm4KNlX0msCyuMvGk6DG/cX1h4Gc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PEgZtkdS0qGaGYWdCu4dkbpwxsU9fDRfb2wGP7Zo7771YOHNk1E5B6gqK2d6oAVWcOuGspUeNWYvlKHOXtTgZX4WNqODSbFkWGHtkSnyWMrkzaXUDDiMYvNdxmt9bJV+xBvwkN9M8kPkaTogFuG1JokVGYzFpGbTuh0oZHyZhwY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jJ6UJOU9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jJ6UJOU9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8719EC32782;
	Tue, 30 Jul 2024 17:04:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722359074;
	bh=4H+Gvd/XUxU8LnvCm4KNlX0msCyuMvGk6DG/cX1h4Gc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jJ6UJOU99YL5rkYRXY0ZZY7FROxaz062BTTvRv2YrPRI+T2igHBYTO0YSnvMYEbJE
	 7O6ePZorI/CB3YV7AyS/3mLXvoHmVJuqQGfhaPMb1qlvKaK4upP7f3czJfPQqVW6nk
	 qDK7V5WjC22P4qhSWN1L9MkByoHmYBXRcaK+bBWQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joao Martins <joao.m.martins@oracle.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Matt Ochs <mochs@nvidia.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 430/809] iommufd/selftest: Add tests for <= u8 bitmap sizes
Date: Tue, 30 Jul 2024 17:45:06 +0200
Message-ID: <20240730151741.684477703@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joao Martins <joao.m.martins@oracle.com>

[ Upstream commit 33335584eb78c0bda21ff8d759c39e035abb48ac ]

Add more tests for bitmaps smaller than or equal to an u8, though skip the
tests if the IOVA buffer size is smaller than the mock page size.

Link: https://lore.kernel.org/r/20240627110105.62325-4-joao.m.martins@oracle.com
Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Tested-by: Matt Ochs <mochs@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Stable-dep-of: ffa3c799ce15 ("iommufd/selftest: Fix tests to use MOCK_PAGE_SIZE based buffer sizes")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/iommu/iommufd.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/tools/testing/selftests/iommu/iommufd.c b/tools/testing/selftests/iommu/iommufd.c
index 0b04d782a19fc..61189215e1ab7 100644
--- a/tools/testing/selftests/iommu/iommufd.c
+++ b/tools/testing/selftests/iommu/iommufd.c
@@ -1727,6 +1727,12 @@ FIXTURE_SETUP(iommufd_dirty_tracking)
 	void *vrc;
 	int rc;
 
+	if (variant->buffer_size < MOCK_PAGE_SIZE) {
+		SKIP(return,
+		     "Skipping buffer_size=%lu, less than MOCK_PAGE_SIZE=%lu",
+		     variant->buffer_size, MOCK_PAGE_SIZE);
+	}
+
 	self->fd = open("/dev/iommu", O_RDWR);
 	ASSERT_NE(-1, self->fd);
 
@@ -1779,6 +1785,18 @@ FIXTURE_TEARDOWN(iommufd_dirty_tracking)
 	teardown_iommufd(self->fd, _metadata);
 }
 
+FIXTURE_VARIANT_ADD(iommufd_dirty_tracking, domain_dirty8k)
+{
+	/* half of an u8 index bitmap */
+	.buffer_size = 8UL * 1024UL,
+};
+
+FIXTURE_VARIANT_ADD(iommufd_dirty_tracking, domain_dirty16k)
+{
+	/* one u8 index bitmap */
+	.buffer_size = 16UL * 1024UL,
+};
+
 FIXTURE_VARIANT_ADD(iommufd_dirty_tracking, domain_dirty128k)
 {
 	/* one u32 index bitmap */
-- 
2.43.0



