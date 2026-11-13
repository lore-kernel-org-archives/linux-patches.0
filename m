Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585398;
	b=hGVim/UhACAP7rndcVWuCU0aBRyDxtdGJM9I1T4gxxUhOgoEKE75PEkgxa8/PV7wLLBK
	 WXrQYi8LKexcChgWbR0BT+FrOSBh7CLIPhEjtfjEtU25l8iXZkGeFTYElXGJt4PG6zhl3
	 k1NNH/Ou7kZ9XDCfAgR50piyyIciAK5cWpY8Ie4YRrWBfgym6kfIQHIY08PzRpW4xfmmd
	 XxOq4n4p6clUOUmJvSWYorGi+U+eCyDd5U5PV2xNUZB5iL4p+eTRa2+LHJZBwOx4f2ESF
	 sAyvjfOrnFPansSgMYMnR0dAtSCpMlMA99iSqdAN3J8N9lSI9c+EfDLhNkCK3jDNEUQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585398;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=vqV3XO0rZP8OgbTZzGaMPw2SSZwF2G79zNr+p1TSZPw=;
	b=dSHvzxtNws0WWgHFea6ia6uaeuRkLMDKM7DZDWcw+dlJmb1j657gEIYdErKKz/136QeZ
	 yZg3JNxJbPBcl4cdDP2HXjtfxDj5mURcNG/6ohbTx/VJY63OfmUVRFC2cPT4eMcKdrK1b
	 KjZNXL3asq/vGOeC3XYe+WL4SPQ+kookmhLHi121Q1/qJtmFQTuxrlJsocIKWuBsvU61R
	 Fg5PGD+guYRzHfe/ONSrcFc23VjMwHnALFtHHdsJKwoBweA73LIwU/A2qkqMP550IkYNN
	 /PuzEeZva2WWqj1PqSi8iL7GmF4JD3uOt4TtGbJuTHqwGHXz2L8o3BxKA8X0bc/N98g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=u1mWRgWe;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0C2C606A882;
	Fri, 13 Nov 2026 15:56:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=u1mWRgWe
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D5711F000C6;
	Fri, 13 Nov 2026 15:56:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585398;
	bh=vqV3XO0rZP8OgbTZzGaMPw2SSZwF2G79zNr+p1TSZPw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=u1mWRgWehwp50zUJFHDbWyvnSm8NKhcYGYPzOINGPiPakauHQp+qGsl86hweFwTI8
	 uDxw/rq7/mhPnOaTaEeVsT9GITRGr4gjaJ2DgHkXb+tZjXJ8T7Kmu5QIXe1Mh76IZr
	 SlrJ5p7uwKL3kG/AtFwRqn4exkEn7byOdbR9oe74=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Iago Toral Quiroga <itoral@igalia.com>,
	=?UTF-8?q?Ma=C3=ADra=20Canal?= <mcanal@igalia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 069/507] drm/vc4: Drop the BO reservations outside of job_lock
Date: Fri, 13 Nov 2026 10:46:13 -0500
Message-ID: <20261113153755.901447284@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index f4be154d4eb0c..0fef9b48d3c68 100644
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



