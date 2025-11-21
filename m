Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85E05332904;
	Fri, 21 Nov 2025 13:14:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763730863; cv=none; b=YpwIilXi7zy64cp/F1twtpZE+4HgSNv/9teG5wyJsgRpFj+KXA/YCZDdZnjbTjGw3hUgVQSTAlQURnOrlGwXUi0xm94X/I6DGPS7d2Fpj/i0YmXsb4sJcuXa/UgjVp4+Sf0x3XlhSc7vxJC3cI+33IUBpEewwjaO/TlEg2LSPk4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763730863; c=relaxed/simple;
	bh=EhhsKuRnHMzkexv/FWaOA8UNiZQ6TxMUz3JQGNohNcs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C1cYjIlxubWnPHPfbuy2FoO26ZBnSrLtt1zL04+5BW/cY2gn4tUU4mSarAxf/iPvy8DE4Lw6CcrelaQH+gRga4xjoJUn6TqDei7YQxMjmROfYOAMoZSTwpunaZo/RR4occeec7DsGF4pcMFDjAgDeumVEwvj/xoF57I9ZPiuqnc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ukweaJSL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ukweaJSL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B975FC4CEFB;
	Fri, 21 Nov 2025 13:14:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763730863;
	bh=EhhsKuRnHMzkexv/FWaOA8UNiZQ6TxMUz3JQGNohNcs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ukweaJSLbW3LwRuNi+R27Ao6q5Xd4ficlUNI3YIfves98/vFae/z2UF2JAQIayfBm
	 ctHVhvXb7Ur6eSXYk+jUVohLJyVLaiyKUOZ1XUc06sNw9Wjd7qZckDww7+/hGsk0BJ
	 cdjVMwcfeqNdAzrAZ0sJqXROdszXlr01S4e6yMDA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolin Chen <nicolinc@nvidia.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 001/247] iommufd/selftest: Fix ioctl return value in _test_cmd_trigger_vevents()
Date: Fri, 21 Nov 2025 14:09:08 +0100
Message-ID: <20251121130154.646275388@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130154.587656062@linuxfoundation.org>
References: <20251121130154.587656062@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicolin Chen <nicolinc@nvidia.com>

[ Upstream commit b09ed52db1e688eb8205b1939ca1345179ecd515 ]

The ioctl returns 0 upon success, so !0 returning -1 breaks the selftest.

Drop the '!' to fix it.

Fixes: 1d235d849425 ("iommu/selftest: prevent use of uninitialized variable")
Link: https://patch.msgid.link/r/20251014214847.1113759-1-nicolinc@nvidia.com
Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/iommu/iommufd_utils.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/iommu/iommufd_utils.h b/tools/testing/selftests/iommu/iommufd_utils.h
index 772ca1db6e597..9f472c20c1905 100644
--- a/tools/testing/selftests/iommu/iommufd_utils.h
+++ b/tools/testing/selftests/iommu/iommufd_utils.h
@@ -1044,8 +1044,8 @@ static int _test_cmd_trigger_vevents(int fd, __u32 dev_id, __u32 nvevents)
 	};
 
 	while (nvevents--) {
-		if (!ioctl(fd, _IOMMU_TEST_CMD(IOMMU_TEST_OP_TRIGGER_VEVENT),
-			    &trigger_vevent_cmd))
+		if (ioctl(fd, _IOMMU_TEST_CMD(IOMMU_TEST_OP_TRIGGER_VEVENT),
+			  &trigger_vevent_cmd))
 			return -1;
 	}
 	return 0;
-- 
2.51.0



