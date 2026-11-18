Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795061462;
	b=Dt63fvsEWMmFEvITjSYEyw8VE3+GUXTiaAGRZX/87LlWHY5qLORDqdt8xpL6OlrnrIfG
	 TwqQFDVdSPmS9f8tqQNwmYD1UBr+yU7O8hWiTwr9F2vD4W04P4tjdulD2X36Je6udZl8G
	 ie6aQ6WFKo9YYGpTRHEK61mirIYK4aAioWROKXvnVDq6AO1cekC4DYxXb8dabF8bhH42A
	 J/LMum5yPnfynbMtScW0JZqgowB25Q/SjTdeU/NxPFCWs8iyzHvyGWubPhsyYTfu+kePG
	 3ct1FAf16rQI827fdCvlbM0kTkfcIxkzqztclbs6c0sEiTxMwhK1/N2Y5SeTYsF4mZg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795061462;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=Euty6C5XezTL275n/3YgjMgxROLB482A5PBjhd3ykak=;
	b=OKvcIyXG1IBbsD00UZqX7zo1xFm/OI/vln8vD+ZM4u/Bu0xxgpzo3/UDLH70JIO4b+ax
	 xYe7ZywXI/9rHm6FMivx1mahE2CNiDuKjy3+WTwNFZjZtY1PMEsEdz2Uj/bKuhfPNvfB9
	 7PsjXYJbYFuVqbdAWVZfUyvLu+yrPknktjd4sS7sj2dtCWu4w1gWgmSzF91hasQUVX5Am
	 rAyHKHuDthayNPRMS5vEQySzmLpEmtY1vtfOY1GlPo46ED2HCZ2twtb3CKDNzQfuQKYLb
	 aUcPiq2x17tfjLhyfHfs0zY0j9Xf8fuIWg9x0k+JOC794H68o2CxZV5XVdbEniK0XhA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=exesZhW1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CCE6606A32A;
	Thu, 19 Nov 2026 04:11:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=exesZhW1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A94A1F000C4;
	Thu, 19 Nov 2026 04:11:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795061462;
	bh=Euty6C5XezTL275n/3YgjMgxROLB482A5PBjhd3ykak=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=exesZhW1ngXOmNenuH1LGP0iXWhKiYtiq2+1Myx/bxLjENRATWhDe+8s9vh5P2E8u
	 ItUaaZj8RejiYBPQYkOukDGJBJU97hx/5bZ+aS/pEQxCkkRCkwXmsiAmReiVYvoO88
	 CY6Fq3Nns3nHQvVqvWF5X1R9nvhwz9RhA8MAIFAc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Boris Brezillon <boris.brezillon@collabora.com>,
	Steven Price <steven.price@arm.com>,
	=?UTF-8?q?Adri=C3=A1n=20Larumbe?= <adrian.larumbe@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1562/1848] drm/panfrost: Explicitly enable MMU interrupts at device init
Date: Wed, 18 Nov 2026 16:00:00 +0100
Message-ID: <20261118150024.991973622@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index c81f3ac22cddb..53fbb2cd5d0a1 100644
--- a/drivers/gpu/drm/panfrost/panfrost_mmu.c
+++ b/drivers/gpu/drm/panfrost/panfrost_mmu.c
@@ -195,6 +195,12 @@ void panfrost_mmu_as_put(struct panfrost_device *pfdev, struct panfrost_mmu *mmu
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
@@ -211,8 +217,7 @@ void panfrost_mmu_reset(struct panfrost_device *pfdev)
 
 	spin_unlock(&pfdev->as_lock);
 
-	mmu_write(pfdev, MMU_INT_CLEAR, ~0);
-	mmu_write(pfdev, MMU_INT_MASK, ~0);
+	panfrost_mmu_enable_interrupts(pfdev);
 }
 
 static size_t get_pgsize(u64 addr, size_t size)
@@ -706,6 +711,8 @@ int panfrost_mmu_init(struct panfrost_device *pfdev)
 		return err;
 	}
 
+	panfrost_mmu_enable_interrupts(pfdev);
+
 	return 0;
 }
 
-- 
2.53.0



