Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795046117;
	b=mJ1WcnC3zLkS6esm6AQpUdPEhFJAm3gEo0ZdQoKMxbJUiz57NzuNHbFYfeUsLM8g7zAo
	 8WlZUUOVzXbIAfLbH+ib43RnlVV+IHZ789GEmPu6M+TvteEred8BmvF39xM6Ssy5FD571
	 h7C1XBxm8qb9/evw1AxQVCcjx2JLz+4kJ1fMzDM7qkDcdyPxEhmsSe362p7EKjsUopf0U
	 GJJVUvS7vO3UTi/Zeli9nACe9yxRfZ/fdGg/721+fpKcYsF1+wKqWZoFOiwFx16yEayNW
	 PxJWqbuYzCbbs+Hq43pRXUn93wUsSW2V2i6Z1zBATt0T75FOUHzXyE3sUn4bmsr+2Eg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795046117;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=uSnrg2hkrFx6JML7emRzTk5tzP4eWuy29s3za+hw9Bs=;
	b=ZPBfuqE/F93NOsx3MlpNty6nkXqxCg4S8UcnFUpMT8VpWsgyvBRCdrqQSdxnVQaXByl3
	 /VQ7CAmRbOJfnQn+s7sHHjKkjfx5yv5BsWZ4wKxxXetxjUx2Rl42/Ak9oghgaWGwXYOhV
	 EO6qvDQZ9/tcZZIoRTRLWSC4p8DguAV3ANGJoVEkBs9qqqOZ/kBz+9+FZ6Rztsmb3cYON
	 xGCYdy9IiLO+DShkQoKljlyExQQy3I+el1aefS7Ua3OnRkzePfaiO7lvqHUxvEwZCvEdp
	 x6s0Tq/46babPURybX29OIxwPMYp6Di4TpMVsL83DDK4sUSGkbwRba7hPUKab1l7h3w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2m4+Auim;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C126606A325;
	Wed, 18 Nov 2026 23:55:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2m4+Auim
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 412991F000C5;
	Wed, 18 Nov 2026 23:55:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795046116;
	bh=uSnrg2hkrFx6JML7emRzTk5tzP4eWuy29s3za+hw9Bs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2m4+AuimhFcvIgzpYv/X/RFYdtHTt3BtDOtV/lsoESMYbgCy2stFIEuxeR23mATF5
	 QXbA/rLon8S0fFIsSjf+LyA/SMueFfhIaG/l8BLz8UimXZKN+x07z4iqOUGhWMWDm+
	 /tuFgNHMMSqo5mEi9E2eX/Ctk4dDDEwmod19tuXE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jinwang Li <jinwang.li@oss.qualcomm.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Siwei Zhang <oss@fourdim.xyz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1115/2857] Bluetooth: L2CAP: Ignore connection responses with wrong ident
Date: Wed, 18 Nov 2026 15:35:49 +0100
Message-ID: <20261118150241.769235521@linuxfoundation.org>
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

From: Jinwang Li <jinwang.li@oss.qualcomm.com>

commit a9f9eeb5344fc7dc625e5700ccf09891bc2603b5 upstream.

Adjusted context as stable does not have the lockdep_assert_held()
call in l2cap_connect_create_rsp().

L2CAP/COS/CED/BI-28-C requires the IUT to ignore a Connection Response
that carries an invalid Identifier.

l2cap_connect_create_rsp() only checks that a connection request is
outstanding, not that the response answers it. Add an ident check
against the pending request so that a mismatched response is dropped.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Jinwang Li <jinwang.li@oss.qualcomm.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Siwei Zhang <oss@fourdim.xyz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/l2cap_core.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/bluetooth/l2cap_core.c b/net/bluetooth/l2cap_core.c
index 174f7a513f9d1..69040c96e0e39 100644
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -4319,11 +4319,11 @@ static int l2cap_connect_create_rsp(struct l2cap_conn *conn,
 
 	l2cap_chan_lock(chan);
 
-	/* Only accept a response to a connection request we sent and that
-	 * is still outstanding. A channel waiting in BT_CONNECT for security
-	 * or the feature mask has not sent one yet.
+	/* Only accept a response matching a connection request we sent and
+	 * that is still outstanding. A channel waiting in BT_CONNECT for
+	 * security or the feature mask has not sent one yet.
 	 */
-	if (!l2cap_chan_connect_pending(chan))
+	if (!l2cap_chan_connect_pending(chan) || chan->ident != cmd->ident)
 		goto done;
 
 	switch (result) {
-- 
2.53.0



