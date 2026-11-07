Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062378;
	b=JuFhkgFDQbo7qtR9LyEjxXHdaLjs0s67hNWqxkZeW9M25ZjBEetoj3qquFV9PM1DEYf6
	 2dZnbzCNG7UiVTAFmzQDsK7kUuynrUz2aOIK8EHPtZHEiU/18CIMXm4Sqf6AcCLtBw8ie
	 +h0C6d8IE2KGr3T7jVyO0WS1tFELJ3icscQHHkWEBDLQPXWRPbi76NDIN2b36RyGeXD/X
	 vR9ay9lGxGyCqsVtgxBFlsOslsyHnLXbbhAnoOm/QKqann8QwryycLQxhONBxk6SMGpVM
	 2NOl95tWbtnsU61te8Xhs2XlHcI8SphpIuGrZ4xqJ50XCzOmr3Gj/9uzezJ9nMTw+GQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062378;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=F8pgMpdB7BVLK2YxqmTXXAN39o2qDYDL0QcsorVISaI=;
	b=aHpMcu2RVMRA0YhZvaTPHx0F4sB5twbq0vAaFjK9eRNmeMQrGdS0mUl5rVmWAGaO3So3
	 nPVr68p5ECTrDbknN14q/hE+Xr8IWvM9WaBF75tZq+YiVpaQ+2iD+JoDjtHa/jXhygXIA
	 4VfOJjdsQ/Xv0AAH7KW5t11V3RIo6MDWwxW8pP6GHgjxC7kBANXx4bHYnmNTZvqdLz1QM
	 B6twDsJJPX3+xMiCeK+gcK4uWVBherfnZCOnZAPzYvq/NDcarJ1xXBcqZ3t5rC4DhtuIn
	 cywSU+/K5Y1Crcl9Joa1xn9dgXXCKwsa5sHS71NtnDGDxAM0kUa7ikFGpVHnNxG/NZQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MBCDEqhi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A88A46083607;
	Sat,  7 Nov 2026 14:39:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MBCDEqhi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57E9B1F008A1;
	Sat,  7 Nov 2026 14:39:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062377;
	bh=F8pgMpdB7BVLK2YxqmTXXAN39o2qDYDL0QcsorVISaI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MBCDEqhiyBM7ZSloA7N0OwdzMHlsRKl/AJC+D9EJgXkTkdp9vHIRz4lJGwBvd0sj9
	 CA9KMJMOSfubjLUg2refZdEOcBYwJ8vtkbyO1pXKmwiplQgi2QPettZ7qccLOXBtZB
	 wIyhVjt1Eh8CL+5mvnV2YK3iFaugfzN8kJ72d0Nw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Siwei Zhang <oss@fourdim.xyz>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1300/1536] Bluetooth: L2CAP: Reject invalid TxWindow in configuration requests
Date: Sat,  7 Nov 2026 08:55:16 -0500
Message-ID: <20261107135034.303649331@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

From: Siwei Zhang <oss@fourdim.xyz>

[ Upstream commit c5ebb0245fe927cf5fa33510a9cb2799c4a2dd01 ]

A peer can send an ERTM RFC option with a TxWindow
of zero, which is out of spec. It is stored in
remote_tx_win unchanged and later passed to
l2cap_seq_list_init(), where roundup_pow_of_two(0)
is undefined. On some architectures this results in
a ZERO_SIZE_PTR list and a remote kernel oops.

A TxWindow above 63 is out of spec as well. With
6-bit sequence numbers we would then send more
unacknowledged frames than the sequence space can
tell apart.

Reply with L2CAP_CONF_UNACCEPT and propose the
default TxWindow instead of accepting the value, so
remote_tx_win always stays within 1 to 63. Keep the
parameters of an earlier request then, and do not
treat the request as done because an earlier one was.

Also refuse a zero size in l2cap_seq_list_init(), so
any other path that reaches it with a zero TxWindow
fails the channel instead of the kernel.

Fixes: f2fcfcd67025 ("Bluetooth: Add configuration support for ERTM and Streaming mode")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-5-5
Signed-off-by: Siwei Zhang <oss@fourdim.xyz>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/l2cap_core.c | 35 +++++++++++++++++++++++++++--------
 1 file changed, 27 insertions(+), 8 deletions(-)

diff --git a/net/bluetooth/l2cap_core.c b/net/bluetooth/l2cap_core.c
index 69e4ef4834b29..d8c39a4306861 100644
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -323,6 +323,10 @@ static int l2cap_seq_list_init(struct l2cap_seq_list *seq_list, u16 size)
 {
 	size_t alloc_size, i;
 
+	/* roundup_pow_of_two(0) is undefined */
+	if (!size)
+		return -EINVAL;
+
 	/* Allocated size is a power of 2 to map sequence numbers
 	 * (which may be up to 14 bits) in to a smaller array that is
 	 * sized for the negotiated ERTM transmit windows.
@@ -3616,18 +3620,33 @@ static int l2cap_parse_conf_req(struct l2cap_chan *chan, void *data, size_t data
 			break;
 
 		case L2CAP_MODE_ERTM:
-			if (!test_bit(CONF_EWS_RECV, &chan->conf_state))
-				chan->remote_tx_win = rfc.txwin_size;
-			else
-				rfc.txwin_size = L2CAP_DEFAULT_TX_WINDOW;
-
-			chan->remote_max_tx = rfc.max_transmit;
-
 			size = min_t(u16, le16_to_cpu(rfc.max_pdu_size),
 				     chan->conn->mtu - L2CAP_EXT_HDR_SIZE -
 				     L2CAP_SDULEN_SIZE - L2CAP_FCS_SIZE);
 			rfc.max_pdu_size = cpu_to_le16(size);
-			chan->remote_mps = size;
+
+			/* The TxWindow must be within 1 to 63, otherwise
+			 * propose the default one and keep the parameters of
+			 * an earlier request. This overrides a PENDING result
+			 * from the EFS check above, so the request is no
+			 * longer pending, nor done if an earlier one was.
+			 */
+			if (!rfc.txwin_size ||
+			    rfc.txwin_size > L2CAP_DEFAULT_TX_WINDOW) {
+				result = L2CAP_CONF_UNACCEPT;
+				clear_bit(CONF_LOC_CONF_PEND, &chan->conf_state);
+				clear_bit(CONF_OUTPUT_DONE, &chan->conf_state);
+				rfc.txwin_size = L2CAP_DEFAULT_TX_WINDOW;
+				remote_efs = 0;
+			} else {
+				if (!test_bit(CONF_EWS_RECV, &chan->conf_state))
+					chan->remote_tx_win = rfc.txwin_size;
+				else
+					rfc.txwin_size = L2CAP_DEFAULT_TX_WINDOW;
+
+				chan->remote_max_tx = rfc.max_transmit;
+				chan->remote_mps = size;
+			}
 
 			__l2cap_set_ertm_timeouts(chan, &rfc);
 
-- 
2.53.0



