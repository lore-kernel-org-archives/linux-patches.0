Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590527;
	b=cB9BbInBNnQNfpJhjp5h1Kt9Gg4kDwhj++CDOODij2fWaaC+t78Qwd6wYCcfRGUpXS11
	 b4zbfowOVKHGR0ocoUPL8jw5G1AhvEd7ZV7nVAzEmEmhla7csEgHRB54CaXyA121CH8sa
	 X6Ru7wh7VTiwyTFCJEU0OnLQ4qpk+hLqRlu+n2t002yEd/nmDj4GrditDnBfSYHwZLKim
	 Vos2i88+RcHJ6lhPcQUKsyTHnXKXgdq7HlB+Cjzarbw2/ZM/SUM2tuOUp77OGezP8v6c0
	 RAecEyGNEKLfo9XKOBuK/bz4YxPLoj9XQJV5Ia1A8ShiyIz+15F1cUKMbhpw2lsVLzA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590527;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3sLwRGzDb/25eVchsbAbEa+twkbhIT9NntPS/IyNzyk=;
	b=5kzYUArFuKSzfGepvQVOh4Kp6WxoYuf6i7v0dgxD25Q3+dj9s97QMsDMnQNX5XQzK0Hc
	 v5CeKo0gi+IB9Zg66Au+kBl2vfGtKOOnnbhE870DG4PhoVx52hf0NKPkO3WpIbeJ7Ny9L
	 6zArNuBgBLmFkac37uytp1qstD8FgQ+o97twbxcDRvF6AAtnaY2a7s9rrq/bcW4ZuAusL
	 Ndm0vsY2gJlr7QmJyhMy7x+e5mLhhJBuDobEj+E3F2pKr8S1TO40S1rWdF0JEgBf3YNHz
	 jpVqxQemA+hK9AaeniT2xlRYsAttHNCbyLlxHILLXLioHDXES5BVH0qj24jq8C1hSzA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oY4H5sTq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DBA1607323A;
	Fri, 13 Nov 2026 17:22:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oY4H5sTq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A68A1F000C4;
	Fri, 13 Nov 2026 17:22:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590527;
	bh=3sLwRGzDb/25eVchsbAbEa+twkbhIT9NntPS/IyNzyk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oY4H5sTqFhvLC+rUigbPTY8eWfMN2s+3qWQs8NAwhid/Hm8Ze0fhqFaFSWHuGKfMo
	 dWv0Fb0iIOAg+rQHTfLhrTcjrF0auMNNOljv3U0cao6m8yMUYBWtFe2G8N3zMHBjvV
	 /uBaERa8cyqHBD2h1DxKk3dpnbg/9UMocIqK+8lU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Sven Eckelmann <sven@narfation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 471/686] batman-adv: tpmeter: fix u32 truncation of reported bytes
Date: Fri, 13 Nov 2026 10:50:04 -0500
Message-ID: <20261113153836.895752356@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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

From: Sven Eckelmann <sven@narfation.org>

commit 1025b76d13288a311e8259a0eefde0854fa63c41 upstream.

When more than 4 GB are transferred by the throughput meter,
batadv_tp_batctl_notify() will cut of the upper 32 bit of the u64 counter
and thus under-report the actual transferred bytes.

The data type of the temporary storage variable must therefore still
continue to use u64.

Cc: stable@vger.kernel.org
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/bug/linux-08bb3be4-6c6a-452d-b4e4-606940c6cfa5
Fixes: 33a3bb4a3345 ("batman-adv: throughput meter implementation")
[ Context ]
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/batman-adv/tp_meter.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/batman-adv/tp_meter.c b/net/batman-adv/tp_meter.c
index 02af19aaaff29..aa297e551cd07 100644
--- a/net/batman-adv/tp_meter.c
+++ b/net/batman-adv/tp_meter.c
@@ -226,9 +226,9 @@ static void batadv_tp_batctl_notify(enum batadv_tp_meter_reason reason,
 				    unsigned long start_time, u64 total_sent,
 				    u32 cookie)
 {
+	u64 total_bytes;
 	u32 test_time;
 	u8 result;
-	u32 total_bytes;
 
 	if (!batadv_tp_is_error(reason)) {
 		result = BATADV_TP_REASON_COMPLETE;
-- 
2.53.0



