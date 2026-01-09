Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84AFB33372B;
	Fri,  9 Jan 2026 12:31:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767961865; cv=none; b=qV08nL3SrChxXmZJveQq5EinYPHgjrZg4Y0oNIQBQiAqJzRW4yyfVMuVJZslaK51n85a/ErvR4WcFV8ee7FawqVS6Hz4Az0zmCa+4qXC5ehUz3VASf8Y2V08vEdDv3z1vgIn8VX00lu8xOQrYMV1dPdwocXWokuFjqeEq8m2E5M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767961865; c=relaxed/simple;
	bh=nrgrcTJRa3QZfHtFdPnXknk+BduDYzLUvYMdYHZQqfc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kNnPvC7UUSELf0YOzwZPrAu8s3eIR1O7iDWPZmFiz2dTSQ+kN2ykYPn8XjwKIvwRHaqiRm+T4+n60nm82nrydyZMzJB0khVPtEfjEbFHDl0wIcxjH/RwNquY69MygtK9Q+lHfqScm96NGRZqWErkmhMIzw9VxSM+o1vGYeX9D9I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nwTHZ7KC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nwTHZ7KC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 110DBC4CEF1;
	Fri,  9 Jan 2026 12:31:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767961865;
	bh=nrgrcTJRa3QZfHtFdPnXknk+BduDYzLUvYMdYHZQqfc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nwTHZ7KCJVXWFuujf6cyGPU4oR667ubXqhC5Zw+QcgiREeQNLkqMbe5ncfsEZRgoJ
	 RgV+3v3quOy+vxyEfTGBpVpT+5CthSHtgln17Z+x8Iygfb25WNlu4p6gVOWvoTsEFt
	 4R+XrG12eoaJ2mkw7pgtM4o5k3BEez709zxdeWt4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alok Tiwari <alok.a.tiwari@oracle.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 163/634] virtio_vdpa: fix misleading return in void function
Date: Fri,  9 Jan 2026 12:37:21 +0100
Message-ID: <20260109112123.583272394@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112117.407257400@linuxfoundation.org>
References: <20260109112117.407257400@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 056ba6c5bb083..0d596609e1571 100644
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



