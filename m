Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016654;
	b=Nn54i+eewt2R8xLLMSMlWMBbfw4bhYpuVUiGmeADZdATzjHhfpY4YQNHCh+LfbvqfVgF
	 bAFDnjGfhSruA91oi7gQhit/dxNzlGCdwgzpcCau8s1FDSwiAeRCjjCk4TPUTCLOFeYpI
	 +jsXjhMszAMVFRYuZOPE46OMLeDpEsQ9llz32+ETTV4WyWHwOUHalc2TOtR9jdcHhoj2c
	 FgRqZ0Dbg3u0mMCwp7JQp+P497iMtgIieMsGqtJhVLpN8h5NANxXRRw/Mp93OCLkpppcu
	 Go84AwQpnWpU95hJM7gadf9oBX3YYQY64i62G6fILwH5sYjlZa+DJDcmGnZaDPhqlHA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016654;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=yWERIFpxnQDRzMcqsOHPYI8aAKxC9NoLvQBUlGgXR40=;
	b=5b0pOV2FshLDpIo5YA+la+L1VDcv7uKJwI6diS/f1Sd/nNkHDYi1gm1Q6aTgVI+Bb7EB
	 1f7c+8T+Wh6IU7nphnMUCnvRo4mVfpAmli5gYMAGzTB5qYIVhhxL9qLiCSHF7TwGxTJ0q
	 9UCc2868wZ9g6cDAx3WWVasyQKBwi+i1AHE3ZhMO2iT9djBk3EtYYyCn4tXM4DgAjTTg+
	 wfkJrXtqqGEWLyKfldqbybqSEaZ7tEj37ZU6jdreLdGOrILpGgUxz5rGpGFlK62s9GPG9
	 TLVDksO0VlJBwmyfvlP/eIfvGEYDzapg+gX5TXWRc71/eNHwOvCz8wYaK9oD3Fk4EsA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iV3f+fAe;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 293B0606A320;
	Wed, 18 Nov 2026 15:44:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iV3f+fAe
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E1AC1F000C4;
	Wed, 18 Nov 2026 15:44:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016654;
	bh=yWERIFpxnQDRzMcqsOHPYI8aAKxC9NoLvQBUlGgXR40=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iV3f+fAepBJvuCVva9LAD+5bDvOM8ozrkz36+kc0xlQdGS1+RwDiJzUBGfZ32o8fR
	 FWuQ7oxx7+CCoLxflvurdUwfclmo6cLxUSSCwkZ2Pg2/f0SCcq6VdVGbfh06MYBPYj
	 sXZ05xlGalWcabhF5EbGzr7124H9gvpUhPJ1Qc/c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guixin Liu <kanie@linux.alibaba.com>,
	Richard Cheng <icheng@nvidia.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0564/2651] cxl/cdat: Fix uninitialized stack use in bandwidth gathering
Date: Wed, 18 Nov 2026 15:30:04 +0100
Message-ID: <20261118150308.044488983@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cxl/core/cdat.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/cxl/core/cdat.c b/drivers/cxl/core/cdat.c
index 5c9f072625135..df9261ba84e5a 100644
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
 		kzalloc_obj(*res_xa);
-	struct access_coordinate coords[ACCESS_COORDINATE_MAX];
+	struct access_coordinate coords[ACCESS_COORDINATE_MAX] = { };
 	struct cxl_perf_ctx *ctx, *us_ctx;
 	unsigned long index, us_index;
 	int dev_count = 0;
-- 
2.53.0



