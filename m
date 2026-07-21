Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25EBF413D69;
	Tue, 21 Jul 2026 19:00:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784660489; cv=none; b=hgczhFGjxLu/dXChbaEz4Y8cpOu37Q+UhibUKNEQH2tJh3Vd/gDurmC9Fej9p6iLLlhWFNsC+aFd/MIC1qvUJMBIKBeZEOtqsTkNjYGni2+PxvIaZxlHAOSnRWiPV34aY8GGF5ffF6vLl054bz00AF8aVefrGWIIdc9c89j4dhI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784660489; c=relaxed/simple;
	bh=pCRQtxQ9AOX1OHxir1I9dnQ+oVXeGLJ63Kq+dU/jtHU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H6NuEOuMyM/mLEAlK2TXl4wsL9GWjs87li68JpBlyAAEIlv+Bm1KA2BRshrmcmsBvqVFpIGchHRTh7qW+kZlzK8os4PW686PPcqdWXqwGIUx9BiUvaI+8AhnsW9y+2h3m0bWuUOWA9beJFQTap3jt4q+mnIe8d/E2Xol1TAz9sU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pAKkTXP3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pAKkTXP3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B6651F000E9;
	Tue, 21 Jul 2026 19:00:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784660428;
	bh=4DRgfGQYOPa/DgRCHf4fhyaVAlXsowhjtJefo9BeIvo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pAKkTXP3786n1H5Mm/WuYqabeZCrnN91dBNm9ms1trx8ZMkLFPkDc+qVpjFn4INz0
	 3uA7NnzJL1pcqit6mT8FjKoGovPIz2QYOQK3Zp7ZQ5IxsnuaNo4Xg6tjqgms4QbIbb
	 /xNv0reAWWDZ1/5EOrUI4WDZh/C64t4zdowwEFUI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luis Felipe Hernandez <luis.hernandez093@gmail.com>,
	Christian Fontanez <christfontanez@gmail.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0977/2077] virtio: add missing kernel-doc for map and vmap members
Date: Tue, 21 Jul 2026 17:10:50 +0200
Message-ID: <20260721152615.862853814@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Fontanez <christfontanez@gmail.com>

[ Upstream commit ac2c52e9f869897b6f4c0a54cf07da380ef2b8d6 ]

Commit bee8c7c24b73 ("virtio: introduce map ops in virtio core") and
commit b16060c5c7d5 ("virtio: introduce virtio_map container union")
added 'map' and 'vmap' members to struct virtio_device but did not
update the kernel-doc comment block. This caused 'make htmldocs' to
emit warnings:

  ./include/linux/virtio.h:188 struct member 'map' not described in 'virtio_device'
  ./include/linux/virtio.h:188 struct member 'vmap' not described in 'virtio_device'

Add the missing entries in struct-declaration order to match the
existing convention in the file. After this patch, 'make htmldocs'
no longer emits these warnings.

Fixes: bee8c7c24b73 ("virtio: introduce map ops in virtio core")
Fixes: b16060c5c7d5 ("virtio: introduce virtio_map container union")
Reported-by: Luis Felipe Hernandez <luis.hernandez093@gmail.com>

Signed-off-by: Christian Fontanez <christfontanez@gmail.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Message-ID: <20260519013321.32511-1-christfontanez@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/virtio.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/linux/virtio.h b/include/linux/virtio.h
index 3bbc4cb6a6727e..bf089e51970ec6 100644
--- a/include/linux/virtio.h
+++ b/include/linux/virtio.h
@@ -157,11 +157,13 @@ struct virtio_admin_cmd {
  * @id: the device type identification (used to match it with a driver).
  * @config: the configuration ops for this device.
  * @vringh_config: configuration ops for host vrings.
+ * @map: the map operations for mapping virtio device memory.
  * @vqs: the list of virtqueues for this device.
  * @features: the 64 lower features supported by both driver and device.
  * @features_array: the full features space supported by both driver and
  *		    device.
  * @priv: private pointer for the driver's use.
+ * @vmap: the map container with transport- or device-specific metadata.
  * @debugfs_dir: debugfs directory entry.
  * @debugfs_filter_features: features to be filtered set by debugfs.
  */
-- 
2.53.0



