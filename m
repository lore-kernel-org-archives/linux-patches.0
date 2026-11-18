Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795045522;
	b=oWAIiweiSoSF/n4Pt7TeOA1RFAvUBzaNAw06miKfAq8a/Vqpu2vGj/ZfIQC3WL3J88qn
	 G6y2qr82Y/H4fEoLm4l+K7j0WV/Y09S1EgSmBdO0GK0MTC+LjRYwJRmptOMRMdbKoD5NE
	 4+BUezDQsKjc1q610018N/GPkMRqhdcICqR0MtaZMy+RCdWyOMNNnqV/VZVMOUQ1EE0Vt
	 zta4pfBBKp6qipiMGqPdZCjnaVjriDntPVUEQNRv5JJTeJl5ChrWDwCoeiZxL/Srx/7Z5
	 KWSoP+UYW9KOMvR/L5YvHZwc+rWIZSF81eDKuwYDWfUPP2lhm60gpHT1ccu4hBl2UDA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795045522;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=5nn0N/G8UWpK5SX1eVMtW+QxO0dFd3aZq2RH6b+/8cM=;
	b=R7CasKZ9owkWBovYk23OInxNRjozf8v65ytybOWCYwFR+927/n3YdHUwEuYsD/RTFpE5
	 CFy4WSaqHuGZJhNsrOrEg+opI2NTUs2uT4Wu6oWjdYMY8oQ1PcHHSZGfZvFQcIkrN5zh7
	 fhbbhOoT2UKVJ0xJQfoxOVlM1Y4keCw375v0xYwdor4gy9W0FP0qgIwr0gZ7TgyinNnh3
	 aXhnMiwWwCuaK94AmPYCSEfwWh4H4MGFSNvqcsJOutoGq9FkT/cG38L1JLzWB5BM1n2nU
	 ObVgQ134dmssQtSzuYMEvfrngLDUiIK4fVtWmMEgprEWmFqoJvKGqRSdUGkH6/l1YKA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=au+dpymy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0C1D606A31C;
	Wed, 18 Nov 2026 23:45:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=au+dpymy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6E671F000C4;
	Wed, 18 Nov 2026 23:45:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795045522;
	bh=5nn0N/G8UWpK5SX1eVMtW+QxO0dFd3aZq2RH6b+/8cM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=au+dpymyCJtBUKSrM8tliQpJ+5LPg2xmQpVv1wwdhELtzxz3SiT2IplrQXs12M3A+
	 dfmGC3+iA47WlWuAkdxfUrCQR0tkoP8lC9VAJMFz95zU4acmoqXEtvkc7B7/QRfwQc
	 7VofVY2AoP2FS+YQ6eaO5XLodvvo8T3P4wveLMiM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Siwei Zhang <oss@fourdim.xyz>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0954/2857] Bluetooth: L2CAP: Reject invalid TxWindow in configuration requests
Date: Wed, 18 Nov 2026 15:33:08 +0100
Message-ID: <20261118150235.954992766@linuxfoundation.org>
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
index 975d771747aa3..3a4e5aa26f9f1 100644
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -327,6 +327,10 @@ static int l2cap_seq_list_init(struct l2cap_seq_list *seq_list, u16 size)
 {
 	size_t alloc_size, i;
 
+	/* roundup_pow_of_two(0) is undefined */
+	if (!size)
+		return -EINVAL;
+
 	/* Allocated size is a power of 2 to map sequence numbers
 	 * (which may be up to 14 bits) in to a smaller array that is
 	 * sized for the negotiated ERTM transmit windows.
@@ -3627,18 +3631,33 @@ static int l2cap_parse_conf_req(struct l2cap_chan *chan, void *data, size_t data
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



