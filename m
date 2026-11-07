Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062696;
	b=nu8qoh8T4qJM68iCDt0fTLBYGFkd5E7IX7oi9au+6j0xHfaxuS+5+ghIc8uQffL9nSOK
	 vDlwwoZtTmjC80P4MNYqdhkLel+WziiI+7UdKqVImAtoA1Bwjv8Ng05bP3zsJqQnie9Mi
	 yreBbhn8YxldttXMsl/qe9sV33hXquIn+1zCc5lsujdoOUdRzQFaMxNrQpyUogdoUO2ij
	 dU4p7AndQ293Jrit9PwXFqOb62GzACr0JGw7aOIL9IvFb6dTFSw5WBGEhaYn0gd4FQoBD
	 JHHPmQIdnWqVt62A+pTv5rpVr/Y2wJmMIylIBUrYOzeYyZuL+k8EQGk2pagW50CPAQA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062696;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Y1HZgnp1Xx4KkPLzX7faBcRSe0edba7YszpxoM4Nyzo=;
	b=Czh0oxXKd7gha/hNkcs4vYkZs8gOmuKvWIiEXw8JfmF+KVY/7EJQIYZhNZ0V5XiV+vNX
	 o+PRT+RWTwoApuYZM7urIsSKmpqCRkXJ5dSwOkyZbfntw3jhjsfYmuieCdt2mWgkt/FcO
	 vis7oN/lSuVnmM0zBp0YrdutniovZ6+2atxQc2XDVkYVBnD8HpF1PCpHTyFQ/P/Cg5dvz
	 2S9/JL9atIjSYKqHCg3F7sdYPwUj8igTl71g6KPY0e21oeTSZs0z+y6vb4nSLmITKYy/C
	 IGLSCMMyedCX8Tg+UJBLn6FURWkddT7YJZdN9h0kRihgUDqYWPGn6JStMdkl6oCPSqg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fDrCQZhj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 042E9606A32C;
	Sat,  7 Nov 2026 14:44:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fDrCQZhj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5C601F0089F;
	Sat,  7 Nov 2026 14:44:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062695;
	bh=Y1HZgnp1Xx4KkPLzX7faBcRSe0edba7YszpxoM4Nyzo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fDrCQZhjKazgQd3eJTGTSrytHaBZxWl4vXaKzWKeA5gdN24ZrvrCuKIXbeglrPCwP
	 ezACYTZ2SuioSpuTlNFQHw61wg7DhPhmafyPqm2xKeXDhsiLig5gtM5JCV3NBiCa09
	 /uOgA5sawd6DNPBpBPeevZ6XHZPxsRc98iTPxkfc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuhao Jiang <danisjiang@gmail.com>,
	Zhenhao Wan <whi4ed0g@gmail.com>,
	Lyude Paul <lyude@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 022/869] drm/nouveau/svm: drain fault handler before freeing svmm
Date: Sat,  7 Nov 2026 08:45:04 -0500
Message-ID: <20261107134852.820140450@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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
index 6fa387da06371..dc6c79f57a56d 100644
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



