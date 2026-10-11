Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B297E54705F;
	Sun, 11 Oct 2026 03:28:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791689294; cv=none; b=mO4NFO7SHdc7tuI88/Donaq3MnaLWOrlkKDTvCAKbVU3ERGvDoyXpFna3g4zIAnGIMY42GErulIek4UtSLX5zsw83ha7qs/zNQZnNIsI1HlThKzWj8zSJ1wX/qIJj/Bi5lzG7sHawEcqLH7KavvkYQssHpcC4pRv2nvCDh+N54M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791689294; c=relaxed/simple;
	bh=/YPLbqEcFVqjmRMWusjhbUsaybFteEuS+PBKtWSD37I=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=bXFLefT+GYWA+oT4nRFG0dnjNE5bK2BkctN5zdX+8YbUruFcmv6UE8gHlErCHFHq/Rb1htSKxuGQTXGzPxQGa7ECmUjVyAp1qOPnwmXQO3S8EOmGwA8ywTS2IjJWYKN9xq6jjiIFA1rrGC5A6WPEBR+cvguLXgW2tEpfHiIGaHA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=pass smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=pafyuOO3; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="pafyuOO3"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=ZmJlsXYI+H0VdIL85rNDi+Xp9VytUUOPhTxfLykp7to=; b=pafyuOO3/E5PdQ3Yeib6eUID6A
	yrr4hsUiVq+lj2Iv6KCajrqzgyVEJmn+f52VXXaLtXRgIdb7ptxr/rS5KFlj3C96VpPHSnrJ5cpgr
	UCLAZf/9oR9nxdj8USg8WHVi2T6AwW/lQEKdj1yjOpzTS4PDew6VqrqY4CnxGHhTJ9ps06GQKzCZB
	W7T00iwK1lPqHM3QKfIJdy6KuJR0YGu+pcuc3g2JUwqFT7a3GH1SIu1aSI3K96uOehfw6zhM+Xcds
	s0rwok+R02Ixp0bt5hcd32HfORw4gLFw9vcuXMwmlGNpj+fKbau9MkpDJbvv7YfRaHEdwQt72PXm0
	wZlD9yQA==;
Received: from [50.53.43.113] (helo=bombadil.infradead.org)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1xFkEE-00000008gGO-1EWR;
	Sun, 11 Oct 2026 03:28:02 +0000
From: Randy Dunlap <rdunlap@infradead.org>
To: netdev@vger.kernel.org
Cc: patches@lists.linux.dev,
	Randy Dunlap <rdunlap@infradead.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>
Subject: [PATCH net-next] net: dccp: uapi: clean up kernel-doc comments
Date: Sat, 10 Oct 2026 20:28:00 -0700
Message-ID: <20261011032800.278870-1-rdunlap@infradead.org>
X-Mailer: git-send-email 2.56.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Use correct kernel-doc format for struct members and add comments for
missing struct members (dccph_seq2 and reserved).

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
---
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Eric Dumazet <edumazet@kernel.org>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: Simon Horman <horms@kernel.org>

 include/uapi/linux/dccp.h |   41 ++++++++++++++++++++----------------
 1 file changed, 23 insertions(+), 18 deletions(-)

