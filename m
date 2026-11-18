Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055628;
	b=xH8Ydt0wxfem8FxZyqliBfIarf9UTZFythxBU3aHI2MWlncyAlL6PcDwyDlyjmAgqQWR
	 i28f6KGrbReeC+WreZHsnwwzE5zfPiatqdrcwcRvyqkw/slcak7VdznDNduTH5AsGdKHP
	 Rea/2XiDQbNSxXVo+YrX7fhlx0G9ry8abVtHAVpjvP4ojJ8xT5QpOBFzx5F1wTVUCBYdE
	 Kfa/KhAt0nTvjmZFkJfkyN/duAny5Dxfq0swVMEoe0X0zokAZG0ZOmkB5OBKtgLxkJPyB
	 fPvgKmQCjFH/dIxbMY5Oxh0J0rpJwVKuSxnC6q9Qg6OAvj6uP1NVSRRpNXl0Cw/cmuw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055628;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6+Ew7RcTWbVbBPhORmg+tHZ/5L8xHwxt/ym4vbDJMf4=;
	b=T+zWJsMt1nhJhXUEmFdtUX4B3Z8ji4AVXn0vy56TUroNbseDAKvXOGrU5G6TUYbVtfdI
	 ySJHz5yIKBUe/280Vu+FIh6t0Yes8fl73SSsY899W7j/hd0kCGXO/np8TAtO1fjw68Zbi
	 758Z4AR0/HgQklRoK/huwq+qL31/uNbODc02IL4SS1NBEuKj+HW5AzsrmsKdUJsBcNUdE
	 Yc1QZoS+xTlerPS48uTvT2T+6YrSL6cxOsWR7B/7Q6ZsJy5LmCVgvdwOwlvX7iRwCIujK
	 UBr40lyNwxD3mZN+JkdNkvMzKTNo8eM5NlpfVsEhHHd3AnBizCCYrkdt1I2s7O2wZ1g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MsCdXnvQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B44B606A339;
	Thu, 19 Nov 2026 02:33:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MsCdXnvQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C3321F000C4;
	Thu, 19 Nov 2026 02:33:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795055628;
	bh=6+Ew7RcTWbVbBPhORmg+tHZ/5L8xHwxt/ym4vbDJMf4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MsCdXnvQo8oh/D5EwCwUb4w0BIxrFQxNyNY9RuUwJFZN8n3bNY4P4Vbpf110wHmTk
	 B0uxOv/Fzpg9ieHvexvPvi62x+UvevGObmkpCZGYeIVC2a6Hex92+3sOuS4ifvUJQu
	 AouzDNN00uG9uSmBB3ZeAPQ6cedd59VIYW+8CtN4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Mikko Perttunen <mperttunen@nvidia.com>,
	Thierry Reding <treding@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1699/2214] drm/tegra: Fix syncobj_in wait return value check
Date: Wed, 18 Nov 2026 15:56:15 +0100
Message-ID: <20261118150119.765875983@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index aba9d0c9d9031..45f0baeefd555 100644
--- a/drivers/gpu/drm/tegra/submit.c
+++ b/drivers/gpu/drm/tegra/submit.c
@@ -506,6 +506,7 @@ int tegra_drm_ioctl_channel_submit(struct drm_device *drm, void *data,
 
 	if (args->syncobj_in) {
 		struct dma_fence *fence;
+		long wait_err;
 
 		err = drm_syncobj_find_fence(file, args->syncobj_in, 0, 0, &fence);
 		if (err) {
@@ -513,10 +514,15 @@ int tegra_drm_ioctl_channel_submit(struct drm_device *drm, void *data,
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



