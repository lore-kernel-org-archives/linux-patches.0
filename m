Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792773881;
	b=lt7MSC441pysN1cM0CzMirKXJCfSgx00d1nYqVAVfEXt0Yq+H2VccL4wW0bcVY7g9Q+s
	 eo56Q3LnyFbeD6vdQR+flyxMCtnGquYxiJvjdoW0hbn8KJR5oYIAuikyBOFke2aqInDUY
	 Glw4X2EfY5jskuwwDrSq1H5x9/r+R9V/r8dT4ER/eMIyZuC0/gatMnro77yr138iEfDM7
	 08kpAOWgPGSE1qmU9v9t9ufY0QeGZlDWKDtX4M41WhJiIYNXqBzbp43UoIsTuXwH+pouX
	 TlWXjFMKkzRW5EJKaIBHmG+EfOyKop6fxEJFG8KKSw5O3FWY7Q2wAC38ZM/ixL/5Omg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792773881;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=a9BO2YsF1dc0SqGhQCqQSXHl9nJnrm4dN1oO5bCzpG8=;
	b=BOFdwGgFHrkQC3dnxziHxdKBpPFseIQ6GFADyCEmkyRDuv8Ps3Bct3gyTHZw9H7vwMIq
	 khvDcsJpmrI7RHWc3XojfLrg5jSzQ+NUOJcYG03bJmR7AZ+866S9w0Jz6znu9C4U7IQwm
	 lcKFmS+jUpOQ9ogKu0Wton7zzoRF8TdM5L9JvtY0rjuTI403WUjnm7BFk/foGpYOFghP+
	 vq5rMZzDS/C7/uwRcEUxDWtwbXE645UbD4UcUS+f4SkHHQU7XmDM+WpiKjlMKv18sOd9E
	 xG8ikAHlryoJSGkkf34k+vGp1YtRJFlTbVIMyJo//vNlMaiDqmHD0OHP6AP198eymmw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="e/3+QAwV";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E380B606A324;
	Fri, 23 Oct 2026 16:44:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=e/3+QAwV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41A241F01825;
	Fri, 23 Oct 2026 16:44:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792773880;
	bh=a9BO2YsF1dc0SqGhQCqQSXHl9nJnrm4dN1oO5bCzpG8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=e/3+QAwVIGIYRyPdAcB1O8ky0h2YnVGWNG2WCa0HwofyjqUnT+pgM9rGAaKjcyZ5G
	 L+XbG1Lc70T5s9OnZ8fZ3/yNeDQV9CMh4MjAkxVAAXueSVdoSZjzuh1gMBxGeVrq8z
	 JjSxiKXEmkQqxi7oq4LlLXal1hQO916Codm+F4WM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Niranjana Vishwanathapura <niranjana.vishwanathapura@intel.com>,
	Tejas Upadhyay <tejas.upadhyay@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 046/193] drm/xe: skip eviction of a BO with no resource
Date: Fri, 23 Oct 2026 18:35:23 +0200
Message-ID: <20261023163715.297953378@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163714.201276352@linuxfoundation.org>
References: <20261023163714.201276352@linuxfoundation.org>
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
index 6d3db1517c8a4..2496b24840be8 100644
--- a/drivers/gpu/drm/xe/xe_bo.c
+++ b/drivers/gpu/drm/xe/xe_bo.c
@@ -313,6 +313,12 @@ static void xe_evict_flags(struct ttm_buffer_object *tbo,
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



