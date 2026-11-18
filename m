Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026286;
	b=COVyMdW+p98XU0hmWxt4lO0TiAhYkkWm9Qi+tLBvni6X4ENWCmGmrm+NJq3RDXyiA+2r
	 6V0zsNLo/Mf3zVsAbrCAb5SwWWHLP3eJC9SLvcRBxXxk9xB5qBZQ2f4RS00vxjpXhszNv
	 4kgf5pXcjZ9wmgfxBTlo+UL8o2lvgPkqwND4+aXcJFykwhXOc9YA2e4KcED7Biv5mUmsF
	 w0lzbmgYP9AkYQ0d9rQaoWpLJ04blSdnXTN+qPp0WGQEFG7QusUi4EK+cw9g811X/Ir5z
	 IMGQ8PPHD4N9ELjgQi6t1P3fqHgVyjumHh+g2U1XzXIauXSPH6JoA93EmudfERz4W8Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026286;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=uadz7bt82yyKxdiiy7lScBgLP+76x2j0xlX6BCdl2UA=;
	b=ALkLr6WBPl64Ec1xmRxiFONGockl+QwslAO6HZ7NoxibT/SvL8hgOQmaKDxbI3dQDWWH
	 Or4fxRte+Jf4Lbm73bANOnxfvEVumSCWMj7ksAxb2oxzZZJf3V33ZVx+EcMnSjvOjY/9t
	 zaxKCdOSaO3U6LX7z5oQ1xNham2vsT43alDtNTKImNjtjGD092rkQsRIHgjg1wVudOboW
	 oYD+qA62YxcGKek/KLeHYH3Av0XoMgqT3cqsW4tKzhONwAzuHtTfU8b+QQZ834nrM8KhJ
	 cV7mL9yYKk6kEPAzyezMnmmubnSbbwM/jQZx3iW/mjYqZ/kbTz+cP6iRH7yzZMIReuw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="kaGJ7W/w";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9334C606A32F;
	Wed, 18 Nov 2026 18:24:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kaGJ7W/w
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99DED1F000C4;
	Wed, 18 Nov 2026 18:24:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795026286;
	bh=uadz7bt82yyKxdiiy7lScBgLP+76x2j0xlX6BCdl2UA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kaGJ7W/wKTug62AlVy6EQ7pSuNTub3wyI4p3Lf/fewvHSYGH5F0CF2Wa0Qc9Xy9jr
	 KWlVh4lN6srfDKUY75QyGFVtcsGdp+d7F5k6rrIObA1jOls5H9lAFzBm9gGkBshdCI
	 /ZfJlRUPD3GzqHd/vf7YE43AlM8cer/0opAQdHAo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Boris Brezillon <boris.brezillon@collabora.com>,
	Steven Price <steven.price@arm.com>,
	=?UTF-8?q?Adri=C3=A1n=20Larumbe?= <adrian.larumbe@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1339/2151] drm/panfrost: Explicitly enable MMU interrupts at device init
Date: Wed, 18 Nov 2026 15:51:14 +0100
Message-ID: <20261118150210.832032347@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index f6b91c052cfbc..fcb3bac8fd458 100644
--- a/drivers/gpu/drm/panfrost/panfrost_mmu.c
+++ b/drivers/gpu/drm/panfrost/panfrost_mmu.c
@@ -330,6 +330,12 @@ void panfrost_mmu_as_put(struct panfrost_device *pfdev, struct panfrost_mmu *mmu
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
@@ -349,8 +355,7 @@ void panfrost_mmu_reset(struct panfrost_device *pfdev)
 
 	spin_unlock(&pfdev->as_lock);
 
-	mmu_write(pfdev, MMU_INT_CLEAR, ~0);
-	mmu_write(pfdev, MMU_INT_MASK, ~0);
+	panfrost_mmu_enable_interrupts(pfdev);
 }
 
 static size_t get_pgsize(u64 addr, size_t size, size_t *count)
@@ -911,6 +916,8 @@ int panfrost_mmu_init(struct panfrost_device *pfdev)
 		return err;
 	}
 
+	panfrost_mmu_enable_interrupts(pfdev);
+
 	return 0;
 }
 
-- 
2.53.0



