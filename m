Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795031518;
	b=S6AoedW/IQzSoy7cQs9KKp+rYMytQ4yU6jXV4Iq+bdKGXC9fcz6f6RWm45o2S4OjVI1g
	 m341HrC77hSlMYpT+6vD2sJ8xJPlvMstz8xMHoac2FszEKGRFkZckUhA1R9xXE2SlGUJ5
	 cKfr06UIIfB3EfEoeSvoL609zZn2uguU01ZNEXPAwCklbWWLKCgC5A6i9dlvBsdo22RJI
	 7ydeCrFOpywE3L3LAbsABCyCFrg1wAiYHzz6k/EZtK7VNJNfHbTWqQXLVKxyb//Ib/fTS
	 qjgC2nw8EUbNQY37ZyukEQOF0vLsPfomUSWvhpJReFjPAN4AFXYGHdEV7b8YY6OEEKw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795031518;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=K0CjM/CMT4jNZmm3sPI0HmaxRNYR+AI6BhU4+7Uu4Nw=;
	b=VASDNsHZJTEMz8bXfBCWJVumyy3ehrVa9Q/WTxrpia99FFDpJL33H5scZ4FbMDzomLQT
	 Wf9E3ZwdjhVATy8vDlapOUVCvWy5cL0jGjdoy+3OdYJWVQqPhoykXQATcZmj0H0fjhfB+
	 G2H98RMjo/Hftwpv9CghlwAg7IJXkVXGmhmXgfSpB3nX1JmiP9cZdC4VDiwzCcnI2p8xq
	 96QmzLQlLPIGGzHrDnLL8MRtCHCSltPBjZEhqsngdnMyCV25+cP1Hq5XLLIPNsPMs/l2S
	 hHCAKu+T4jEV+nROPBPU6/EvIvTHvsBlW6Jb6gCWxlYY2etQWoZlGv4Lzmpw6Qo+hvA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RO4vrB2d;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF561606A320;
	Wed, 18 Nov 2026 19:51:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RO4vrB2d
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 315D71F000C4;
	Wed, 18 Nov 2026 19:51:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795031518;
	bh=K0CjM/CMT4jNZmm3sPI0HmaxRNYR+AI6BhU4+7Uu4Nw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RO4vrB2drQwQw4pv7l5IQXk6noUCe6w5J8N5SkAQUllOGuTKyfNZMatNfo1Q5CaE0
	 51TN8x//OrYuJJ8lUvyCoCPYTCOL17tm1nBmYg8G9YBiixqjUIzPnXXEkFh2YV3JnJ
	 TkyzRUS4dD01CZc7hQiwqdXVDHRxTjbti9nGGF48=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Boris Brezillon <boris.brezillon@collabora.com>,
	Steven Price <steven.price@arm.com>,
	=?UTF-8?q?Adri=C3=A1n=20Larumbe?= <adrian.larumbe@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1060/1756] drm/panfrost: Explicitly enable MMU interrupts at device init
Date: Wed, 18 Nov 2026 15:53:07 +0100
Message-ID: <20261118150052.457835354@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Adrián Larumbe <adrian.larumbe@collabora.com>

[ Upstream commit 8a597d099b8b2f25df655cbe8e30765013784fed ]

Because the device must be in a position to accept jobs between the time
drm_dev_register() is called and autosuspend first kicks in, there's a very
narrow window inbetween during which jobs targeting the tiler buffer
object would time out, since the device's PM status is 'Active', but no MMU
interrupts were enabled at device initialisation time.

Reviewed-by: Boris Brezillon <boris.brezillon@collabora.com>
Fixes: 73e467f60acd ("drm/panfrost: Consolidate reset handling")
Reviewed-by: Steven Price <steven.price@arm.com>
Link: https://patch.msgid.link/20261012-claude-fixes-v15-7-bc0a6c498553@collabora.com
Signed-off-by: Adrián Larumbe <adrian.larumbe@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panfrost/panfrost_mmu.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/panfrost/panfrost_mmu.c b/drivers/gpu/drm/panfrost/panfrost_mmu.c
index b91019cd5acb1..1f37991c43896 100644
--- a/drivers/gpu/drm/panfrost/panfrost_mmu.c
+++ b/drivers/gpu/drm/panfrost/panfrost_mmu.c
@@ -227,6 +227,12 @@ void panfrost_mmu_as_put(struct panfrost_device *pfdev, struct panfrost_mmu *mmu
 	WARN_ON(atomic_read(&mmu->as_count) < 0);
 }
 
+static void panfrost_mmu_enable_interrupts(struct panfrost_device *pfdev)
+{
+	mmu_write(pfdev, MMU_INT_CLEAR, ~0);
+	mmu_write(pfdev, MMU_INT_MASK, ~0);
+}
+
 void panfrost_mmu_reset(struct panfrost_device *pfdev)
 {
 	struct panfrost_mmu *mmu, *mmu_tmp;
@@ -246,8 +252,7 @@ void panfrost_mmu_reset(struct panfrost_device *pfdev)
 
 	spin_unlock(&pfdev->as_lock);
 
-	mmu_write(pfdev, MMU_INT_CLEAR, ~0);
-	mmu_write(pfdev, MMU_INT_MASK, ~0);
+	panfrost_mmu_enable_interrupts(pfdev);
 }
 
 static size_t get_pgsize(u64 addr, size_t size, size_t *count)
@@ -783,6 +788,8 @@ int panfrost_mmu_init(struct panfrost_device *pfdev)
 		return err;
 	}
 
+	panfrost_mmu_enable_interrupts(pfdev);
+
 	return 0;
 }
 
-- 
2.53.0



