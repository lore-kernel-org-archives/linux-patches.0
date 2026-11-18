Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795054013;
	b=yIawon12zq6zhm1UrucwFbxVZCfPEuThUzeAYVVBKj5k4hbbv0W9VRzc7qBSHZ8dq2N0
	 uuo7QpEmPvxOOJtFUqfWd8wmooXxo4yoaBsjbZEzruKMOQ8y181GZ5d7iCiA1Ha9DWe7v
	 ZhisPu8Ngc5AqZIN+koZzvYoU8DPe6N5kOBXpV215WGzGmFE7XoV89Bz9vk+J4UPNLifu
	 BR4LqdGVxjwQvSvKMaJ4xtqekEWuq/0CGeItCxsNEUAtaiEI7wevVAXpa65z8mHh+zQD7
	 YAN6eTBXZryozKmh6bRNGkkm6KYcCJpd2xj5VHhkGJbSuJ/j5YVXMPHCu+IFqUbEhIA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795054013;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=WRMjwiMeoE4KEDO6vjiievSHxX/4XXxBj9k0FDDweB0=;
	b=zPDScTZwhgWRn3q1qI7mbqv4GAnFAbkjDekZS6Pej5qxDTskDhYfzXoqrAs4Ch76dj1h
	 H5X/6OOWxkAyfc9d7zhTYcAibZjRvFQPr/rk52qPD1IcRMafKQ6Rcx97cnC8akiqhA/7V
	 t99nnym1lbiO8I3K2goqojXv6Tk66/tlN9MKdhxUfJIz1dnb6wSkCZRB9VlvVqPdejnRH
	 5DjjpZRxdLS61lkXUtaaHYQIe10gqtXY3syDnmyBSstcgiRbicuGBgSiUL5HYoiKw/zny
	 kABp60hGSBvOLPhFKnEJnBlJyNZ73qnCcPtNRikmmcOEBXp9et+lItPOphSjk7q8d6Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ieePCvLk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40C2E606A33A;
	Thu, 19 Nov 2026 02:06:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ieePCvLk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F76C1F000C8;
	Thu, 19 Nov 2026 02:06:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795054013;
	bh=WRMjwiMeoE4KEDO6vjiievSHxX/4XXxBj9k0FDDweB0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ieePCvLk0BubJHBJmWvBWWBilVaWp3AzAZxrGDomir82DhkjWkaXHl0vqN7WJ/fqN
	 V0KI+toB6nEDe10759gD0AFrqZ2xnVuNiccyiTryeiJWNpspsGkFq+xIUrlMzC927Q
	 NYMrGvhLVMRlK4mYVqIXe4Gm4OY0y+YRMt6op+gc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Robert Foss <robert.foss@linaro.org>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1125/2214] media: camss: vfe: Dont read hardware version needlessly
Date: Wed, 18 Nov 2026 15:46:41 +0100
Message-ID: <20261118150057.086231607@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Robert Foss <robert.foss@linaro.org>

[ Upstream commit 8cc80c606bd1db7febd43d900fc129520580beab ]

vfe_set_power() is invoked a few times, which causes a lot of
VFE HW version prints.

Secondly there is no real reason for calling hw_version_read() from
this location specifically, since it does nothing more than print
the VFE HW version.

A better location for the hw_version_read() call would be somewhere
which is only executed once per VFE unit.

Signed-off-by: Robert Foss <robert.foss@linaro.org>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Stable-dep-of: e5d4b0e69a40 ("media: qcom: camss: vfe: Fix VFE reset while another line is streaming")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/qcom/camss/camss-vfe.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/media/platform/qcom/camss/camss-vfe.c b/drivers/media/platform/qcom/camss/camss-vfe.c
index 8beea27004ca3..72a26dea84212 100644
--- a/drivers/media/platform/qcom/camss/camss-vfe.c
+++ b/drivers/media/platform/qcom/camss/camss-vfe.c
@@ -714,8 +714,6 @@ static int vfe_set_power(struct v4l2_subdev *sd, int on)
 		ret = vfe_get(vfe);
 		if (ret < 0)
 			return ret;
-
-		vfe->ops->hw_version_read(vfe, vfe->camss->dev);
 	} else {
 		vfe_put(vfe);
 	}
@@ -1302,6 +1300,7 @@ int msm_vfe_subdev_init(struct camss *camss, struct vfe_device *vfe,
 		return -EINVAL;
 	}
 	vfe->ops->subdev_init(dev, vfe);
+	vfe->ops->hw_version_read(vfe, dev);
 
 	/* Memory */
 
-- 
2.53.0



