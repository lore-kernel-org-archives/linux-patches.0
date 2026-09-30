Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E887C4F55B6;
	Wed, 30 Sep 2026 16:53:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790787230; cv=none; b=S5Nh8oVK7KVGA2uBPmmSpQZ6Xt9KNLuqxTJQYGCSuX94tEJbCeIig+zL8Hwrj4uy8hZW13/Eli15fUaeIba8kalnxjJjwR58/8J4lfwytibpf0yiCi8BojF7p41Y2wBmainYXDJm0EV+oicYJAE557heRdVEHKunRoD0a7iJySg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790787230; c=relaxed/simple;
	bh=osiAwvJ79Fbu5JrcDqeUbJ63nTRDRIWs+ykEQ1UTFzg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K6rJnu/+REFj3WLM/BVK9KnitPaps+EOs1Dq9kKxNZT1BDMQQmOpE97v2x87j+X/Zm4GqDyiC7vxGEFjdbMZxHz1i1uu4/o5m87S8GmZwwTCmpImS7ps1oEvm84vwZRDPey1jVHdmEyk5SPGLNhfXK4oUxXV+mxJzcA6kH8Sid8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GntHKoO2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GntHKoO2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 500681F000FF;
	Wed, 30 Sep 2026 16:53:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790787228;
	bh=hmBxNIWVxBG+pxn5R/72htLtc9XSku1msxbornzKQ/M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GntHKoO2gmMh4PqTsseeuY/ZDYDepFHnOL64uhJkni5lWmeaOo1W+6VYWsmn19bFV
	 0B1o7ULZ5l1ZzKbBz5K+hLrB+Fg6LNxRrrPqODKepCGui8QJoUvKazkU3UOiR+OTOw
	 u664qOP4rjw1I9JRGQZ8rPST3aXubsQ+RB8zZimc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Osipenko <dmitry.osipenko@collabora.com>,
	Val Packett <val@invisiblethingslab.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 112/457] Revert "drm/virtio: Allow importing prime buffers when 3D is enabled"
Date: Wed, 30 Sep 2026 17:23:37 +0200
Message-ID: <20260930152348.470223622@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152346.024115587@linuxfoundation.org>
References: <20260930152346.024115587@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index 70b3b836e1c99..c2748378a8ad6 100644
--- a/drivers/gpu/drm/virtio/virtgpu_prime.c
+++ b/drivers/gpu/drm/virtio/virtgpu_prime.c
@@ -310,7 +310,7 @@ struct drm_gem_object *virtgpu_gem_prime_import(struct drm_device *dev,
 		}
 	}
 
-	if (!vgdev->has_resource_blob)
+	if (!vgdev->has_resource_blob || vgdev->has_virgl_3d)
 		return drm_gem_prime_import(dev, buf);
 
 	bo = kzalloc_obj(*bo);
-- 
2.53.0



