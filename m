Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063835;
	b=RING6ZXqIeYr+JtI+sxsjuHNjDgjNPxV+h7IKYDPEi7T4f1uYHqOyeSw2V++6FQRZ6AH
	 buwfy7PBlll40Y8vJQpv7JVMqhgcCY+n1kelTIkK+71uEFTwErCwo5HTqfGMEn7QnfELg
	 yoIhMiC25OIRuLqbTKflOmOf55m9H3WkB4lW5gsrwAuzGiGkfMkPARcyYM3GAsZjkXnqt
	 q2YaQQos4wXEtx8D+O9J+lresnVabe/7z6p4+vkKIYbvenpn7lorbpJ7oG71WoXp9fbhN
	 yGdZu35RDodfUTccozMJT8faoHJC5aJ0k/Y7/+Lq49h1uS71C9K/7ilnQAuULewETyQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063835;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=mIymRQQrVhP5+h0xKQiZN3WR9JSJ4Mx7cx53EDglWNI=;
	b=J3qc1keYyup4inNY8BzdERAVVQf1s5jTI9BGj1mMbZBFQfXv7YxwIlVOFJz4WiwueoaE
	 ttM87Q51Suogv1POrBQ3KshLnw2Vu22w6raNj3KfN7L5o+vq+visDRPPFNq8YV75Hoep7
	 lLjy1FBCl/h6C/9syHCpxiXHbvgzEh7cOjo645vkAWm0Gua9XviWN1ey8ngl/IQTY2e0k
	 Y9exVipnIZtXIJDxYUglyTokUDIMYuPbg7pig5ZHZ9XrCHGrPl8rKqlcBMOn1T5tfV+pG
	 dKSMa3Z1PZz6rXPSk/itQmGkArl/Lga9qfdYMny4FRx7MW+g3Xp3UReEcI1rf8iSfTg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uaURU96+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80F1D60A5BD5;
	Sat,  7 Nov 2026 15:03:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uaURU96+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 259BC1F008A1;
	Sat,  7 Nov 2026 15:03:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063835;
	bh=mIymRQQrVhP5+h0xKQiZN3WR9JSJ4Mx7cx53EDglWNI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uaURU96+FowMth3eAOs+neqOj4fn998pjLCXkpNw7+atnrFlpcS40DD3mRcx6Spk/
	 Ysr/hy2qOVYptjzKZzeuzdXDUr8Y1T23OUPnMbXTf42Hy9yMIzi9XS5iP5p4HVQmEe
	 qUvFFjIzYvQ1mQ4NqEsXe1/Wv1omYctdPAZoUvHo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuhao Jiang <danisjiang@gmail.com>,
	Zhenhao Wan <whi4ed0g@gmail.com>,
	Lyude Paul <lyude@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0015/1257] drm/nouveau/svm: drain fault handler before freeing svmm
Date: Sat,  7 Nov 2026 08:38:31 -0500
Message-ID: <20261107134939.845341000@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 58735446d7832..c519c28164fa0 100644
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



