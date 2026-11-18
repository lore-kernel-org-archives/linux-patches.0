Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795044443;
	b=LEso8MuTrTceYW5NZ/ww9P0ePnZAkqYJZ1uI26/Z5EltaIJfDfl2IgDavcXKXE3I+9vH
	 oZOSgAE7ciD2Oi2gznZBjfuLuu7FO8LXKEoBAPYXET3AVusnoETDASk/cGf4/NZP2ZbQ6
	 hizJFuxuYh8MG/sofwxJcEPpXhsyG56VsbqqYYUN9hfNLkW50fzVhQxWzQUzi3moCTh1B
	 nmpI7C2oRO+vhLDtzAh2HIzvQJ+MmqmOeotq3IU12Y9bnz8wO3qPQz/TF9h5eNALuNIOj
	 9X1HxTuv8WV2/91JOho1pNEmzyOYl1MWr/APMjasB7eaNBXBBUw/BQPOuzMdj0ArRIA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795044443;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=s7VFKJ7Ouup6k4qjzz+7RFPcaIe9dl3aO+sKkt3meD4=;
	b=VHLj2v8Q82/9402Lu/VdsjmEUjDbes/LiKfYjGYrO8IJB4Nez9EtFQt7KEp/JUFztw4W
	 Vp8icDHPjN/nq8UWmdKIuGJ14ZUzZ5wnW+9KHkWAJIiXGMM1lai3qPol/mC5WCJ/UZuE3
	 rBtX16oiF8zA+A9CkPF6VUNeSn9IGqJn9QagGN1iit7Mc0vUVgE5yE4NjpHPUKbAXrLBg
	 bT8YppZfTbaXhlL1U0LnGXBLaR0s7UmzQsjC6XoOi8BJLlUUydmJmdr1YB1hTqxAe9E2n
	 nRij+RX0B+Card5Di/e9t70vCjqSRLG02i8/O7Hu/gwRrHIrqr9DTb+RdoKbGVv5FhQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sfrDarM8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33F49606A31C;
	Wed, 18 Nov 2026 23:27:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sfrDarM8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81CAF1F000C4;
	Wed, 18 Nov 2026 23:27:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795044443;
	bh=s7VFKJ7Ouup6k4qjzz+7RFPcaIe9dl3aO+sKkt3meD4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sfrDarM8RFufFj9SHE4EprZuqqaTi19jW11ApnCpuAnfKjEV2nH2mRnBSPi66HqmM
	 o9j1saK5C9N+IjoMQeFbPOZXvbO5K823rjVPvPQEGgpDEQzHlkE3P/+lLfrV45Q9XF
	 HFeIws+VVU8unSp/JJSszPT/Ebvp+Rlq78wZ21bc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrey Misiurov <amisiurov@cloudlinux.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0522/2857] Bluetooth: ISO: drop unbalanced sock_put() in iso_conn_ready()
Date: Wed, 18 Nov 2026 15:25:56 +0100
Message-ID: <20261118150220.263322363@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrey Misiurov <amisiurov@cloudlinux.com>

Commit 1702f12cf59a ("Bluetooth: ISO: fix use-after-free of listener
socket in iso_conn_ready"), the 6.1.y backport of upstream 560bef609fa5,
puts the listener when it is no longer listening. Upstream that put
balances the reference taken by iso_get_sock(). On 6.1.y
iso_get_sock_listen() takes no reference (it got one only in v6.8 with
fa224d0c094a), and no other exit of iso_conn_ready() puts the parent.

No race is needed to hit it: shutdown() of a bound socket sets
SOCK_ZAPPED and keeps BT_BOUND, so listen() still succeeds and the
listener stays BT_LISTEN with SOCK_ZAPPED. Every incoming connection
then takes the new branch, and the second one frees the listener while
it is still on iso_sk_list and attached to its file.

Drop the put.

Found while reviewing a backport of this fix; not reproduced at
runtime.

Fixes: 1702f12cf59a ("Bluetooth: ISO: fix use-after-free of listener socket in iso_conn_ready")
Signed-off-by: Andrey Misiurov <amisiurov@cloudlinux.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/iso.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/net/bluetooth/iso.c b/net/bluetooth/iso.c
index 5bf91e702330d..c993cffc8c380 100644
--- a/net/bluetooth/iso.c
+++ b/net/bluetooth/iso.c
@@ -1536,7 +1536,6 @@ static void iso_conn_ready(struct iso_conn *conn)
 		if (parent->sk_state != BT_LISTEN ||
 		    sock_flag(parent, SOCK_ZAPPED)) {
 			release_sock(parent);
-			sock_put(parent);
 			return;
 		}
 
-- 
2.53.0



