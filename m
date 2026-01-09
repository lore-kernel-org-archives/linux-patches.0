Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE7C62C21E6;
	Fri,  9 Jan 2026 11:58:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767959927; cv=none; b=la+jZ4Nvg7YQNWIV0AG1GLAvpLGS8aJbR5z+GpAT142NTnpNb/CcwY7ZavfiC8skg/oTHsZ/U4V0Hc7tFKS8nWYVylAKPAQUob9AgO2g1xVpoDdFSHlcNvh3PKz+EwHJLzObJAzTcyhmnDyDIa2odS3XYrXLjF8v6c+yMKU7WjI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767959927; c=relaxed/simple;
	bh=iAj7Zs4BpZc2mYo9N9qnJlVai5JyCZ4zMbZ38otFKAI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LgtUwV2WNtmVdLC2I0yQ0jN4pn6RQDVVFqfbHWU2DGadi7x0bsjp2yuk//XBGeufSv96l65VGc/Bn+wPn3grmlIm8zGGjOZ3ES3X8vhrMGpWjiSUKhkkndXAzX6Hc170erg/MQO7icy5QhmByT8/GtvxL6Rw3rDE2i3bGrqal5E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fyk0U5v+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fyk0U5v+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60B3BC4CEF1;
	Fri,  9 Jan 2026 11:58:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767959927;
	bh=iAj7Zs4BpZc2mYo9N9qnJlVai5JyCZ4zMbZ38otFKAI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fyk0U5v+QO3qHdmwOnoFeus/Drs4uwMNS8dG71yte7gwe6VfCkZ8pKB3rNLxHTVY9
	 a3XdcHypZ2YDY5l5KIhdpeBNjz6xd3T/5t98LsQJu+orI6gpCdn0yxBY+8k9/Jstx4
	 g6W22kr8A2MdGAJTNSKVTZh04HHokUxjaOZcSR14=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alok Tiwari <alok.a.tiwari@oracle.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 225/737] virtio_vdpa: fix misleading return in void function
Date: Fri,  9 Jan 2026 12:36:04 +0100
Message-ID: <20260109112142.465821657@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alok Tiwari <alok.a.tiwari@oracle.com>

[ Upstream commit e40b6abe0b1247d43bc61942aa7534fca7209e44 ]

virtio_vdpa_set_status() is declared as returning void, but it used
"return vdpa_set_status()" Since vdpa_set_status() also returns
void, the return statement is unnecessary and misleading.
Remove it.

Fixes: c043b4a8cf3b ("virtio: introduce a vDPA based transport")
Signed-off-by: Alok Tiwari <alok.a.tiwari@oracle.com>
Message-Id: <20251001191653.1713923-1-alok.a.tiwari@oracle.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Acked-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/virtio/virtio_vdpa.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/virtio/virtio_vdpa.c b/drivers/virtio/virtio_vdpa.c
index 06ce6d8c2e004..6855cc22ea96e 100644
--- a/drivers/virtio/virtio_vdpa.c
+++ b/drivers/virtio/virtio_vdpa.c
@@ -93,7 +93,7 @@ static void virtio_vdpa_set_status(struct virtio_device *vdev, u8 status)
 {
 	struct vdpa_device *vdpa = vd_get_vdpa(vdev);
 
-	return vdpa_set_status(vdpa, status);
+	vdpa_set_status(vdpa, status);
 }
 
 static void virtio_vdpa_reset(struct virtio_device *vdev)
-- 
2.51.0



