Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E29633203A2;
	Mon, 18 Aug 2025 13:31:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755523870; cv=none; b=i1kB53R6Sy3taKH48V4VS3VJymkl3sfBzo0f4UvqCm7htuOqTFHjVeHcN/h1KZuIxmz7O+HGEqVPHvV3K3uRYwF9dduyf9ch7kT5U1NwKVShbj+rc37HbnoxlHdA7Vrz0k46DLtcdnytbGTIcyBxTTq3gKkE73eOFbR9DER31z4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755523870; c=relaxed/simple;
	bh=N/7oK+S+8l5bEKf7cC+ipAYKyIomikWleNW0OR4jOys=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Yb4ERpyg6/4aDTFS3SM3ewiTbfiHq0ybqWLLEIbeegV92T1yGNeaq+IBH8pj4CP4+0Jblkj4kbuUDVQ2rLLqiBqgIGOJOL4v8MdLsjF40r/frX+tCI654ss5xi/TRSRu/Ucy2ygrkpTvK4+6nZaHMeKrB5YsHGS9a3fTJKjrq50=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zFLYov+r; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zFLYov+r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 153D2C4CEEB;
	Mon, 18 Aug 2025 13:31:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755523869;
	bh=N/7oK+S+8l5bEKf7cC+ipAYKyIomikWleNW0OR4jOys=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zFLYov+rztlUeG8l8PTPa2aUxl+EN0v7xze458kV23V9O1bel6c73nwD+upLWLoB4
	 V5p9jS+Y20UkKLiw+MA72uBy1MPO5Z62swmTqC0xEUNQa/mFNipL056xQbt4rAAjoi
	 iRHiHq/6+LXXTfNtcK3LOXTd0h/BfCZD0uPZr2NI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karthikeyan Kathirvel <quic_kathirve@quicinc.com>,
	Sarika Sharma <quic_sarishar@quicinc.com>,
	Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 290/515] wifi: ath12k: Decrement TID on RX peer frag setup error handling
Date: Mon, 18 Aug 2025 14:44:36 +0200
Message-ID: <20250818124509.585178789@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124458.334548733@linuxfoundation.org>
References: <20250818124458.334548733@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Karthikeyan Kathirvel <quic_kathirve@quicinc.com>

[ Upstream commit 7c0884fcd2ddde0544d2e77f297ae461e1f53f58 ]

Currently, TID is not decremented before peer cleanup, during error
handling path of ath12k_dp_rx_peer_frag_setup(). This could lead to
out-of-bounds access in peer->rx_tid[].

Hence, add a decrement operation for TID, before peer cleanup to
ensures proper cleanup and prevents out-of-bounds access issues when
the RX peer frag setup fails.

Found during code review. Compile tested only.

Signed-off-by: Karthikeyan Kathirvel <quic_kathirve@quicinc.com>
Signed-off-by: Sarika Sharma <quic_sarishar@quicinc.com>
Reviewed-by: Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>
Link: https://patch.msgid.link/20250526034713.712592-1-quic_sarishar@quicinc.com
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath12k/dp.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/ath/ath12k/dp.c b/drivers/net/wireless/ath/ath12k/dp.c
index 807c5b345e06..a53e4ebdcbfc 100644
--- a/drivers/net/wireless/ath/ath12k/dp.c
+++ b/drivers/net/wireless/ath/ath12k/dp.c
@@ -84,6 +84,7 @@ int ath12k_dp_peer_setup(struct ath12k *ar, int vdev_id, const u8 *addr)
 	ret = ath12k_dp_rx_peer_frag_setup(ar, addr, vdev_id);
 	if (ret) {
 		ath12k_warn(ab, "failed to setup rx defrag context\n");
+		tid--;
 		goto peer_clean;
 	}
 
-- 
2.39.5



