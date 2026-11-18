Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022895;
	b=xr+DHnbESZEKMI+2zLEyPtLhHAUFMlX+s8Ev8VPW8mF1oLfU/NqaTxBs7tHZXwiAwSIT
	 dQOrsg2gIF+JA0iLX4e5PdyBN+TbG8uDVXwpuQ7GSnxSEaezqJhMn6y0rX2dymr3rwrpY
	 7KRnzTkR5GRkcEVcJ+B1QMVWYepZo4iBA6q0jiWFvhi6BnXlL5PrT5juAoUcpLkj4wWII
	 FWzpZIx3y+YmlzBnIp2mA5xrzTUFNbFSq5NhGDrJJ+ceKgnuN0hliACHsPSgl1sKaEgCK
	 Zvmrk4x/AFJdYzeuKYn4dJ2xgfBUD8AI+EjB9S0cWwFx0wXFMyXDqrMCIK0ip2MCTsw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022895;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=s484Ko2FX8WDpYqTRyZB1mDlu/5eJqQnN3c1TvOWDME=;
	b=f8GmiOviJ9NCXOrpgE0g9lZXfjfnypVdfwNAUUEy86b/z4N49WTJgq55atmVcquuptgV
	 7IQuu9LlHsLfuAt7IKOeHrCv04nlQUH4bhJlATNQDuZOG2rcl01dsjdmQvd13Zjpo2Ad1
	 xGSLA+HIrWBZeVng9w0D2muysCFIQgO2rNfIMlgZwmJafAvH+lvjiBREhgOtY00xA1AN0
	 ctgjZAL064hrGX/DYRmDE9rmXpQR+TwNG87gI6i+WelaJlF0VBe3jf9DPO4JSe304gh5g
	 hDWqiPB9ITaJPgiUmOICDTkPzW0P3vKFm5rfaD1hHdZ0EFW+L8I1j+YmUGLJwYVoSTA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aSnuSkHt;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A89E3606A32A;
	Wed, 18 Nov 2026 17:28:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aSnuSkHt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A28F1F000C5;
	Wed, 18 Nov 2026 17:28:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795022895;
	bh=s484Ko2FX8WDpYqTRyZB1mDlu/5eJqQnN3c1TvOWDME=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aSnuSkHtfT2HNF/5beDY4XyopID+jlxskLHIwVV5CfjeITwpODgX3tUhtpj1wmfxv
	 +gl7JImXxn2NrXwYPjGkbMXPjdP7Ad8LJmgsjJCwVGAQ0s9qTyL2I00TwpvHCTNwyI
	 44ZAx1MCYpoJolYbRwRCK8QxpjwZh3LdUCgVYGV0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Boris Brezillon <boris.brezillon@collabora.com>,
	Nicolas Frattaroli <nicolas.frattaroli@collabora.com>,
	Liviu Dudau <liviu.dudau@arm.com>,
	Steven Price <steven.price@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0139/2151] drm/panthor: Take reqs_lock in soft_reset for clearing pending_reqs
Date: Wed, 18 Nov 2026 15:31:14 +0100
Message-ID: <20261118150126.847686273@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

From: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>

[ Upstream commit 2d354adc5bbabe2e818be09bbe13f6bfde4a30c7 ]

panthor_gpu_soft_reset() sets pending_reqs to 0 without taking the
requisite reqs_lock.

Fix this by taking the lock for the duration of the modification.

Fixes: 5cd894e258c4 ("drm/panthor: Add the GPU logical block")
Reviewed-by: Boris Brezillon <boris.brezillon@collabora.com>
Signed-off-by: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>
Reviewed-by: Liviu Dudau <liviu.dudau@arm.com>
Reviewed-by: Steven Price <steven.price@arm.com>
Signed-off-by: Liviu Dudau <liviu.dudau@arm.com>
Link: https://patch.msgid.link/20260812-panthor-cache-flush-fix-v4-3-751e32901898@collabora.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panthor/panthor_gpu.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/panthor/panthor_gpu.c b/drivers/gpu/drm/panthor/panthor_gpu.c
index 77d0f4ced1206..7f2dc65386fd4 100644
--- a/drivers/gpu/drm/panthor/panthor_gpu.c
+++ b/drivers/gpu/drm/panthor/panthor_gpu.c
@@ -334,7 +334,10 @@ int panthor_gpu_soft_reset(struct panthor_device *ptdev)
 		return -ETIMEDOUT;
 	}
 
-	ptdev->gpu->pending_reqs = 0;
+	scoped_guard(spinlock, &ptdev->gpu->reqs_lock) {
+		ptdev->gpu->pending_reqs = 0;
+	}
+
 	return 0;
 }
 
-- 
2.53.0



