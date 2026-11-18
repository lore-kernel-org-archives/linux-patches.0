Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795035810;
	b=bt8amVIaDgSytjdgcBcUzyp+o14FJm+ahsByntdM8+oqqwFAUSugUNr5yQhxBBdYYwOV
	 Tc1yJ9pUAD2F6wPSg29+tcJbw8MI5wxFK+6HKv+dpnZD90GpgvzDaqsMcPhES/JZhxtTI
	 Y1xHZeAVdgzSnTaw1yihggptEubeR4Tbk6PuEmys2SOhTJB938WudaAVa5w6+hHAOLukc
	 hAgXD7Hn0o0me8HaAlqJ9aISc80gZVe9SweyCaPAfKJkLPR8HIA5wNE1/4VDBm9QJ6jmF
	 qz4nGmfm9M9lOiwX0HlWWjIxOvuHu4Z0wzFa8I9bZ2x9gi71u3D7psUFbX+gkwf+a3Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795035810;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=5z2iS+4XlTE1B758vN6tIUozEPZJs3IAlk1zTmi2yJ8=;
	b=ss4/qPfGtPL8qi18EcG1K/qml6jsGVwP1RxnEnDOl1puV41/TaZqoutWzJjm0RwtM4Ya
	 zzjmnF+Sa2YTltjzymuvw4gF31EDhvoeIvOyVjPsQ9AlNRizq38rRKX/zKWggmCH+Qusg
	 ZxRAXs5yM+IpmG+3loVqe0UeFPAdwGGkFnogUxfzRRQs1TJ2EQCRnwWUMcHlkzJjDybLE
	 10pUONqO1GvE+8qQVdWxBmlaQ+xjS4P13yNtPPTnkGWB+yDuiId8jdUGnHhFv5+eFp+kK
	 EH3tUEKk2grNZPEkgf/5eWPffwJWyeFVQg3UimkOb3qNYY/YVxxHEX4KSobheNC46bw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fSuB5pv+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1D5D606A325;
	Wed, 18 Nov 2026 21:03:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fSuB5pv+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F0221F000C4;
	Wed, 18 Nov 2026 21:03:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795035809;
	bh=5z2iS+4XlTE1B758vN6tIUozEPZJs3IAlk1zTmi2yJ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fSuB5pv+qQMGjlTo2AZEwstWEEYOZ9iKHKui9Mxc3+MrsWHLgP2izoFOddjnvv5KI
	 SxYRV6P+lx/dX46xhC1cIsXmH3PVcHcv4Ac9nzDHoMazSqORSW8X0qMYaMIVQ5vGwX
	 Wg2o2dInkKyMn0jwgpLEANywlQ2pEMw5d4+n75iw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuhao Jiang <danisjiang@gmail.com>,
	Zhenhao Wan <whi4ed0g@gmail.com>,
	Lyude Paul <lyude@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0793/3318] drm/nouveau/svm: drain fault handler before freeing svmm
Date: Wed, 18 Nov 2026 15:23:35 +0100
Message-ID: <20261118150342.682869247@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 6c71f6738ca51..d90370113ba10 100644
--- a/drivers/gpu/drm/nouveau/nouveau_svm.c
+++ b/drivers/gpu/drm/nouveau/nouveau_svm.c
@@ -307,6 +307,19 @@ nouveau_svmm_fini(struct nouveau_svmm **psvmm)
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
+			flush_work(&svm->buffer[0].work);
+
 		mutex_lock(&svmm->mutex);
 		svmm->vmm = NULL;
 		mutex_unlock(&svmm->mutex);
-- 
2.53.0



