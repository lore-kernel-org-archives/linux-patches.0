Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793217317;
	b=T8vgFlLh5HRmeki74U66Ook5TcAdncLWhEOSxYFwevjMtaOLqM56XJdi4PzThkciRvcM
	 vwkYXT6ttSzsevHAnb7cPmmHE6tgX4R7A3niMYCa5GLnZa1xISZqhLLKIXIaBBi4L9cAi
	 f7SMDWiEhtJr8L/jCtukp68bLH0AzkVf0FqSgzfb7+gKY5lFkXzIq8VJnQliTdELsDN6+
	 /hS+oOQX4eG2qRkiSLkcwU1fFH2W/+pAu6OtCU2arx2Xisv+fYB2+kffzjDSbuD169SMd
	 x/WxlyHmn5TTsC1e/lzusFYC1jmcU9npfQKXylbPh5rRUfJFn6qbHon+QMjycqogqEw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793217317;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=TqmjzdpnLsVcsiMNBVWdP8CCrnjM3Ib7yIinsdqzdrc=;
	b=jvBcuHP2+MpSaPKaViPZ1KlVsuDiSj9cKeyutNgPdUN+frPq+lfmCafTSrYZTQwxsvuy
	 QRw72uRykaiBYgSFLnGpYkOhAagHjdlORFC5dRWu9OqCuKvtg8AxjQFAttHINl41cTQ1W
	 XK/NpWR/nZCXe0+LSLWsMPsjwU2C9JQB+b+jjYz8dWRzYm3jQQlNH2ou84HfYLlWUiKKX
	 ySpZZ3x/uVDpJBqEwOBAw5fU7iYTJIhlUka/CCXoS9RoKTe1JEkZ/7FKWOOwRPHyJo9qw
	 DOkHHcXe7/D9fRfrPw5//rBjKBgYa51ac1vG4cDSuaM15rLKAZmZIOGAOSKupIq9xOQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Np45PXBG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CFE6606A31D;
	Wed, 28 Oct 2026 19:55:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Np45PXBG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D2521F01825;
	Wed, 28 Oct 2026 19:55:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793217317;
	bh=TqmjzdpnLsVcsiMNBVWdP8CCrnjM3Ib7yIinsdqzdrc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Np45PXBGechYHX7m9028KFe7qQGrwY43V2VgZA9l7K/Tf+Pa0CL5+cQ4ONYAAkw4q
	 DdjPMNnEFCEs9CBGinkpGX+UUlWkyQEZ4nMsY1l54YMVmpm33XWUjNOsEZfXmL/dZ4
	 1Xybl6g9ztmWb8icjUSenBbr7iB4QgOcljnsGUvk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Prike Liang <Prike.Liang@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1861/1887] drm/amdgpu: fix the idr allocation flags
Date: Wed, 28 Oct 2026 18:05:57 +0100
Message-ID: <20261028170541.801363373@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Prike Liang <Prike.Liang@amd.com>

[ Upstream commit ea56aa2625708eaf96f310032391ff37746310ef ]

Fix the IDR allocation flags by using atomic GFP
flags in non‑sleepable contexts to avoid the __might_sleep()
complaint.

  268.290239] [drm] Initialized amdgpu 3.64.0 for 0000:03:00.0 on minor 0
[  268.294900] BUG: sleeping function called from invalid context at ./include/linux/sched/mm.h:323
[  268.295355] in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 1744, name: modprobe
[  268.295705] preempt_count: 1, expected: 0
[  268.295886] RCU nest depth: 0, expected: 0
[  268.296072] 2 locks held by modprobe/1744:
[  268.296077]  #0: ffff8c3a44abd1b8 (&dev->mutex){....}-{4:4}, at: __driver_attach+0xe4/0x210
[  268.296100]  #1: ffffffffc1a6ea78 (amdgpu_pasid_idr_lock){+.+.}-{3:3}, at: amdgpu_pasid_alloc+0x26/0xe0 [amdgpu]
[  268.296494] CPU: 12 UID: 0 PID: 1744 Comm: modprobe Tainted: G     U     OE       6.19.0-custom #16 PREEMPT(voluntary)
[  268.296498] Tainted: [U]=USER, [O]=OOT_MODULE, [E]=UNSIGNED_MODULE
[  268.296499] Hardware name: AMD Majolica-RN/Majolica-RN, BIOS RMJ1009A 06/13/2021
[  268.296501] Call Trace:

Fixes: 8f1de51f49be ("drm/amdgpu: prevent immediate PASID reuse case")
Signed-off-by: Prike Liang <Prike.Liang@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Stable-dep-of: 3c863ff920b4 ("drm/amdgpu: replace PASID IDR with XArray")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_ids.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_ids.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_ids.c
index 5b248c4df12d5..e526a2824d1ff 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ids.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ids.c
@@ -68,8 +68,11 @@ int amdgpu_pasid_alloc(unsigned int bits)
 		return -EINVAL;
 
 	spin_lock(&amdgpu_pasid_idr_lock);
+	/* TODO: Need to replace the idr with an xarry, and then
+	 * handle the internal locking with ATOMIC safe paths.
+	 */
 	pasid = idr_alloc_cyclic(&amdgpu_pasid_idr, NULL, 1,
-				 1U << bits, GFP_KERNEL);
+				 1U << bits, GFP_ATOMIC);
 	spin_unlock(&amdgpu_pasid_idr_lock);
 
 	if (pasid >= 0)
-- 
2.53.0



