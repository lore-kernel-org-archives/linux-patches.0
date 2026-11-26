Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795704327;
	b=4I8IUuuqHIHC+6CG2KcUM6A/MMulM/tYOmXrMy3G714ZlpJ4pIxX7RPsecPQ9bMLi1BX
	 MuXGPtDBK9zAwv2G/Cq/03/jd3V/ZsaWTeMqcf7PKTBm+lLe4aa0X3F+6oMNIcM4OP+LR
	 fEjXOHiqcB1g0m2aVIZf6GKOvxjBmKMavGfueUvsAntMneO2koMpTFlkkGW7M9to+b9Ux
	 LwRpQbyUEylw9aMeGkZK2mUNbbunQVolHW2DYQlvu2F1QM2fXai1da1B9Rfr8N7s2U7wM
	 AT7dGpxTAyVoADP+wywpJidyzdsBHIdaYkNCunRhNMsKe1gO7P9YbnV4ug+F6DPvIlg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795704327;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=jktKKKoZXe9Zry+tOUXdNxVGgVnHOboV1oFmKvD5rrI=;
	b=vMMfd0maz4daZcInAIuk/sQfkPRRpYwn65xJQluIQasOrCWFNi0qF0BQp1FsAH82mijC
	 3Kjr/iJzOqKpt9pn8u/NAOelfm5eUjwPj7KfjlSA8+x5GWecSIADImU9KDO+oshlc0PqX
	 R4OvPA3TU6o3A5qV6Q3YfThQ81FLORAIzlmqJeOKL/HcQl3z5E7W/Sri/HGDUWTxdfWlA
	 yL2RbF5jGl5uQp0otlGSOp5Z53UnJWnFrBDD8SIfntTCIixON06aSpWvI2Uq9l2wWDrSB
	 wIFi44IxzhZtMcUkpnqXl+ThctYTwEckg/3jV428zlSRnYcgYstotat3CVvesedEBfQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="GJMg/wl3";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 355B9606A321;
	Thu, 26 Nov 2026 14:45:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GJMg/wl3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BE0F1F000C0;
	Thu, 26 Nov 2026 14:45:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795704326;
	bh=jktKKKoZXe9Zry+tOUXdNxVGgVnHOboV1oFmKvD5rrI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GJMg/wl3cpLYCiAbgm06Q05ovmKtvLI/s3M5+ZwmJRgLhjyss7vBvWmv4LL4uliay
	 O2wnbx0wreRJ6Ws9rz1Y6UiY+8dx2LgsuS5GCZVAKbtDORNpaWdHVPviywaw41Rmk5
	 8BKd8es0IpefPGSK27ozRVfm1dxmhVKNXrHEb/8A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eli Cohen <elic@nvidia.com>,
	Anirudh Rayabharam <mail@anirudhrb.com>,
	Jason Wang <jasowang@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 048/265] vhost: allow batching hint without size
Date: Thu, 26 Nov 2026 15:36:18 +0100
Message-ID: <20261126143608.450603294@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126143605.076581697@linuxfoundation.org>
References: <20261126143605.076581697@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jason Wang <jasowang@redhat.com>

[ Upstream commit 95932ab2ea07b79cdb33121e2f40ccda9e6a73b5 ]

Commit e2ae38cf3d91 ("vhost: fix hung thread due to erroneous iotlb
entries") tries to reject the IOTLB message whose size is zero. But
the size is not necessarily meaningful, one example is the batching
hint, so the commit breaks that.

Fixing this be reject zero size message only if the message is used to
update/invalidate the IOTLB.

Fixes: e2ae38cf3d91 ("vhost: fix hung thread due to erroneous iotlb entries")
Reported-by: Eli Cohen <elic@nvidia.com>
Cc: Anirudh Rayabharam <mail@anirudhrb.com>
Signed-off-by: Jason Wang <jasowang@redhat.com>
Link: https://lore.kernel.org/r/20220310075211.4801-1-jasowang@redhat.com
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Tested-by: Eli Cohen <elic@nvidia.com>
Stable-dep-of: b179f21d2d8a ("vhost: reject invalid IOTLB update permissions")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vhost/vhost.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index 9e9455054ce6d..7cf2b5a2cceeb 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -1171,7 +1171,9 @@ ssize_t vhost_chr_write_iter(struct vhost_dev *dev,
 		goto done;
 	}
 
-	if (msg.size == 0) {
+	if ((msg.type == VHOST_IOTLB_UPDATE ||
+	     msg.type == VHOST_IOTLB_INVALIDATE) &&
+	     msg.size == 0) {
 		ret = -EINVAL;
 		goto done;
 	}
-- 
2.53.0



