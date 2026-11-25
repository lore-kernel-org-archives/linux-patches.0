Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795618291;
	b=S7FD2jjLCWpoplJn1Si55+iPjvd5q1fL93bZ1qAaImql0NMMCQMzIBiNIkz9zZ2dJou4
	 TpXlSo+1DiUubO0G6ucQy6KZHyPkwUatEL7qGLUz+/2+BxnMVOydE4Rs5V6jgZUqeeCti
	 7Ou/xo+QD0uxiW/pHEepdidXTmImbvMmDxERQ7+aXCWsiIZCJl8agHMgMRlIv0QdF1lAt
	 O5QHwG9QIhU0vMTsihpIeC9tdlcf9fz6NnzjhuRePMt0DB2EIFhv5aBX2cCpkLcfHS1oW
	 DXDzIVrsgK4cCdQxPZWfbqz+VvUZ9t3y6q5Al68KmaGnPVB8kN+X5Ncy2qIIBIJiA3Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795618291;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=x8yI8nw7qnNB0/FQJEKBda82TezzvVIphRb1pgnqfaA=;
	b=NjWgAYLS6b4rr5UdcQOaB/kJPw0z2B0D5hNoCJONVFNuEmt7Ws5bP6MK8OFVR1SVjvgf
	 XztRZAKd0xwiylm9uxp9wSL9zGhzdyf2ai/qtNZcX+Fni+Av26VxKi1UVXBHmRdPa+ULp
	 ix03T4XikWo5CUtj0pR0yIOnWxxYSMo9ItpCaZtRCA0Fx3vqMIB83ZOtlZI17/OR76azs
	 uFRmPyDAltt6kQW+jrlAu8sIb5ZANmFc5rv39B8OBEN7c7PDsFfZ2VLjzPCo34E+l677l
	 Qycd3CaP4dSWvxZTWJX25+6taSTwjsCAy3QqLhFO35Q3FH5KRtWec13He23LIq6qT4w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eVAmo6rq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B382606A327;
	Wed, 25 Nov 2026 14:51:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eVAmo6rq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C55A1F000C0;
	Wed, 25 Nov 2026 14:51:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795618291;
	bh=x8yI8nw7qnNB0/FQJEKBda82TezzvVIphRb1pgnqfaA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eVAmo6rqzgovzRZXD0a8pwYHx16+1KRgRSx3Mfpg2lszMERJIWOkDlxIVwT7SeNUh
	 s2QCPjzRUMULxCitB+3CDox7M/ClNL7tvEZk4gm7/xm388nwEufv529qOGQQV+TljA
	 qSbI3yDLrh3ft/audSQOvhtbvujVPivdrD+RDfy0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linfeng Sun <linfeng.sun.dev@gmail.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0233/1005] vhost-vdpa: initialize state before publishing cdev
Date: Wed, 25 Nov 2026 15:26:11 +0100
Message-ID: <20261125143827.197473288@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 81a6fbab8c0d6..ad5d1dfd104d0 100644
--- a/drivers/vhost/vdpa.c
+++ b/drivers/vhost/vdpa.c
@@ -1707,7 +1707,7 @@ static int vhost_vdpa_probe(struct vdpa_device *vdpa)
 		return minor;
 	}
 
-	atomic_set(&v->opened, 0);
+	atomic_set(&v->opened, 1);
 	spin_lock_init(&v->config_lock);
 	v->minor = minor;
 	v->vdpa = vdpa;
@@ -1730,16 +1730,17 @@ static int vhost_vdpa_probe(struct vdpa_device *vdpa)
 
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



