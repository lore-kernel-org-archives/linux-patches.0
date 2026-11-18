Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048967;
	b=Hzwt7sHh9FzREVLNOUZDs2j7Zj8fxUj4xtlvglCUGTlDRllcDRQX70Fis7DcN6Ad7CTQ
	 4XT/5KgEK0epTFbgfSxun8L1V1Q0zDSCKcDNSwbEw25KsbhqX4dQPm1PkdBCPY2ktZuRR
	 rn2eJCgOj4ckzP/0db3O3fW0bq9y8wv9RhdP1RnTAoftQVcqVkZchdoW8hflUFsBvwZoM
	 /US4ev3q/9ghVtYMuF8K+sZiXT0+GEMP1/0WIGPMJNenHhtLdLuU9DaFUwszKq8rKQ6h8
	 QFiSuVXuCGLPt0fqN6ubhpLuWgc7JB+Ck1RwlZ+9PAN/4d7HI1VprsK/VEIzQBC4wUA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048967;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=oCwS1ovUxuAZZ05erI8xHdfMLbS4tjnGtNwMnVzzNoY=;
	b=zUknxgCEoj/Ah/USbV7jb2HjAhq5WhB6Ta/GY+y55avM/Y/88MTGrOLBFSCD58mQxqnC
	 KJDRR0jvXQnzLx8BpY8ulkX5E5vuGM8AU1ReJEzhy8J1mccRiY2h1alOiE19YPxZwyTyW
	 xq9EBoeqnDTt5M5ODfjM3IpZ5jfEqxN0OpTxnPnlKQUJ/EDMPfAOl9jaumGHuf6qwdvk6
	 9HByahu4l4koElJnk8QVb0WsTq1RogB1/Q3Xrild8M7n8eK9WfkZOuJ/hHGT0yeygDFkY
	 A6zBUNJ4A2GUatquRYDT9X5K5NZGcpszEu/hCZj2Gh+6CBHXo3ReaeTpGr9RWHDJHjQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YHZPvJoc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 010E5606A325;
	Thu, 19 Nov 2026 00:42:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YHZPvJoc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 573F81F000C4;
	Thu, 19 Nov 2026 00:42:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048966;
	bh=oCwS1ovUxuAZZ05erI8xHdfMLbS4tjnGtNwMnVzzNoY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YHZPvJocLRB9u54PxR0xdGPQ5gsdrMiktKcpPs+nQ3XtOjSr7rvTxpkdqLzsiwow3
	 asdlDArpw9X03nYeNd8PKXyXGYoKwEAlJxZOXmRzd61TviAWPr8b4Cn1niPCC3loq1
	 583UuIHnIaqbezwzaxfzW5QYMdRKQN6pvHWxbrDc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Mikko Perttunen <mperttunen@nvidia.com>,
	Thierry Reding <treding@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2166/2857] drm/tegra: Fix syncobj_in wait return value check
Date: Wed, 18 Nov 2026 15:53:20 +0100
Message-ID: <20261118150319.391265869@linuxfoundation.org>
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
index 12af6560ba5cd..31b54bfb5c9cc 100644
--- a/drivers/gpu/drm/tegra/submit.c
+++ b/drivers/gpu/drm/tegra/submit.c
@@ -535,6 +535,7 @@ int tegra_drm_ioctl_channel_submit(struct drm_device *drm, void *data,
 
 	if (args->syncobj_in) {
 		struct dma_fence *fence;
+		long wait_err;
 
 		err = drm_syncobj_find_fence(file, args->syncobj_in, 0, 0, &fence);
 		if (err) {
@@ -542,10 +543,15 @@ int tegra_drm_ioctl_channel_submit(struct drm_device *drm, void *data,
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



