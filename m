Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019531;
	b=nYGIlGKdMPAgIiGCmWO9AirarSp5o3lIFLMWV6T/6As8nL4rjeojrDLhBCCd57Z0Zbrb
	 wgED51b1jBFllnoq5lV8FWc8UPfP6TVMyvi08UlXj0Tez11/oZ5HEg5WmLEyBQVJgLhZQ
	 ZddndLyxfzbhpKTR6w/GkkQ4l0R2SiRddDwoyiiM3InTWQQylg8FwV5PI1gXLOqXmZPpK
	 vtPKznBSXfWnYxXIlrU3HMx5lfLtZO/y0lg+x4SWpp9VK2RXbn8UqwPWoyJWq6K0dHXWT
	 SFNHY4MleVdZ1mQvg1CyyLxKAY6CirTxCnCshj3kkOoMwY7JBALqtx95bkI+q4kRcmw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019531;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=oZJDUTwTauVJF2aFam0ZFFckzcPbhZEWa9kWy9TpdBw=;
	b=UB7oy7Icq0RhSiUep3QXrRwTZ4bl0XdtSl42WLasVPR9TR8nxIk9GB1NczZujKcIK6NW
	 lXlAAtOhj79DO8oQtzl0OO7ZXzuJc//ktok6fsIwdJDJHD/Yfct+7xlHOp71ubfH0Fkd5
	 upOkp61Qvbw+osqo2i8wyyf94BgvtHZOR3ivBKY6rj0sevj6zy7F5YYQuUxo/0ZwietYW
	 rizZLUv5WNWRIDvNgltH8PcKCXl/qySwqrmEcDExmbDTUDeqzT5fM7xZti7VQU/y/xSoy
	 g3xUAQRJRNZ/WBCKzthZCSZ1tMys7rhRIIKVcBxKMwEI/72pFLhzTsPqhS1P01ju3CQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CfYwKMK9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50A82606A7C5;
	Wed, 18 Nov 2026 16:32:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CfYwKMK9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62E001F000C4;
	Wed, 18 Nov 2026 16:32:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795019530;
	bh=oZJDUTwTauVJF2aFam0ZFFckzcPbhZEWa9kWy9TpdBw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CfYwKMK9RqWBWnKh10XMv9e1PCcVv3ukyF0sIUVA7ljDo8L/DkjwOFW5GIXJ6oTQx
	 pbD0mmtKezRSAg6ufEicLGQ8Id3p8KvUCM3MISKsNg9b+T6JBkNFIZYbUbIVKfXsn2
	 bRbKTSYAgle7q4otxDIbOGtoqNEYyrOtsLbY1VEg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Boris Brezillon <boris.brezillon@collabora.com>,
	Steven Price <steven.price@arm.com>,
	=?UTF-8?q?Adri=C3=A1n=20Larumbe?= <adrian.larumbe@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1630/2651] drm/panfrost: Explicitly enable MMU interrupts at device init
Date: Wed, 18 Nov 2026 15:47:50 +0100
Message-ID: <20261118150346.537341017@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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
index 4a3162c3b659f..bb6c1614964b1 100644
--- a/drivers/gpu/drm/panfrost/panfrost_mmu.c
+++ b/drivers/gpu/drm/panfrost/panfrost_mmu.c
@@ -336,6 +336,12 @@ void panfrost_mmu_as_put(struct panfrost_device *pfdev, struct panfrost_mmu *mmu
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
@@ -355,8 +361,7 @@ void panfrost_mmu_reset(struct panfrost_device *pfdev)
 
 	spin_unlock(&pfdev->as_lock);
 
-	mmu_write(pfdev, MMU_INT_CLEAR, ~0);
-	mmu_write(pfdev, MMU_INT_MASK, ~0);
+	panfrost_mmu_enable_interrupts(pfdev);
 }
 
 static size_t get_pgsize(u64 addr, size_t size, size_t *count)
@@ -970,6 +975,8 @@ int panfrost_mmu_init(struct panfrost_device *pfdev)
 		return err;
 	}
 
+	panfrost_mmu_enable_interrupts(pfdev);
+
 	return 0;
 }
 
-- 
2.53.0



