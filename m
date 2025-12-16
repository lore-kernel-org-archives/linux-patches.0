Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 471653557E7;
	Tue, 16 Dec 2025 11:57:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765886231; cv=none; b=otkUphDV+wf0ZJv8Be44M7reSM8xg9JZNl2NEEmXKPq68cEO9djm4PeJYvxfFi/D7nT1nO2diQ0LQGxyOgNgrjJSoJpzH0vcnebG+hvB8rNtm9aF1AVK5EccvPNkju6r2oK5txS9ZJjIMtBCwiALXDCnAJcCUhCBsOK6XAqPIEk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765886231; c=relaxed/simple;
	bh=23tLCtpUl2z/qmUVGzbavof4B/FeIGBD9zTfvauCPWo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jW1ltN8J875sq+G2sXqsX3ZZW+8CE6mAujLRh/7wFvqTIW61LuTvJpnlmnmuE+wejEc7tE/9LAUSmP+59rfnEesbeczu0ArAiGiTSlxyzhJTy+DzMQ6/Zt4RBsS8M4KdNbx05yWnE0a3nxD5peHPjQf1/KFTQpLOAac/fIr/XfI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PPJyHG3D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PPJyHG3D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F335C4CEF1;
	Tue, 16 Dec 2025 11:57:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765886229;
	bh=23tLCtpUl2z/qmUVGzbavof4B/FeIGBD9zTfvauCPWo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PPJyHG3DBb+o65ozbG8zeq3iTpzuIKeigkauCZiS+T+qrO9qIzSTpJPr7xZltpCsp
	 kamH+UnTYmmIzVXkzmoqevwC3PouJIwEHVzpEuuzW12yZD4NDTeaHbTH0czI6q84tB
	 WVq9lGLNtpXw77Q+ipmb9HbsG/XJQNWLH3S0UCx4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alok Tiwari <alok.a.tiwari@oracle.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 375/507] virtio_vdpa: fix misleading return in void function
Date: Tue, 16 Dec 2025 12:13:36 +0100
Message-ID: <20251216111359.046635305@linuxfoundation.org>
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
index 657b07a607881..1abecaf764654 100644
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



