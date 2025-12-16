Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFCF334167A;
	Tue, 16 Dec 2025 11:32:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765884730; cv=none; b=E/5+JQ7S853mhkVNHpHzuq7mZtS5NGMKLp7wCPidvU0wAt2TX0DFvBZPzaYQqp2WG0Uul4Z6mw5Hqv51UwwexmtfiJxbna+284ganl/+w+o0AuoOeGGLvVkz7Xw+xWgnQpsHZublf+S5c7dqmKwPWD00Qyj9ATBc0FycSWLsvHg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765884730; c=relaxed/simple;
	bh=5mUXdkQWhInDXdew5HwbOOniKc/9nbDGiKRSO/k1j+Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G/eNloHq1yMBTzo966icrq2Vn6Cx9yVTZDHJzol9ZakPELrkalDvQdYwE8VLH7ZilWb2UtB13xv1K8dZoA1xPT4WfmRPT5bJXWTD04XZqk8QWcsvy0v87PIo0l4EiB/MJHNpVmKwJnH+c5xWuIC1QU4ZoRQEjoT2ZZ0z4miGeeo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HAVongjC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HAVongjC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8987C4CEF5;
	Tue, 16 Dec 2025 11:32:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765884730;
	bh=5mUXdkQWhInDXdew5HwbOOniKc/9nbDGiKRSO/k1j+Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HAVongjCG5v60v56+oP1yoBxhkob1/G1+l8SwskDG9YE2A4L2Q/Urgi64cOEk67ta
	 7edEwuzBmKg/qLuuoS6sRQA1egzfT5PKquOUmEYLf1xJVlcFj42mkoxLqBtuPRm3hG
	 4rFiMQwNR+MmwzvNl6C8QTP+Omaru9EAiYEle5bU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Wang <jasowang@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 248/354] virtio: fix typo in virtio_device_ready() comment
Date: Tue, 16 Dec 2025 12:13:35 +0100
Message-ID: <20251216111329.898331152@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111320.896758933@linuxfoundation.org>
References: <20251216111320.896758933@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 169c7d367facb..165f71635cb99 100644
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



