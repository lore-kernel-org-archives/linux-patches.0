Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793215908;
	b=vx5H0/Z8Hfhfcdr6wJR6PylLGtIITj8HrWMDPfKldHKmlK35HxCRxIHID11J6lnIFR5S
	 r1rwg3Qk5nC0AsjyYj3lchg/fPj4UKvzEaVdExZLHZdaG/mZHTQGzI22UTq/M0yqtWcXG
	 ZCkyTan7YB/IuT2DJMs0uMrC430p+DRVtkIporvhwQnIFZ/cO80DamKNI3vRbZ4gb9Cbp
	 0UF9lnM9jPm9q3x7FTyysLBr7tz57YfILxt5lbZ3z98tjiK9O1QVvOgWx9EZF/77YfCC0
	 xHJCXmjYqzIjv2dU9oTN0yZB1MJSmQVYhsyu7Iy3x5aixswiabQYs7fPtn3AFluDwiw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793215908;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bSSp8uMcso5DIlKABCixS9YQL+Q/s8T4BpcMM5l9a9I=;
	b=gd0ufuaCS4BZ7nNTWuuPESZTHbmVn4Aq2jCS1RLggWw6yGcSI/7+mOCUucFzibD37Zdv
	 NHx2FpGUEzZEoXhIClNtXSZ+cwcwgWKmTVYF8ogGnPcEmgehn+ewxT9BTFFpeVBqTDJs6
	 WIymZUpwjgBx9czyDGJFNE1Ce8gIUxZYSjL5ZObJjJYP6YV8WfykSFq7AtKsewrunI9Cn
	 x7VGZcxF4W3BP+/0JAGOBiLwE4t+1flvKSY3hVcaIw+jaoNBVfC1i7IEcOGka+jIO8D3Q
	 wF4H/nSW/lYvdMPJsID1zYU8iB6hq4rTrV79V5+i8YrUTze72vnW0CS/vnTdjVrp/+Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=01v6CegR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCF9B606A31E;
	Wed, 28 Oct 2026 19:31:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=01v6CegR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 281DD1F01825;
	Wed, 28 Oct 2026 19:31:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793215907;
	bh=bSSp8uMcso5DIlKABCixS9YQL+Q/s8T4BpcMM5l9a9I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=01v6CegRhCODx/91QcH3qxTckcn3jDgEi8ZoIvzCHH94ovGUR1ehnY5kKTPPv9iGt
	 QcGbc724Es0R0L/8R38NeSGQcXOlIiPGlBtBkm5oegx216uhYfQya1O1QIFDdQEKsk
	 rE6Au/F3ezvZo8pfmwRIJYw+lcC6IexoBLIXfTwk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fan Ye <fy15309206903@gmail.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1375/1887] net: thunderbolt: Mark the connection down when bringing it up fails
Date: Wed, 28 Oct 2026 17:57:51 +0100
Message-ID: <20261028170530.739480408@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

From: Fan Ye <fy15309206903@gmail.com>

[ Upstream commit 3c8b26ebf525ba5960510f48c6e9936a79ebe76f ]

Every failure path in tbnet_connected_work() undoes its own work and
returns without clearing login_sent, so the connection still looks
established. The next tbnet_tear_down() therefore takes its main branch
and repeats a teardown that already happened: it stops rings that are
already stopped, which is a dev_WARN() and fatal under panic_on_warn,
and it releases net->remote_transmit_path even on the HopID mismatch
path, where this connection never owned that id, silently freeing one
that someone else is still using.

Clear login_sent on those paths. That is enough for tbnet_tear_down() to
leave the unwound state alone, and login_received has to stay set: it
records that the peer has logged in and carries the transmit path it gave
us, which nothing on this side can make the peer send again. Two things
change beyond keeping the teardown out of the way: the logout request in
that block is no longer sent, and the peer's next login request now
re-queues our login work rather than connected_work, giving the
connection a fresh login instead of a retry on stale state.

Fixes: e69b6c02b4c3 ("net: Add support for networking over Thunderbolt cable")
Cc: <stable@vger.kernel.org> # 5.13+
Signed-off-by: Fan Ye <fy15309206903@gmail.com>
Acked-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20260811-b4-tbnet-hopid-v3-2-9e75d1b51331@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/thunderbolt.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/net/thunderbolt.c b/drivers/net/thunderbolt.c
index a6a52d7d190af..5f0d3f38742b1 100644
--- a/drivers/net/thunderbolt.c
+++ b/drivers/net/thunderbolt.c
@@ -606,6 +606,14 @@ static int tbnet_alloc_tx_buffers(struct tbnet *net)
 	return 0;
 }
 
+static void tbnet_connect_failed(struct tbnet *net)
+{
+	/* Leave login_received set: only the peer can make it true again. */
+	mutex_lock(&net->connection_lock);
+	net->login_sent = false;
+	mutex_unlock(&net->connection_lock);
+}
+
 static void tbnet_connected_work(struct work_struct *work)
 {
 	struct tbnet *net = container_of(work, typeof(*net), connected_work);
@@ -627,6 +635,7 @@ static void tbnet_connected_work(struct work_struct *work)
 		netdev_err(net->dev, "failed to allocate Rx HopID\n");
 		if (ret >= 0)
 			tb_xdomain_release_in_hopid(net->xd, ret);
+		tbnet_connect_failed(net);
 		return;
 	}
 
@@ -669,6 +678,7 @@ static void tbnet_connected_work(struct work_struct *work)
 	tb_ring_stop(net->rx_ring.ring);
 	tb_ring_stop(net->tx_ring.ring);
 	tb_xdomain_release_in_hopid(net->xd, net->remote_transmit_path);
+	tbnet_connect_failed(net);
 }
 
 static void tbnet_login_work(struct work_struct *work)
-- 
2.53.0



