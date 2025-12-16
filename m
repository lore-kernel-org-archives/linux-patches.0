Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F64234029C;
	Tue, 16 Dec 2025 11:32:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765884740; cv=none; b=GHwHBsk9zN4pldnZ3XkDWHWdl/j611QXcp+FXZxW6fcC/7I7j6Lp+6ZEcTl+1EFjGOFR+av+kV1X2GFwcpGqVQahGsjraOsWBq1W10VUCt18TuSXoNZFklORiAViNFxFdklPc9E2wOJAdt4/0HTKYvRMkH1lsWBKOQbLEaE/sxw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765884740; c=relaxed/simple;
	bh=8vsJKrdCM2scu/GOnY8mQo6+JlILvrB83G1Az9LC8zU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QyvdCYFeBwFjdv1sgoUv144dWOnixrB4mQJKgNWJllPlg72dOnrN2P/sQWoWgBVXyhus+bzSyUo7HNbg+VX46f68azSxvjqOQR7egFIz0/8GsMyNgVfiwvWvaMrSOCBGPyx9zVZiB/nDiu2L2n0PyPPRLuebge/Ofc3ITs3so0o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Payccz9h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Payccz9h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E573C4CEF1;
	Tue, 16 Dec 2025 11:32:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765884740;
	bh=8vsJKrdCM2scu/GOnY8mQo6+JlILvrB83G1Az9LC8zU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Payccz9hMxsSwYkVyeEbNsi8/SEgp8Ym47B8+DhAwHI46TlPoUn8w+SBVexQu6Pc3
	 N5XWYXtleqYZiVTh13jEU4rFyAfYvUE6C2VqCZzwBVLU07577vTd4K+jW5+K8q1xk9
	 7lgoxaZpj1RXtl1eYwde0yW23LJDbEPfOiAdxkmw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Wang <jasowang@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 251/354] virtio: fix virtqueue_set_affinity() docs
Date: Tue, 16 Dec 2025 12:13:38 +0100
Message-ID: <20251216111330.009278862@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111320.896758933@linuxfoundation.org>
References: <20251216111320.896758933@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael S. Tsirkin <mst@redhat.com>

[ Upstream commit 43236d8bbafff94b423afecc4a692dd90602d426 ]

Rewrite the comment for better grammar and clarity.

Fixes: 75a0a52be3c2 ("virtio: introduce an API to set affinity for a virtqueue")
Message-Id: <e317e91bd43b070e5eaec0ebbe60c5749d02e2dd.1763026134.git.mst@redhat.com>
Acked-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/virtio_config.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/virtio_config.h b/include/linux/virtio_config.h
index 1255493b7f377..94b3adc7c2dbf 100644
--- a/include/linux/virtio_config.h
+++ b/include/linux/virtio_config.h
@@ -312,7 +312,7 @@ const char *virtio_bus_name(struct virtio_device *vdev)
  * @vq: the virtqueue
  * @cpu_mask: the cpu mask
  *
- * Pay attention the function are best-effort: the affinity hint may not be set
+ * Note that this function is best-effort: the affinity hint may not be set
  * due to config support, irq type and sharing.
  *
  */
-- 
2.51.0



