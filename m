Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB7B73557E8;
	Tue, 16 Dec 2025 11:57:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765886233; cv=none; b=jxBtkV8Eil2KseF8FYI+wfETDkzqZKw6vljgF4O29KxSvOtMpDL9AiS3Z3DXdxNV5cyTxVR/BlrEVXeklcjZqi2K1RC1zwq/J1OBM5SmtDEsgIEFCsXer0XVdbBMqBa6IMMfQtOJo+uFtXUpXQvIfl2yMB0KTipNiFU4o23pAxY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765886233; c=relaxed/simple;
	bh=BijKMYWAqo/FgVWME6NFPDK9W/LtH8xodBJZNrinNvU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eLQrDCbjcBihP6YsRiRE0uZZ5Y/T/cd7m8IZniA/prIt5Eo65i485pmdKvrU3nMnaAeR9zdQUWxz9TYlWWspNa4KSgXzz2qxNXXCATuXIo2PSP8OQDulTCou7KawvBkO4Juf4usHhDK7K46zivLAd61uwP58HhYGbkRSlZC90U0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HShdcz2j; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HShdcz2j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DCE9C4CEF1;
	Tue, 16 Dec 2025 11:57:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765886233;
	bh=BijKMYWAqo/FgVWME6NFPDK9W/LtH8xodBJZNrinNvU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HShdcz2jkI6zq+H6E/qQ2u9K8uqVsWgv601CAgFWQZ1cM9jmWo0AwM5Rlhy7mr/gT
	 f6uke18s9jyTOeWZRND0sAtzvtDVQVb/IvZZuuo+mzktqaWMsFbOfzwL+iiFAoOfZK
	 CCuC98/ttv4HsMGRO8qs3BnYmqCidulb1wgBSr+I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Wang <jasowang@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 376/507] virtio: fix typo in virtio_device_ready() comment
Date: Tue, 16 Dec 2025 12:13:37 +0100
Message-ID: <20251216111359.082510070@linuxfoundation.org>
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
index 7427b79d6f3d5..148dc5056002f 100644
--- a/include/linux/virtio_config.h
+++ b/include/linux/virtio_config.h
@@ -290,7 +290,7 @@ void virtio_device_ready(struct virtio_device *dev)
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



