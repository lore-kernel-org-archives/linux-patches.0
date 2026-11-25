Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795622381;
	b=bbVlGEmqCacGLKVP2GHrcHCEuRHxv+B7lubbeV6Rp4TnEPPNr2kO0opeg6UIAX+IQVPu
	 6w18mTebezdqhEqwuLVJaFULPYtt5Sd4HF5HgG7auuR7I0hiDthncNdwNXmGwuundEFnP
	 oSPYlhXl3L/Idqbe5LNM+TTq5btO3E/V41oS/bXxWC6GaBcdFk7czWzStnFUFgg8fjsBG
	 l9qcAYWMA29MugOZ6e7KFFg4t6O2QGPCpezGAVvkisMMve4Yz0mnu1A6RDH4k68dP3xry
	 ljT4YeN6AqY25r0KeN+w5609DYuGFjkdD7nSly9bhIfgSEbwiVlJZaWkheWxOMwPyCw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795622381;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=aV72Xcnl4Oh65WopZDQvzTJ9uK0CS1L/LwPTdmzDr60=;
	b=kh0bnKO1AOLXokdxq0wcbIFkNbPZT6JqOrwfpdydcwKMfji8JQsmODGci1nef5WX9uJs
	 jJ5VBXpViiTOd3EXF2dyhStBOfB5T9kA6+SOpIY1Jn8XESZuz4yBxfQhNUuAx67doTv42
	 n3GGq45B9nvogiZu5h26hGNpNSyL4nplwvj6Nvm7eJ6LnMFy4mJWhSW6lT64Q85RBA96c
	 63V69kcTZEBqzYN5wghhA2hZWwDmor1AA9NdTIQ767O64LhUHL4c/zr77xn3o1hdZMo00
	 KSWCORxbgFYcGqPR9y3fN08OE7wkw2l16QyjgKTzEh4zD0ULrZ1sD4B3FUrBoT1F3nQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=e5VJcIWq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D03FF606A31E;
	Wed, 25 Nov 2026 15:59:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=e5VJcIWq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B17641F000C6;
	Wed, 25 Nov 2026 15:59:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795622381;
	bh=aV72Xcnl4Oh65WopZDQvzTJ9uK0CS1L/LwPTdmzDr60=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=e5VJcIWqjwdDXtCNyuwNTB4iAlYSOFv2y3M2RM1h9h4IkOAYxkTejMeasTl53PWqk
	 AWJGW0CBme8QsbRIucxcJcxfbF0QmePLnLMuuWTJ5LVtbioCx2hkvYEm2ttwV0BZWJ
	 50uSdPe5sNXGQPNcDtOZQiawbUZmt2ChvhHNp5LI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guixin Liu <kanie@linux.alibaba.com>,
	Richard Cheng <icheng@nvidia.com>,
	Li Ming <ming.li@zohomail.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 519/990] cxl/region: Unregister the pmem region when the bridge is unbound
Date: Wed, 25 Nov 2026 15:31:26 +0100
Message-ID: <20261125143834.253594690@linuxfoundation.org>
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
[ sashal: Relocated the hunk from the split-out pmem region file into the region file where the function still lives; the hunk content is otherwise unchanged. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cxl/core/region.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/cxl/core/region.c b/drivers/cxl/core/region.c
index 46fc6644c8a72..7df6139f83ef2 100644
--- a/drivers/cxl/core/region.c
+++ b/drivers/cxl/core/region.c
@@ -3306,12 +3306,14 @@ static int devm_cxl_add_pmem_region(struct cxl_region *cxlr)
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



