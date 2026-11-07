Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061873;
	b=1k4ZuNyZ1dIm0cBD9j0YGRnmD5eM76rYCGCvAoQaVw/vLiesUXODARm3zICLdkG/EBEg
	 zdqpOz4qhwhg+/KOMT/1QbszlAQjeiCTfebVV7IGNqEpX9VajXYkabi+bQD6OB88HXtlm
	 AwRUiXYOEjV7R1B54zh8zdEKmD4Q/vScqXqv5ReMwperw683LfHmbyhxN1XOf7WMJeGUT
	 gM60WKip4W0WO96mmMKgiocFiZZwCIPGvu0oNIRe8H+6ZcSnGybPaUFejO5yiwfvObWVr
	 DeJSd4FRGCNskJ0BsRKrSdGnIwY7+857L2+izEcMpMDyG5QFPZpHgwMel+kFcRu3JAg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061873;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=o3TDiQ1fntGFgtZeFoAnf75bzKvFZCydbsFgdTjeV6U=;
	b=I5/g7JQVtj0eAqiiw+dtFwEwCv/50+m5PX2OvSILrc1Bjp3O1nVj/V6iRzPnlw+GqZ60
	 NM8SfhH6aTG87G94L6RSR2aMXgrc25WYK+v/+mX7H1hL8SHkiaM8UFC/SCpFqP87Ihrqn
	 3GXAHjErTa9oZtWe4o7bqjDQiGIkw5TOV0XmV4/E9iMDnQ421zbGKS5awZC8OEqjkUMwi
	 Qjc5HwXYq8VwO1IKnwXCqmifqlWyRt5YjuyiKze652UEgtZfZVnDncdBHLBMmCI3LcB6b
	 2JBFdzmAwTFiKNMcj0OgGIHfQSRagCDiWNuDbMbd4DW1yKzeZ31MeiVSLsUWyaRRJ4Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rNU1NeKv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C7F0606A32D;
	Sat,  7 Nov 2026 14:31:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rNU1NeKv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 836291F0089F;
	Sat,  7 Nov 2026 14:31:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061872;
	bh=o3TDiQ1fntGFgtZeFoAnf75bzKvFZCydbsFgdTjeV6U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rNU1NeKvKWCZvQPKMs8jTx3B9zdGI68PuKUQfAR+AuUNj1vO60bUvQcadCFBovYbt
	 9iEDYmxoL8awahIc5VOFMLqX4l05l36jgs0K3qfTtVpEDmFphZJepbu4L0nG8BS8hw
	 6M6O5p9gt0SJzb4AWgUCPHFjQ0xjj5gNv2c6uxsI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuhao Jiang <danisjiang@gmail.com>,
	Zhenhao Wan <whi4ed0g@gmail.com>,
	Lyude Paul <lyude@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0887/1536] drm/nouveau/svm: drain fault handler before freeing svmm
Date: Sat,  7 Nov 2026 08:48:23 -0500
Message-ID: <20261107135022.536603652@linuxfoundation.org>
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
index 8ea98f06d39af..18ec4db06b962 100644
--- a/drivers/gpu/drm/nouveau/nouveau_svm.c
+++ b/drivers/gpu/drm/nouveau/nouveau_svm.c
@@ -304,6 +304,19 @@ nouveau_svmm_fini(struct nouveau_svmm **psvmm)
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



