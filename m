Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017558;
	b=OqZeDjZfhuKE/DVkrVdbR8AGKrJ4YIH29iX2WhVxfUh2l+SFUO4/hJt0n6+EIFzPIsL5
	 elSwvXWxXpBbxQwlC8V50si6OqzukFI5hd3vFXFo1OnXchtRxraLqyIY2ImPcTyNO2lGq
	 yZq6GUd0P4eHAXUQ84VY29aTidh1u4HwJshoIwydGOBAZrqn3H9r4GFob3GZQn/mTmYqg
	 iCXihcV4d7t6+nidMWY3W1kFUH2albOj9+/tYD69TLPQYv1xnEuoPs5cb0BtXU9juytcR
	 PJSunvahsKHIrYQJQusaS2g8VtO2zpG0q2uBQOdx/0GbXmKt6CXfs1u06tM/rif4Hvw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017558;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=YYIkhll7f7YwVqMkGE++lOaXEybXDKCEcg/itMW82uU=;
	b=Hhj+dt60rT996jF+tIsxxc8cbfs5wZPQnE9Ho/76zK+JlfVIQeM7k+LzIyDuvcUYKIkA
	 6zNei06d1L3/JHk8Tsgd3Gq1jHSjXWea77LwhaN18QeGSe2a4qVkkVxNWM7k+L8wF8B7H
	 cPLLdwTNShCuIOU5m1T+vtHKRo+E/KmhGWedXgoEdkBZ/gX/3BA6TnnMt8nvkfVBl1CPH
	 8cJWY2IAAVwpSK1V01h69XXFek9Ja6nlsu1Jz+/6VkcjAMNni8XBBLGvgjrSXXWhBOtjD
	 bzgiBSqyzttsbhv6L55VaRprFOv0Mv7ROHY+o79JwVnAaXFbl9bMyPjJTUOzL16Tz5Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=boi1pmO0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C1ED606A320;
	Wed, 18 Nov 2026 15:59:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=boi1pmO0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D33E1F000C4;
	Wed, 18 Nov 2026 15:59:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017557;
	bh=YYIkhll7f7YwVqMkGE++lOaXEybXDKCEcg/itMW82uU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=boi1pmO0Tz327SZpKC5va2ZLKIzhnS0fIKpLIoGtUEW4iejVFp2wng9mQbshoB52p
	 ucuUkWFxR5RiWV2KBQRazJ0/52+pj5LmC/UAK0JFJypzX59FT6Dr2jxgNvO+eGeyPD
	 PFyjA6eQOmjG6mGO04z2zCLJBfj5gZnddvpKWP28=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Joerg Roedel <joerg.roedel@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0928/2651] iommu/vt-d: Drop old iopf ref only after attach succeeds
Date: Wed, 18 Nov 2026 15:36:08 +0100
Message-ID: <20261118150321.291054573@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index c9e246e8f8e23..fddb624af7c17 100644
--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -3987,6 +3987,14 @@ static int identity_domain_attach_dev(struct iommu_domain *domain,
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
@@ -3994,16 +4002,9 @@ static int identity_domain_attach_dev(struct iommu_domain *domain,
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



