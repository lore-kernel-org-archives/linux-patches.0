Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51BD72D8782;
	Tue, 16 Dec 2025 12:30:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765888201; cv=none; b=djMdR5PCOZvHz7n12vqAs1HsZC5822fTmGhEH7NV/4mzMDipEnQpOEU4HTo1S8sOSOH/FmKeotyQH57nsffSeXzv/9/y0DZ1nrNI+EE4Vvk2H6G0v+2KIhYDUW3BZ1PdquXg/STEsiiU2rEh9C65dQNi+qAP/jzx/KGj/Pi7QZM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765888201; c=relaxed/simple;
	bh=rlWO7YawStpB0NXVw3rULGhQuNLDz+wSorBanrPeleU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Zu2+26vet7xxnljA+U+2r5pSnTo5s9mI676XtERfbiVcirDjwJNDFTxDyCojahlTCbWmXuAPoRvtguPwXRjncBk04W+GICK2+36rGl60ogxeTCs+ln2/cmgCjzLT0T++ov8TvpTvLCf362mBsk/gnGg+hY3xG6Od9MiWY2wzWdI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ucAT2LFY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ucAT2LFY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 297CEC4CEF1;
	Tue, 16 Dec 2025 12:29:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765888201;
	bh=rlWO7YawStpB0NXVw3rULGhQuNLDz+wSorBanrPeleU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ucAT2LFYDsvBE94qEsufsXdHrUq3LPbFiefen1JfuL5Cs7GI0PIPtdx4vz/e9wpjR
	 h1YIj268iet4c6aJnbd0HP84bCam+BjWnr2M8zAR8+5M4DQZxMVZnK1ojJzsXzdbq3
	 oldTsa+EqWzozr2TNNBw2tR8WoWqdkeuLt59Yuq4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Wang <jasowang@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 463/614] virtio: fix grammar in virtio_map_ops docs
Date: Tue, 16 Dec 2025 12:13:50 +0100
Message-ID: <20251216111418.143188736@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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

From: Michael S. Tsirkin <mst@redhat.com>

[ Upstream commit c15f42e09178d2849744ccf064200f5e7f71e688 ]

Fix grammar issues in the virtio_map_ops docs:
- missing article before "transport"
- "implements" -> "implement" to match subject

Fixes: bee8c7c24b73 ("virtio: introduce map ops in virtio core")
Message-Id: <3f7bcae5a984f14b72e67e82572b110acb06fa7e.1763026134.git.mst@redhat.com>
Acked-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/virtio_config.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/virtio_config.h b/include/linux/virtio_config.h
index 78cf4119f5674..6660132258d40 100644
--- a/include/linux/virtio_config.h
+++ b/include/linux/virtio_config.h
@@ -141,8 +141,8 @@ struct virtio_config_ops {
 
 /**
  * struct virtio_map_ops - operations for mapping buffer for a virtio device
- * Note: For transport that has its own mapping logic it must
- * implements all of the operations
+ * Note: For a transport that has its own mapping logic it must
+ * implement all of the operations
  * @map_page: map a buffer to the device
  *      map: metadata for performing mapping
  *      page: the page that will be mapped by the device
-- 
2.51.0



