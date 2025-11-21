Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4168134D39E;
	Fri, 21 Nov 2025 13:43:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763732593; cv=none; b=pXLdhU8eMwQ0X64mAo1sQmNhNCB4pgga+Pjx4GrtIEUTE8C98rRyosFhEsjNWmIqfSooXnna64GoYg6Q3xxHDwfXbjNtrxgoas1Wz4VLwMpV1KKmFQ1uxmYPyv+Yoojb4ZurM0KmkfTRSo433+mmI/2oGa75GSSc5U5FmU4+YOg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763732593; c=relaxed/simple;
	bh=b2+WORRJZlUsMIdq6jUFy2KKYIXj1bNL1UNAptx2UK4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=asm1/DW3x39++Gjyzl6Zy0f9Y++rQGi+4vYOTT9RNgHIHFG93Oixb8xORZcBmKP4Yja7eKSIXR+hhyhcSAKPRzVDuRDXG0TwH7keFb7v1kedAddoaPHHgyTrOaIvx1z0bXnV9Fto2bMFCU9FtQZYg9EH3VemNK+epPywp+D9coM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pPvs/F97; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pPvs/F97"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD8D1C4CEF1;
	Fri, 21 Nov 2025 13:43:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763732593;
	bh=b2+WORRJZlUsMIdq6jUFy2KKYIXj1bNL1UNAptx2UK4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pPvs/F97dn9aWeHDkkA5vwV37I2p8DuGDfmKvJEwIbegiu21ENpZQrG+4h4PkygNz
	 qugpZfi78qivHs6LX8Dst+r+wYIz6VBY+613ieGQey9DlvIClDWDSztIHM/1kTl1x6
	 bvQDob7ZNXjquuFsN3dA5GcsGpWquXcFWRne0hSY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qianfeng Rong <rongqianfeng@vivo.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 176/529] crypto: qat - use kcalloc() in qat_uclo_map_objs_from_mof()
Date: Fri, 21 Nov 2025 14:07:55 +0100
Message-ID: <20251121130237.280167637@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qianfeng Rong <rongqianfeng@vivo.com>

[ Upstream commit 4c634b6b3c77bba237ee64bca172e73f9cee0cb2 ]

As noted in the kernel documentation [1], open-coded multiplication in
allocator arguments is discouraged because it can lead to integer overflow.

Use kcalloc() to gain built-in overflow protection, making memory
allocation safer when calculating allocation size compared to explicit
multiplication.  Similarly, use size_add() instead of explicit addition
for 'uobj_chunk_num + sobj_chunk_num'.

Link: https://www.kernel.org/doc/html/next/process/deprecated.html#open-coded-arithmetic-in-allocator-arguments #1
Signed-off-by: Qianfeng Rong <rongqianfeng@vivo.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Acked-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/intel/qat/qat_common/qat_uclo.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/intel/qat/qat_common/qat_uclo.c b/drivers/crypto/intel/qat/qat_common/qat_uclo.c
index 4bd150d1441a0..473e1ab9b8baa 100644
--- a/drivers/crypto/intel/qat/qat_common/qat_uclo.c
+++ b/drivers/crypto/intel/qat/qat_common/qat_uclo.c
@@ -1745,7 +1745,7 @@ static int qat_uclo_map_objs_from_mof(struct icp_qat_mof_handle *mobj_handle)
 	if (sobj_hdr)
 		sobj_chunk_num = sobj_hdr->num_chunks;
 
-	mobj_hdr = kzalloc((uobj_chunk_num + sobj_chunk_num) *
+	mobj_hdr = kcalloc(size_add(uobj_chunk_num, sobj_chunk_num),
 			   sizeof(*mobj_hdr), GFP_KERNEL);
 	if (!mobj_hdr)
 		return -ENOMEM;
-- 
2.51.0



