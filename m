Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 992973C0094;
	Thu, 15 Jan 2026 17:32:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768498377; cv=none; b=N6IsfSLOKBMpRlfuF0B0ZOHM3RJZyN/qVOONKZaZI6ER0MXqKhHAcmp3QvwbRvhwP5qg5e65E4ynqUe2w2FsOvtf2ZyQUIdlRFRrx57dK8f+243AyvRBWAzC/LokTGkIqK2wFMVQR9Ii3rqXYoRIxJ00p6AkRzplA452WUIxBpc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768498377; c=relaxed/simple;
	bh=+WjfMRB4odVOIRaZEVBD5s0J4llR8Nj+5FCD9nSWn8M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Wi9Lne+7/6RmHM+EYd51Crli01qwjBcsRs4FncA4jQDkcG5JEaWx+P+LAytNPgiReZSlimv9QPyA5Z0NMDqkltSJY1yQqMS5CdIVdQpVg2xcf9OLufNt5/YOWJjXvXvFNR8Ui9f2SEKakT3pVRwZ1a3+Ktg5F/xVWEXCYbatB8w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Adw/8KvG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Adw/8KvG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E41EC116D0;
	Thu, 15 Jan 2026 17:32:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768498377;
	bh=+WjfMRB4odVOIRaZEVBD5s0J4llR8Nj+5FCD9nSWn8M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Adw/8KvG2eICySI7t/g21o5Dlb3N2/kLlc7pXG3N0ZzhCqlLleY5ghKe1FxOBkCY6
	 +jT/+ecvK9Je3eOTM6ct+1kR4upz637AHVP1Ig1Crhwo3Z92nFY6wca0h0QC3V0Qrs
	 kZlP8EmaDJpLc47qED/9c2qQyfgofLg+RpL2wsAI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Simon Richter <Simon.Richter@hogyros.de>,
	Matthew Brost <matthew.brost@intel.com>,
	Shuicheng Lin <shuicheng.lin@intel.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>
Subject: [PATCH 5.15 410/554] drm/ttm: Avoid NULL pointer deref for evicted BOs
Date: Thu, 15 Jan 2026 17:47:56 +0100
Message-ID: <20260115164301.075447711@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164246.225995385@linuxfoundation.org>
References: <20260115164246.225995385@linuxfoundation.org>
User-Agent: quilt/0.69
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Simon Richter <Simon.Richter@hogyros.de>

commit 491adc6a0f9903c32b05f284df1148de39e8e644 upstream.

It is possible for a BO to exist that is not currently associated with a
resource, e.g. because it has been evicted.

When devcoredump tries to read the contents of all BOs for dumping, we need
to expect this as well -- in this case, ENODATA is recorded instead of the
buffer contents.

Fixes: 7d08df5d0bd3 ("drm/ttm: Add ttm_bo_access")
Fixes: 09ac4fcb3f25 ("drm/ttm: Implement vm_operations_struct.access v2")
Cc: stable <stable@kernel.org>
Closes: https://gitlab.freedesktop.org/drm/xe/kernel/-/issues/6271
Signed-off-by: Simon Richter <Simon.Richter@hogyros.de>
Reviewed-by: Matthew Brost <matthew.brost@intel.com>
Reviewed-by: Shuicheng Lin <shuicheng.lin@intel.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Matthew Brost <matthew.brost@intel.com>
Link: https://patch.msgid.link/20251013161241.709916-1-Simon.Richter@hogyros.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/ttm/ttm_bo_vm.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/gpu/drm/ttm/ttm_bo_vm.c
+++ b/drivers/gpu/drm/ttm/ttm_bo_vm.c
@@ -427,6 +427,11 @@ int ttm_bo_vm_access(struct vm_area_stru
 	if (ret)
 		return ret;
 
+	if (!bo->resource) {
+		ret = -ENODATA;
+		goto unlock;
+	}
+
 	switch (bo->resource->mem_type) {
 	case TTM_PL_SYSTEM:
 		fallthrough;
@@ -441,6 +446,7 @@ int ttm_bo_vm_access(struct vm_area_stru
 			ret = -EIO;
 	}
 
+unlock:
 	ttm_bo_unreserve(bo);
 
 	return ret;


