Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69CF63F2115;
	Wed, 20 May 2026 17:24:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779297847; cv=none; b=HHRJMBPQfl2S80HehY5S6iXACEeNdwHv8PlYakmaNP0bm9H7FaRPdbbybRVKLPQ8/1jt2M0m5bZYG7xU2yU5b2JJt8RlCBrYsyahj4GqlWzx3wxhX0zXvNkSavDXFKR9/2t562o0TZfFkgWLgiCZs50s8dhxN/USr3fhbIDO3w4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779297847; c=relaxed/simple;
	bh=Jqs6j9PQobd+8z8RtsE1LxBSLvRZkKuOxGJpnWTbiiE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=el5my1XRIvMojQzLmEB/WP7G74OTI3nxMoCC1bL9pYDU+eSnehV4RrLvXOWLhjku4paWmFBMhfZauLD0hVI06qwhy3/czUCUMwuxVhcMQbCZGMnzqVElGlz9AnJbxau3JdWhTgucec7Vu1NBFKDutUMuSzFxDi5ejfAaHga9rFA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fw9bKHnr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fw9bKHnr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF4281F000E9;
	Wed, 20 May 2026 17:24:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779297846;
	bh=oyFLgoZiQdUXyH9xWnPNfJ12fvXQosmPGOUpUinCQpI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fw9bKHnr7BZuXoTuG2fk+rUN/Sq3Zy1wZ5y5STK/quZKvcZjePy0xzCmga6u5yKkX
	 XVlxYxJgLZZCTiWxeNB47d6UuSlZTVLcA3SXvG3czL3XWv43Iyk2N5qJ7AgGxW0v1l
	 TkeLYUQRJ+pG1412c7jA49OPAo4FDzeTwPGnmuB8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Val Packett <val@invisiblethingslab.com>,
	Dmitry Osipenko <dmitry.osipenko@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 187/957] drm/virtio: Allow importing prime buffers when 3D is enabled
Date: Wed, 20 May 2026 18:11:10 +0200
Message-ID: <20260520162138.607952386@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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
index ce49282198cbf..2fedd5d3bd62c 100644
--- a/drivers/gpu/drm/virtio/virtgpu_prime.c
+++ b/drivers/gpu/drm/virtio/virtgpu_prime.c
@@ -312,7 +312,7 @@ struct drm_gem_object *virtgpu_gem_prime_import(struct drm_device *dev,
 		}
 	}
 
-	if (!vgdev->has_resource_blob || vgdev->has_virgl_3d)
+	if (!vgdev->has_resource_blob)
 		return drm_gem_prime_import(dev, buf);
 
 	bo = kzalloc(sizeof(*bo), GFP_KERNEL);
-- 
2.53.0



