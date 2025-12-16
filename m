Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08F5DAD2C;
	Tue, 16 Dec 2025 12:30:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765888211; cv=none; b=bPDTyVXXg6MEYAu1ivyBpzSwq7Xt7Qs/DJ0mPYNQcUknaW83yydI6Hs58W9dsF8Sl+Te24jArcdjEeuitCZAH0f2QA6XJrf0ZRqTo3Dzd/A6rk+FClIjFrc21EDtw6WKfJW+ymR/hNxt1yT87QQ3Li/nop5sMWh6Xqy+u8OXV+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765888211; c=relaxed/simple;
	bh=Y3tm8xD78fzAlz9eUwwyXlFSBpAoSxw6nm8vwWIHa0M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FPio5E+BesZiGPc9q4WwFtxWDiIAg0RYpZzGzPQN7TzuUMJpbmjFmthEq6KEw3uKAD+vH12MDkuET40QmA9CXek+Rywf6XuvmisnaN7Xx8BR6PPmGiFoo3k4DjODANFIJ+VmU7JnVomBeyR0Vod+s9rKEdfHWF0t0J0tDssMS9I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ON+rP0bH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ON+rP0bH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F6EFC16AAE;
	Tue, 16 Dec 2025 12:30:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765888210;
	bh=Y3tm8xD78fzAlz9eUwwyXlFSBpAoSxw6nm8vwWIHa0M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ON+rP0bHhk58+RzIJfYtQpUQtM+ZahtaM1esyO+PQuylSsftNSX4YGg1RK6ifkIBh
	 0wLunGQERMLVWPtvC3ASWfZI9MQZVGsWlA1YbnV0ULqjoAtYvxLEt+EgDczpAOdRCb
	 5zXrON0brtNGKSDuAFBAJhWew+7qUmjVil2uDcf8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Wang <jasowang@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 466/614] virtio: fix map ops comment
Date: Tue, 16 Dec 2025 12:13:53 +0100
Message-ID: <20251216111418.254378459@linuxfoundation.org>
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

[ Upstream commit deb55fc994e3dc38f139c0147c15fc2a9db27086 ]

@free will free the map handle not sync it. Fix the doc to match.

Fixes: bee8c7c24b73 ("virtio: introduce map ops in virtio core")
Message-Id: <f6ff1c7aff8401900bf362007d7fb52dfdb6a15b.1763026134.git.mst@redhat.com>
Acked-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/virtio_config.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/virtio_config.h b/include/linux/virtio_config.h
index 1a019a1f168d5..a1af2676bbe6a 100644
--- a/include/linux/virtio_config.h
+++ b/include/linux/virtio_config.h
@@ -177,7 +177,7 @@ struct virtio_config_ops {
  *      map: metadata for performing mapping
  *      size: the size of the buffer
  *      vaddr: virtual address of the buffer
- *      map_handle: the mapping address to sync
+ *      map_handle: the mapping address that needs to be freed
  *      attrs: unmapping attributes
  * @need_sync: if the buffer needs synchronization
  *      map: metadata for performing mapping
-- 
2.51.0



