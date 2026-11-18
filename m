Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795059291;
	b=IGtLzdPAbppC+BoE8PXDNDrCyI53ouB01iuraLrRAL75ESorvLq8gXfRugcnT90KWeiZ
	 xMhp23UJc2JBo0SIVSdXTDpqFSTNE8q2FKdy7uSnCfxpA7YW3lQWh8mfctA27NHBQhmHl
	 SyB4uuicPDZnUZyMPkt0YD5xKbWfcskFl40MFqFIq/QvGcfgzWXFb7rtXGKqngQva6f73
	 qw9yn1M8/MZc80OH6LmCCUtLlcYX+TR0fSqYfYHr/G1zT7cJzimg5jkcv3t9PqRRD+OyQ
	 5LWGo9RX4z97agCT/7HjJaPAO1/s4BX9O4dypnfqzIHtfrkZVxp3p6U4euLtCMfWcCA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795059291;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=l/lGu39zJQmbEy4vvGpWySjaj5xQ/uOzZxvxo+zaLd8=;
	b=4049z+G3qNYfPJZLISNHEJgDB6Scts52aTDpXLyN2gHsKlgNzpgzZ0iu0qj9F5/h0CIG
	 5RFaY+Z8lRNwMjRAssB4SNH9g/a6+fLfsMmDfhD6a9IoNoJA1z41C3EzWTjjcyNsw6cwE
	 P3yVI+JB3IoXmXalDO2MDbQWCW0A+g0630alLy9mbu8odXGi74a0Hn3OuK34g4HSWXuWb
	 2qkw8vEkwXEzNHIdoxb1SCKcMryFPyT5vrD1FcxDacz1OhGateRFGrX9kXmrk1J8somVg
	 eOG07olcz7W25oYRIAi8Oq8HqUZZsotML8ALhsyKjYOI+N1qxVLIV5zZOzZP1n/vDZQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FxBgQCBv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFE13606A320;
	Thu, 19 Nov 2026 03:34:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FxBgQCBv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28CAF1F000C4;
	Thu, 19 Nov 2026 03:34:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795059291;
	bh=l/lGu39zJQmbEy4vvGpWySjaj5xQ/uOzZxvxo+zaLd8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FxBgQCBv8m2ibDn7HW5OQ9HhDhIClQ0Lj0Qc//XyMdKNstL+pbjCqC3gPLpXlx4km
	 RxKkrmKbtaXM7f0o3DQh7Q7o84tQYSUz+nG+2Tx6NmcmeFjj9VTj9kOXkDZ2Kc3UqX
	 crd3cJeiT8WMrfTF34g4wkGJh7+U10VEPYzTVyV0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuhao Jiang <danisjiang@gmail.com>,
	Zhenhao Wan <whi4ed0g@gmail.com>,
	Lyude Paul <lyude@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0788/1848] drm/nouveau/svm: drain fault handler before freeing svmm
Date: Wed, 18 Nov 2026 15:47:06 +0100
Message-ID: <20261118145949.432018409@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhenhao Wan <whi4ed0g@gmail.com>

[ Upstream commit b46ddaf0823405f81e681eb26ec98508f3eb9a07 ]

The SVM fault handler nouveau_svm_fault() looks up each fault's
nouveau_svmm under svm->mutex, caches it in the fault array, then drops
svm->mutex and dereferences the svmm across blocking faults
(mmu_interval_notifier_insert(), hmm_range_fault()).

nouveau_svmm is not refcounted. On DRM file close nouveau_svmm_fini() ->
mmu_notifier_put() frees it asynchronously via call_srcu() without
waiting for the handler, and mmget_not_zero() pins the mm, not the svmm.
flush_work() on the fault buffer otherwise runs only at device removal
and suspend, never on close, so a fault handled concurrently with a close
can dereference a freed svmm.

The instance is already unlinked by nouveau_svmm_part() earlier in the
same close, so no new fault can resolve to it. Drain the handler in
nouveau_svmm_fini() before the free, guarding the flush with a NULL check
on drm->svm: on device teardown nouveau_svm_fini() runs first and frees
drm->svm (NULL) after blocking the notify and flushing the buffer, so the
handler is already drained; on per-client close drm->svm is alive and the
flush runs.

Fixes: eeaf06ac1a55 ("drm/nouveau/svm: initial support for shared virtual memory")
Reported-by: Yuhao Jiang <danisjiang@gmail.com>
Assisted-by: Claude:claude-opus-5
Cc: stable@vger.kernel.org
Signed-off-by: Zhenhao Wan <whi4ed0g@gmail.com>
Reviewed-by: Lyude Paul <lyude@redhat.com>
Signed-off-by: Lyude Paul <lyude@redhat.com>
Link: https://patch.msgid.link/20260814-nouveau-svm-svmm-uaf-v2-1-8e6590519f07@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/nouveau/nouveau_svm.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/gpu/drm/nouveau/nouveau_svm.c b/drivers/gpu/drm/nouveau/nouveau_svm.c
index f67700c028c75..a723c72049df0 100644
--- a/drivers/gpu/drm/nouveau/nouveau_svm.c
+++ b/drivers/gpu/drm/nouveau/nouveau_svm.c
@@ -302,6 +302,19 @@ nouveau_svmm_fini(struct nouveau_svmm **psvmm)
 {
 	struct nouveau_svmm *svmm = *psvmm;
 	if (svmm) {
+		struct nouveau_svm *svm = svmm->vmm->cli->drm->svm;
+
+		/* The fault handler caches svmm pointers under svm->mutex and
+		 * dereferences them after dropping it, across blocking faults.
+		 * The instance is already unlinked (nouveau_svmm_part), so drain
+		 * the handler before the free to release any in-flight reference.
+		 *
+		 * On device teardown nouveau_svm_fini() ran first and freed
+		 * drm->svm (NULL) after draining the buffer; nothing to flush.
+		 */
+		if (svm)
+			flush_work(&svm->buffer[0].notify.work);
+
 		mutex_lock(&svmm->mutex);
 		svmm->vmm = NULL;
 		mutex_unlock(&svmm->mutex);
-- 
2.53.0



