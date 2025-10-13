Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D987E30DECB;
	Mon, 13 Oct 2025 15:40:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760370029; cv=none; b=uCziU5NfL3tQJpPq85izlSwy6Mi3Sv/IutHnqq1QdUsMQkiiQKaM+MKinoEknbKnioav83KgIQtA26dnC90j5cnr7Wl+t8GafWslG/N7YTVwQNvhUzXhy18UTmTx+nhc8dKuEKL3/kFYXZAXHdnnGvqJl6JRZeM6HSPziHZQyOY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760370029; c=relaxed/simple;
	bh=hV5YyiXYT8jNMyASh0sr3RDOQkDQbP1Vgj6b042MdO0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AIH4HbIdUhwy9vkCdd8VnaTtOmuppVqF3jH0r2bRZmYWi2TEeca/lNvvUr8VwX0LFK5IFwxJiv3dkpwAh4nH7iQ+apjLGTu/31f9erXsrn0e3Zubyd5lHHSp4cX5m/ezifyegHxOMY+S1LOy1/jQwfI/t8CpAgAn/9XjaqTCzNY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dRaEE1mP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dRaEE1mP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F271C4CEE7;
	Mon, 13 Oct 2025 15:40:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760370029;
	bh=hV5YyiXYT8jNMyASh0sr3RDOQkDQbP1Vgj6b042MdO0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dRaEE1mProW+ujCHm1NuN9cH8o9EtkzvgN6Nbsm5LfMHtbdXI6y3GJJbuW4qE/cPh
	 2Ri0ykkYB7SqF1ltSXzE0WXhKt2weJkYDyaaT2F6j/jIGZpPqdGOJzfSNf8dsxDDA5
	 WMQu1S8jvVwokQRltPHXWcy+XrCThPUnbWPbDyhk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nithyanantham Paramasivam <nithyanantham.paramasivam@oss.qualcomm.com>,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 420/563] wifi: ath12k: Fix flush cache failure during RX queue update
Date: Mon, 13 Oct 2025 16:44:41 +0200
Message-ID: <20251013144426.504665539@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
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

From: Nithyanantham Paramasivam <nithyanantham.paramasivam@oss.qualcomm.com>

[ Upstream commit 5e32edc6942570429d9c64d0641fc2addbf92be1 ]

Flush cache failures were observed after RX queue update for TID
delete. This occurred because the queue was invalid during flush.
Set the VLD bit in the RX queue update command for TID delete.
This ensures the queue remains valid during the flush cache process.

Tested-on: QCN9274 hw2.0 PCI WLAN.WBE.1.3.1-00173-QCAHKSWPL_SILICONZ-1
Tested-on: WCN7850 hw2.0 PCI WLAN.HMT.1.0.c5-00481-QCAHMTSWPL_V1.0_V2.0_SILICONZ-3

Fixes: d889913205cf ("wifi: ath12k: driver for Qualcomm Wi-Fi 7 devices")
Signed-off-by: Nithyanantham Paramasivam <nithyanantham.paramasivam@oss.qualcomm.com>
Reviewed-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Reviewed-by: Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>
Link: https://patch.msgid.link/20250806111750.3214584-7-nithyanantham.paramasivam@oss.qualcomm.com
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath12k/dp_rx.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/ath/ath12k/dp_rx.c b/drivers/net/wireless/ath/ath12k/dp_rx.c
index 8c61c7f3bbdc9..9048818984f19 100644
--- a/drivers/net/wireless/ath/ath12k/dp_rx.c
+++ b/drivers/net/wireless/ath/ath12k/dp_rx.c
@@ -781,6 +781,8 @@ static int ath12k_dp_rx_tid_delete_handler(struct ath12k_base *ab,
 	cmd.addr_lo = lower_32_bits(rx_tid->qbuf.paddr_aligned);
 	cmd.addr_hi = upper_32_bits(rx_tid->qbuf.paddr_aligned);
 	cmd.upd0 |= HAL_REO_CMD_UPD0_VLD;
+	/* Observed flush cache failure, to avoid that set vld bit during delete */
+	cmd.upd1 |= HAL_REO_CMD_UPD1_VLD;
 
 	return ath12k_dp_reo_cmd_send(ab, rx_tid,
 				      HAL_REO_CMD_UPDATE_RX_QUEUE, &cmd,
-- 
2.51.0



