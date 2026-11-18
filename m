Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015133;
	b=Kkqt9t+vuH7lJMm7/1v0X3Wb2ngf4zgoYnXCj1I93pgrorC/2USzfizZrzZx6wIRPGj9
	 KQmzZIN7KI1oOzxCHDTEhGkq+qlUNC7iyw9JrblYRIgrE+WLemzjB02oOWBZEqDfSI/ZO
	 5rpYJ8exKUc2CtJDFum2fktzX75ubpadk27cpGhSE8N3t8C4CN5FMKqIJtI9SUI9h4seO
	 hKw04JYZWkq0jk65A6SzNbfy6J0zNe/ykpiw13fRuHvxiu11oSsgtdyGgSagjRyBPKz5+
	 ccBR0apUvb+SrAERlumv8OP5E5LOkEj81XpI0NPX1xII43JK1Ky1XJjsrLo030QaXtQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015133;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=ZEshy7e0sMO1W0DwXWihgVpQgKD3LO22Uar1bVR6sos=;
	b=RRFDGiQ3PbFWNOnDkzu5yKVhAkPgYmsIddioAMLkS8Hz4TUuz7DIifRwHKgfBPGEw3Lq
	 7CZD8ji4G5QwAR3ydy+fC9qp7hPk9MK/K6Ap3Ai02hzT67nFwu3kBE+nB43F03oUkz3wb
	 xVIJCPteY/dni9TO0bX4QHr+bM30rDsch3O6R5ZqtfDMjgRBYUHxRTZZ28F7Y8dLsmCOh
	 wYiSJoc2lVTdUddjsrtjaoj8NW55+aJI/5qjWfYTlZzGATxldDxfI6VGBMDybWNmilF5R
	 00EDGbdl9nb44P8nokicyvTgY3zhwZAigNbuh+rFS2Wgu+xrLTOTGsGmCbwpw9ZYu0Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2PpbNq+R;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6E0F60A2622;
	Wed, 18 Nov 2026 15:18:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2PpbNq+R
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 139B81F000C6;
	Wed, 18 Nov 2026 15:18:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795015132;
	bh=ZEshy7e0sMO1W0DwXWihgVpQgKD3LO22Uar1bVR6sos=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2PpbNq+R1778ceWfnuTRQOBjNxW6Zc3JIZ5fFJg/9LxuLGz3PNOCwfVe6I8ORJPWV
	 CflVnLfU3VhwLl/K1TRLdjnd0mJ/VskpGD5jrno7jLc2zy+aM/Z3rIfDQxTpQqYPn8
	 gA/ZqGJT3cS+888ggUWaIGr7CeX1duUH+DnFbqrE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Claude <noreply@anthropic.com>,
	Steven Price <steven.price@arm.com>,
	Boris Brezillon <boris.brezillon@collabora.com>,
	=?UTF-8?q?Adri=C3=A1n=20Larumbe?= <adrian.larumbe@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0063/2651] drm/panfrost: Check another bo field for cache option query
Date: Wed, 18 Nov 2026 15:21:43 +0100
Message-ID: <20261118150250.211104671@linuxfoundation.org>
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

[ Upstream commit a34340574bad0e3280d8b43b3836147bf2149abc ]

When querying the properties of a BO, whether it was created in
Writeback caching mode for userspace mappings, is recorded in a Panfrost
BO's wb_mmap field.

Reported-by: Claude <noreply@anthropic.com>
Closes: https://gitlab.freedesktop.org/panfrost/linux/-/work_items/88
Fixes: 62eedf1ccba5 ("drm/panfrost: Add flag to map GEM object Write-Back Cacheable")
Reviewed-by: Steven Price <steven.price@arm.com>
Reviewed-by: Boris Brezillon <boris.brezillon@collabora.com>
Link: https://patch.msgid.link/20260820-b4-panfrost-fixes-v1-1-1b2c2376f4bc@collabora.com
Signed-off-by: Adrián Larumbe <adrian.larumbe@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panfrost/panfrost_drv.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/panfrost/panfrost_drv.c b/drivers/gpu/drm/panfrost/panfrost_drv.c
index 36cc2e67a3080..96a66d673ba60 100644
--- a/drivers/gpu/drm/panfrost/panfrost_drv.c
+++ b/drivers/gpu/drm/panfrost/panfrost_drv.c
@@ -662,7 +662,7 @@ static int panfrost_ioctl_query_bo_info(struct drm_device *dev, void *data,
 		if (bo->is_heap)
 			args->create_flags |= PANFROST_BO_HEAP;
 
-		if (!bo->base.map_wc)
+		if (bo->wb_mmap)
 			args->create_flags |= PANFROST_BO_WB_MMAP;
 	}
 
-- 
2.53.0



