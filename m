Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A2723E9C3D;
	Wed, 20 May 2026 16:35:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779294941; cv=none; b=QA17SbE3/t5Jh5CD0Dmgu7XFw/RwtZw7FlrfTKPMhRFkXUqs4EwOemipzK2IVYKRRam+J4sRdsgxsQ4OPBCeuYkiF9peBwCechci5svaAE+tbY1mZMYatlIZHr4aDTVyvYKtoMGxUU2kNLiKL2ArZ7k6e8D/mLTLEqh9xgj6OuM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779294941; c=relaxed/simple;
	bh=koW7mrs20CjKSDcVsn4c42pgGityshh+8+ddx4/IxfE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JVihPQrb+kDzZfpq3DZVuMNNhbnQCENi3R3dTK1Fmuk4Zyk4DZ0IMN3nGPS8u1PADJOWDdvdnwU20ow+7BkhnMQYVE+MKF5EeUUdT/NzCeYW/BQ2C09TmtFs1JTyGMOjz+CwdyRb8PWkuR25MPJhZf+EcZL3XsUnhPnojwLGCGY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tV6Wd4YH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tV6Wd4YH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 846381F000E9;
	Wed, 20 May 2026 16:35:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779294940;
	bh=SP8nseoVCpy7EQiQF4wMaze9pv8zqEN2shs2B6agiv8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tV6Wd4YHStz5ZPZxeN41rmh0XCfpSaKrsj+Gy7JcoEMsDjTSB01/+SulOjznHvYy+
	 wouAVJui+6OXPFF+QxY63BbCnI4u05udHqoo4DNTxiqdKY1hQtPY1h1vZwRourUMoG
	 ObBjzhkm/GZOewhuVsZFZssYHWIMq2D82JzeWZDw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Val Packett <val@invisiblethingslab.com>,
	Dmitry Osipenko <dmitry.osipenko@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0230/1146] drm/virtio: Allow importing prime buffers when 3D is enabled
Date: Wed, 20 May 2026 18:08:00 +0200
Message-ID: <20260520162153.457299487@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Val Packett <val@invisiblethingslab.com>

[ Upstream commit df4dc947c46bb9f80038f52c6e38cb2d40c10e50 ]

This functionality was added for using a KMS-only virtgpu with a physical
(or SR-IOV) headless GPU in passthrough, but it should not be restricted
to KMS-only mode. It can be used with cross-domain to pass guest memfds
to the host compositor with zero copies (using udmabuf on both sides).

Drop the check for the absence of virgl_3d to allow for more use cases.

Fixes: ca77f27a2665 ("drm/virtio: Import prime buffers from other devices as guest blobs")
Signed-off-by: Val Packett <val@invisiblethingslab.com>
Reviewed-by: Dmitry Osipenko <dmitry.osipenko@collabora.com>
Signed-off-by: Dmitry Osipenko <dmitry.osipenko@collabora.com>
Link: https://patch.msgid.link/20251210154755.1119861-2-val@invisiblethingslab.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/virtio/virtgpu_prime.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/virtio/virtgpu_prime.c b/drivers/gpu/drm/virtio/virtgpu_prime.c
index 8adcf5c15d456..05756ed4f1dac 100644
--- a/drivers/gpu/drm/virtio/virtgpu_prime.c
+++ b/drivers/gpu/drm/virtio/virtgpu_prime.c
@@ -310,7 +310,7 @@ struct drm_gem_object *virtgpu_gem_prime_import(struct drm_device *dev,
 		}
 	}
 
-	if (!vgdev->has_resource_blob || vgdev->has_virgl_3d)
+	if (!vgdev->has_resource_blob)
 		return drm_gem_prime_import(dev, buf);
 
 	bo = kzalloc_obj(*bo);
-- 
2.53.0



