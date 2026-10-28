Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793209643;
	b=XHNmFcqyuYIwojPNMzz9/4lsrTPCBEj7w/DT8HE3vWudkwLYrqWrlsRlspMdZlOAAz4p
	 NF+0HVcmgyz880n1z9ETFDpYLTQBofAdx6GsLlw3dOedc8xarfP17DMOjSnYhH1yPAw7o
	 fD0g/0bYhCvGxPwhZr5DkIpz6LXJmpjAXrB3JQGm7IB+yob4BVr3aRZ9MUCjL5gOsi+HG
	 9q1vC0C50uhvrKykoiK18lE3E6jBgsCkxI4SJBED7wk68Lwrb0q0n/Um6mju9yqnauag2
	 6jXEZRv6xLp64mB6zA0O3vM9JDFoTWpPhgO6tCRABywCMqgllkmxej5e4fBXb6HEn+w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793209643;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=b/NRO1QHM9q78DXT7vOOszY4SRXFe8Fq5Y7hYhpfGYI=;
	b=IkDIwLUKoL6lVxzB4UEWyN6gBrdk5b6JxkQn5nWHZd9GTYltwebDfu5CN5XVpTvnJCyG
	 LxhdjhNWXdwpoFBJAWPFYpvCYpotrfpUF70TLsLyaUq1ZZtFqmWTJ9A/lj2e8QCchdvEB
	 Db516UXzT5fvW0QPmzn4NUoP/DR8JCMOP5FZDAJCjZ/MoJnUIWMNIu4Lry2UU1maG3r7N
	 Yxa1GhRv6oLUkk2zHMfUhXD9sNjg5jXzpZrl22AR3lx25z+8QFw4TD4YWE7nur4dve7OI
	 7uPtWmV3Yfj/eD62dXDnZHjt2bmPwQ+StqGRt+yq1WgmwC9nFl3GnBOERI2KhM2oquQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=A9hfX5ma;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D50E8606A321;
	Wed, 28 Oct 2026 17:47:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=A9hfX5ma
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 316681F01829;
	Wed, 28 Oct 2026 17:47:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793209642;
	bh=b/NRO1QHM9q78DXT7vOOszY4SRXFe8Fq5Y7hYhpfGYI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=A9hfX5maFhfOjHrk8KSKD9zHcxPOqVyN/H1pAjeKBeRceXbjaJ3O+AUc/S1OPZB3L
	 2H7/BBzW/MA3aypYqABupVz0wfQy7OAjSGayRFG5VLz22/qaXe9OlEjss0h15N7KN9
	 veyMhNDAx0zKy4fOq4KANcFqH9kTVnvuWj2L1ReM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bernard Pidoux <bernard.f6bvp@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 026/109] ax25: send a private copy of each I frame
Date: Wed, 28 Oct 2026 18:00:10 +0100
Message-ID: <20261028165942.979501067@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165942.357251485@linuxfoundation.org>
References: <20261028165942.357251485@linuxfoundation.org>
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

From: Bernard Pidoux <bernard.f6bvp@gmail.com>

ax25_kick() keeps every I frame on the ack queue until it is
acknowledged and hands a clone of it to the device. After a REJ or a T1
timeout the frame goes back to the write queue and ax25_kick() clones it
again. A clone shares its data with the original, so ax25_send_iframe()
and ax25_transmit_buffer() write the control field and the address
header of the new clone in the very bytes used by the previous one. If
the previous clone is still waiting in the device queue, its control
field is rewritten there: it leaves with the N(R) current at the time
of the retransmission, not the one it was sent with.

Frames queued behind it, an RR for instance, were built in between with
a lower N(R). The peer then receives an N(R) lower than one it has
already been given. ax25_validate_nr() rejects it and
ax25_std_nr_error_recovery() resets the link with a SABM, in the middle
of a transfer. The layers above pay for it: on a ROSE circuit, the
frames replayed after the reset carry stale sequence numbers and the
circuit is reset as well, with loss of data.

Hand a private copy to the device instead. The frames are small (256
bytes of data by default) and the link is slow, the extra copy is not
measurable.

Found on a test bench: two virtual machines with four CPUs each, a
6.12.94 kernel with KASAN and lockdep, one ROSE circuit over an AX.25
link on a serial line (mkiss), 192 messages each way in bursts of 24,
and three REJ frames injected by one side. Instrumentation showed that
frames reached the driver in the order they were given to
dev_queue_xmit(), that V(R) never went backwards on the sender, and
that the driver nevertheless saw frames whose N(R) was lower than the
one before.

Counting, on the receiver, the frames whose N(R) is lower than the
previous one:

 - this code plus the two pending AX.25 fixes used on the bench (REJ
   guard, requeue on re-establishment): 4 runs, 13 such frames, 4 link
   resets; with this patch: 6 runs, none, no link reset;
 - the same with the transmit serialisation patches for AX.25 and ROSE
   on top: link resets in most runs before; with this patch: 6 runs,
   none, no link reset, no ROSE reset, 192/192 messages both ways in
   every run.

Signed-off-by: Bernard Pidoux <bernard.f6bvp@gmail.com>
Assisted-by: Claude:claude-opus-5-5
(cherry picked from commit 1b464137f3173fadf81a7a1bf4a9584ebaf72c7b)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ax25/ax25_out.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/net/ax25/ax25_out.c b/net/ax25/ax25_out.c
index f082b69126623..7c4ebef5ae6c2 100644
--- a/net/ax25/ax25_out.c
+++ b/net/ax25/ax25_out.c
@@ -341,7 +341,16 @@ void ax25_kick(ax25_cb *ax25)
 	ax25->vs = start;
 
 	do {
-		if ((skbn = skb_clone(skb, GFP_ATOMIC)) == NULL) {
+		/*
+		 * Send a private copy, not a clone. The frame stays on the
+		 * ack queue and is sent again after a REJ or a T1 timeout,
+		 * while the previous copy may still be waiting in the device
+		 * queue. A clone shares its data with the original: building
+		 * the frame again would rewrite the control field, and so
+		 * the N(R), of the copy already queued.
+		 */
+		skbn = skb_copy(skb, GFP_ATOMIC);
+		if (!skbn) {
 			skb_queue_head(&ax25->write_queue, skb);
 			break;
 		}
-- 
2.53.0



