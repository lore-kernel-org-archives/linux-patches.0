Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591444;
	b=hOdzzbAiwhM2B/mcjMhyv1GdndZo40Bz0LUbgQ3hXj0erwHpnI0WLZfZdyYN6BgRsYRB
	 oKaKBrk7ZiO9COAYf6DL1EJ0jUttKG1tI12yqe7eUAihVeCkTX79opOQQu9Mk/Ob+d0BK
	 PNik6tqxCHfvo27LA9KjmKwOdbjVjVt75hG7b3qXTP1zmgxK2c01NMH4jV2Mw8X2Ak/Pd
	 yYFrjMoaWbHlIXHfcKxMHjlfXxgUiZem4S7RAY5nXnE2Do+IBZzGoAtwxVxR3DViN9+vZ
	 HyM1ykMZw1VhiSKbaF40GyAbFD9n3r06Vq0rD+t+qeGhItpoeLSohGE9+a1X2vi8TZQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591444;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qkA4Pn6u887i7qa6ihmU+N0B7XDmxAEoV7n6BX4S0k0=;
	b=ZxI0N02xvE94wGgRIi8e/CQzkG2xgnaRXVKU2NyjQz4SJDUYubcwM/97wjnun4m0qrvi
	 TdYE1kCxJGbyg9PbBlJ4MQz/Rp3OYNLXmLcUYh+aIoXC8b1rhUNVTYE3JAPvg7e8H76cC
	 QRZ0cyzqO2K0MpFzLp0k6GejMhqILrs5LFk1FUlU2e6s1/1nWhl3X/1GN/NScEBnZl3YU
	 b9N2iGCPruSw8wRYNJeFqdYKSIWhUZbeAWmBoxGCrLpio3Ku/sv0jLN0+oJPVnfqPafd9
	 zgjCgJlNrbkgxHJ5a+e1fnhCh85GRvBLLdjjv4rfI7r2G0L/kgEAc4afT7uuBmuzAqg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Pq2ffNpU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7276607C355;
	Fri, 13 Nov 2026 17:37:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Pq2ffNpU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 540251F000C4;
	Fri, 13 Nov 2026 17:37:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591444;
	bh=qkA4Pn6u887i7qa6ihmU+N0B7XDmxAEoV7n6BX4S0k0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Pq2ffNpUPaxbd9mvNro5iB61k/LgWC9OqLB3Q2WCEajdUKdBrIhaI+gHVnqlpOS/h
	 Te8/7I5M/oLfPYJTZ7UYgZeu8CZ3Lec1RlXyLZ/zBOss4ChCHgdkSHIVeygtVwuyjW
	 Oz6nli5O0pEnYL1HuCL5SkBknKxGQCfI/KyQX0bk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Rob Clark <rob.clark@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 517/670] drm/msm/dsi: Fix VM leak in dsi_tx_buf_alloc_6g()
Date: Fri, 13 Nov 2026 10:51:21 -0500
Message-ID: <20261113153829.457576767@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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

From: Wentao Liang <vulab@iscas.ac.cn>

[ Upstream commit ab91ba61871a896ca2ecc6e048d80a152136da44 ]

dsi_tx_buf_alloc_6g() takes a reference to the kms VM with
drm_gpuvm_get() and stores it in msm_host->vm.  If
msm_gem_kernel_new() fails, the function returns early without
dropping that reference.  Since msm_host->tx_gem_obj is cleared on
the error path, msm_dsi_tx_buf_free() will never see a non-NULL
tx_gem_obj and thus never calls drm_gpuvm_put(), leaking the VM
reference.

Drop the VM reference and clear msm_host->vm on the error path.

Fixes: 5e05be782645 ("drm/msm/dsi: free TX buffer in unbind")
Cc: stable@vger.kernel.org
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Reviewed-by: Rob Clark <rob.clark@oss.qualcomm.com>
Patchwork: https://patchwork.freedesktop.org/patch/754332/
Link: https://lore.kernel.org/r/20260916175738.2089950-1-vulab@iscas.ac.cn
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
[ sashal: Adapted GPU VM cleanup to use the older msm_gem_address_space_put() API and msm_host->aspace member. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/dsi/dsi_host.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/msm/dsi/dsi_host.c b/drivers/gpu/drm/msm/dsi/dsi_host.c
index cd605c75cef8e..ebd9dfca6459b 100644
--- a/drivers/gpu/drm/msm/dsi/dsi_host.c
+++ b/drivers/gpu/drm/msm/dsi/dsi_host.c
@@ -1205,6 +1205,8 @@ int dsi_tx_buf_alloc_6g(struct msm_dsi_host *msm_host, int size)
 
 	if (IS_ERR(data)) {
 		msm_host->tx_gem_obj = NULL;
+		msm_gem_address_space_put(msm_host->aspace);
+		msm_host->aspace = NULL;
 		return PTR_ERR(data);
 	}
 
-- 
2.53.0



