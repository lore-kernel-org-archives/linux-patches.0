Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43440211A2A;
	Wed,  7 May 2025 18:50:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746643849; cv=none; b=pNvdBGot3qEKha0mcaL3EmHgRxjC0WnRySfnQRIsz01hlYYNoXTY+4p09tm18WIb31uxWQRd3U/F6Sv8/cbb2AKNPuFGFX0fNZAauqvtLrHWxLbaoH0UvQzbtreoxVK0iwSR+NjNq8Dbomi4KqvNinCVqGpYWgB+912iAw1a6rc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746643849; c=relaxed/simple;
	bh=WNVnt61Zh6Ss/SdNcvxbRNO9iXOTPmMdb4WRWviysqw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=neshVJcK4PzxcJ8RdYEPsH5BDxwJnrHiAGRctuyMhpAUDpaWs15GoV5pip3jvYyBxi9FsltBgXPmtmnGeTAE+SkQdO20U3yd+h/P7PoAlXySJC5pvADaeGgCpAShxtIGq61bSrcbQwamoINA0BK86Vf7lJJXPVMIPotceCF3pFc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GWZ2f6rI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GWZ2f6rI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C338CC4CEE2;
	Wed,  7 May 2025 18:50:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746643849;
	bh=WNVnt61Zh6Ss/SdNcvxbRNO9iXOTPmMdb4WRWviysqw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GWZ2f6rIsiz7Hnk1Ien3vvd+T0twoCoeiLKTEHmdJ2DWFpDh/D1WWPx2tlGwWQgBQ
	 lKvqKVtMmrDsdzieTfGK5A01NzRanv+c5qw0BVixq2t2UppqkZO1gvQHvHl9oO3rph
	 YF6vTq8ckfdyvEs46QxrOYHRKIoVA7+2rQn1bMi8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolin Chen <nicolinc@nvidia.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Alok Tiwari <alok.a.tiwari@oracle.com>,
	"Matthew R. Ochs" <mochs@nvidia.com>,
	Joerg Roedel <jroedel@suse.de>
Subject: [PATCH 6.14 037/183] iommu: Fix two issues in iommu_copy_struct_from_user()
Date: Wed,  7 May 2025 20:38:02 +0200
Message-ID: <20250507183826.188677521@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183824.682671926@linuxfoundation.org>
References: <20250507183824.682671926@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicolin Chen <nicolinc@nvidia.com>

commit 30a3f2f3e4bd6335b727c83c08a982d969752bc1 upstream.

In the review for iommu_copy_struct_to_user() helper, Matt pointed out that
a NULL pointer should be rejected prior to dereferencing it:
https://lore.kernel.org/all/86881827-8E2D-461C-BDA3-FA8FD14C343C@nvidia.com

And Alok pointed out a typo at the same time:
https://lore.kernel.org/all/480536af-6830-43ce-a327-adbd13dc3f1d@oracle.com

Since both issues were copied from iommu_copy_struct_from_user(), fix them
first in the current header.

Fixes: e9d36c07bb78 ("iommu: Add iommu_copy_struct_from_user helper")
Cc: stable@vger.kernel.org
Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Acked-by: Alok Tiwari <alok.a.tiwari@oracle.com>
Reviewed-by: Matthew R. Ochs <mochs@nvidia.com>
Link: https://lore.kernel.org/r/20250414191635.450472-1-nicolinc@nvidia.com
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/iommu.h |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -425,10 +425,10 @@ static inline int __iommu_copy_struct_fr
 	void *dst_data, const struct iommu_user_data *src_data,
 	unsigned int data_type, size_t data_len, size_t min_len)
 {
-	if (src_data->type != data_type)
-		return -EINVAL;
 	if (WARN_ON(!dst_data || !src_data))
 		return -EINVAL;
+	if (src_data->type != data_type)
+		return -EINVAL;
 	if (src_data->len < min_len || data_len < src_data->len)
 		return -EINVAL;
 	return copy_struct_from_user(dst_data, data_len, src_data->uptr,
@@ -441,8 +441,8 @@ static inline int __iommu_copy_struct_fr
  *        include/uapi/linux/iommufd.h
  * @user_data: Pointer to a struct iommu_user_data for user space data info
  * @data_type: The data type of the @kdst. Must match with @user_data->type
- * @min_last: The last memember of the data structure @kdst points in the
- *            initial version.
+ * @min_last: The last member of the data structure @kdst points in the initial
+ *            version.
  * Return 0 for success, otherwise -error.
  */
 #define iommu_copy_struct_from_user(kdst, user_data, data_type, min_last) \


