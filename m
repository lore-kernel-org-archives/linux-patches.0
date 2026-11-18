Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795056038;
	b=QPJQ/mV3ES+VXhhHwTPJGn3q7K57qKd6rUJQh7hoJ0s0G3lLKvNoV/oBcrhSkKMzxcTm
	 pcgbMP9SElE90Mlq5QDkoz1C5EaZ3wZ8VPsRYpVVCzyWiELCxo5HKfQIPWSZWItZbTlJB
	 KBn+cH3JUQicXAIOY5FlRj26q78wxe1ec4n4abxqTJiTS7h9MKEBn1jxH/DPEYvieaxXH
	 Z2nZWUIbiUrAAfy7mwuWGU0GBsRsUsqkcj99zdqmxFPyPVk46IPRXYkjxd83mR18AQxkW
	 IlX9nmtVGGyERsOSeS00D/uNOCHpWCA1uu7d96MYVdgJbuLfjteRLAzGCTUgOLSkRkA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795056038;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=41XxRNsYHMXOr1/rTSb4+g3PhQ/3ezWSJAoFpTc5vyo=;
	b=eebsjoAt8Jyyi0ce6qQlHxLIPoHES8iCTAu8UtA5zYZsnIMHHCr78zs+30K5u5fCcri5
	 oZ8FfI7c5eEmnNzemfLOqEqxrNqoDxkhMZeUK7pttIeWxSbIbi0Afb+7Y7BIoG5rYQW9i
	 um+4D0VFa8gO3PJSZVhVL5XEYbMVv69gaBOkQHjLyQUfiB6Tv4ImBLzreimLUPYO8E9G8
	 7mNx8I2PdoWzBhGasauYLv08C4al968WaSz+VJ2GEN9m186LGoy/ej6oJV3J1HpMSyfdY
	 7UcJ4GHI7pA6TxMRSr3o7Qk1RNuLW3f++uBYjvfa1nQ53A4BaIFDOpvafJy7ztD1QdQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=od9P2Ery;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1E8F606A320;
	Thu, 19 Nov 2026 02:40:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=od9P2Ery
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A0741F000C4;
	Thu, 19 Nov 2026 02:40:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795056037;
	bh=41XxRNsYHMXOr1/rTSb4+g3PhQ/3ezWSJAoFpTc5vyo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=od9P2EryMOVVuTSeV8Sx0xMOB5tDaPcuAPxajUvsdNo5TDn/RL9NpdXS0znWgvBbi
	 ynr5oRrRLXKWTyd7PztBNc5b9lfyS+N8NTfN/0Y8GUMB3TV6pA3yR/lOQUj0E+uFNP
	 5U6w1prnzBN0JBrGuCAtn2VbbFxYEGqn6EGprzDk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Boris Brezillon <boris.brezillon@collabora.com>,
	Steven Price <steven.price@arm.com>,
	=?UTF-8?q?Adri=C3=A1n=20Larumbe?= <adrian.larumbe@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1844/2214] drm/panfrost: Explicitly enable MMU interrupts at device init
Date: Wed, 18 Nov 2026 15:58:40 +0100
Message-ID: <20261118150125.179738648@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index b5ee076c2841f..9c9a22eb8392a 100644
--- a/drivers/gpu/drm/panfrost/panfrost_mmu.c
+++ b/drivers/gpu/drm/panfrost/panfrost_mmu.c
@@ -211,6 +211,12 @@ void panfrost_mmu_as_put(struct panfrost_device *pfdev, struct panfrost_mmu *mmu
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
@@ -228,8 +234,7 @@ void panfrost_mmu_reset(struct panfrost_device *pfdev)
 
 	spin_unlock(&pfdev->as_lock);
 
-	mmu_write(pfdev, MMU_INT_CLEAR, ~0);
-	mmu_write(pfdev, MMU_INT_MASK, ~0);
+	panfrost_mmu_enable_interrupts(pfdev);
 }
 
 static size_t get_pgsize(u64 addr, size_t size)
@@ -733,6 +738,8 @@ int panfrost_mmu_init(struct panfrost_device *pfdev)
 		return err;
 	}
 
+	panfrost_mmu_enable_interrupts(pfdev);
+
 	return 0;
 }
 
-- 
2.53.0



