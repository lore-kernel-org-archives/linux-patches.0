Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96D71387B1D;
	Tue, 16 Dec 2025 12:31:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765888295; cv=none; b=aAYkYgtoh06Vg+P0lEdpkOffBXC7+vjipUyTPFDAN8y1Z8RFEAwWmgpl8SBiP2ZgT5mFvBglb2mZRQnU0gr9sJ61SSZH5aktEUTPmDOtOh17GiT3LSaTteKqzve5vp99e1texPFzj8qGCUqGz8QV2biaMmth+yHXnYrDPtK/5zo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765888295; c=relaxed/simple;
	bh=4HXEqFKUJZ3I48Gb13jz92hFfAr9rQugLrwtE94aqGU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CRe/q8cnIxIjMsHpytn7Jtp8RN234OrpwRevYAyhZT8dwPu0aIvKCNH2kvc5fg2AMPbC2yaz9gNTiiRQoPfBlmdtirdqVtWRU2oMT6sniTFo3o6r28C4mZWqx/FO4YN9qFmMuyVizYm2g13JtK6rvnDHlt6hIK+PI8vsssJUGuc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GuHqpwGj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GuHqpwGj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF842C16AAE;
	Tue, 16 Dec 2025 12:31:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765888295;
	bh=4HXEqFKUJZ3I48Gb13jz92hFfAr9rQugLrwtE94aqGU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GuHqpwGjY1x4noNX5maw5G7Js1HySOMtEJsFBJyiRXmY6VQJPUrNxMdKRtgxJ2kG/
	 80dZArDQDx1RRSfmcoRymL/hgZiEXHdqstRnyt++M215dDhQ3LF+diqo5JS3d3rhqw
	 XVZCxyAXnx50CzRkaXRWTZ8wl1ngyqQbB1MkMFI8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alok Tiwari <alok.a.tiwari@oracle.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 458/614] virtio_vdpa: fix misleading return in void function
Date: Tue, 16 Dec 2025 12:13:45 +0100
Message-ID: <20251216111417.963311889@linuxfoundation.org>
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
index f9a29045eca0d..0a801f67b5996 100644
--- a/drivers/virtio/virtio_vdpa.c
+++ b/drivers/virtio/virtio_vdpa.c
@@ -80,7 +80,7 @@ static void virtio_vdpa_set_status(struct virtio_device *vdev, u8 status)
 {
 	struct vdpa_device *vdpa = vd_get_vdpa(vdev);
 
-	return vdpa_set_status(vdpa, status);
+	vdpa_set_status(vdpa, status);
 }
 
 static void virtio_vdpa_reset(struct virtio_device *vdev)
-- 
2.51.0



