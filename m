Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795046636;
	b=ufObfH/jcAn+YLUY+p7Rh1ixTqdNZQ3HfQ1kfGRscG3DFhrfTrLbAP2vSL5iHrekDOMH
	 hRYn0N2N51WVAoyKY4sTXUaC5LPK+/9jvCBRH/L91GVri7Fs64K25G+3qWHYA+svcWvYn
	 XBmYC671slhT4akE2aQtLG1oWBIjuAwxXdS1PSb04pxLq++W3YTqudatLvsDuPvaoaF/v
	 wnsQyj8xWLwgZ9B2lWHfo9NgC2qv0M54aYNWQFDkl2tnM3Fale78ZSB8B3g3P5yA0HcTP
	 sGGTahmTrpDSwMv6WlN/BUhJl7mK2cQJNbzGXQwGB9K8vXw5NyOxwEIU+kZv8NnDscA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795046636;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2H/zG4A38PxsvNfSy5FTF/CJdyEaM+mfHYG9rgmJ6Ww=;
	b=r4ZUMqKACGhHhgZB9jPgeQfm6Y5ma/jLpUlWPWdPmFCsN1NUuVUQBw5TrlnAZhzBvakG
	 6iNnF4atjHy4oZU+OG2e+lIubu7uFRA79Lt1Qa2Brq1Jp1/RnlGRcplj2QD11+oDLaqq/
	 lye/97n8Hz6vI+SJCV+glECnN41LIjYo2Ixr2RlC0W7OsQA8aHhvlrZNr2slTQWT/5xAr
	 RRAnUlSqIvKl+EEAyTFsx2bKWfBMHX9vV+hRkiYSYyl3a6hoffp2EHOUj+QZGtSwTvqI8
	 jpAZIWrp7TS6kLyJt/uFHPqqCOnsDb+xma+pLK/fO9Tu6X951TFAEsYWNyT0pLTByGA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lLRcsowG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4A3B606A320;
	Thu, 19 Nov 2026 00:03:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lLRcsowG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16B131F000C4;
	Thu, 19 Nov 2026 00:03:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795046636;
	bh=2H/zG4A38PxsvNfSy5FTF/CJdyEaM+mfHYG9rgmJ6Ww=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lLRcsowGJf5+RfTvo+SNfOAtIDVDtvtMCDR4AztamtiByNa8pOdV12RHC7arYmUSB
	 iUumIHC+9NKh/NjB9e4SNKMHeeiukE7Vh2uNrOJBwbA5CieFk+tboKzOEy+GZoH9iP
	 bGd+CXl4eoHaBP7o6wv/atKQ0JVzMwQkR1RyTSGs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuhao Jiang <danisjiang@gmail.com>,
	Zhenhao Wan <whi4ed0g@gmail.com>,
	Lyude Paul <lyude@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1335/2857] drm/nouveau/svm: drain fault handler before freeing svmm
Date: Wed, 18 Nov 2026 15:39:29 +0100
Message-ID: <20261118150249.499910926@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index d0bff13ac758d..75218519c29e0 100644
--- a/drivers/gpu/drm/nouveau/nouveau_svm.c
+++ b/drivers/gpu/drm/nouveau/nouveau_svm.c
@@ -306,6 +306,19 @@ nouveau_svmm_fini(struct nouveau_svmm **psvmm)
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



