Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795058537;
	b=3YYanalmEnYBkkBMaq+BXcSaCHI74aKvJWbzdndkRVUlMFaDk+gBpQ5c8F7YBvO+Sdku
	 AuH/ZF8JLZCuit9lEcnD3FfP9bJrIm6DCzGm3zebRXg+dMJNErwY9O/3KdC+UsrtllJjr
	 R6B9HsWEQVfn+yi3/Dvv1RGIU/OJ1UcPm/ypuNVY05blNWlLq35WzmbSQwgCFabmyxo8F
	 AnP3ETPi/EJnxIfiawJbO7Wb1Tdhn213LUFdH6pHiU8ZHcZppPXDRiNjJTaTR80Od7tr+
	 T0kVW/1nIBApMA1gY26sQIkpDLkqN8uvo4lhUA2x3N9kxtELz97MWHGxmMAXwuHMCSA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795058537;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Mw8xt1kX/N5neiu3j76LvRirtJ/HFwj2nYqHhqJ481g=;
	b=v9d8Lm+9kscNUz8G0HRjklCUUVgKPmhrRBVcCV7ChGKOXKkMX6jeF6fXiN9k1KMWD1f2
	 1jtXsWJGDel4A/CONEuR7fGgNdhbn4km+rgV5aJJG0Qi6wyPrMrM7zbbRSpDmhTmK+tFd
	 8oHcnSWOoW+VSgwQxL/ylcuiA5fWtmqbkW/poQZxddLWBi7wGi77JKekF3ngoER7kB6Tf
	 +vi1JCp6Dn/cybf6316wgc4dZghiutGEZQ9Yz0X7UBdQeo1fU/6sGeZZcmsMgMOg/fHSn
	 ewd3ZZ2xwa3NHo2AqozKZdzFq38wFHGHuMg/J0VWXl6Ah4gEmCXSgq+vR7hVB00csvA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=o63Qvc9t;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8340F606A320;
	Thu, 19 Nov 2026 03:22:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=o63Qvc9t
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D48AE1F000C4;
	Thu, 19 Nov 2026 03:22:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795058537;
	bh=Mw8xt1kX/N5neiu3j76LvRirtJ/HFwj2nYqHhqJ481g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=o63Qvc9tGpK6/nyUTVS1dq4nRZq9r/ffzQsXQr4YR41KAoszrE6nlJGpmAI//nxEC
	 d2OCzXNtgeakIPvhbGqK5Ni661onweoNEhcFGsOJ7Rt5DEM/xyT0Lx2RdQqUF10uOh
	 FywafSMIm8mN2k3Sa56S16vdFEuJMJL1k8lZb1pE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Siwei Zhang <oss@fourdim.xyz>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0520/1848] Bluetooth: L2CAP: Reject invalid TxWindow in configuration requests
Date: Wed, 18 Nov 2026 15:42:38 +0100
Message-ID: <20261118145936.465243129@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 244cd0865df08..de97a746bb38c 100644
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -347,6 +347,10 @@ static int l2cap_seq_list_init(struct l2cap_seq_list *seq_list, u16 size)
 {
 	size_t alloc_size, i;
 
+	/* roundup_pow_of_two(0) is undefined */
+	if (!size)
+		return -EINVAL;
+
 	/* Allocated size is a power of 2 to map sequence numbers
 	 * (which may be up to 14 bits) in to a smaller array that is
 	 * sized for the negotiated ERTM transmit windows.
@@ -3814,18 +3818,33 @@ static int l2cap_parse_conf_req(struct l2cap_chan *chan, void *data, size_t data
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



