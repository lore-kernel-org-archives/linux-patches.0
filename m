Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795030909;
	b=t5VcA1Wh+xKp/DJkrGHYwKSepKSMLbOCbHYIhtjTzawwKffEPVWmXYieXyF/AvDtO+A/
	 pAJ3tepdBcQZq5PzHjy5W/D7HqtaryrFnMmK+wIpCrHQYm8cbQOp5jhiYmPVlMh2MYATp
	 Wi/dcacLCiTdkkKIFpPRvHmhMgnfR5yvIXk2pqbBx8SEakWaKjcB6VdUusUj3k9p0TXFS
	 QgiAr71KmGJOvrFNxj3n95Y0v2Gcu1ZrVf/e4M6NL4F0TMigMQ15ozLBhByLR6LIGEWl2
	 kWl5QAZWaJwrDXSt8dyFnGBJWP0olsSUTYvvuXyd2jpaTxe36SzhviRsaxiyZEGNnmw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795030909;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=HVrKjZkxsgV3yJKGfrK9XM/3t0d9LxuDaosZ7Zb2CDg=;
	b=P3ob4UI1ij3bvY1v6O/ogLd2O0tP1rRtNAGo3w2wAxh2PcpvzZHX72uIfMfMXc3DFck8
	 biQWTw3mxNwV2AkkqAtFFZC418+t6Tur2jAGLObiS6feY7SBurlwCYKsWBGgnIYMNrUMr
	 Kv5o5vNTE7ud5YR+ritZN9B8DjSDe48wRL84fNBTVsYRuKAhlr938VLSDyFtKjfcSKPWx
	 GYPyBeNisX7b9xgnKUS0GUti/TpTan2Rpzto2L4eVeYrgVds1mbQLbLZNyUhsfTrY6FVi
	 rdIc6GLxaY+FWe62r/0MQBWghSJzVNBTp7++eEkj57jgRc6chiplHulvP78a/M0ArtA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=x3h7p74t;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 324B7606A331;
	Wed, 18 Nov 2026 19:41:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=x3h7p74t
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FF061F000C4;
	Wed, 18 Nov 2026 19:41:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795030909;
	bh=HVrKjZkxsgV3yJKGfrK9XM/3t0d9LxuDaosZ7Zb2CDg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=x3h7p74t50mjD/0HHE0G3d5eUHnatUBWFENADlS9o31aNFacat9qWchsTk5j/AC1Y
	 MhVBj9TC/iP1ZCo8K4R8OW79pEng1uKSrKgTwxeTX8ACDYHrmXIFHyjHSPhopl0Rbl
	 zUfGRyJbx1Oq8lSD2WMXJSH5eB4sUgry3wNq/jjc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <cel@kernel.org>,
	Anna Schumaker <anna.schumaker@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0870/1756] SUNRPC: reject a client-side TLS alert record that is not two octets
Date: Wed, 18 Nov 2026 15:49:57 +0100
Message-ID: <20261118150043.950066855@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chuck Lever <cel@kernel.org>

[ Upstream commit 1e87497aac8d2d4aee9b288ba43f58d1690b9a89 ]

tls_alert_recv() reads two octets from the kvec it is handed and does
not check the length (net/handshake/alert.c). xs_sock_process_cmsg()
calls it for any alert record, and the alert[] buffer that
xs_sock_recv_cmsg() supplies carries no initializer. A one-octet alert
body leaves the description read from uninitialized stack and reported
through trace_tls_alert_recv().

The peer controls that length. Neither tls_rx_msg_size() nor
tls_rx_one_record() enforces the two-octet Alert payload. A TLS 1.3
record carrying only the inner content-type octet decrypts to a
zero-length payload. RFC 8446 Section 5.1 requires a record with an
Alert type to carry exactly one message, so any other length is
malformed. RFC 9289 Section 5 bars RPC-with-TLS from negotiating a
version below TLS 1.3, so no other alert framing applies.

Require exactly two octets before parsing and return -EACCES
otherwise. xs_stream_data_receive() already treats -EACCES as a fatal
alert and reports it to the pending tasks. Gate the path on a control
message rather than a positive count so that a zero-length record
reaches the check.

Fixes: cc5d59081fa2 ("sunrpc: fix client side handling of tls alerts")
Signed-off-by: Chuck Lever <cel@kernel.org>
Signed-off-by: Anna Schumaker <anna.schumaker@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sunrpc/xprtsock.c | 20 ++++++++++++++++++--
 1 file changed, 18 insertions(+), 2 deletions(-)

diff --git a/net/sunrpc/xprtsock.c b/net/sunrpc/xprtsock.c
index b021c9b8477c1..ec7b29780eb94 100644
--- a/net/sunrpc/xprtsock.c
+++ b/net/sunrpc/xprtsock.c
@@ -407,9 +407,25 @@ xs_sock_recv_cmsg(struct socket *sock, unsigned int *msg_flags, int flags)
 	iov_iter_kvec(&msg.msg_iter, ITER_DEST, &alert_kvec, 1,
 		      alert_kvec.iov_len);
 	ret = sock_recvmsg(sock, &msg, flags);
-	if (ret > 0) {
-		if (tls_get_record_type(sock->sk, &u.cmsg) == TLS_RECORD_TYPE_ALERT)
+	/* put_cmsg() shrinks msg_controllen, so a short one means
+	 * kTLS filled in u.cmsg.
+	 */
+	if (ret >= 0 && msg.msg_controllen < sizeof(u)) {
+		if (tls_get_record_type(sock->sk, &u.cmsg) ==
+		    TLS_RECORD_TYPE_ALERT) {
+			/* RFC 8446 Section 5.1 requires a record with an
+			 * Alert type to carry exactly one message. An alert
+			 * is two octets. tls_alert_recv() reads both without
+			 * checking the length. alert_kvec caps the count at
+			 * two, so a longer record fills it as well. kTLS
+			 * sets MSG_EOR only once the record has been
+			 * drained.
+			 */
+			if (ret != sizeof(alert) ||
+			    !(msg.msg_flags & MSG_EOR))
+				return -EACCES;
 			iov_iter_revert(&msg.msg_iter, ret);
+		}
 		ret = xs_sock_process_cmsg(sock, &msg, msg_flags, &u.cmsg,
 					   -EAGAIN);
 	}
-- 
2.53.0



