Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6CB62D948D;
	Thu, 15 Jan 2026 17:20:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768497647; cv=none; b=gFHrntl4wH0iar/UOC0It7CoiVmBw2rgMRDipyQ4PotXr/VwzkVsUUbC8qxighlfeL1HOTmNIl66h6A7lu6MZtI9+5tjpWwRqjp8XCh5Y/z/rdCMYTej4kExGpuhZ3iFusn5RJCeWNDnn+Y+BTOpjArR/iY1NkQ4jNfVZljXzu8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768497647; c=relaxed/simple;
	bh=HzMTQMO8mMYZPQugzA6xfCSExvyg933r/vQ74MCrGM0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ud97qBjrpMwoCCJORm4iM9Fec/7msNTArgBYEWGssQfdyHQr0wldtvDTO+yp2opyRfHWKJjimu/2W8r0uwnf4QT4gIhZ7xmox9qpt9p6uD+AxGBjCa/dDZs/MBBKfcf+lw7Y09I2m7XAe3SlorYOsvaFldP9CPJ/13Sg5vWhpmY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K3coNKdK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K3coNKdK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32AB8C116D0;
	Thu, 15 Jan 2026 17:20:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768497647;
	bh=HzMTQMO8mMYZPQugzA6xfCSExvyg933r/vQ74MCrGM0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K3coNKdK2fPBu9b9oDyl4FdWwR9uxdCEj5G74y7zpUoUI9BPpXNd683w4XDLlzSmy
	 6p9d4vTLB+t9eyU0fsV7izoI25f/dW6k3oDRFy0k4LZhuSVoFu152bwlYvUY8ISwv7
	 bkL3DRlnKqh8dMyHmBILNtX6QwU4htiHIYLnHHSU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Wang <jasowang@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 154/554] virtio: fix virtqueue_set_affinity() docs
Date: Thu, 15 Jan 2026 17:43:40 +0100
Message-ID: <20260115164251.840437482@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164246.225995385@linuxfoundation.org>
References: <20260115164246.225995385@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index b341dd62aa4da..f971986fa0e9a 100644
--- a/include/linux/virtio_config.h
+++ b/include/linux/virtio_config.h
@@ -247,7 +247,7 @@ const char *virtio_bus_name(struct virtio_device *vdev)
  * @vq: the virtqueue
  * @cpu: the cpu no.
  *
- * Pay attention the function are best-effort: the affinity hint may not be set
+ * Note that this function is best-effort: the affinity hint may not be set
  * due to config support, irq type and sharing.
  *
  */
-- 
2.51.0



