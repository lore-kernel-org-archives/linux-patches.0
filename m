Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07ED41EF36E;
	Mon, 13 Oct 2025 15:37:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760369868; cv=none; b=oqftN85x/QmsY+HjrhBnOqlQk4NXcexu+M84sUeYp9ptY+//a2sqRa6QBowqHi1b1eyAm/jXeNLHIn+WZMad8+GrIfe74oTtv/EmII5MpkRloHrx2Wf608jwlyXdBYQDvv/BbzyysbBAt8WZCdLO29c7FOdmNpv/P7UqSsRQgnc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760369868; c=relaxed/simple;
	bh=HlnDYGqotFAWB4rc0ldPNy/qFQiLMy02DMF8lS4ekXw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K+5HRt6GZcXz5xGhN613EGyFjkT7sEONcNBZPgV6PphIpx//z49mFFJFDouFG6zDtZjPdsnxlDh3WAlZtrRnxJTTwYaMzFDFMsmLTPjjVPE62+rX8Vw3SimWAovVJyO2+9KfkopDkkCJ/H0sTtgd7T0AAW0BFgqWpUIpiiruAPQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q3gz8LdK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q3gz8LdK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B6C5C4CEE7;
	Mon, 13 Oct 2025 15:37:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760369867;
	bh=HlnDYGqotFAWB4rc0ldPNy/qFQiLMy02DMF8lS4ekXw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q3gz8LdKyIm9GxOR4pZMdl2CicyE26lc3hYCWpUjmYQE/YZpNwFtu3flKgF+7ghKy
	 NgOiEUJ6NKEh28Fw+d5jJUVxDi6/Q666WuxawmRVfJC05JQPn7HSFTBb62ggk7kUQg
	 Di64caCsKCsBzkWWOLcgw9437wEqrEOGP0TGoWds=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 396/563] wifi: ath12k: fix wrong logging ID used for CE
Date: Mon, 13 Oct 2025 16:44:17 +0200
Message-ID: <20251013144425.629429775@linuxfoundation.org>
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

From: Baochen Qiang <baochen.qiang@oss.qualcomm.com>

[ Upstream commit 43746f13fec67f6f223d64cfe96c095c9b468e70 ]

ATH12K_DBG_AHB is used for CE logging which is not proper. Add
ATH12K_DBG_CE and replace ATH12K_DBG_AHB with it.

Compile tested only.

Fixes: d889913205cf ("wifi: ath12k: driver for Qualcomm Wi-Fi 7 devices")
Signed-off-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Reviewed-by: Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>
Link: https://patch.msgid.link/20250815-ath-dont-warn-on-ce-enqueue-fail-v1-2-f955ddc3ba7a@oss.qualcomm.com
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath12k/ce.c    | 2 +-
 drivers/net/wireless/ath/ath12k/debug.h | 1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath12k/ce.c b/drivers/net/wireless/ath/ath12k/ce.c
index f93a419abf65e..c5aadbc6367ce 100644
--- a/drivers/net/wireless/ath/ath12k/ce.c
+++ b/drivers/net/wireless/ath/ath12k/ce.c
@@ -478,7 +478,7 @@ static void ath12k_ce_recv_process_cb(struct ath12k_ce_pipe *pipe)
 	}
 
 	while ((skb = __skb_dequeue(&list))) {
-		ath12k_dbg(ab, ATH12K_DBG_AHB, "rx ce pipe %d len %d\n",
+		ath12k_dbg(ab, ATH12K_DBG_CE, "rx ce pipe %d len %d\n",
 			   pipe->pipe_num, skb->len);
 		pipe->recv_cb(ab, skb);
 	}
diff --git a/drivers/net/wireless/ath/ath12k/debug.h b/drivers/net/wireless/ath/ath12k/debug.h
index 48916e4e1f601..bf254e43a68d0 100644
--- a/drivers/net/wireless/ath/ath12k/debug.h
+++ b/drivers/net/wireless/ath/ath12k/debug.h
@@ -26,6 +26,7 @@ enum ath12k_debug_mask {
 	ATH12K_DBG_DP_TX	= 0x00002000,
 	ATH12K_DBG_DP_RX	= 0x00004000,
 	ATH12K_DBG_WOW		= 0x00008000,
+	ATH12K_DBG_CE		= 0x00010000,
 	ATH12K_DBG_ANY		= 0xffffffff,
 };
 
-- 
2.51.0



