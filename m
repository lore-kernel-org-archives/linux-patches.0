Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51C054854FB;
	Thu, 20 Aug 2026 16:46:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787244394; cv=none; b=NWyQbUExrfYWdM0c3R7JGdQxMGg6vsoKrJKCoWXur1QmF4ri/uisAUw7LLzy0sLwyEgw1aSI2LLZ/AL/lKVyXgJFRAAcC2fns8wRFP4K5B0R5MYgtD3dORo0M3VDSynI1zDuR504LQy59MNJB435+hQ9gzPGPqJ2AWN4mEImPpU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787244394; c=relaxed/simple;
	bh=uBs/VTGSIaY9Fff96D0pRpuvzA7rP5aI0hJbSmkC/e4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=amZdcZuBhSJC6JN4LaUzieSuDAt45tVUIG6qW1pcy+XGebnYaFrnyiiaoTmn5TIK/xIRB4L1zDSULvIOJmrSyRyofNmpPIusCCU2p3OVMP6kuNEsfDIFDrJYtHZCmU22si/TiqaohMSSLSs2uz+N5eGuiq8LSyHTMIe8lAyzQhQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ffr463EZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ffr463EZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD4D61F000E9;
	Thu, 20 Aug 2026 16:46:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787244393;
	bh=27fegexsqchu096CI4BhjYf7wztc82fQMaBT/9YmZTY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ffr463EZAloPy1Bj8gYVhwhoZUACxjj7DF2IXlwFMci8VpqgwbK/WunzlcZgN1D/+
	 OqWZ1Kvpghdzl+5fdqxrDvd0uh9m+nQ0KzhBiQkOr0Wb9kFt5dQM1BQSb1Jvbbx72M
	 tlHCl/hWo4EtZnlV/bCtyLOI081tJZvZzsV3rXxM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Osipenko <dmitry.osipenko@collabora.com>,
	Gerd Hoffmann <kraxel@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 154/235] drm/virtio: Return proper error codes instead of -1
Date: Thu, 20 Aug 2026 16:56:30 +0200
Message-ID: <20260820145221.133163786@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145216.426568665@linuxfoundation.org>
References: <20260820145216.426568665@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Osipenko <dmitry.osipenko@collabora.com>

[ Upstream commit 4c703f5d6f776eaa6a98611c9b5dfe800fbeb0c8 ]

Don't return -1 in error cases, return proper error code. The returned
error codes propagate to error messages and to userspace and it's always
good to have a meaningful error number for debugging purposes.

Signed-off-by: Dmitry Osipenko <dmitry.osipenko@collabora.com>
Link: http://patchwork.freedesktop.org/patch/msgid/20220630200726.1884320-10-dmitry.osipenko@collabora.com
Signed-off-by: Gerd Hoffmann <kraxel@redhat.com>
Stable-dep-of: 4e1a53892ba7 ("drm/virtio: bound EDID block reads to the response buffer")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/virtio/virtgpu_vq.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/gpu/drm/virtio/virtgpu_vq.c
+++ b/drivers/gpu/drm/virtio/virtgpu_vq.c
@@ -329,7 +329,7 @@ static int virtio_gpu_queue_ctrl_sgs(str
 		if (fence && vbuf->objs)
 			virtio_gpu_array_unlock_resv(vbuf->objs);
 		free_vbuf(vgdev, vbuf);
-		return -1;
+		return -ENODEV;
 	}
 
 	if (vgdev->has_indirect)
@@ -393,7 +393,7 @@ static int virtio_gpu_queue_fenced_ctrl_
 			if (!sgt) {
 				if (fence && vbuf->objs)
 					virtio_gpu_array_unlock_resv(vbuf->objs);
-				return -1;
+				return -ENOMEM;
 			}
 
 			elemcnt += sg_ents;
@@ -725,7 +725,7 @@ static int virtio_get_edid_block(void *d
 	size_t start = block * EDID_LENGTH;
 
 	if (start + len > le32_to_cpu(resp->size))
-		return -1;
+		return -EINVAL;
 	memcpy(buf, resp->edid + start, len);
 	return 0;
 }