--- linext-2026-1007.orig/include/uapi/linux/dccp.h
+++ linext-2026-1007/include/uapi/linux/dccp.h
@@ -8,15 +8,19 @@
 /**
  * struct dccp_hdr - generic part of DCCP packet header
  *
- * @dccph_sport - Relevant port on the endpoint that sent this packet
- * @dccph_dport - Relevant port on the other endpoint
- * @dccph_doff - Data Offset from the start of the DCCP header, in 32-bit words
- * @dccph_ccval - Used by the HC-Sender CCID
- * @dccph_cscov - Parts of the packet that are covered by the Checksum field
- * @dccph_checksum - Internet checksum, depends on dccph_cscov
- * @dccph_x - 0 = 24 bit sequence number, 1 = 48
- * @dccph_type - packet type, see DCCP_PKT_ prefixed macros
- * @dccph_seq - sequence number high or low order 24 bits, depends on dccph_x
+ * @dccph_sport: Relevant port on the endpoint that sent this packet
+ * @dccph_dport: Relevant port on the other endpoint
+ * @dccph_doff: Data Offset from the start of the DCCP header, in 32-bit words
+ * @dccph_ccval: Used by the HC-Sender CCID
+ * @dccph_cscov: Parts of the packet that are covered by the Checksum field
+ * @dccph_checksum: Internet checksum, depends on dccph_cscov
+ * @dccph_x: 0 = 24 bit sequence number, 1 = 48
+ * @dccph_type: packet type, see DCCP_PKT_ prefixed macros
+ * @dccph_reserved: reserved bits
+ * @dccph_seq: sequence number high or low order lower 16 bits,
+ *  depends on dccph_x
+ * @dccph_seq2: sequence number high or low order upper 8 bits,
+ *  depends on dccph_x
  */
 struct dccp_hdr {
 	__be16	dccph_sport,
@@ -50,7 +54,7 @@ struct dccp_hdr {
 /**
  * struct dccp_hdr_ext - the low bits of a 48 bit seq packet
  *
- * @dccph_seq_low - low 24 bits of a 48 bit seq packet
+ * @dccph_seq_low: low 24 bits of a 48 bit seq packet
  */
 struct dccp_hdr_ext {
 	__be32	dccph_seq_low;
@@ -59,7 +63,7 @@ struct dccp_hdr_ext {
 /**
  * struct dccp_hdr_request - Connection initiation request header
  *
- * @dccph_req_service - Service to which the client app wants to connect
+ * @dccph_req_service: Service to which the client app wants to connect
  */
 struct dccp_hdr_request {
 	__be32	dccph_req_service;
@@ -67,8 +71,9 @@ struct dccp_hdr_request {
 /**
  * struct dccp_hdr_ack_bits - acknowledgment bits common to most packets
  *
- * @dccph_resp_ack_nr_high - 48 bit ack number high order bits, contains GSR
- * @dccph_resp_ack_nr_low - 48 bit ack number low order bits, contains GSR
+ * @dccph_reserved1: reserved bits
+ * @dccph_ack_nr_high: 48 bit ack number high order bits, contains GSR
+ * @dccph_ack_nr_low: 48 bit ack number low order bits, contains GSR
  */
 struct dccp_hdr_ack_bits {
 	__be16	dccph_reserved1;
@@ -78,8 +83,8 @@ struct dccp_hdr_ack_bits {
 /**
  * struct dccp_hdr_response - Connection initiation response header
  *
- * @dccph_resp_ack - 48 bit Acknowledgment Number Subheader (5.3)
- * @dccph_resp_service - Echoes the Service Code on a received DCCP-Request
+ * @dccph_resp_ack: 48 bit Acknowledgment Number Subheader (5.3)
+ * @dccph_resp_service: Echoes the Service Code on a received DCCP-Request
  */
 struct dccp_hdr_response {
 	struct dccp_hdr_ack_bits	dccph_resp_ack;
@@ -89,9 +94,9 @@ struct dccp_hdr_response {
 /**
  * struct dccp_hdr_reset - Unconditionally shut down a connection
  *
- * @dccph_reset_ack - 48 bit Acknowledgment Number Subheader (5.6)
- * @dccph_reset_code - one of %dccp_reset_codes
- * @dccph_reset_data - the Data 1 ... Data 3 fields from 5.6
+ * @dccph_reset_ack: 48 bit Acknowledgment Number Subheader (5.6)
+ * @dccph_reset_code: one of %dccp_reset_codes
+ * @dccph_reset_data: the Data 1 ... Data 3 fields from 5.6
  */
 struct dccp_hdr_reset {
 	struct dccp_hdr_ack_bits	dccph_reset_ack;
