Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795622584;
	b=BxetMtRK+AJ3HqS+R5wTXi+Vn6cYInO0DyCUV3xF1sxfGNdc2+Cw6PMbftXfIQtKUZho
	 W0TJwKNnFenoW2KQHCQRRJXrymU07evEuyZmnAlKlUf1K59G8Ib03CRZedjfRIhKloxI7
	 gpHrKAIPXFek/LV6oGN42LbIxSmTnBhsi1Cg2VjNM6LfdD5MEyxaFEala7fAkU7Ztr22c
	 hFTo4y404JSwRf7LMe9TqnaWbXuqs1fhBdoreHxLvs2CnGCVEMpbKYTW7nan7xogtqgM5
	 v7oHXHuF4wUhcsgUSjs3uqvlSRJyV7ecYDuh574ICUYBCwPYw0DH8LFJN/MPZD705Sw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795622584;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/rbAGiXbxYrft5Bkdi3pGQ7eAgJy40xDxyG/GobY/EY=;
	b=qyAKyyFE7yQUHAu80hzJfduZ7EWRuOnNLym3kEsjjS/GjCp44R2PINLld7jGvgN2p6zD
	 avnMUzVyRXLSJRLePqnHqRAIhWLQvN1n+opb3AKasWMuaCaBMH2qK8hSy/+/t466HVx33
	 E1cN13FnFkIIYr3Y1wDe5iXRBAvcbiZvAF3l3yXrwquWxv8Uml5BjOVjEQtvPfvzKZHgS
	 0VzGg1tYWuv6CFqSCdpFRo/96GU8jtNx4iF5WxrDJuif2wQTS9WMHkX94gEnenYNPTQaa
	 zLCwazh0TaX5M1wI4p6nkwVKejra4ec6SLb0Y6bgcedVnJVT0QE75pLWHTinX+stfWQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MjzK8TVs;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A81E606A336;
	Wed, 25 Nov 2026 16:03:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MjzK8TVs
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57CA11F000CF;
	Wed, 25 Nov 2026 16:03:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795622583;
	bh=/rbAGiXbxYrft5Bkdi3pGQ7eAgJy40xDxyG/GobY/EY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MjzK8TVscnuf/rswr3LWPcMZX5b79ss3CcAW6pf1cIGxZA8UBorHyzGBGGbVh0CwK
	 QG1F8JsUf68u9JsT+e2yLfcwkMs4uHe0dHMXKKE22A2XWNAT6GG+e0TK+AfY0B8yU1
	 i7sRuq0FhGedV6KGzYs9TR22P52+63VJCPgOP9Dg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kang Yang <kang.yang@oss.qualcomm.com>,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 547/990] wifi: ath12k: fix stale tail_msdu pointer returned from mpdu_pop
Date: Wed, 25 Nov 2026 15:31:54 +0100
Message-ID: <20261125143834.912674703@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: Applied the one-line change to the pre-split dp_mon.c, using the old function name, since the wifi7 split of ath12k does not exist here. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath12k/dp_mon.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath12k/dp_mon.c b/drivers/net/wireless/ath/ath12k/dp_mon.c
index 0e9b02f1140fc..a9ba30c330833 100644
--- a/drivers/net/wireless/ath/ath12k/dp_mon.c
+++ b/drivers/net/wireless/ath/ath12k/dp_mon.c
@@ -4254,7 +4254,7 @@ ath12k_dp_rx_mon_mpdu_pop(struct ath12k *ar, int mac_id,
 	if (last)
 		last->next = NULL;
 
-	*tail_msdu = msdu;
+	*tail_msdu = last;
 
 	if (msdu_cnt == 0)
 		*npackets = 1;
-- 
2.53.0



