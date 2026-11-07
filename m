Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060942;
	b=i3oeeZXZtVKo6k2MbJy2DW0eCBgO/hnByrtAEldMFuid2Dkwp1w9vN6Lkv7NWccaMfAr
	 +9wfbErMRVswponHQ02K+TBDV8G+gM1N5SAHtA8xavj9zztEH/c46LtULiNaJ8hCUf9OY
	 qyxsDRRPdi5yiunUbtS8y4Tw3GJMAdXefsOYk1wfcewZK2nsUYYWnvlR6sDJ/rmVgCj62
	 k1PZxqVqay0e0TWy8509E/3nh66hhToO2wsQct3WYNDD21NZAkEgr889KMLWSZ449l1+z
	 6/VofMHknFuST/0S/cRb46Id6qCkeKRTiRjoXcXAwHshyLaIGOKGsVs0sMI2lvUPzAA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060942;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=asij5N/GohelCx78wP2g1Bz8OqI6BiwWMRhYnel2y3A=;
	b=5tapYviI9T+kG1O0f/2Fv8oGjgQmorGgSqlFQZNWPQOmb19HVwnZuo+h3Eb2EboEuUnr
	 io0jgqu9Wi0SIRQtwrfxX0ndQ8dR4uVHEH2EW7oAiNnU+HAO6xyNq/jlYFO6+K8ix97Dv
	 jCLc8N3VOhiK/5z6zk3vVTaQedY90JntUc/xQy3cSr+v3E9A0rqb7c9j2qZJICdqMnbHH
	 mGYCQiXN0CzmdkeRgtpAt/uqmFInvyMymQg9wqq3VOT0kFzwVn+JtzD44H24LzDhTW6Zf
	 pyBXf395fT6ZI+vPPUNz4Mgrydc2Ze4oVtOP7Azle2h6LjzzRxTFn4ag3uc1Flq20+w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="zZHLW/cv";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BB6D606D836;
	Sat,  7 Nov 2026 14:15:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zZHLW/cv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27E981F0089F;
	Sat,  7 Nov 2026 14:15:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060942;
	bh=asij5N/GohelCx78wP2g1Bz8OqI6BiwWMRhYnel2y3A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zZHLW/cvPesOHKfN+wPHknGunPWGaw2Vwjh/Q+n4i7NijrPVwqhdrObH1vUrhL3Og
	 cVUPpFDFG3yogbaeruyeAdCGhGYMaTGyys7D53YmfT/dAX8d2KO9x5gQYMqpwxM7R5
	 /fQxb5RIks9Ede8Al3C/3EiPUTbsxCNYe5n8gVuk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guanghui Feng <guanghuifeng@linux.alibaba.com>,
	Guixin Liu <kanie@linux.alibaba.com>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Joerg Roedel <joerg.roedel@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0305/1536] iommu/vt-d: Fix CACHE_TAG_NESTING_DEVTLB polluting shared variables in flush loop
Date: Sat,  7 Nov 2026 08:38:41 -0500
Message-ID: <20261107135006.287249741@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

From: Guanghui Feng <guanghuifeng@linux.alibaba.com>

[ Upstream commit 3846e469c1ba1407260066070bff5c88ee39a4c7 ]

In cache_tag_flush_range(), the CACHE_TAG_NESTING_DEVTLB case modifies the
shared local variables 'addr' and 'mask' before falling through to
CACHE_TAG_DEVTLB. This causes all subsequent CACHE_TAG_DEVTLB entries in
the same loop iteration to incorrectly use the full-range flush parameters
(addr=0, mask=MAX_AGAW_PFN_WIDTH) instead of the precisely calculated PSI
range. This is not the intended behavior, as regular DEVTLB entries should
always perform targeted range-based invalidation.

Fix this by having CACHE_TAG_NESTING_DEVTLB directly call
cache_tag_flush_devtlb_psi() with the full-range constants and break,
instead of modifying shared variables and falling through. This ensures
CACHE_TAG_DEVTLB always uses the original calculated addr and mask for
precise range flush.

This change slightly affects trace_cache_tag_flush_range() behavior.
Previously, after addr/mask were overwritten, the tracepoint could record
a full-range flush even when the caller requested a narrower range.

The tracepoint should reflect caller intent. Although this helper may
widen the actual hardware invalidation range for implementation reasons,
that does not change what the caller requested, so logging the requested
range is the correct behavior.

If the actual invalidation range sent to hardware is needed, it is already
visible via the qi_submit trace event, which records the invalidation
descriptors emitted by the driver.

Signed-off-by: Guanghui Feng <guanghuifeng@linux.alibaba.com>
Signed-off-by: Guixin Liu <kanie@linux.alibaba.com>
Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/intel/cache.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/iommu/intel/cache.c b/drivers/iommu/intel/cache.c
index 09694cca8752d..7048ee6eafc00 100644
--- a/drivers/iommu/intel/cache.c
+++ b/drivers/iommu/intel/cache.c
@@ -463,9 +463,8 @@ void cache_tag_flush_range(struct dmar_domain *domain, unsigned long start,
 			 * affected by a change in S2. So just flush the entire
 			 * device cache.
 			 */
-			addr = 0;
-			mask = MAX_AGAW_PFN_WIDTH;
-			fallthrough;
+			cache_tag_flush_devtlb_psi(domain, tag, 0, MAX_AGAW_PFN_WIDTH);
+			break;
 		case CACHE_TAG_DEVTLB:
 			cache_tag_flush_devtlb_psi(domain, tag, addr, mask);
 			break;
-- 
2.53.0



