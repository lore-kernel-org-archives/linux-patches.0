Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9B412FF152;
	Tue, 12 Aug 2025 18:47:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755024457; cv=none; b=PoqpCrLeZHeBXfwpR1qcZt+1rds08SbFgesnACG7mLChgBsROYqLzntHDf/UMoATidqkejD5z87tK9O7L5acjEQ7Vd0V3BjtmbfsyJoR/KkFH2qXYnPIWCnBnQ1iZxZ7Bda7SH7u6tivLzWn0Qn/UYPtlp2dhuDSTGfnvUcaA2g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755024457; c=relaxed/simple;
	bh=w4MUzgMp+P3d/lAo3qM7O+qyf4GhZHOgqnyrXdfm+hs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qfxDnUuPbuDkWBmmL/j6xvU8ApipUCYrzQJFAyyD4dnz0cYO+lc8GMfuylNNXV1BYqJ0B+hFEzkWJQlDeVUgSVeTbVhyD0g21NTJdJgUCZU/EjDL89MK2p4dTfe8qTh0cZlQ+BwtSPpWAkzrkXK4BVMAdpKrSFCqjZnwmuzQJig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TlCtuHLV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TlCtuHLV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62F50C4CEF1;
	Tue, 12 Aug 2025 18:47:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755024457;
	bh=w4MUzgMp+P3d/lAo3qM7O+qyf4GhZHOgqnyrXdfm+hs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TlCtuHLV5JCtHrm62ThXR/QDBG8Z9Z/CggfqaPCNCr23lu29n6I40Y4eVUbYSrLJC
	 g/DV06HhoaWhzjDVN5JQQHWBe6skQPEKnEalGp86SfzAXDexkROzksIpw6mUPMP9g3
	 go9VA0zDHuZXWRS2cHJTpj2uGqn+NM9SNtwnu2sc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alison Schofield <alison.schofield@intel.com>,
	Li Ming <ming.li@zohomail.com>,
	Shiju Jose <shiju.jose@huawei.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Jonathan Cameron <jonathan.cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 378/627] cxl/core: Introduce a new helper cxl_resource_contains_addr()
Date: Tue, 12 Aug 2025 19:31:13 +0200
Message-ID: <20250812173433.679636183@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Li Ming <ming.li@zohomail.com>

[ Upstream commit 5b6031c832c2747d58d3f0130098d965ef050b9a ]

In CXL subsystem, many functions need to check an address availability
by checking if the resource range contains the address. Providing a new
helper function cxl_resource_contains_addr() to check if the resource
range contains the input address.

Suggested-by: Alison Schofield <alison.schofield@intel.com>
Signed-off-by: Li Ming <ming.li@zohomail.com>
Tested-by: Shiju Jose <shiju.jose@huawei.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
Reviewed-by: Alison Schofield <alison.schofield@intel.com>
Link: https://patch.msgid.link/20250711032357.127355-2-ming.li@zohomail.com
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Stable-dep-of: 03ff65c02559 ("cxl/edac: Fix wrong dpa checking for PPR operation")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cxl/core/core.h | 1 +
 drivers/cxl/core/hdm.c  | 7 +++++++
 2 files changed, 8 insertions(+)

diff --git a/drivers/cxl/core/core.h b/drivers/cxl/core/core.h
index 29b61828a847..6b78b10da3e1 100644
--- a/drivers/cxl/core/core.h
+++ b/drivers/cxl/core/core.h
@@ -80,6 +80,7 @@ int cxl_dpa_alloc(struct cxl_endpoint_decoder *cxled, u64 size);
 int cxl_dpa_free(struct cxl_endpoint_decoder *cxled);
 resource_size_t cxl_dpa_size(struct cxl_endpoint_decoder *cxled);
 resource_size_t cxl_dpa_resource_start(struct cxl_endpoint_decoder *cxled);
+bool cxl_resource_contains_addr(const struct resource *res, const resource_size_t addr);
 
 enum cxl_rcrb {
 	CXL_RCRB_DOWNSTREAM,
diff --git a/drivers/cxl/core/hdm.c b/drivers/cxl/core/hdm.c
index ab1007495f6b..088caa6b6f74 100644
--- a/drivers/cxl/core/hdm.c
+++ b/drivers/cxl/core/hdm.c
@@ -547,6 +547,13 @@ resource_size_t cxl_dpa_resource_start(struct cxl_endpoint_decoder *cxled)
 	return base;
 }
 
+bool cxl_resource_contains_addr(const struct resource *res, const resource_size_t addr)
+{
+	struct resource _addr = DEFINE_RES_MEM(addr, 1);
+
+	return resource_contains(res, &_addr);
+}
+
 int cxl_dpa_free(struct cxl_endpoint_decoder *cxled)
 {
 	struct cxl_port *port = cxled_to_port(cxled);
-- 
2.39.5



