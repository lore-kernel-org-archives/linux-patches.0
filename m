Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70FB143152;
	Tue,  2 Jul 2024 17:20:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719940847; cv=none; b=LVihrrmWIlco/rE5QuSJsr9Ddss/mOn9ca9RvcVzCliyHVFKVjdFbZdaTeKdV3mrxZyC4S+Zacn9XCBWR0CHkCIm6vR/c6LeAo+IOO4S33u9obeOQE59ibkFtWXtTTCETwcQn76Nmz7ClVlisEvWPJF1TcxFQl5FO7zs1ZbjISk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719940847; c=relaxed/simple;
	bh=C0NOzj7nVz5WXXNeLc7KP17J2PiD2BLSATOsu6opTKA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pmG78NlLqFlZ3cYdVW6dch8z7JV2A92Qrpcv78ZD8r4wv5uv2yUDocuk3EaJ2gE0EJNzUXEAVvSUfiwvSYzQPA4dya1iOB05I91tD3+TUtnt+XPeiybM9vHFgdRY/KcRtcTmFDPGCaMPoF3Ud5N1s7UbrI+eGlnIAybMt4gKFxE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BPU4ECkc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BPU4ECkc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4DE7C116B1;
	Tue,  2 Jul 2024 17:20:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719940847;
	bh=C0NOzj7nVz5WXXNeLc7KP17J2PiD2BLSATOsu6opTKA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BPU4ECkcdWpk+vsZHYw/l6vbhLrIKdqn3F3gBZQBfvVc5/yWbm23f4I9vhdHDjjUO
	 1FBaXGSaHt/ayWf0q9ERkHrDy2N9S+KZwVkUjdnavlwxJL4tUrLgF1uIJd0NhR68Ec
	 KXyxb0AoafSk6inn6G5Q+iOMmTOq5CQ0F2NEpyl0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Wang <jasowang@redhat.com>,
	Xie Yongji <xieyongji@bytedance.com>,
	=?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>,
	Maxime Coquelin <maxime.coquelin@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 054/163] vduse: validate block features only with block devices
Date: Tue,  2 Jul 2024 19:02:48 +0200
Message-ID: <20240702170235.108027545@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702170233.048122282@linuxfoundation.org>
References: <20240702170233.048122282@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maxime Coquelin <maxime.coquelin@redhat.com>

[ Upstream commit a115b5716fc9a64652aa9cb332070087178ffafa ]

This patch is preliminary work to enable network device
type support to VDUSE.

As VIRTIO_BLK_F_CONFIG_WCE shares the same value as
VIRTIO_NET_F_HOST_TSO4, we need to restrict its check
to Virtio-blk device type.

Acked-by: Jason Wang <jasowang@redhat.com>
Reviewed-by: Xie Yongji <xieyongji@bytedance.com>
Reviewed-by: Eugenio Pérez <eperezma@redhat.com>
Signed-off-by: Maxime Coquelin <maxime.coquelin@redhat.com>
Message-Id: <20240109111025.1320976-2-maxime.coquelin@redhat.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vdpa/vdpa_user/vduse_dev.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/vdpa/vdpa_user/vduse_dev.c b/drivers/vdpa/vdpa_user/vduse_dev.c
index df7869537ef14..d91fe7e0733b6 100644
--- a/drivers/vdpa/vdpa_user/vduse_dev.c
+++ b/drivers/vdpa/vdpa_user/vduse_dev.c
@@ -1662,13 +1662,14 @@ static bool device_is_allowed(u32 device_id)
 	return false;
 }
 
-static bool features_is_valid(u64 features)
+static bool features_is_valid(struct vduse_dev_config *config)
 {
-	if (!(features & (1ULL << VIRTIO_F_ACCESS_PLATFORM)))
+	if (!(config->features & BIT_ULL(VIRTIO_F_ACCESS_PLATFORM)))
 		return false;
 
 	/* Now we only support read-only configuration space */
-	if (features & (1ULL << VIRTIO_BLK_F_CONFIG_WCE))
+	if ((config->device_id == VIRTIO_ID_BLOCK) &&
+			(config->features & BIT_ULL(VIRTIO_BLK_F_CONFIG_WCE)))
 		return false;
 
 	return true;
@@ -1695,7 +1696,7 @@ static bool vduse_validate_config(struct vduse_dev_config *config)
 	if (!device_is_allowed(config->device_id))
 		return false;
 
-	if (!features_is_valid(config->features))
+	if (!features_is_valid(config))
 		return false;
 
 	return true;
-- 
2.43.0



