Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70E993557E8;
	Tue, 16 Dec 2025 11:57:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765886246; cv=none; b=d6yl86F9SbAdtbDMpgL8qeklfoG96tPmbYwhLasQcScSGxjHUWU75fNmOgPIGi1JQGLrLBh5LtKdFRsC4Y2jGdlrdyL7DrWnVGki0MSr0n8roRoJS1klWa+FQJTpjJacDiBmqa2pVislvqZYNTj5lWlL3j4+Zs2XNYtKBML21mE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765886246; c=relaxed/simple;
	bh=cFHyXDWxO62Jg6FFx00gU/mSfrd6iKv3bBTbkF7FM88=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jINYCWAK6Z4jzZ4niWEjqpV2urnsdP/w49VHDEimyIvSgxEwFQxFKKkF0+xEzxBijZ5d6woH5uCjYlxNvTLUN8espEEZdQGaHBDYdxIc6jawNSS6oeWMa0JXGHvOoTvio8A1lDvRhCSM67Qt3zToqXbPechA5PJ4zP5fdOFfSjQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qO/ql+9k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qO/ql+9k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3891C16AAE;
	Tue, 16 Dec 2025 11:57:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765886246;
	bh=cFHyXDWxO62Jg6FFx00gU/mSfrd6iKv3bBTbkF7FM88=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qO/ql+9klBOSf4FmlZqB5C6ebyh7XwxGY0cClitIJvbfqb3ckypxA437BSr7/6+Te
	 naw0+WloXX2H5CviIES+rWkLqUe96TcDHZSUV5NGxk0Q+N290sEcEl/pghONvnPUUE
	 MEvCddCgxmEm6yZCt/dA2cmrBbj/9Ob0j4UB2pjM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Wang <jasowang@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 379/507] virtio: fix virtqueue_set_affinity() docs
Date: Tue, 16 Dec 2025 12:13:40 +0100
Message-ID: <20251216111359.190524125@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111345.522190956@linuxfoundation.org>
References: <20251216111345.522190956@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
index 2e7ead07376d1..ba621d86517c3 100644
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



