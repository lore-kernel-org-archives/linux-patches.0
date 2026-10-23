Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792774593;
	b=fioKZwp0fPdeK5CNDHDI3xsH84Tp3fdieOlqddKO/Hd51BZUR9+rGZiVHqCxDUPK1iqT
	 BKhQzXxq+hsLfa46pDByCJEX4qxpTJtoCZoCdumv2e5CaYWhxv5Hk/S9aNZxy7yf72vJ8
	 sq35MIKxA1FMx7OxUqByphLyTnWjiujzIIEgq/SnaRB3kPignVMzftGq8E+e+RDTCLAzC
	 xNjXOhl4ngK54J9ogDpGMbHF22JkkQaij4kbHnAp8xYXs4//fN/n8KSewe7kIBymSHMn1
	 lG0YAMl7MvIf7AdiyUH/aZ4L1v8L5acD6SLXcDOBtaroBGricGYhr7czxzQxI/RqqLA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792774593;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=idatbPIIzlZogXZjfV9iHbaEV6/4YmR8LIBg0z2oUy4=;
	b=FIPb0GlR+zRaSmgO9dhOH8kLzcHQWBS2lXFEMpUgsRnO5sSg/Ezrf7DOspc9yuGMQyaO
	 H3A9kWFicM1DvUZD0WZqq68m8XU3kY0pY1kl4MSMHKZj73kmToYb71cwQ+kA0gkHSphGK
	 FcteR5d5jqs6lhszsDpN6VKnc2IDyZfUSo5zuZpsyxeaSyqoJYoIL+sodJokGiyS0lIii
	 KlR7RnqgP1tZmIkkRxWtkpH0ub2PfqaVK0KE2lWRfoHI0qiFjMuu8xwvemo2GFVtYOqEq
	 8nQC5+ScHP4tR0P/Ozpyd+rWPWDWaIuVB2qxEdfmFIwFo6iOoaoHonmr1qYtQPf6abw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wd0X74C4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71564606A31A;
	Fri, 23 Oct 2026 16:56:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wd0X74C4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C25B31F01825;
	Fri, 23 Oct 2026 16:56:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792774593;
	bh=idatbPIIzlZogXZjfV9iHbaEV6/4YmR8LIBg0z2oUy4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wd0X74C4vwYBFH5PP8P97bINS0rS2NQz9tp/0WJH0Pl8SXznLW6JRwczN3DgtAKSt
	 WLGkX/l0+3WbsecRZOIFR+mFPU2wLUQrBC7Ms50L3lTr9F7RA1TaSHurUoLTWwNKHL
	 Es8ZzKDAQezZ2GX5WGbuzid1cx84NZUd3lZucjY8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Niranjana Vishwanathapura <niranjana.vishwanathapura@intel.com>,
	Tejas Upadhyay <tejas.upadhyay@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 045/242] drm/xe: skip eviction of a BO with no resource
Date: Fri, 23 Oct 2026 18:38:07 +0200
Message-ID: <20261023163714.843414047@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163713.816071858@linuxfoundation.org>
References: <20261023163713.816071858@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Niranjana Vishwanathapura <niranjana.vishwanathapura@intel.com>

[ Upstream commit 448e76cbdc6652ccd3ba337b7a6e1f028859f2ed ]

xe_evict_flags() switches on tbo->resource->mem_type to choose an
eviction placement. An xe BO can reach eviction with no ttm.resource,
e.g. an imported dma-buf BO whose resource was freed during teardown
while its attachment is still live: the exporter then invalidates it via
xe_dma_buf_move_notify() -> xe_bo_evict(), and the switch dereferences a
NULL resource and faults.

A BO with no resource has nothing placed or mapped, so there is nothing
to evict. Return an empty placement (num_placement = 0), mirroring the
handling already used for non-xe scatter-gather BOs just above;
ttm_bo_validate() then takes the pipeline-gutting path and returns 0.

Without the fix the xe_dma_buf@xe_test_dmabuf_move_notify_no_resource
dynamic live selftest will fail with below stack.

BUG: kernel NULL pointer dereference, address: 0000000000000010
RIP: 0010:xe_evict_flags+0xf4/0x140 [xe]
Call Trace:
 <TASK>
 xe_bo_evict+0x40/0xa0 [xe]
 ? ttm_bo_pipeline_gutting+0x71/0x180 [ttm]
 xe_test_dmabuf_move_notify_no_resource+0x182/0x440 [xe]
 xe_dma_buf_kunit+0x387/0x580 [xe]

v2: Add Fixes tag and failure info in commit text (Matt Brost)

Fixes: dd08ebf6c352 ("drm/xe: Introduce a new DRM driver for Intel GPUs")
Assisted-by: GitHub-Copilot:claude-opus-4.8
Signed-off-by: Niranjana Vishwanathapura <niranjana.vishwanathapura@intel.com>
Reviewed-by: Tejas Upadhyay <tejas.upadhyay@intel.com>
Link: https://patch.msgid.link/20261012215014.1495677-5-niranjana.vishwanathapura@intel.com
(cherry picked from commit dbcfaac6331f1fcb0c2fe3ad3e9adb1e5d43ec0c)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_bo.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/gpu/drm/xe/xe_bo.c b/drivers/gpu/drm/xe/xe_bo.c
index f4c5151d61c7c..dcdbe70b5f734 100644
--- a/drivers/gpu/drm/xe/xe_bo.c
+++ b/drivers/gpu/drm/xe/xe_bo.c
@@ -330,6 +330,12 @@ static void xe_evict_flags(struct ttm_buffer_object *tbo,
 		return;
 	}
 
+	/* No resource: nothing is placed/mapped, so there is nothing to evict. */
+	if (!tbo->resource) {
+		placement->num_placement = 0;
+		return;
+	}
+
 	bo = ttm_to_xe_bo(tbo);
 	if (bo->flags & XE_BO_FLAG_CPU_ADDR_MIRROR) {
 		*placement = sys_placement;
-- 
2.53.0



