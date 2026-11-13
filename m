Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590194;
	b=Rbg0r9p+wPTJ4ZjWQcJFT3129MmF6+w2AEll8jSCQzwRbKSwe1It5H1WRHASOLWlrjhl
	 a5ptGbrr7DIgCnot+z4ewc817JMG73J8ey04vboaQHzlX1gbZBpH3lvY1naFfnfn+3ZOB
	 Tjt2jQulfxIPLHGwPZeWcBBTQxCmphtCSsZ7/Hq3Gq25SRIAa+qC4xQUbRU6wdgo07/aN
	 /6xhJQAMEu3KWebg/QUi2QBULT7qeYIwOIJIXt6p3+K+nRQpFFaBiFT+z6tTsA041fnX7
	 DQLVscjS4NE32hbIU11hanhabRWH018nB9zmqzAvNZz+okfhnxqFqd0JvzVjb1oQA+A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590194;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=S/jjRwobw0q8EX9y+WsUHVUE4V8c94IsliIzms6wjN8=;
	b=ydHWicSneCtPhdjbbF6gVDRyiL8Gj8Vk7MkCMWBLi5RN4b/TlYFNhyl1SRTCtUDkXgIM
	 2/6fz+PUbFERv9maOnDB8L7Qw6fHVkfDEDQJUnDie3YSJxiOYdKzZuNRR+VfpaDEDeXoQ
	 DfOL72KDf/DezBONL6IgzpzyZkotHvuDt4Pxtg3QPz1MhHHA6iIUOjat9CbTwt8ljtUkt
	 I5iZ5vPcKOC/vx+oL2AnGT6nS1fH/aT0R54mSJWPOdyEphkNiceRLWInPxemKflTj+H5l
	 Wrmn/xEX0Yq1vaCQAUll9lXz43PtdXXfPNDTgZQ3HcF/tNRD+0/OEH8Dw0BttFEVVAA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rE7O42vi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D778F6074B38;
	Fri, 13 Nov 2026 17:16:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rE7O42vi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84E841F000C8;
	Fri, 13 Nov 2026 17:16:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590194;
	bh=S/jjRwobw0q8EX9y+WsUHVUE4V8c94IsliIzms6wjN8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rE7O42viiPnSPA8T5GBjK8jkFf8x/KL7V9joOJ3xMeAOdBj0BbZupwpgBnz4eJBeb
	 /d+qyla8Cvfl97IKpZQ4XS8iSz2I0il6y0pryGIbg+r4aUS3g+b2fgrgMFBqH9O30j
	 EE/S+IKIRPv1SW6tcMFfMtpMA4Gz4PU/bvfsgBeU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Iago Toral Quiroga <itoral@igalia.com>,
	=?UTF-8?q?Ma=C3=ADra=20Canal?= <mcanal@igalia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 202/686] drm/vc4: Drop the BO reservations outside of job_lock
Date: Fri, 13 Nov 2026 10:45:35 -0500
Message-ID: <20261113153827.892125415@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maíra Canal <mcanal@igalia.com>

[ Upstream commit 8ef66514d7b993c9fb96a5886f001e3556610c1c ]

vc4_queue_submit() calls drm_exec_fini() with job_lock held and interrupts
disabled. Besides unlocking the reservations, drm_exec_fini() frees the
object array with kvfree(), which asks for preemptible task context or a
non-NMI interrupt, and may reach might_sleep() through vfree().

Considering that an array that exceeds a page can take the vmalloc
fallback, call drm_exec_fini() once job_lock is dropped. The reservations
are then held across the job kick, which is harmless as nothing in the
completion path takes a BO reservation.

Note that vc4_attach_fences() has to stay inside the critical section, as
it walks exec, which the job done worker is free to release as soon as
job_lock is dropped.

Cc: stable@vger.kernel.org
Fixes: 04630796c437 ("drm/vc4: Use DRM Execution Contexts")
Reviewed-by: Iago Toral Quiroga <itoral@igalia.com>
Link: https://patch.msgid.link/20261004-vc4-misc-fixes-v1-2-b763df9e33e1@igalia.com
Signed-off-by: Maíra Canal <mcanal@igalia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/vc4/vc4_gem.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/vc4/vc4_gem.c b/drivers/gpu/drm/vc4/vc4_gem.c
index 812636318cd9f..4fa6e71140a84 100644
--- a/drivers/gpu/drm/vc4/vc4_gem.c
+++ b/drivers/gpu/drm/vc4/vc4_gem.c
@@ -647,8 +647,6 @@ vc4_queue_submit(struct drm_device *dev, struct vc4_exec_info *exec,
 
 	vc4_attach_fences(exec);
 
-	drm_exec_fini(exec_ctx);
-
 	list_add_tail(&exec->head, &vc4->bin_job_list);
 
 	/* If no bin job was executing and if the render job (if any) has the
@@ -665,6 +663,8 @@ vc4_queue_submit(struct drm_device *dev, struct vc4_exec_info *exec,
 
 	spin_unlock_irqrestore(&vc4->job_lock, irqflags);
 
+	drm_exec_fini(exec_ctx);
+
 	if (out_sync) {
 		drm_syncobj_replace_fence(out_sync, &fence->base);
 		dma_fence_put(&fence->base);
-- 
2.53.0



