Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795041236;
	b=igq34nYehO2VMnbseC3cxl1TrKrpjqJ9y9I1gkexdX6wwC8V/8YuxhjEnkEiyYCKkxu1
	 RgqLzdlOgSJs9zuoEmxH5meNIvpUNPV/se57A/bn7HB9jgDS013MCrfSZuQi3MfZRbM4Z
	 J9SapXZauglVzxH/4ICemhgfnIkQBJQKgyLsBifzlqyLjLkoAL0EywLJsg0MPpReH+KU+
	 oN8xKiCKMiO08pFq26SiMygEccwp0bub1diRV+NVLbe7kJjnAACv4bbbrAt7IkQn8/fza
	 GC6Q3NEhm9fXrGt2nbmOeJ+IHffj0VzykyhftGWyljolbKa4y88o2nC9H4MxHxbgM6Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795041236;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=kaTbMeq65PWL9DhFTfSkzkloG/yEDPSO5Hb1VRmfQ9U=;
	b=X54PH5glGei/BoZ8fu7SEZsO7/krP8DBlYyUaSurjF4mmW74b3bPNy7oR+mFt0EbBle0
	 LiJxImxrBlFDyt6hYvmDP3h7bzW/cyvTXlXumrhnMxp9wgG+nChFXgk4ruE7xEBscIR96
	 0je+bt4NxLr0Nqky1xSpDWXh46XHvjIykdYb+yo6jY+uRHpMxDuEFGqiqCcADubK4myO7
	 LDK8DNf54/mOTmxTdnbIBtgJD0oM5p+69YyK4DYP+kY2+p518lpreNyrjuStUICgPa0E1
	 Ux21ABRg3tvCfH08ESzC1ueNgPSytw6e0NdDJXwVXCRH9l3Upm0L1iiFRSOZNd6ZhbQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fjskMWKT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F787606A31C;
	Wed, 18 Nov 2026 22:33:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fjskMWKT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E492A1F000C5;
	Wed, 18 Nov 2026 22:33:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795041236;
	bh=kaTbMeq65PWL9DhFTfSkzkloG/yEDPSO5Hb1VRmfQ9U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fjskMWKTAUCXqGZbsqy+Cnz2e2smZNu7Q1zXXR1gHddpt213oRkT3Ylozc8Qwqe5B
	 uDeUG0uzqDA0ik4rzigk1q4ct4ath50qYYwaIS5KJ3+oUZ+R/rKBhJSjLisXyYlufb
	 W6LGM8mj2O11sNLuO+WaLERa/TtD6QfNZdrmDRRY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Boris Brezillon <boris.brezillon@collabora.com>,
	Steven Price <steven.price@arm.com>,
	=?UTF-8?q?Adri=C3=A1n=20Larumbe?= <adrian.larumbe@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2741/3318] drm/panfrost: Explicitly enable MMU interrupts at device init
Date: Wed, 18 Nov 2026 15:56:03 +0100
Message-ID: <20261118150443.012862141@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 83fa384f6a24c..ce1cd73580f6b 100644
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
@@ -244,8 +250,7 @@ void panfrost_mmu_reset(struct panfrost_device *pfdev)
 
 	spin_unlock(&pfdev->as_lock);
 
-	mmu_write(pfdev, MMU_INT_CLEAR, ~0);
-	mmu_write(pfdev, MMU_INT_MASK, ~0);
+	panfrost_mmu_enable_interrupts(pfdev);
 }
 
 static size_t get_pgsize(u64 addr, size_t size, size_t *count)
@@ -774,6 +779,8 @@ int panfrost_mmu_init(struct panfrost_device *pfdev)
 		return err;
 	}
 
+	panfrost_mmu_enable_interrupts(pfdev);
+
 	return 0;
 }
 
-- 
2.53.0



