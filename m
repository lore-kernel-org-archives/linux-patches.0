Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795049588;
	b=NIw0bv24dwDj3zs8Q7/AL4o+dtorHtxkodCtyovQUuf2GDnS5n0ndX8pvkdI6uEDvsco
	 jajf0EtgQgOnusIfXSlMq2P8e74gMoH/YqPqf3q9WsPTxHlhR048BRNX7+26dRSENvgPo
	 DkuILz2KTvHM4K/YJW1dw6y4JmZE5Yed7m+Tek3PXDFMCil/4u6cg8OfHlGfqOPTS11k7
	 YfXHUJecrJOWdRD77PXYv+ANrObjTaz8lD5LrH42n2nk3dNeSgvjUOT4QILQTr9CaC7ls
	 4uAfUfXJL+D6f6i5XPQXS4aDHpdGZl2D64mbmIKeyh1bg40MzL3adeVIW+Qx9uSHOWQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795049588;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=fsnM1OU3vSaLucE5mblTajWKHykhmZ/MxUPHbVhEPu4=;
	b=oaFZ03d6cPUW5DqYwSF+z0LnmiVtdNOZUfPeZRnnP0BuDy8jYJpXgJ5nIABmhLVNfD7R
	 TqiBaTvAdMhHn3Wi3inTZzPJ/2uUD0SbdL4k7ATgPrXEOGH/yVr4tiT7loCrmZYW7tw3n
	 btUEMCUgvTiUpfLI9cgIpnOWzIz2/Sy+iz6+T5Eza8HUqrskqkX66kjcFhwHO6re0EqKK
	 Lp8tYVpWMK1NuTOcAOERzBKOR4wsZh+aYeos7DXz076w7wQ+dOVFTrfCMQR645UILiG6Q
	 RYfb3y5Vq4+7gulCWWIiCnVm2oPQPIfcn3L+tBOlCqXsAuLPGrrszV4CcIwU5g8HzNw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0DfyV41F;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56597606A31C;
	Thu, 19 Nov 2026 00:53:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0DfyV41F
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4B151F000C4;
	Thu, 19 Nov 2026 00:53:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795049588;
	bh=fsnM1OU3vSaLucE5mblTajWKHykhmZ/MxUPHbVhEPu4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0DfyV41FgW1for6T8Ly+7Npqy8cnwLsOOrPXfdstu5PXAEbMXZqMVw6Oqtb4r26vC
	 Lh1MPJk/FMk3Jn8pkgRT/M8Wgk2YKpbNvFydaE96qUPGeuLBgW/5lBr84fxs8oQ87o
	 VJzt0haDXjGmjj332D+92smybjV1VPVH3Ebi2rbE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Boris Brezillon <boris.brezillon@collabora.com>,
	Steven Price <steven.price@arm.com>,
	=?UTF-8?q?Adri=C3=A1n=20Larumbe?= <adrian.larumbe@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2364/2857] drm/panfrost: Explicitly enable MMU interrupts at device init
Date: Wed, 18 Nov 2026 15:56:38 +0100
Message-ID: <20261118150326.638464627@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 5aa6d94e95c98..e7776c4352659 100644
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
@@ -773,6 +778,8 @@ int panfrost_mmu_init(struct panfrost_device *pfdev)
 		return err;
 	}
 
+	panfrost_mmu_enable_interrupts(pfdev);
+
 	return 0;
 }
 
-- 
2.53.0



