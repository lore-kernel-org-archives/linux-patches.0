Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5743CC129;
	Mon,  1 Apr 2024 16:22:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711988577; cv=none; b=NQL32+kptPHhSyGj0MBvLjrbIIYCvWoKQerrFJWzs6LRz3W3yLUdFayIcTI/rYkPWUEVxrR0yj+bnCTSyHut1AXpq45/05Adfu1g4ISRo6944M5LSnuIUhvV2Ila7qrTkVnxGtg29mSDMLQAVKoH/A9qTIos3gejKwCvEEORMzM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711988577; c=relaxed/simple;
	bh=FhOnGyT98rcZDtyE3lrLtAfyAEyr0LBCruSE49QjwIY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ir4EseVtRhi7pjAiuLOAuXeaptHpgQEbZaj7nT2lTRnXwf/5RtErcklRKxEiir/xVhT65QqYyOYUlgsinJJdp9tXf13GZxWxnynMUG5DCZsJwTJw4poy7/ksoe+3Z3ahvGBn/yU2k97d7N9XRmRL+PbvhApMxYEuq1rOYdZDVU0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d1vLMZIh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d1vLMZIh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0053C433F1;
	Mon,  1 Apr 2024 16:22:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711988577;
	bh=FhOnGyT98rcZDtyE3lrLtAfyAEyr0LBCruSE49QjwIY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d1vLMZIhe0bvtO8xSWSej7AdFFk4jbmEz8nka8+zFHJMS85SUPMvZX3e1TOhGsvv8
	 awGCP57cIBEQooL8Y+Wfr4Do3XYKFaDWILSWVNJdlmPks4c50Wof6l12/sdXXNaHur
	 8IfF+9eAGdJUIClnDtWiViaM3itVXKN7WiTcPNaA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Feng Liu <feliu@nvidia.com>,
	Parav Pandit <parav@nvidia.com>,
	Jiri Pirko <jiri@nvidia.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Yishai Hadas <yishaih@nvidia.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 197/432] virtio: Define feature bit for administration virtqueue
Date: Mon,  1 Apr 2024 17:43:04 +0200
Message-ID: <20240401152559.015194527@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152553.125349965@linuxfoundation.org>
References: <20240401152553.125349965@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Feng Liu <feliu@nvidia.com>

[ Upstream commit 838bebb4c926a573839ff1bfe1b654a6ed0f9779 ]

Introduce VIRTIO_F_ADMIN_VQ which is used for administration virtqueue
support.

Signed-off-by: Feng Liu <feliu@nvidia.com>
Reviewed-by: Parav Pandit <parav@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Acked-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
Link: https://lore.kernel.org/r/20231219093247.170936-2-yishaih@nvidia.com
Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
Stable-dep-of: 310227f42882 ("virtio: reenable config if freezing device failed")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/uapi/linux/virtio_config.h | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/virtio_config.h b/include/uapi/linux/virtio_config.h
index 8881aea60f6f1..2445f365bce74 100644
--- a/include/uapi/linux/virtio_config.h
+++ b/include/uapi/linux/virtio_config.h
@@ -52,7 +52,7 @@
  * rest are per-device feature bits.
  */
 #define VIRTIO_TRANSPORT_F_START	28
-#define VIRTIO_TRANSPORT_F_END		41
+#define VIRTIO_TRANSPORT_F_END		42
 
 #ifndef VIRTIO_CONFIG_NO_LEGACY
 /* Do we get callbacks when the ring is completely used, even if we've
@@ -114,4 +114,10 @@
  * This feature indicates that the driver can reset a queue individually.
  */
 #define VIRTIO_F_RING_RESET		40
+
+/*
+ * This feature indicates that the device support administration virtqueues.
+ */
+#define VIRTIO_F_ADMIN_VQ		41
+
 #endif /* _UAPI_LINUX_VIRTIO_CONFIG_H */
-- 
2.43.0



