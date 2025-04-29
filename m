Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B0B8253332;
	Tue, 29 Apr 2025 16:56:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745945761; cv=none; b=OKg/KLnILXv0UOz3Gl9qRce3sb5NwPanLCwZTEl4uO+2zN/hDwId1OBkpWgNrnnb0ixJTCfhlaxmSydnAZd5f1VSZwQZP5VNbYThZlu0ZKk7sq4tZEg5aXjOfLShhOaOsDFqOXhz5qAbBpHCFmGUcG73XeWm/SGRPJaCadjIo7o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745945761; c=relaxed/simple;
	bh=PLApYQlCAY1C2VPjkVm/U+TFLQczVPtFrgazakt1NE8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xbc2zDV/vnDZnsZcCKs8ziYq/cL5bPeBSp9cUKDLkUCMUUQTY6mUh0pRClfIGiK8SRr6tgrVx8clwgpMQ4PEMxKHB3r15DANKxu7v7RSUHgac49NJvZDaHSGiXqFOksFaVM1nI+oKa5R/XKBApY2pKmQLEe1NBad5tUBJwS4JmE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a77ehFXX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a77ehFXX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E24EC4CEE3;
	Tue, 29 Apr 2025 16:56:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745945760;
	bh=PLApYQlCAY1C2VPjkVm/U+TFLQczVPtFrgazakt1NE8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a77ehFXX9uvwFwrTFuxlUujo7yJUHpP3WiddDySNThyNpJ3xXGBq6ysmKDyqUERcJ
	 YguW4K1jAu6FK7ZgUWjJox1DCWEoH5Pyl3N6Ei9dpeZ7qR2OxGCVE88tmM7D1E7xF+
	 0Ht6IUW8Z/T1vL0ZOnF21IVRvGayan9YkG1N+eXU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Jurgens <danielj@nvidia.com>,
	Parav Pandit <parav@nvidia.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 040/311] virtio_pci: Use self group type for cap commands
Date: Tue, 29 Apr 2025 18:37:57 +0200
Message-ID: <20250429161122.668090036@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161121.011111832@linuxfoundation.org>
References: <20250429161121.011111832@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Jurgens <danielj@nvidia.com>

[ Upstream commit 16c22c56d4282584742022a37d4f79a46ca6094a ]

Section 2.12.1.2 of v1.4 of the VirtIO spec states:

The device and driver capabilities commands are currently defined for
self group type.
1. VIRTIO_ADMIN_CMD_CAP_ID_LIST_QUERY
2. VIRTIO_ADMIN_CMD_DEVICE_CAP_GET
3. VIRTIO_ADMIN_CMD_DRIVER_CAP_SET

Fixes: bfcad518605d ("virtio: Manage device and driver capabilities via the admin commands")
Signed-off-by: Daniel Jurgens <danielj@nvidia.com>
Reviewed-by: Parav Pandit <parav@nvidia.com>
Message-Id: <20250304161442.90700-1-danielj@nvidia.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/virtio/virtio_pci_modern.c | 4 ++--
 include/uapi/linux/virtio_pci.h    | 1 +
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/virtio/virtio_pci_modern.c b/drivers/virtio/virtio_pci_modern.c
index 5eaade7578606..d50fe030d8253 100644
--- a/drivers/virtio/virtio_pci_modern.c
+++ b/drivers/virtio/virtio_pci_modern.c
@@ -247,7 +247,7 @@ virtio_pci_admin_cmd_dev_parts_objects_enable(struct virtio_device *virtio_dev)
 	sg_init_one(&data_sg, get_data, sizeof(*get_data));
 	sg_init_one(&result_sg, result, sizeof(*result));
 	cmd.opcode = cpu_to_le16(VIRTIO_ADMIN_CMD_DEVICE_CAP_GET);
-	cmd.group_type = cpu_to_le16(VIRTIO_ADMIN_GROUP_TYPE_SRIOV);
+	cmd.group_type = cpu_to_le16(VIRTIO_ADMIN_GROUP_TYPE_SELF);
 	cmd.data_sg = &data_sg;
 	cmd.result_sg = &result_sg;
 	ret = vp_modern_admin_cmd_exec(virtio_dev, &cmd);
@@ -305,7 +305,7 @@ static void virtio_pci_admin_cmd_cap_init(struct virtio_device *virtio_dev)
 
 	sg_init_one(&result_sg, data, sizeof(*data));
 	cmd.opcode = cpu_to_le16(VIRTIO_ADMIN_CMD_CAP_ID_LIST_QUERY);
-	cmd.group_type = cpu_to_le16(VIRTIO_ADMIN_GROUP_TYPE_SRIOV);
+	cmd.group_type = cpu_to_le16(VIRTIO_ADMIN_GROUP_TYPE_SELF);
 	cmd.result_sg = &result_sg;
 
 	ret = vp_modern_admin_cmd_exec(virtio_dev, &cmd);
diff --git a/include/uapi/linux/virtio_pci.h b/include/uapi/linux/virtio_pci.h
index 8549d45712571..c691ac210ce2e 100644
--- a/include/uapi/linux/virtio_pci.h
+++ b/include/uapi/linux/virtio_pci.h
@@ -246,6 +246,7 @@ struct virtio_pci_cfg_cap {
 #define VIRTIO_ADMIN_CMD_LIST_USE	0x1
 
 /* Admin command group type. */
+#define VIRTIO_ADMIN_GROUP_TYPE_SELF	0x0
 #define VIRTIO_ADMIN_GROUP_TYPE_SRIOV	0x1
 
 /* Transitional device admin command. */
-- 
2.39.5



