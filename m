Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2766E21D5BC;
	Tue, 11 Nov 2025 01:19:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823954; cv=none; b=YDypULoyuwYNHO7k5wm0aYHzgIJyrbE52XdgaZ9v8G1Hfa6sx4CBLpDqiqQrDMKxyH7PbJCawBHl/ushxsRngLooxGLTx/+eKYa1iqU5xGGca0yCLccGflaCvI9FF7RZiGkFLzGd+cBUb7KzPk2y1p+guQuHfIgUluwwz3JDre4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823954; c=relaxed/simple;
	bh=raZyvmNSl/NvuVw+WzSViDcxtJj+luQI2iFChMryFZc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=szgt26RjEiwvPZBBLltZT2Nf592fHQOou5NOOF+Xy+DybeMxU2fIhkSW/K+uiaaiaZ2Hz/4QfuAHoddY0wxxn+h11vKlRUI0SDKeDOyEWEy79bDsNTfop7Cyes51GEP0yZoyyiPJYDtEIDb6Vzmcb5zjo7OCXvahFetriY5nP44=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D4V5p3+y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D4V5p3+y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B17F1C4CEF5;
	Tue, 11 Nov 2025 01:19:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823954;
	bh=raZyvmNSl/NvuVw+WzSViDcxtJj+luQI2iFChMryFZc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D4V5p3+y0lzK7Ag+HunZdshzR5bEmQK42YSWahHfafjGv/twU+jYW/hW/XW45xYh7
	 O/BCit1R4C7VAfn6RQqhm0Nuhl3/ZpggXSUE6HP3tPWSUq8+6WCkTEtW6dYKZtY6M1
	 bH7RtCHdzfbhOq9b7Lpu5ixNzKg5gR3ZPAiInuYc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qianfeng Rong <rongqianfeng@vivo.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 404/849] crypto: qat - use kcalloc() in qat_uclo_map_objs_from_mof()
Date: Tue, 11 Nov 2025 09:39:34 +0900
Message-ID: <20251111004546.207043397@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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
index 21d652a1c8ef3..18c3e4416dc51 100644
--- a/drivers/crypto/intel/qat/qat_common/qat_uclo.c
+++ b/drivers/crypto/intel/qat/qat_common/qat_uclo.c
@@ -1900,7 +1900,7 @@ static int qat_uclo_map_objs_from_mof(struct icp_qat_mof_handle *mobj_handle)
 	if (sobj_hdr)
 		sobj_chunk_num = sobj_hdr->num_chunks;
 
-	mobj_hdr = kzalloc((uobj_chunk_num + sobj_chunk_num) *
+	mobj_hdr = kcalloc(size_add(uobj_chunk_num, sobj_chunk_num),
 			   sizeof(*mobj_hdr), GFP_KERNEL);
 	if (!mobj_hdr)
 		return -ENOMEM;
-- 
2.51.0



