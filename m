Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795624476;
	b=k8b3nklCshTAyXXKW+7abWnRInwJjTVTd2llZH8lkBia3MTn596OuE1NnQsWQyrEycR2
	 a8aIXvO+HYhScQXWRI6mvqJSNLD8QaDMdJ3E6FzK82a7IsHDNZ6SIgQOpNyaYG4dta8JU
	 +KlmewJN5xkm7nGa+k1qOCRzdlYTQOA0Xus7AyKs3AsjQSIlpb0bL14O+qrIEmcmM1BEj
	 P05tdHPWg/91c7HvIXyDYzF2PfQuwCloFlqc9Y5ad01f8Z54z5WlS/Hkusq0gMTKv9Eyc
	 Uun+t/9xiLm62DMiRJLp4oJYNZtbvKOrFerlC0+J7dNtYB8MN7meRNsFGrvgDRT4wTg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795624476;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=KzN5lXQS+0LXFPC9nyE17t9w6vOShgNzAWXhm3hY7T0=;
	b=X4PsWJHyMi41zj+skeAaMARelHn/WY52fmsGIHWfCxLBikthoSDZ44hJUrdTROvBzPQf
	 SHdqF+n5w5egaTv60EFGNuV5Nw8bLhagnGEAVyV7RDq7cHh3kv8MT4uqW9lj6C1VFdC5h
	 +/Kkit733Lx9gDSR/vOGaAW0X7JYvf3xd9NuNARtJLihMSGW1JAaFf68yGZCx6FOmWEXL
	 gtHXeCBbV0CELo1O5mfdr9FkRzQlF5GmN7D6NSNnBCWuUpADNRMD7VmI7WF3XQ/Ms557X
	 Al/M8CufEpxNLBQgifVjKPhXCnEvNogRv/72SNGWiuZVaQ+zM6PjorDsbeRaV4oFYOQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=E4gvgaMy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1A3F606A33B;
	Wed, 25 Nov 2026 16:34:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=E4gvgaMy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DBC01F000D2;
	Wed, 25 Nov 2026 16:34:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795624476;
	bh=KzN5lXQS+0LXFPC9nyE17t9w6vOShgNzAWXhm3hY7T0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=E4gvgaMyoU4/i163gW3SXCvGxDu9CL3hPYr2XvFZMl62iQi+HlxQrmLdc7OFTDlHt
	 vLtO+gT9kdyAqIcpKug4WSuOxnuAC13WnYb+FwTGtV7YvuNJGApCSlp0g06ncnWXWP
	 Mc/pce0J7qJtr87Co/GcpXhJBnZb2cJjuRKC937U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linfeng Sun <linfeng.sun.dev@gmail.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 178/816] vhost-vdpa: initialize state before publishing cdev
Date: Wed, 25 Nov 2026 15:28:46 +0100
Message-ID: <20261125143853.311165740@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Linfeng Sun <linfeng.sun.dev@gmail.com>

[ Upstream commit 4b03d1e7f13613af708441a061556de99891a516 ]

Initialize the completion and as hash buckets before cdev_device_add()
makes the device accessible.

Fixes: 4c8cf31885f6 ("vhost: introduce vDPA-based backend")
Assisted-by: OpenAI-Codex:GPT-5.6
Signed-off-by: Linfeng Sun <linfeng.sun.dev@gmail.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Message-ID: <20261011-fix-null-pointer-in-vhost_vdpa_release-v2-1-66ba929971ce@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vhost/vdpa.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
index 9e881c4d25ba3..011e36847b4ee 100644
--- a/drivers/vhost/vdpa.c
+++ b/drivers/vhost/vdpa.c
@@ -1703,7 +1703,7 @@ static int vhost_vdpa_probe(struct vdpa_device *vdpa)
 		return minor;
 	}
 
-	atomic_set(&v->opened, 0);
+	atomic_set(&v->opened, 1);
 	spin_lock_init(&v->config_lock);
 	v->minor = minor;
 	v->vdpa = vdpa;
@@ -1727,16 +1727,17 @@ static int vhost_vdpa_probe(struct vdpa_device *vdpa)
 
 	cdev_init(&v->cdev, &vhost_vdpa_fops);
 	v->cdev.owner = THIS_MODULE;
+	init_completion(&v->completion);
+	for (i = 0; i < VHOST_VDPA_IOTLB_BUCKETS; i++)
+		INIT_HLIST_HEAD(&v->as[i]);
 
 	r = cdev_device_add(&v->cdev, &v->dev);
 	if (r)
 		goto err;
 
-	init_completion(&v->completion);
 	vdpa_set_drvdata(vdpa, v);
 
-	for (i = 0; i < VHOST_VDPA_IOTLB_BUCKETS; i++)
-		INIT_HLIST_HEAD(&v->as[i]);
+	atomic_set_release(&v->opened, 0);
 
 	return 0;
 
-- 
2.53.0



