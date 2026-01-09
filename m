Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35ABF336EDA;
	Fri,  9 Jan 2026 12:31:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767961871; cv=none; b=d39llprBTgAX504+YhAexoIiR6oHFk7pESqg1p/2MxLht2rvol/1a+VlsfeTS+MhDqOYNBykb3Qs++1+p9mckszl1yuu0dRiX2h6pLJDEhajqUOoZKeOQofZhJNj2aKXmt7CyU7aTeCSakS+rVh9U6Dxjos7dSNUw4zVEZjkx4o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767961871; c=relaxed/simple;
	bh=HX/MO2qiNQ+dLvzCe6C3JMYU8tefDDfVLmAckJIy5Q8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TqJX4hC9GriAZWyTyx3HxJilV2rumJJko/FtfAXDLNpMPU2JWFgBxKvKvJBLSnE9gcQLK16D50PE+fYGEteFZuQweno1WqUH9BN2noswPfBBdC18XYTCVoLPhO2k6X4eIhTTvVIQqaMIqUL+uBsT01HmThPQQGq8TNVTL0kf7lk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hCtmVexB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hCtmVexB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2F49C4CEF1;
	Fri,  9 Jan 2026 12:31:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767961871;
	bh=HX/MO2qiNQ+dLvzCe6C3JMYU8tefDDfVLmAckJIy5Q8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hCtmVexBMRYGUF/5SInuXR7k3yr/0U3CF3NuSP9VmEXfE3Juq9V84p2aWf0U1Usvj
	 cF7zfrYd9HzisJeqCmG+Sm+U3OCZV0TOybO//4O8IUI8ToUSQBsz/Av7HWg1ogzUvm
	 pMgO+76twogIP1oQdXK17iFaRoJqD5UYjRsGUJ64=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Wang <jasowang@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 164/634] virtio: fix typo in virtio_device_ready() comment
Date: Fri,  9 Jan 2026 12:37:22 +0100
Message-ID: <20260109112123.620170105@linuxfoundation.org>
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

From: Michael S. Tsirkin <mst@redhat.com>

[ Upstream commit 361173f95ae4b726ebbbf0bd594274f5576c4abc ]

"coherenct" -> "coherent"

Fixes: 8b4ec69d7e09 ("virtio: harden vring IRQ")
Message-Id: <db286e9a65449347f6584e68c9960fd5ded2b4b0.1763026134.git.mst@redhat.com>
Acked-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/virtio_config.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/virtio_config.h b/include/linux/virtio_config.h
index 4b517649cfe84..eee145cfea6b5 100644
--- a/include/linux/virtio_config.h
+++ b/include/linux/virtio_config.h
@@ -286,7 +286,7 @@ void virtio_device_ready(struct virtio_device *dev)
 	 * specific set_status() method.
 	 *
 	 * A well behaved device will only notify a virtqueue after
-	 * DRIVER_OK, this means the device should "see" the coherenct
+	 * DRIVER_OK, this means the device should "see" the coherent
 	 * memory write that set vq->broken as false which is done by
 	 * the driver when it sees DRIVER_OK, then the following
 	 * driver's vring_interrupt() will see vq->broken as false so
-- 
2.51.0



