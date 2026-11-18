Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795030683;
	b=yxIiKNU0W6oxFqbz1BZ5KoRgllNIj8PhPvqGf/63lFQwZYVGQ7zIR2yLmaFAjgdm9py6
	 0aZBLrmq5FdrwrnsHt7P+9FeQXuX4VgaMGykergEeF1/H50s1whm2W1/3IKYTotwu0SoM
	 FXFl5FPbUt3tFZPLUqU7kGa4bt/2QLSaSEkB1tRHdJqkKiHzYic3sYcw+fHVk913wjzrM
	 Ew/l5zPXF0ybVAgdJnS/TTuhWTRD6KvhNww5V5DNPbmy81idlKAr7uv62Wl1FDejxO3sp
	 y4Stkraj89DPXjQ9/aid6t4lycQJ6wU8wk8HswO1yXsq/a4NygmCnEuKe9PmLAv9xPA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795030683;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=5DhxFE3vm+9AoKk6NgSbYOmHRwXgDtmPy+wjiaFZovs=;
	b=yGDVpjNyI6NzePzhAY63nCAh8pe2szS4QwtvJXQyqrT+HwWxQFbFRBCfarKH12Kr2c9I
	 ZQ9xY8W+EODaZ9jow5lkc20+ElZdyGOGl9XsMR+PprtmhenMS4qAFTWFVnBeBu/cCjXSH
	 DpGSJnMIuS2sL9ngJku5y5+LGueJb9FZyFMNaNnnGb6OyZcVjqV+PbjIJMv3dvMW3m4Ya
	 Q2ypwbsv93pd4ZcuuBv7EnAcRFD+CEUWtvd7iKJsTrkuwobrDZaCAkRhFgJ4j3ZYVm81b
	 RTpASioDDZ2E+mHnPz5Y1ccBTdvz/fK9S7m2Q5pVnp3CjU9wSum7f6Q39Vd+Mmcb0ag==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lhkz9NXI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1452E606A7C6;
	Wed, 18 Nov 2026 19:38:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lhkz9NXI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 632C81F000C4;
	Wed, 18 Nov 2026 19:38:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795030682;
	bh=5DhxFE3vm+9AoKk6NgSbYOmHRwXgDtmPy+wjiaFZovs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lhkz9NXIXiEcGivWNRQoHvmw4tyZoJ7Rfntok/08g/7520wi9R86NRSw4T2lWBifO
	 HJnztrjhzE7Z+PfRQKqPGjWwqx/O9SfRNZkvHxifExPrx0HDu80Ay9al4LBwTcp/eu
	 5ZGpVY0/5iPuNodta3aOq8xn80fIOj1RSNOO/EWo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Mikko Perttunen <mperttunen@nvidia.com>,
	Thierry Reding <treding@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0749/1756] drm/tegra: Fix syncobj_in wait return value check
Date: Wed, 18 Nov 2026 15:47:56 +0100
Message-ID: <20261118150039.389368457@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

From: Mikko Perttunen <mperttunen@nvidia.com>

[ Upstream commit 27836c46a3db5a7869a9f7e181136f0c4d8bc0d1 ]

dma_fence_wait_timeout() returns the remaining timeout in jiffies on
success, zero on timeout, and a negative error code if interrupted. The
return value was assigned to 'err' and checked as if it were an errno,
the opposite of the correct logic.

Fix the code to use a properly typed variable and check each condition
correctly.

Fixes: 13abe0bb15ce ("drm/tegra: Implement job submission part of new UAPI")
Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Closes: https://lore.kernel.org/all/aJM_te551jUwnRv7@stanley.mountain/
Signed-off-by: Mikko Perttunen <mperttunen@nvidia.com>
Signed-off-by: Thierry Reding <treding@nvidia.com>
Link: https://patch.msgid.link/20260730-b4-host1x-syncobj-wait-v1-1-afa730410392@nvidia.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/tegra/submit.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/tegra/submit.c b/drivers/gpu/drm/tegra/submit.c
index 705382035f5f6..f35e5c3ff37cd 100644
--- a/drivers/gpu/drm/tegra/submit.c
+++ b/drivers/gpu/drm/tegra/submit.c
@@ -530,6 +530,7 @@ int tegra_drm_ioctl_channel_submit(struct drm_device *drm, void *data,
 
 	if (args->syncobj_in) {
 		struct dma_fence *fence;
+		long wait_err;
 
 		err = drm_syncobj_find_fence(file, args->syncobj_in, 0, 0, &fence);
 		if (err) {
@@ -537,10 +538,15 @@ int tegra_drm_ioctl_channel_submit(struct drm_device *drm, void *data,
 			goto unlock;
 		}
 
-		err = dma_fence_wait_timeout(fence, true, msecs_to_jiffies(10000));
+		wait_err = dma_fence_wait_timeout(fence, true, msecs_to_jiffies(10000));
 		dma_fence_put(fence);
-		if (err) {
+		if (wait_err == 0) {
 			SUBMIT_ERR(context, "wait for syncobj_in timed out");
+			err = -ETIMEDOUT;
+			goto unlock;
+		} else if (wait_err < 0) {
+			/* In practice, -ERESTARTSYS */
+			err = wait_err;
 			goto unlock;
 		}
 	}
-- 
2.53.0



