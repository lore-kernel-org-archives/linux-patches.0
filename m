Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795620193;
	b=2Q2W69OwfE+EHkszXCr3C1h4HZpF5DTpj2BwKxia0U4qaf/obIeA9BskPqjRz8b78NeT
	 i60TOdIBY9RFLDUxdt7oMZWbOZAFRwh9BGGQcRchyTye/14cvMyUOVsOOKzSqJONh8ax1
	 FKRLgiC74I/q2iZstZzLV829NKoqKa0joajSzGPJBcSNL7OSaGoKJ86gC9PknmyPc8XoX
	 veC5cIINmuprtBfQ3442CICMfe5yf37wO93sUbpOmsxP+KXfStcQ4jqD414T6EDayWTxu
	 z9nN/AHGZvxaUQtWxtDH6p2jm6B5rpNHRBkfXG75+wTu/TKbpTKlNCORv7lkZQhYkTw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795620193;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ZQJcduByfQN6Hbz0KFe7GOPn+gutCPXbEIz1xrt6wUc=;
	b=ukB2Dk4o6VkklIdjSYmo7+4qaqLyqj/WR/T4SpjO1LriCyzQ2WOM9mh/GZ+zCB/Zum82
	 tqNKKxBM11rF25NtW8tiZHt4Eq3xpbJBEWgMD9xFg4ZTrcInoWoS4hJRraNpoFSXIYv3Q
	 jdDXLOxIL+fVyVVlPKXPFLFVr1T3OMMX3QBF1m7T9lNKdG9HcNiGtoTQdmxgXqZox8MOk
	 af+GjVy/D0szpBb6pRwxApWk25xaXRx9qopFDAbaRuAzZc2Dj2IX3vB7Xk8PxTPRt/ETM
	 xeRv/HxO2pQ3xydqaQUhfgJ9EQ+uR/PQQ2BK+3w8mjXZtQf8bZCGKpn/BrreeakTsQg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fsDFQHpS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7369D606A31E;
	Wed, 25 Nov 2026 15:23:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fsDFQHpS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 652661F000C4;
	Wed, 25 Nov 2026 15:23:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795620192;
	bh=ZQJcduByfQN6Hbz0KFe7GOPn+gutCPXbEIz1xrt6wUc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fsDFQHpSn8wIGr3JBK/WeOvj1bfj2mMUoWnHohRHCJBvElznb6EJ7u5Qr24N+EKCC
	 eLLl5O/uMCUXNs+FOE+EBztKaxQZuNkn3rY723e8KbidBb4/wQTP5+JD4aag+lhaoo
	 DbCi6OW9AJEb5Nas1hByRrLiIYwrHPOwXhmcsGkU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tristan Madani <tristan@talencesecurity.com>,
	Jeff Chen <jeff.chen_1@nxp.com>
Subject: [PATCH 7.3 0794/1005] wifi: nxpwifi: validate scan response TLV sizes before indexed access
Date: Wed, 25 Nov 2026 15:35:32 +0100
Message-ID: <20261125143840.337379341@linuxfoundation.org>
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

From: Tristan Madani <tristmd@gmail.com>

commit bcc5bbaa6de61a0ccaa57228ca233b4390eca27e upstream.

The scan response handler indexes into TSF and channel-band TLV arrays
using a loop counter derived from the number of BSS entries, but never
checks whether the TLV data is large enough. A firmware response with
fewer TLV entries than BSS entries leads to reads past the TLV buffer.

Add bounds checks that verify each indexed access falls within the
TLV's declared length before dereferencing.

Fixes: 73b01e57ed3e ("wifi: nxp: add nxpwifi driver for IW61x")
Cc: stable@vger.kernel.org
Signed-off-by: Tristan Madani <tristan@talencesecurity.com>
Signed-off-by: Jeff Chen <jeff.chen_1@nxp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/nxp/nxpwifi/scan.c |   18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

--- a/drivers/net/wireless/nxp/nxpwifi/scan.c
+++ b/drivers/net/wireless/nxp/nxpwifi/scan.c
@@ -2017,12 +2017,22 @@ int nxpwifi_ret_802_11_scan(struct nxpwi
 		 * was received.
 		 */
 		if (tsf_tlv)
-			memcpy(&fw_tsf, &tsf_tlv->tsf_data[idx * TSF_DATA_SIZE],
-			       sizeof(fw_tsf));
+			if ((idx + 1) * TSF_DATA_SIZE <=
+			    le16_to_cpu(tsf_tlv->header.len))
+				memcpy(&fw_tsf,
+				       &tsf_tlv->tsf_data[idx *
+							  TSF_DATA_SIZE],
+				       sizeof(fw_tsf));
 
 		if (chan_band_tlv) {
-			chan_band = &chan_band_tlv->chan_band_param[idx];
-			radio_type = &chan_band->radio_type;
+			if ((idx + 1) * sizeof(*chan_band) <=
+			    le16_to_cpu(chan_band_tlv->header.len)) {
+				chan_band =
+					&chan_band_tlv->chan_band_param[idx];
+				radio_type = &chan_band->radio_type;
+			} else {
+				radio_type = NULL;
+			}
 		} else {
 			radio_type = NULL;
 		}


