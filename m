Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017355;
	b=BNrAlgf1nLRY3nAhqUeE2V4PgEN+8mdxI/NbZnv+xa/tEjESYZINwif7ZnuJdacQe3zk
	 r0nKDspFZnGM9VeMOEFCszsVBwjWwB4cpEsCmvReVc2piMiOuybgMQ7Xv9+UUhyaFcpGI
	 wfeoxIZsDcp1F7hACH6+SwRjk2ra72WoZVonmGF50ZN6N2a5EVimOTzx0iIuWyWiJR0xy
	 6GFxi+Bc0pB9PCjZZJRANG0bndsvAakKnEIiYnI+RS2BVlHc1dA7qfVkVi7Lb2/jLPl4c
	 EbTNOOHE1hKyWq0gBURoAc8p+w5bjhxkIKWD0iQ+YG2Nek2w/6HO8rdllyYN2hYNb7g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017355;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=5XKj5qiSqRYQKYBWenW7ka3p7qkAMbBcfcdx+3AmFhM=;
	b=d/c9y2q+xyhVW3qAThzhEeZVJ93cQVHwk7M5B9YA//eHyzYL1gn9c0nZxcUXb95NB9WX
	 D+HoiWlF9d8XnCWEgRpbC4Vu8Y4P0/xHCzydPy77EV2yDaUT8c/mC9hq2wk20UyoPq7R9
	 JZ4uIv7vTQIJV/Xx0nUDoM3XTMcL0DqO9PSbTYvHbG36oVbTyqHoR38zbZVWMIDcsLLpO
	 YmO9PIAFYm5lOvmab0FxPw7S71u+ONYbSOypgYC/Ke6tczgnv4Y2+crb/IOLM0V+cWxQh
	 XyKLqdmmj4fwjt51SQ1C5Cp8zIci5lCE5O+srS7UcxUVm3/vxw62ShJTVN/xtYBQi2w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nbTB3bO2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE425606A31C;
	Wed, 18 Nov 2026 15:55:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nbTB3bO2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09F2C1F000C6;
	Wed, 18 Nov 2026 15:55:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017355;
	bh=5XKj5qiSqRYQKYBWenW7ka3p7qkAMbBcfcdx+3AmFhM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nbTB3bO2tT8IoPP655FqKt0umIo4ILzNBHWW+/YFgKgOANMcLXSre01O+aL/cMyPg
	 BBunmk6Esnvjv0/banMdEL9u94RaNazmlq592LgF9gh0GWH+lKBI2qi1Z7ycGeQYIh
	 B/E2fbqm+cmiUMYyAuMxMB7Z8abtCtUF94iT4/RE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kang Yang <kang.yang@oss.qualcomm.com>,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0854/2651] wifi: ath12k: fix stale tail_msdu pointer returned from mpdu_pop
Date: Wed, 18 Nov 2026 15:34:54 +0100
Message-ID: <20261118150318.612769890@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kang Yang <kang.yang@oss.qualcomm.com>

[ Upstream commit 1a10a558555072dba8510ded23a9174b2a00d079 ]

ath12k_wifi7_dp_rx_mon_mpdu_pop() assigns *tail_msdu from the loop
cursor msdu at function exit. That cursor reflects the state of the
last msdu_list entry processed, not the end of the accumulated MSDU
chain: on next_msdu paths (invalid skb, drop_mpdu, first-MSDU rx_desc
invalid) it is set to NULL, and on the set_pktlen failure path it
becomes a dangling pointer to a freed skb. When these occur on the
final iteration, callers see head_msdu populated with a valid chain
while tail_msdu is NULL or points to freed memory.

The chain end is already tracked by the local variable last, which is
updated only after each MSDU has been validated and linked. Use it as
the source for tail_msdu so head_msdu and tail_msdu are either both
NULL or both point into the same live chain.

Tested-on: WCN7850 hw2.0 PCI WLAN.HMT.1.1.c7-00108-QCAHMTSWPL_V1.0_V2.0_SILICONZ_UPSTREAM-3

Fixes: 72bfbf19b7da ("wifi: ath12k: add support to reap and process mon dest ring")
Signed-off-by: Kang Yang <kang.yang@oss.qualcomm.com>
Reviewed-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Reviewed-by: Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>
Link: https://patch.msgid.link/20260916060325.854-4-kang.yang@oss.qualcomm.com
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath12k/wifi7/dp_mon.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath12k/wifi7/dp_mon.c b/drivers/net/wireless/ath/ath12k/wifi7/dp_mon.c
index 08f2fba3e6807..8fca777041d18 100644
--- a/drivers/net/wireless/ath/ath12k/wifi7/dp_mon.c
+++ b/drivers/net/wireless/ath/ath12k/wifi7/dp_mon.c
@@ -2802,7 +2802,7 @@ ath12k_wifi7_dp_rx_mon_mpdu_pop(struct ath12k *ar, int mac_id,
 	if (last)
 		last->next = NULL;
 
-	*tail_msdu = msdu;
+	*tail_msdu = last;
 
 	if (msdu_cnt == 0)
 		*npackets = 1;
-- 
2.53.0



