Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795619723;
	b=xPCWzSpQ+5TNP3JAsMVbK9drmKqBgVC5DUEGccYSFMyqr/wu+KK2NoKhSqz1u+SU0arw
	 BslpMH5tLS5UyiuVqn4GSE8s2tfXt2fNEab4C9VeYZa6PwrrCmViG0bhHjaKjtbyaHmlp
	 3q6M0ZhW1k8Rf4Xpc4Esf7bZOHC2ThhmgDhr+i0ta/LHceWWFwyijREr4T38OqBV7brF2
	 jc9uwHVC7nXcsXdwYVRpVrxaK+mSLUvv6KkTLem0igeDSFLkVQ+wSZ1J9p0oNPZz2JeqL
	 UUkpJujyY/StnIkEOxLyAUvy/GhO7DMwpQMPYcKzAiL5uDnjbfNLNPFh/qYmZKek1aQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795619723;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7aygBLdDYuv/+lMncWbBM7gQoG4yYA9uzLpgjih1BZQ=;
	b=4EbvSdzAeEpV+Y8EDv/v7Rue3DI1QThKTnPbwewBBJCg9rXxpuB8bD/FsUohnIB/eFkW
	 d1N6T9qP4SLI9+ntARqWNSgKqqUEJbcRRwxbduyAOAe5IFvgODO0VB6cI3fNP5YW9psEA
	 AoLThS6u3g6x52z+iDKTD3xgl8m/j1TFKTAF4FkGOUpMEgypwmezbU1tVIqx7NQN2Ewod
	 moFZn6clNLBOUkQmQm496qLXvmAvINmlWnidOiTSUwpfqWIGqWbbmcOooTAlk0D8LlCXe
	 UGofMyPPdtA1yxH2EsnJqiMe2xVU42EN5GhEltHkCZZkd7BOlED+OTd7ACEpxR+Za4Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yBbMc8uB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB2A9606A32E;
	Wed, 25 Nov 2026 15:15:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yBbMc8uB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFE571F000D8;
	Wed, 25 Nov 2026 15:15:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795619723;
	bh=7aygBLdDYuv/+lMncWbBM7gQoG4yYA9uzLpgjih1BZQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yBbMc8uB/tlHJCDBdZfvj6qJ9RW3C9BRhhfKsRfNFBvGdX+ORE2ZoRsh0tJwciLxm
	 EOYluvBn9kEy/AFacyNIq462nf7IDKMNb+9/pA/eYbeqIWy1gQR4+jsiunHO3aMICl
	 CYxePgFOCF5QiBKtDG8RDPDIgGL9/4oRUVO/A3W0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhao Li <enderaoelyther@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 7.3 0686/1005] Bluetooth: L2CAP: Keep recvmsg from resuming a closed channel
Date: Wed, 25 Nov 2026 15:33:44 +0100
Message-ID: <20261125143837.822124203@linuxfoundation.org>
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

From: Zhao Li <enderaoelyther@gmail.com>

commit 1f2ac56137c51be0601e18a163d817e02a15913f upstream.

Reading buffered ERTM data after ACL link loss can clear local busy and
send a supervisory frame after l2cap_conn_del() has destroyed the HCI
channel, which oopses on a NULL pointer in hci_send_acl(). The socket still
owns its L2CAP channel, so its lifetime does not protect the underlying HCI
channel.

Require BT_CONNECTED before clearing local busy in recvmsg. The socket lock
already held here serializes this check and send with teardown, which
closes the socket before the HCI channel is destroyed. Continue to allow
buffered data to be read after disconnection.

AI assistance was used.

Fixes: 61aa4f5b9f43 ("Bluetooth: Use the transmit state machine for busy state changes")
Cc: stable@vger.kernel.org # needs adjustments for 5.15
Signed-off-by: Zhao Li <enderaoelyther@gmail.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bluetooth/l2cap_sock.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/net/bluetooth/l2cap_sock.c
+++ b/net/bluetooth/l2cap_sock.c
@@ -1332,7 +1332,8 @@ static int l2cap_sock_recvmsg(struct soc
 	 * available.  This avoids resending large numbers of
 	 * frames.
 	 */
-	if (test_bit(CONN_LOCAL_BUSY, &pi->chan->conn_state) &&
+	if (sk->sk_state == BT_CONNECTED &&
+	    test_bit(CONN_LOCAL_BUSY, &pi->chan->conn_state) &&
 	    atomic_read(&sk->sk_rmem_alloc) <= sk->sk_rcvbuf >> 1)
 		l2cap_chan_busy(pi->chan, 0);
 


