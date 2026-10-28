Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793209691;
	b=dLuVeOCmuUiR2csrlnnzPd8Bomdhp1vlvGbBXjZhjHi2O8koSxq2DPn76dQook4b9uUY
	 p0FU1+L4cAc2SRdCM0QVOjAajmKEO2Kcv7GYpsBVd73nBUge3rJ2SOZrH+1jzEmQfwG80
	 x7QTvD8MmV/O1kIxRzXdYPeSmqmDwo3BG03UlNYkjKrVRh0dyPDVo7Mfe4w5Y3okNDNlY
	 IqIPwUIGSRR9ZFT6AqMqZQ5U68U9RtIzh/kLq07kPitf5lhsncjZ33XfgKkExrb9RLZzF
	 RrCBtqNQiBTbNbWir4yOg6Uu4jLGHgn6c3XpQTxyx3GexENmoDWS4ExaZ4YfP1ppHWw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793209691;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=x9831MnJtVJOXvM9K7RD6YEPd2NaIFcgNy+JFblo3fQ=;
	b=KrCwZhbLfzzmVK+jzrzuMrA3hCFsCLz/fqCNORXdz5mOgD0Pjoz+FsFcX42aUxUmaL3D
	 2c5F4ZIb/fprUozbe3ClLM5hQ2MkjhsDNx8yqS/lv+9JbLkiru7ACS0KfytCL4FpcC9Lt
	 hJ/jVeLE3T4vVPI6i54SUFn8qwLgucgdpdvveT6wf4nnT9IFllLEqHnRtulym9bDUdlvs
	 GJi8+N4HihpM2OkgEgud5gvTqZSxtMgOSFQcfMcOYHOrNNItlDTpV+DdMZPZ0AmLKYuNf
	 t306LzHNnak6nn3vL6MkjiGGgJ+utrpc78Z1fgUZTeOUEss7r8/e+ec2mYMoqN1Ss4g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="fwe1Df/5";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61875606A323;
	Wed, 28 Oct 2026 17:48:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fwe1Df/5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 822671F031E2;
	Wed, 28 Oct 2026 17:48:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793209691;
	bh=x9831MnJtVJOXvM9K7RD6YEPd2NaIFcgNy+JFblo3fQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fwe1Df/5pRBfAB0nGAFwm75Ki071T7pv3/pZo5fJWD07AUCiVM6Tt7uZEsjPCxhnC
	 7uuJyHvD8bTq9mss4WLTF8QFbxhNY1AaagHZ9I5BYB6F4G8WjxdGlJKCB2a+YUZ3EJ
	 U5aNy+biogQv6t6pvflryPFCMkWiW/6VXMctYQSo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mashiro Chen <mashiro.chen@mailbox.org>,
	Bernard Pidoux <bernard.f6bvp@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 008/109] net: netrom: validate source address in nr_find_socket()
Date: Wed, 28 Oct 2026 17:59:52 +0100
Message-ID: <20261028165942.558448198@linuxfoundation.org>
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

From: Mashiro Chen <mashiro.chen@mailbox.org>

nr_find_socket() dispatches incoming NR_INFO frames into a connected
socket by matching the frame's circuit index/id pair (bytes[15-16])
against the socket's my_index/my_id.  It performs no validation of
the frame's source callsign against the socket's dest_addr.

This means any node on the network can craft an NR_INFO frame with
a guessed or brute-forced circuit index/id pair and have it accepted
into an arbitrary STATE_3 connection as if it came from the legitimate
peer.  Circuit IDs are assigned sequentially starting at (1,1), making
them predictable in practice.

Combined with other receive path bugs, this lets a third party feed
frames into a circuit it does not own. nr_find_peer() already checks
the source address for CONNREQ; do the same for the other frame types.

Fix by adding a source address parameter to nr_find_socket() and
requiring it to match the socket's recorded dest_addr for all
frame-dispatch lookups.  The internal nr_find_next_circuit() caller,
which only checks for circuit ID availability, passes NULL to skip
the source check.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Signed-off-by: Mashiro Chen <mashiro.chen@mailbox.org>
[F6BVP: rebased on mod-orphan; dropped the reference to an unassigned
CVE from the changelog. Checked that every caller other than
nr_find_next_circuit() is in nr_rx_frame() for non-CONNREQ frames,
whose network source is the remote node recorded in dest_addr.]
Signed-off-by: Bernard Pidoux <bernard.f6bvp@gmail.com>
(cherry picked from commit 70bf32b0eda85781a416cb929b7c6b4761abd2a8)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netrom/af_netrom.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/net/netrom/af_netrom.c b/net/netrom/af_netrom.c
index 0e70d149abcd5..d9c484705c9e7 100644
--- a/net/netrom/af_netrom.c
+++ b/net/netrom/af_netrom.c
@@ -162,7 +162,8 @@ static struct sock *nr_find_listener(ax25_address *addr)
 /*
  *	Find a connected NET/ROM socket given my circuit IDs.
  */
-static struct sock *nr_find_socket(unsigned char index, unsigned char id)
+static struct sock *nr_find_socket(unsigned char index, unsigned char id,
+				   const ax25_address *src)
 {
 	struct sock *s;
 
@@ -170,7 +171,8 @@ static struct sock *nr_find_socket(unsigned char index, unsigned char id)
 	sk_for_each(s, &nr_list) {
 		struct nr_sock *nr = nr_sk(s);
 
-		if (nr->my_index == index && nr->my_id == id) {
+		if (nr->my_index == index && nr->my_id == id &&
+		    (!src || !ax25cmp(&nr->dest_addr, src))) {
 			sock_hold(s);
 			goto found;
 		}
@@ -219,7 +221,8 @@ static unsigned short nr_find_next_circuit(void)
 		j = id % 256;
 
 		if (i != 0 && j != 0) {
-			if ((sk=nr_find_socket(i, j)) == NULL)
+			sk = nr_find_socket(i, j, NULL);
+			if (!sk)
 				break;
 			sock_put(sk);
 		}
@@ -928,7 +931,7 @@ int nr_rx_frame(struct sk_buff *skb, struct net_device *dev)
 		if (frametype == NR_CONNREQ)
 			sk = nr_find_peer(circuit_index, circuit_id, src);
 		else
-			sk = nr_find_socket(circuit_index, circuit_id);
+			sk = nr_find_socket(circuit_index, circuit_id, src);
 	}
 
 	if (sk != NULL) {
-- 
2.53.0



