Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024623;
	b=3g6WmW/ZGHVtZFkOOcOBjCwLFpx3DPIlRe+kbEYga9Fk948vNq2dWuJYXrVr1t57UZIP
	 7VTTXsVegUFj1iaol4eWsfzfZrE2uKROrNUTfDd12MndmW8m/wfWN8ILCsN1UkQTZb8a5
	 BFTOl2v6eTH05Dpo7ApaRWDYLuvLFBQo/osw1bOPnsN7seLUk3uWI1jvkMUIekpyAyeHh
	 /4MOTD2IvUgUxTN+OsCw7keovq7xoZ7uu4vvo/F3gL3qS+wFXe16ygr6b/0LmttChg6N5
	 /YXSnpGa85GG7LIepAIn2VZxZJev6XzXFhpeXFI3c5G+osjyOq1ttUlrUsRDVSFKrmQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024623;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=dnyXG/NNCu9Z+j5klBkA+FHdzjMLsMudkZhcC7QT4oY=;
	b=EAeDj/kPE3XcKx6532e1GRgUAzBe+ScLNrH/ZueG8PxOIuKOkGxIH2LAHkCri3IfjJTQ
	 PZKb52FMpO3nwuq1aldb7mxqCdxjh8kk3BWGyGHbgB00CqOccsonEjYYnMyao901DX+Ed
	 amjIH2f8IE+f0zt6ygFsh0jwpv0eTKsGsKUUQcRcHmPuyIqQmvaMO+PeSQbEr9tvUd0uk
	 yMoAijJBrfV5zjra8iZCHeGYIabi7wW1GlAhwjAdYvYxI7cRTQ5bSY3RLzSYNypHkM+32
	 4NcV8o0MB6E13fH8RMHtW5ORnjyc7LCC7Vs5ZHHM8XwisAgZWyNLYqM1oK3eZ21O7gw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wsFCT8Yd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60CE9606A325;
	Wed, 18 Nov 2026 17:57:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wsFCT8Yd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFD101F000C4;
	Wed, 18 Nov 2026 17:57:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024623;
	bh=dnyXG/NNCu9Z+j5klBkA+FHdzjMLsMudkZhcC7QT4oY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wsFCT8YdhlFbAr7tF5k/NQVjncrGYqi5AVf5oGGSwG21FHGYgHNcbbc+oFhF8FaMU
	 vXXhN0s63klQLQTFacnCCse4u5nrKCdEteXpYM7ZdkyIWXmPNTGn1A1ddNYl0SCDpF
	 wTYln+fTfViCfd3w6NQpRHt/59gcNxy+FMx2dWNQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Joerg Roedel <joerg.roedel@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0792/2151] iommu/vt-d: Drop old iopf ref only after attach succeeds
Date: Wed, 18 Nov 2026 15:42:07 +0100
Message-ID: <20261118150150.950541705@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lu Baolu <baolu.lu@linux.intel.com>

[ Upstream commit 5fbb0fa7327667ade8fa61921425bd4f8803e272 ]

identity_domain_attach_dev() currently removes the old domain’s iopf
reference before programming pass-through. If pass-through setup fails,
attach fails but the old domain is still effectively attached — now
with its IOPF ref already dropped.

This can undercount info->iopf_refcount and may disable iopf queue
handling while the old domain can still issue page requests.

Fix it by removing the old domain’s iopf reference only after
pass-through setup succeeds, matching other attach paths.

Fixes: 236dd58fabd2 ("iommu/vt-d: Fix iopf_refcount leak on RID domain replacement")
Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/intel/iommu.c | 19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
index 19ea73dad7f35..4098c4f1dcfd9 100644
--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -4562,6 +4562,14 @@ static int identity_domain_attach_dev(struct iommu_domain *domain,
 	if (dev_is_real_dma_subdevice(dev))
 		return 0;
 
+	if (sm_supported(iommu))
+		ret = intel_pasid_setup_pass_through(iommu, dev, IOMMU_NO_PASID);
+	else
+		ret = device_setup_pass_through(dev);
+
+	if (ret)
+		return ret;
+
 	/*
 	 * The identity domain has no iopf_handler, so no IOPF reference is
 	 * taken for it.  The reference held by the old domain must still be
@@ -4569,16 +4577,9 @@ static int identity_domain_attach_dev(struct iommu_domain *domain,
 	 * not affect the IOPF reference count.
 	 */
 	iopf_for_domain_remove(old, dev);
+	info->domain_attached = true;
 
-	if (sm_supported(iommu))
-		ret = intel_pasid_setup_pass_through(iommu, dev, IOMMU_NO_PASID);
-	else
-		ret = device_setup_pass_through(dev);
-
-	if (!ret)
-		info->domain_attached = true;
-
-	return ret;
+	return 0;
 }
 
 static int identity_domain_set_dev_pasid(struct iommu_domain *domain,
-- 
2.53.0



