Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795622378;
	b=hzfY7OoEQS3f6vjJY85QUoSWqNeVAqE6oaGCel9rT5IeYLVjTax9bFdoka543yrQFj8q
	 EOLMzqlV39ERkPUaHyCUvzJw0e5cAxa9FA6jwwoJWkES5va/cWvQuG/Dlnw8lUwSuInPk
	 li2IeOfFvr43tqGXkL3WKwXkA49Kaxzj0LQEswfjMOF6UMRmaDIVRCqJJcwTMtVtOpo/R
	 ER87V/Mo4x+UCbXFYKHpTQrW4BsrSqa77ijcEnfvlrsv7dfeWzDXNYrBXxNBLtZ1/SHLb
	 5YtEkjYaeZNXbe0OjT9zqe5Ys/nHaJdqPhF7QV4eVhVLMzd0CAI2FKv3V4CSbeCwQ7w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795622378;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=8xUs+v/YvR0jmqrJJ6gKXKXeBUM7PdBuc/2DaV1ZOwY=;
	b=NCRFrNMNKm9YDQ+TrBQYwdFseh7TaZGJ/f29hSvo+LtwXe8XFl0Cg3IR4QjElYTWkxgH
	 fLus4FAedl+Do6s/7EbaF3dvvO5m9wL7dMglYM3eDuHfS39vAIsLESnnrOCs88ZWJOY/g
	 ezVWaacDBCn3C4RVXMJCvHwfzdbmEYls4CK+F9k6ydTMnWjSuWs61nZtMaUNtysoqspHi
	 MOjI0dZUe/vqC+Cu4mcg0dXMG39gd0UlNy6doZEyQhCqgkptEfoMdeEGbgJpnrMWOQyzK
	 LuyOh6y1Kh4xJuSqvRVR05KBGY38RbGH69kwqB/WDfMeuG3hgJqmy3VZFl38le/m2uQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="oxN/hSgb";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93107606A321;
	Wed, 25 Nov 2026 15:59:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oxN/hSgb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D7DF1F000C0;
	Wed, 25 Nov 2026 15:59:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795622378;
	bh=8xUs+v/YvR0jmqrJJ6gKXKXeBUM7PdBuc/2DaV1ZOwY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oxN/hSgbj2Mf5iT5giqKOdRUJghLMHxt2lM/sOMLHLFaOBosAgC3yONSarMhUADMI
	 MZiUc/qy5nCq5wD57fAqEfMiIJU/TfHQ00z34fq+Pqfy1Ch4Ecql2iz2jLSeheEcJm
	 1ANKfCA04Ky1AdUaQHMJC/WxOwhBCeEPdL12nkx8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guixin Liu <kanie@linux.alibaba.com>,
	Richard Cheng <icheng@nvidia.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 518/990] cxl/cdat: Fix uninitialized stack use in bandwidth gathering
Date: Wed, 25 Nov 2026 15:31:25 +0100
Message-ID: <20261125143834.229386508@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guixin Liu <kanie@linux.alibaba.com>

[ Upstream commit 97b74de26c81885a6447f5fe87641a2a136f8c7c ]

cxl_endpoint_gather_bandwidth() and cxl_switch_gather_bandwidth() declare
access_coordinate arrays on the stack and rely on their helpers to fill
them. The helpers assign only the bandwidth members, and the combine step
assigns even those only when both inputs are non-zero. The latency members
are summed from stack residue on every call, and the bandwidth members
keep that residue into the region access coordinate sysfs attributes when
the endpoint CDAT reports no bandwidth.

Zero initialize the arrays. Zero is the value this code already uses for
"not reported", so an unset member now reads back as unknown rather than as
a plausible number.

Found by code inspection. Tested on a QEMU CXL topology with two endpoints
sharing a switch upstream link and HMAT generic-port coordinates for the
host bridge, which the calculation requires to run at all: with temporary
printk at the combine sites, the unpatched kernel summed 0xfefefefe, the
CONFIG_INIT_STACK_ALL_PATTERN stack filler, into the latency members, while
the patched kernel reports the CDAT latency values there.

Fixes: a5ab0de0ebaa ("cxl: Calculate region bandwidth of targets with shared upstream link")
Signed-off-by: Guixin Liu <kanie@linux.alibaba.com>
Reviewed-by: Richard Cheng <icheng@nvidia.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Reviewed-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Link: https://patch.msgid.link/20260831092216.540644-2-kanie@linux.alibaba.com
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
[ sashal: Context lines differ because kzalloc_obj(*res_xa) isn't available here, so the existing kzalloc(sizeof(*res_xa), GFP_KERNEL) line was kept while applying the same coords initializer change. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cxl/core/cdat.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/cxl/core/cdat.c b/drivers/cxl/core/cdat.c
index c4bd6e8a0cf03..abb12d45af111 100644
--- a/drivers/cxl/core/cdat.c
+++ b/drivers/cxl/core/cdat.c
@@ -633,9 +633,9 @@ static int cxl_endpoint_gather_bandwidth(struct cxl_region *cxlr,
 	struct cxl_port *endpoint = to_cxl_port(cxled->cxld.dev.parent);
 	struct cxl_port *parent_port = to_cxl_port(endpoint->dev.parent);
 	struct cxl_port *gp_port = to_cxl_port(parent_port->dev.parent);
-	struct access_coordinate pci_coord[ACCESS_COORDINATE_MAX];
-	struct access_coordinate sw_coord[ACCESS_COORDINATE_MAX];
-	struct access_coordinate ep_coord[ACCESS_COORDINATE_MAX];
+	struct access_coordinate pci_coord[ACCESS_COORDINATE_MAX] = { };
+	struct access_coordinate sw_coord[ACCESS_COORDINATE_MAX] = { };
+	struct access_coordinate ep_coord[ACCESS_COORDINATE_MAX] = { };
 	struct cxl_memdev *cxlmd = cxled_to_memdev(cxled);
 	struct cxl_dev_state *cxlds = cxlmd->cxlds;
 	struct pci_dev *pdev = to_pci_dev(cxlds->dev);
@@ -757,7 +757,7 @@ static struct xarray *cxl_switch_gather_bandwidth(struct cxl_region *cxlr,
 {
 	struct xarray *res_xa __free(free_perf_xa) =
 		kzalloc(sizeof(*res_xa), GFP_KERNEL);
-	struct access_coordinate coords[ACCESS_COORDINATE_MAX];
+	struct access_coordinate coords[ACCESS_COORDINATE_MAX] = { };
 	struct cxl_perf_ctx *ctx, *us_ctx;
 	unsigned long index, us_index;
 	int dev_count = 0;
-- 
2.53.0



