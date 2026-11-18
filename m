Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795036317;
	b=n9Nq5fPkrDM3u+XEl2hrMLWtiV9v7X1oftqljyxWs3hV6H9zBcj6KqElsHcC4RYDX3oE
	 bG8m5vShw85wtyVAFdnmZcMJHFtqUWtSXue3Vp9aifw6SxUlpcnrBhA1qNmDyueN7ho72
	 nhqriHLH9OiiVSKzFp8gqFx7rbJXkiVxjOKt4O+pzecY9JJDHX6cKgHO4frQLeW2c6Ra/
	 nj4/Z/zxmF4Va/ZoiuPtVFGUBgySH1Vn6+JYMh8JK4N2E++RmxOAhrTYKb1XI5tRBKlXI
	 peOhNyv6ob3SGeCOG4lc4rmR6tYywApqrywL2TyjlumZkHPNXiQGuvNjhx8alGQAfzA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795036317;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=SjvbZtjLPa5Ad5lCmFrBcCRxOWRjT82rcAGoi71tYPk=;
	b=SpK/W1rtrsP9lRH4q7OFl1QlnANOIh6qJO57mDum8Q96CfL8GA3NZz++90UHDA4s6TJf
	 +9vWUcT8zBRXlXg4C0/wlAW6ZBDXlshTgfXHS2CNasFWCqyOa7KCmY0EAYcIqJLSl/fP8
	 VytrnqLWBdmW/KQCTO/CJzYVG7UXX/JybQBvzsS+Pe9vULxQePvLg7cjBKkN+rKfCAcL9
	 7Dxi6LeMhi2kik5AqEhNncZkt8ekhBNMtDPZyOn69vUeQsvWbjsxA49Yg29VLDOkVXq8V
	 i43CSIW6qMHnya+EVybcGLFHoqQ7ag5QNtXsmsbehMT6DcUPk+hL59Cw04hKmmNEWfQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qRW1g1AL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F0B6606A31C;
	Wed, 18 Nov 2026 21:11:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qRW1g1AL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8445B1F000C4;
	Wed, 18 Nov 2026 21:11:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795036317;
	bh=SjvbZtjLPa5Ad5lCmFrBcCRxOWRjT82rcAGoi71tYPk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qRW1g1ALlIFKV2LBByV13IGqFbx0B+maDfoxcsMWiY+vNFFbBgeyjOXt0YBeT0Irk
	 Ydjvz/LSw/WeHHv5hdllD7t8tXmgEXixZHvkEwZQG415spfNmDqx8PaT48s1sIl/an
	 gJOgN3AkwkSexUiPqUmnHBy13q87NUC2yOICm7To=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0973/3318] media: tw686x: fix V4L2 device lifetime on probe failure
Date: Wed, 18 Nov 2026 15:26:35 +0100
Message-ID: <20261118150348.901171166@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guangshuo Li <lgs201920130244@gmail.com>

[ Upstream commit ce6c6dd632b3b4a2c2bfc9efd8f656f4d2137dbd ]

tw686x_video_init() registers the V4L2 device, which initializes its
reference count. Successfully registered video devices take additional
references to the V4L2 device as well.

The probe failure paths currently tear down the PCI resources and then
free the channel arrays and the tw686x device directly. This bypasses
the V4L2 device reference count and the tw686x_dev_release() callback.

If a video device still holds a reference, its eventual release will
drop a reference to the already freed V4L2 device. Even when no extra
references remain, directly freeing the device bypasses the lifetime
management established by v4l2_device_register().

After cleaning up the PCI resources, check whether the V4L2 device was
registered. If so, mark the hardware unavailable and drop the driver's
V4L2 device reference, letting tw686x_dev_release() free the backing
objects when the final reference is released. Keep the existing direct
free path for failures that occur before V4L2 device registration.

This issue was found by manual code inspection.

Fixes: 704a84ccdbf1 ("[media] media: Support Intersil/Techwell TW686x-based video capture cards")
Cc: stable@vger.kernel.org
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/pci/tw686x/tw686x-core.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/media/pci/tw686x/tw686x-core.c b/drivers/media/pci/tw686x/tw686x-core.c
index c53099c958ca8..dc6a2cc433d3a 100644
--- a/drivers/media/pci/tw686x/tw686x-core.c
+++ b/drivers/media/pci/tw686x/tw686x-core.c
@@ -241,6 +241,7 @@ static int tw686x_probe(struct pci_dev *pci_dev,
 			const struct pci_device_id *pci_id)
 {
 	struct tw686x_dev *dev;
+	unsigned long flags;
 	int err;
 
 	dev = kzalloc(sizeof(*dev), GFP_KERNEL);
@@ -352,6 +353,15 @@ static int tw686x_probe(struct pci_dev *pci_dev,
 	pci_release_regions(pci_dev);
 disable_pci:
 	pci_disable_device(pci_dev);
+	if (dev->v4l2_dev.dev) {
+		spin_lock_irqsave(&dev->lock, flags);
+		dev->pci_dev = NULL;
+		spin_unlock_irqrestore(&dev->lock, flags);
+
+		v4l2_device_put(&dev->v4l2_dev);
+		return err;
+	}
+
 free_audio:
 	kfree(dev->audio_channels);
 free_video:
-- 
2.53.0



