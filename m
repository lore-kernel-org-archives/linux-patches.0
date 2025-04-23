Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B54F28E5F1;
	Wed, 23 Apr 2025 15:18:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745421508; cv=none; b=UOInV+rYWa116gX/f4VhluSepLRdrdFX21moUbgkU6QpKgV9xrfz7JaKl8Bi/ry0ofqH78MJhsHmAUiV7rnScMS8YWrq9zeOCk6FKLUN9ZOKu+wSAX2d8gOqtM6exxSq1Y0NdrNCTdDJxNEnGVAVQU17cqCVSTo/hlR4yET02LU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745421508; c=relaxed/simple;
	bh=ckjvxrOVdAlsuLkvaO7QBzw+8e/UHZ5KGtuhlHwno5E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MBbN/9Qqjuwya2j6x7og/xaaEfAGIm6fJFJIcRTZD82oYc/NVRacP+KUQKjZHZ4bFPb0H2vjOBou8/R3Omx9Exjr8ffoM1Yjklk/AFg6/4e13FYb0kxoKMrBjwNco19+UB4IR0lW9LhqFFyAd13IvVvMMfZ/ORJmekVIX/cgFgo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Hv1HPMBd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Hv1HPMBd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E388C4CEE3;
	Wed, 23 Apr 2025 15:18:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745421507;
	bh=ckjvxrOVdAlsuLkvaO7QBzw+8e/UHZ5KGtuhlHwno5E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Hv1HPMBdSzdsWb5ONd0TIu6Gq+IjxrADA5uKNg6G/NXxdRRMOKJEJkaPxNqmwli4U
	 YvwASaqR8yXA97BYKJKWjX/R1BRYhaZho7UXQCIjy+P2GO4h0X8HfRY315+GoKpxTR
	 yAEtmwaFpZL5lyI73MNbbzSqZcWzGniLOzU0rU2s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Dan Carpenter <error27@gmail.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	Jason Gunthorpe <jgg@nvidia.com>
Subject: [PATCH 6.6 186/393] iommufd: Fix uninitialized rc in iommufd_access_rw()
Date: Wed, 23 Apr 2025 16:41:22 +0200
Message-ID: <20250423142651.062484103@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142643.246005366@linuxfoundation.org>
References: <20250423142643.246005366@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicolin Chen <nicolinc@nvidia.com>

commit a05df03a88bc1088be8e9d958f208d6484691e43 upstream.

Reported by smatch:
drivers/iommu/iommufd/device.c:1392 iommufd_access_rw() error: uninitialized symbol 'rc'.

Fixes: 8d40205f6093 ("iommufd: Add kAPI toward external drivers for kernel access")
Link: https://patch.msgid.link/r/20250227200729.85030-1-nicolinc@nvidia.com
Cc: stable@vger.kernel.org
Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <error27@gmail.com>
Closes: https://lore.kernel.org/r/202502271339.a2nWr9UA-lkp@intel.com/
[nicolinc: can't find an original report but only in "old smatch warnings"]
Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iommu/iommufd/device.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iommu/iommufd/device.c
+++ b/drivers/iommu/iommufd/device.c
@@ -1076,7 +1076,7 @@ int iommufd_access_rw(struct iommufd_acc
 	struct io_pagetable *iopt;
 	struct iopt_area *area;
 	unsigned long last_iova;
-	int rc;
+	int rc = -EINVAL;
 
 	if (!length)
 		return -EINVAL;


