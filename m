Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD1DE51FCD3;
	Wed, 30 Sep 2026 18:29:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790792986; cv=none; b=Z1kUQcEknJ+Lkttz2MWJynlgKJS4EzTn4G09yd04Paqkr/tD+jlAZ7P7JFRQCJRg4/2pGYmPIFHD4GyZbd2EDxVDKfETkZiinuCvVwv7Cp+55BhPxnzgmoQUBdOSurQaXzvd3OTvZjHobttMVGrd3wEsHye/VIeQ3tcGy2cdLtE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790792986; c=relaxed/simple;
	bh=qKEJqbcGR8RHlCFweA7YL0tKQIW2TbdXQDX1OvzCpCM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qJ/2xO1rS4/3e/FCZbS/am8ZromjmPTb4K9dxHdAzBLuLSc6XXfbvqxWymZaCf5oF3Lq9AZHykGCGdIgQcnVH+MVvE8urYRnnBZNOdWg4KXr4Vl+tmoAuNNu8y3TJzKL8slMDXAFGnB6qAASdQXt1WW8Ake9u1AblRpifr8OzZ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ruYG07st; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ruYG07st"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31DD01F000FF;
	Wed, 30 Sep 2026 18:29:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790792984;
	bh=7uPISs4C0OEXM8ICcHTWCErXuS5EEG6IcHOkOSnZOUo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ruYG07stmnzsCMfoKDq0kIWqu42wfrBXuvZMXId26hnZCgXCOVzjf94gUNpAoln43
	 GfxDqB3BZMHrauDlk1tD5EyjfcwCprfL+TZj+O19orbc3Gdaw+EsKGuRjEtkzFES7m
	 hzzjyVcOvNGgrJHPPfG6soK1T1XS/6jAlYxrjWz8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Osipenko <dmitry.osipenko@collabora.com>,
	Val Packett <val@invisiblethingslab.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 095/395] Revert "drm/virtio: Allow importing prime buffers when 3D is enabled"
Date: Wed, 30 Sep 2026 17:25:57 +0200
Message-ID: <20260930152342.696129474@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152340.591469096@linuxfoundation.org>
References: <20260930152340.591469096@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Osipenko <dmitry.osipenko@collabora.com>

[ Upstream commit 1e3b08de63274d0b009e99ef51cd6a9c0c6bf08c ]

Guest userspace may import udmabuf to vrend. Vrend doesn't support guest
blobs, and thus, further 3d operations with the imported blob are failing.
Typical scenario of the problem shown with mouse cursor RGBA image imported
into virtio-gpu, which previously was rejected by virtio-gpu driver.
Revert enabling guest blobs importing into vrend to fix the regression.

Link: https://gitlab.freedesktop.org/virgl/virglrenderer/-/work_items/674
Fixes: df4dc947c46b ("drm/virtio: Allow importing prime buffers when 3D is enabled")
Signed-off-by: Dmitry Osipenko <dmitry.osipenko@collabora.com>
Reviewed-by: Val Packett <val@invisiblethingslab.com>
Link: https://patch.msgid.link/20260911144204.2089401-1-dmitry.osipenko@collabora.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/virtio/virtgpu_prime.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/virtio/virtgpu_prime.c b/drivers/gpu/drm/virtio/virtgpu_prime.c
index 2fedd5d3bd62c..ce49282198cbf 100644
--- a/drivers/gpu/drm/virtio/virtgpu_prime.c
+++ b/drivers/gpu/drm/virtio/virtgpu_prime.c
@@ -312,7 +312,7 @@ struct drm_gem_object *virtgpu_gem_prime_import(struct drm_device *dev,
 		}
 	}
 
-	if (!vgdev->has_resource_blob)
+	if (!vgdev->has_resource_blob || vgdev->has_virgl_3d)
 		return drm_gem_prime_import(dev, buf);
 
 	bo = kzalloc(sizeof(*bo), GFP_KERNEL);
-- 
2.53.0



