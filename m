Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4C23399011;
	Thu, 15 Jan 2026 17:20:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768497644; cv=none; b=uvCdmQPTTagEK4VNY3cqPbbAb0d0fqKyqFSw59KplD/xHvpbyNM6cV55QFMEIMIixcjSIqZyT2lJzbzKzlcEoRTtigaJrgIB5hk/GOlTlvV4xeELo5VPXnB/ASvvHQO9DP967ndU7p71hU0E+uKLaxqXHthDNjI5NRb8nNoacN8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768497644; c=relaxed/simple;
	bh=FqFvW4B6R6wESq5vQwukEU2fyQzyZMbn5kGU3ighNis=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u4skJoXtGFtq8hpmQTTnujS9RGZO/2EiDZrInU6ugeXGPdu/O/rs2E23al4Y5OHAe3PfHbIxqxdnLh0x1erPIcVrkMCYm6jgCjs+dJvj0ln+DlUSmqs73orbWKz8Dcs715xSF1xmffTM6o67Da3shvBZ4TwxMKrvMNHRqhwApd0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=om+fG5Ci; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="om+fG5Ci"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DDDEC116D0;
	Thu, 15 Jan 2026 17:20:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768497644;
	bh=FqFvW4B6R6wESq5vQwukEU2fyQzyZMbn5kGU3ighNis=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=om+fG5CiX3TR2F6KDzqGJH1QpjJkfrALf7MpxQZhnETVb0CJWVn8HnGY6f40gIrLX
	 YW5NSh7csqWilXrSB5N6tbcuf53pxNWuKEz3Boi+QLYre2U19CYokFM4J16hTRxrpQ
	 OPAuEESVHEtYu8wH+djvXM/RRYsHuPuGkAzb3hrw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alok Tiwari <alok.a.tiwari@oracle.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 153/554] virtio_vdpa: fix misleading return in void function
Date: Thu, 15 Jan 2026 17:43:39 +0100
Message-ID: <20260115164251.804214828@linuxfoundation.org>
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
index a85a10d65973f..af085b3df4562 100644
--- a/drivers/virtio/virtio_vdpa.c
+++ b/drivers/virtio/virtio_vdpa.c
@@ -92,7 +92,7 @@ static void virtio_vdpa_set_status(struct virtio_device *vdev, u8 status)
 {
 	struct vdpa_device *vdpa = vd_get_vdpa(vdev);
 
-	return vdpa_set_status(vdpa, status);
+	vdpa_set_status(vdpa, status);
 }
 
 static void virtio_vdpa_reset(struct virtio_device *vdev)
-- 
2.51.0



