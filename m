Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795625122;
	b=FmiygR0DlsV5Rv8ATCWYI32DYjgHhaybKhJhF1zLaT8ymguJdUr5Ie9CehmPRhc/pLSy
	 Sg6Lkii4XQdXNjPzRx1xBEOkePIaHTI1As5y2+TPwVhB/ZqhbwfMkVVsqQbkIn1phXnLh
	 qN7JfVdcnccDWQEAqTOMZyKfHw56vpsbS9QxIuWXiaG5LwfgX+T3gEAffUxfK52L6JN/6
	 oEujpkHWPaTS/ZxywoPT3kjVrbJ60h5QKn2D+bRoCRPs2UWIrTIeFYapp6NbcSf4X/l1w
	 0vysdOjkG/B7JlgzS9wdxmwhxI6cMWrv5/x1aMDp6WmFLqpvNqN3NX+SO+ONyFnCJMg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795625122;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ULW1CFEoPOMywE9me5HpegNRdPsURV4jsKz5c+nxuJU=;
	b=WR+AsccBZXnx9JbQStnPgXRdKugAnC1Ftva72n01xs/nMzKgr/LGiw2iFyUxMsRkUrdI
	 6pmFcvI+Z5apK/XFD7oO1CVCwNOn7zUb/JQ1jVftrvZ831yfCn5dZZpvs56Pxf7DA+VI/
	 7DzC4nN6XlDsWYqPOCAN5kiVFnRvFmA4VEs4lTWbNhk+G6pDfzYPgZ6Wvlg717hi9zTFv
	 Q+WyyYdpGKaFzBG6J5Ttn9FFhXgPBiv1Kj1/KrWn/ofga8QNBZAaXQr/v7GcUL7NMIzZt
	 CtVflmoOPSg+bJRHMz33MbdRt0SrZGnCzxcZpKwV2xsF6m/h3Q0oYswiulQqbl7pSZQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uVGXdFe5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A4C1606A321;
	Wed, 25 Nov 2026 16:45:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uVGXdFe5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA92B1F000CA;
	Wed, 25 Nov 2026 16:45:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795625122;
	bh=ULW1CFEoPOMywE9me5HpegNRdPsURV4jsKz5c+nxuJU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uVGXdFe5WrlnxXN0bY2KMncgiXepGHVdtTKdN2w7UgBYSNMyNGfrSXH2y61c8s5a/
	 y/9Z8cQ50Akx01upVU2EHsr2icF5DAEVpNZquPzxqozxnHhPuEIJp6u61r+RywVHOp
	 0GdetcTMCetYt9hnCdZu+Akw1x0xqVYeD8syTcz4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guixin Liu <kanie@linux.alibaba.com>,
	Richard Cheng <icheng@nvidia.com>,
	Li Ming <ming.li@zohomail.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 412/816] cxl/region: Unregister the pmem region when the bridge is unbound
Date: Wed, 25 Nov 2026 15:32:40 +0100
Message-ID: <20261125143858.731069127@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guixin Liu <kanie@linux.alibaba.com>

[ Upstream commit bb26797c08d408ea7e8d3625045f0fe28714a425 ]

Removing cxl_acpi unbinds the nvdimm bridge before the regions it
serves. A region probe can therefore register its cxl_pmem_region and
only then find the bridge unbound, which leaves the new device with
nothing to remove it.

The orphan outlives the teardown and pins its region and its memdevs, so
a later cxl_acpi bind renumbers the root port, ports, endpoints,
decoders and the memdev.

Unregister the cxl_pmem_region when the bridge is unbound.

Found by code inspection. Racing a cxl_region bind against a cxl_acpi
unbind leaked a pmem_region device on 12 of 12 attempts, and none with
this patch.

Fixes: f17b558d6663 ("cxl/pmem: Refactor nvdimm device registration, delete the workqueue")
Signed-off-by: Guixin Liu <kanie@linux.alibaba.com>
Reviewed-by: Richard Cheng <icheng@nvidia.com>
Reviewed-by: Li Ming <ming.li@zohomail.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Link: https://patch.msgid.link/20260831061120.200790-1-kanie@linux.alibaba.com
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
[ sashal: adjusted the patch to apply to devm_cxl_add_pmem_region() in core/region.c, since the separate region_pmem.c file doesn't exist in this tree. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cxl/core/region.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/cxl/core/region.c b/drivers/cxl/core/region.c
index e1c9e121b7c64..87923ef92094a 100644
--- a/drivers/cxl/core/region.c
+++ b/drivers/cxl/core/region.c
@@ -3170,12 +3170,14 @@ static int devm_cxl_add_pmem_region(struct cxl_region *cxlr)
 		dev_name(dev));
 
 	scoped_guard(device, &cxl_nvb->dev) {
-		if (cxl_nvb->dev.driver)
+		if (cxl_nvb->dev.driver) {
 			rc = devm_add_action_or_reset(&cxl_nvb->dev,
 						      cxlr_pmem_unregister,
 						      cxlr_pmem);
-		else
+		} else {
 			rc = -ENXIO;
+			cxlr_pmem_unregister(cxlr_pmem);
+		}
 	}
 
 	if (rc)
-- 
2.53.0



