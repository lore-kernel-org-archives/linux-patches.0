Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795619104;
	b=i3tjK5lkCu8enLBMCKxiP4XoYQz8GV3IjxdcKx4CAXmo1KruQ/b5jqOl3R/MMl6+R30V
	 S3prB9RUHz0T+xUzCzuX+pzugeUnsba1MLqmwxPxKq0z7daSQo0VKi3/ut6emhKuDlow/
	 FEMXmbS3LNSoxYOTPLZnElPDQ7nXtDz9rUHGj6/1CPGF5NAxewp/y1t4aaeX7ivQe6L8z
	 a35ztUgPWxE7Wqi6Esgws5KbZZLinABKoycJVRCDnIjftSw5/rfO4W9UCPZB699wzifNO
	 S4k/5zUhQfR1RmhwjlBkwE5Of4/m+eIkj/JxfJy1IwbCbmHagNbIxii4+EhWH8Tu6oQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795619104;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=V/CS4BldytsWkpo5ehW6PyHyKhsqi34kXxo9YCIWD6A=;
	b=4R5s+g9pNKL9+rD8ay1VC693RL4EEv7b4tF/Ry57KnXu5vKFaoTWlK5L8bGThQ5mBjzi
	 WP6FWAfdsK+ZXi2JvX0GCZd+mm23lP9aQt7TKjWMPmEi4FPF7B1jF0vjEnDNAwHrT9qc4
	 a9PCwpbqZT2vHy2nF0Q/9IrdEik72fwOrxkojskwDLfFrj5rJzvcdgvKI8hDATG62TL26
	 Amdxxf3f2X+/CQlUVwOxnWGudIx39vCvdEZXdOF0E8KI3uW0P62B6GMZNWNoor7PzQmoY
	 PNzi4PfJnluoJ4bLreb6pey7RhhB4SYlUzX5v4urU3qtlvy7kR/TKjAts3CbQfu+mkQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wVXydAo1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D04BA606A323;
	Wed, 25 Nov 2026 15:05:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wVXydAo1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BD6C1F000C4;
	Wed, 25 Nov 2026 15:05:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795619104;
	bh=V/CS4BldytsWkpo5ehW6PyHyKhsqi34kXxo9YCIWD6A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wVXydAo125CFUMVOgyhnkhhoneez7XxKhQhBV9wn4EkPz1xUtJhdJZG33d+bKuNZW
	 k/+0libpczVIBnl1UZ4TE3Wzkrk1K8scJriKJOWp0Fwk48m7EhE44CQbAdAxCpPkSY
	 MhMi1u1k/GEtxBbRfGmdCNkSluJK089X1nuI08ac=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tim Menninger <tmenninger@everpuredata.com>,
	Anna Schumaker <anna.schumaker@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0490/1005] NFSv4/flexfiles: limit transport disconnects when cancelling I/O
Date: Wed, 25 Nov 2026 15:30:28 +0100
Message-ID: <20261125143833.225592232@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

From: Tim Menninger <tmenninger@everpuredata.com>

[ Upstream commit 788c4f628565897e7090cdf5bb2e049e74aeca96 ]

ff_layout_cancel_io() cancels RPC tasks associated with a recalled or
revoked layout segment. If any matching tasks are found, it then calls
rpc_clnt_disconnect().

rpc_clnt_disconnect() disconnects every transport attached to the RPC
client. A data server client can have multiple transports, while the
cancelled requests may have used only a subset of them. Cancelling I/O
for one layout segment can therefore disrupt unrelated I/O using other
transports belonging to the same data server client.

This is particularly disruptive with RPC/RDMA during data server
recovery, where unnecessary transport disconnects can result in repeated
reconnect activity on otherwise unaffected connections.

Use rpc_cancel_tasks_and_disconnect() instead. Matching tasks are still
cancelled, but only matching requests belonging to that client that
remain on the transport transmit or receive queues are marked for
disconnect. When such a request is released, SUNRPC conditionally
disconnects the connection generation on which that request was sent.

This preserves cancellation and draining of I/O associated with the
layout segment without disconnecting unrelated transports attached to
the same RPC client.

Fixes: b739a5bd9d9f ("NFSv4/flexfiles: Cancel I/O if the layout is recalled or revoked")
Signed-off-by: Tim Menninger <tmenninger@everpuredata.com>
Signed-off-by: Anna Schumaker <anna.schumaker@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/flexfilelayout/flexfilelayout.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/fs/nfs/flexfilelayout/flexfilelayout.c b/fs/nfs/flexfilelayout/flexfilelayout.c
index 1bc6559ab660f..a4ccd53c79e79 100644
--- a/fs/nfs/flexfilelayout/flexfilelayout.c
+++ b/fs/nfs/flexfilelayout/flexfilelayout.c
@@ -2597,10 +2597,9 @@ static void ff_layout_cancel_io(struct pnfs_layout_segment *lseg)
 			clnt = ds_clp->cl_rpcclient;
 			if (!clnt)
 				goto next;
-			if (!rpc_cancel_tasks(clnt, -ECANCELED,
-					      ff_layout_match_io, lseg))
-				goto next;
-			rpc_clnt_disconnect(clnt);
+			rpc_cancel_tasks_and_disconnect(clnt, -ECANCELED,
+							ff_layout_match_io,
+							lseg);
 next:
 			nfs4_ff_layout_put_deviceid(mirror_ds);
 		}
-- 
2.53.0



