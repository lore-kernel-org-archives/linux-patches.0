Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1904713AA47;
	Tue, 18 Jun 2024 12:48:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718714929; cv=none; b=Mn+DGNXhD8yBzys5xwQTykVYDtjsN2wcp+1XosXI9osVDA/HjrT0XqTxl6GvSw5Y7zz4EaX7x33IbtsVCIpNVr4el4Z/MnH9sIAPAEHpUqnmGOcaRV9nxgFMx9P5OyeUQDIGJbbkkyxP39lttoKP0PQYE7vU/WZa6+eOsWHkh2g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718714929; c=relaxed/simple;
	bh=gvictd9rqWzCkt8pFPzfJH6GGG5byNsIJsx6/vwZPto=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uasTA6YZb/8NZYGA8qje4k5zi0+ngtSHg7OVUk07EAeD8855l/mUlnuBJxYRctedWrUv3u0phzD3GhehnDDExqdf9ftmpRPW4qCXtAA7HbBGskIr171GCKmnpG7G/A5rczOte9ky/XsgHzCNPx4xkuzwqbmCNnRfCfgf9hY0ge0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KVYOIJ9U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KVYOIJ9U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95361C3277B;
	Tue, 18 Jun 2024 12:48:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718714929;
	bh=gvictd9rqWzCkt8pFPzfJH6GGG5byNsIJsx6/vwZPto=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KVYOIJ9UX1YXwPo3NRRJ+IXqbt0TAz/dxrTfcEfMRO6w3W85KW43THEyYLnmbUWUL
	 A04rTB4o+2cqBZY+io3amIFBu2mtWB9L9K9oZKTBRl23B5Mlhws8Y4fWBcfHx6dlLJ
	 hR92Lh18qJTw3DMwKQl1W+L842S/7+Zad43Gy5dQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 135/770] SUNRPC: Move definition of XDR_UNIT
Date: Tue, 18 Jun 2024 14:29:48 +0200
Message-ID: <20240618123412.488556203@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240618123407.280171066@linuxfoundation.org>
References: <20240618123407.280171066@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit 81d217474326b25d7f14274b02fe3da1e85ad934 ]

Clean up: The unit of XDR alignment is defined by RFC 4506,
not as part of the RPC message header. Thus it belongs in
include/linux/sunrpc/xdr.h.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/sunrpc/msg_prot.h |  3 ---
 include/linux/sunrpc/xdr.h      | 13 ++++++++++---
 2 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/include/linux/sunrpc/msg_prot.h b/include/linux/sunrpc/msg_prot.h
index 43f854487539b..938c2bf29db88 100644
--- a/include/linux/sunrpc/msg_prot.h
+++ b/include/linux/sunrpc/msg_prot.h
@@ -10,9 +10,6 @@
 
 #define RPC_VERSION 2
 
-/* size of an XDR encoding unit in bytes, i.e. 32bit */
-#define XDR_UNIT	(4)
-
 /* spec defines authentication flavor as an unsigned 32 bit integer */
 typedef u32	rpc_authflavor_t;
 
diff --git a/include/linux/sunrpc/xdr.h b/include/linux/sunrpc/xdr.h
index f6569b620beab..eba6204330b3c 100644
--- a/include/linux/sunrpc/xdr.h
+++ b/include/linux/sunrpc/xdr.h
@@ -19,6 +19,13 @@
 struct bio_vec;
 struct rpc_rqst;
 
+/*
+ * Size of an XDR encoding unit in bytes, i.e. 32 bits,
+ * as defined in Section 3 of RFC 4506. All encoded
+ * XDR data items are aligned on a boundary of 32 bits.
+ */
+#define XDR_UNIT		sizeof(__be32)
+
 /*
  * Buffer adjustment
  */
@@ -329,7 +336,7 @@ ssize_t xdr_stream_decode_string_dup(struct xdr_stream *xdr, char **str,
 static inline size_t
 xdr_align_size(size_t n)
 {
-	const size_t mask = sizeof(__u32) - 1;
+	const size_t mask = XDR_UNIT - 1;
 
 	return (n + mask) & ~mask;
 }
@@ -359,7 +366,7 @@ static inline size_t xdr_pad_size(size_t n)
  */
 static inline ssize_t xdr_stream_encode_item_present(struct xdr_stream *xdr)
 {
-	const size_t len = sizeof(__be32);
+	const size_t len = XDR_UNIT;
 	__be32 *p = xdr_reserve_space(xdr, len);
 
 	if (unlikely(!p))
@@ -378,7 +385,7 @@ static inline ssize_t xdr_stream_encode_item_present(struct xdr_stream *xdr)
  */
 static inline int xdr_stream_encode_item_absent(struct xdr_stream *xdr)
 {
-	const size_t len = sizeof(__be32);
+	const size_t len = XDR_UNIT;
 	__be32 *p = xdr_reserve_space(xdr, len);
 
 	if (unlikely(!p))
-- 
2.43.0



