Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 421B4356A12;
	Tue, 21 Jul 2026 19:15:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784661331; cv=none; b=J/awxEVfmZ3UU2RaJa9fVYix4T2kBIyMEred4Da4sCyTFB7qnSZTPda8Mc+qQVDS+Rcxz9MZNPy2Izg+u/G/jUY4EnusJE5yqbHPJrYAnNgt6pifhhrYgrc+sFR+m41f1Hne6thB+WDfj29sEoIAGG8dsT+1I82Y1Pi5uXRklVQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784661331; c=relaxed/simple;
	bh=fas1ZULNdjY1fsTwkfUqboQkM9OyE90qod98RMIz/pI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sAvq27d8cT09oMYGqHFDZGgN+hTWQS5uNmxfJPpuEhryaGXSuBWx0H+XnfXEmzTc5jfm9VEnH0LOhX6jARTOJeVAZv6I8lKkzR7b84kSbSgsbQeHi+KILkFcmC26H9g0gUEvmZbi93GPZGIRxice6PQyi2yLV5Bd3hDKlSG4kbc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QDXGfV5W; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QDXGfV5W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A91C01F000E9;
	Tue, 21 Jul 2026 19:15:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784661330;
	bh=kE5WFWii9zT21xQJPMRdxjE1jRpW5TlgrA5LNbuPdhA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QDXGfV5W15hCfRecMb96dWYFXLcPjaIh2OLQE/sCRtK4Gi1alSNMIazgq7bnKb6oz
	 ZHnpwZalznYAGtlf5KmaCgatbHiVr+ttXM4cXnyTv2GUi0FktSMFzJ9Cdla58IMSgr
	 DLVch0NIP0mNilrEBwbpjdKCh+hGh8eSYuXVQGa0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Heiko Stuebner <heiko.stuebner@cherry.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0026/1276] net: dropreason: Gather SOCKET_ drop reasons.
Date: Tue, 21 Jul 2026 17:07:49 +0200
Message-ID: <20260721152446.669137376@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kuniyuki Iwashima <kuniyu@amazon.com>

[ Upstream commit 454d402481d45af79ee7eea7e64bce02bbbe9766 ]

The following patch adds a new drop reason starting with
the SOCKET_ prefix.

Let's gather the existing SOCKET_ reasons.

Note that the order is not part of uAPI.

Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Link: https://patch.msgid.link/20250116053441.5758-2-kuniyu@amazon.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Heiko Stuebner <heiko.stuebner@cherry.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/dropreason-core.h | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/include/net/dropreason-core.h b/include/net/dropreason-core.h
index 02e7be19b0428f..76311b3ebfc890 100644
--- a/include/net/dropreason-core.h
+++ b/include/net/dropreason-core.h
@@ -6,9 +6,10 @@
 #define DEFINE_DROP_REASON(FN, FNe)	\
 	FN(NOT_SPECIFIED)		\
 	FN(NO_SOCKET)			\
+	FN(SOCKET_FILTER)		\
+	FN(SOCKET_RCVBUFF)		\
 	FN(PKT_TOO_SMALL)		\
 	FN(TCP_CSUM)			\
-	FN(SOCKET_FILTER)		\
 	FN(UDP_CSUM)			\
 	FN(NETFILTER_DROP)		\
 	FN(OTHERHOST)			\
@@ -18,7 +19,6 @@
 	FN(UNICAST_IN_L2_MULTICAST)	\
 	FN(XFRM_POLICY)			\
 	FN(IP_NOPROTO)			\
-	FN(SOCKET_RCVBUFF)		\
 	FN(PROTO_MEM)			\
 	FN(TCP_AUTH_HDR)		\
 	FN(TCP_MD5NOTFOUND)		\
@@ -124,12 +124,14 @@ enum skb_drop_reason {
 	 * 3) no valid child socket during 3WHS process
 	 */
 	SKB_DROP_REASON_NO_SOCKET,
+	/** @SKB_DROP_REASON_SOCKET_FILTER: dropped by socket filter */
+	SKB_DROP_REASON_SOCKET_FILTER,
+	/** @SKB_DROP_REASON_SOCKET_RCVBUFF: socket receive buff is full */
+	SKB_DROP_REASON_SOCKET_RCVBUFF,
 	/** @SKB_DROP_REASON_PKT_TOO_SMALL: packet size is too small */
 	SKB_DROP_REASON_PKT_TOO_SMALL,
 	/** @SKB_DROP_REASON_TCP_CSUM: TCP checksum error */
 	SKB_DROP_REASON_TCP_CSUM,
-	/** @SKB_DROP_REASON_SOCKET_FILTER: dropped by socket filter */
-	SKB_DROP_REASON_SOCKET_FILTER,
 	/** @SKB_DROP_REASON_UDP_CSUM: UDP checksum error */
 	SKB_DROP_REASON_UDP_CSUM,
 	/** @SKB_DROP_REASON_NETFILTER_DROP: dropped by netfilter */
@@ -160,8 +162,6 @@ enum skb_drop_reason {
 	SKB_DROP_REASON_XFRM_POLICY,
 	/** @SKB_DROP_REASON_IP_NOPROTO: no support for IP protocol */
 	SKB_DROP_REASON_IP_NOPROTO,
-	/** @SKB_DROP_REASON_SOCKET_RCVBUFF: socket receive buff is full */
-	SKB_DROP_REASON_SOCKET_RCVBUFF,
 	/**
 	 * @SKB_DROP_REASON_PROTO_MEM: proto memory limitation, such as
 	 * udp packet drop out of udp_memory_allocated.
-- 
2.53.0



