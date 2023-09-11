Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55A071172A
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:30:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9FDEC433C7;
	Mon, 11 Sep 2023 14:30:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694442611;
	bh=wcrOCfrsrK9m4f2/f5g5SOAOs7GVgWjAg0CJuP4eTsc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zZF3fTvKohxUCA/5jdGtJdAutZp9RIhXBwVgoEkdL6VHgP2N4U9rPmNOEk3A4pIfI
	 hBRcY6VASk0Y9XLWjkf3AF4U71WqBKtcnIrvuXVDNizaR6VdnY+0YoBXS58CYnbhl0
	 lt9H3YLdZUtlL7A1txQFXDGinEC+DHsy874wV1Og=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shih-Yi Chen <shihyic@nvidia.com>,
	Liming Sung <limings@nvidia.com>,
	David Thompson <davthompson@nvidia.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 085/737] platform/mellanox: Fix mlxbf-tmfifo not handling all virtio CONSOLE notifications
Date: Mon, 11 Sep 2023 15:39:04 +0200
Message-ID: <20230911134652.880186142@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.286315610@linuxfoundation.org>
References: <20230911134650.286315610@linuxfoundation.org>
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

6.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shih-Yi Chen <shihyic@nvidia.com>

[ Upstream commit 0848cab765c634597636810bf76d0934003cce28 ]

rshim console does not show all entries of dmesg.

Fixed by setting MLXBF_TM_TX_LWM_IRQ for every CONSOLE notification.

Signed-off-by: Shih-Yi Chen <shihyic@nvidia.com>
Reviewed-by: Liming Sung <limings@nvidia.com>
Reviewed-by: David Thompson <davthompson@nvidia.com>
Link: https://lore.kernel.org/r/20230821150627.26075-1-shihyic@nvidia.com
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/mellanox/mlxbf-tmfifo.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/platform/mellanox/mlxbf-tmfifo.c b/drivers/platform/mellanox/mlxbf-tmfifo.c
index a79318e90a139..b600b77d91ef2 100644
--- a/drivers/platform/mellanox/mlxbf-tmfifo.c
+++ b/drivers/platform/mellanox/mlxbf-tmfifo.c
@@ -887,6 +887,7 @@ static bool mlxbf_tmfifo_virtio_notify(struct virtqueue *vq)
 			tm_vdev = fifo->vdev[VIRTIO_ID_CONSOLE];
 			mlxbf_tmfifo_console_output(tm_vdev, vring);
 			spin_unlock_irqrestore(&fifo->spin_lock[0], flags);
+			set_bit(MLXBF_TM_TX_LWM_IRQ, &fifo->pend_events);
 		} else if (test_and_set_bit(MLXBF_TM_TX_LWM_IRQ,
 					    &fifo->pend_events)) {
 			return true;
-- 
2.40.1



