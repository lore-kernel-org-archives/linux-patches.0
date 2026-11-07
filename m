Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064935;
	b=hXaXrTYxB8e2i2M9VeouV/bj44Z/lWGiJXXIZcyrGsKjP6ver69PSx92AglRGi+uwjoe
	 eT1i+yUmrlYTTEkjEKZIFWHWMrJEW6irHKKhdjIcuCCwDOWfwHjczlzRIk2At6pK3wN0n
	 XvYl+ecl/g2161v14QX9QA32XlYyWs+uihyS2n3yQDU47hwV0BBK/5xaAqfIrnvR0OKG+
	 246Nprpl/4DTV+Nu5X+2ZgOVzsoNLz3w8RkSPT7+UPLuDZO7/UUcpHUsGL9FT//VMsxxP
	 cbQrn/+kXLv4IYXLQs7vn9fohRskJ+SjwFBJovXeJxQPYtkE3AxP2xEdyUKBUPMvcNQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064935;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=TgZLFdDPiSJ/s3tAIGWM39FcPJbIBFjwRfR3+iSSW6A=;
	b=QNRDEYSKSzhaBa3uHnxuZWKtJi6pV5sS1yjgfhpwHtpeGvZ4qd6wkhLAfmyQr3NVb9QW
	 uMB4X7x9zQydZ5F25LRqp/GqUVMDCQEbofE+Q2BTeWempnmOAehXdYF01I3nA1ZZAs33q
	 ZZeLP8FUwrTCujbiYThVDHolPTx/0GJTxFU53RjT72ZlpBA4jxfh4SQRz60FqH+Ib/33q
	 XZHyWynuAaS4dzogOrXe3OdgIJ8N3ViXaCwzUb9xsYNB4QqYGQmtR8kCYxnM1NmGl6/cW
	 +jvRpRKUAaC2TavBT84ZPRgkqWLdXo0sx1VOojoIkNKwiLivy9nTv6OllHJe7BgpWcA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2SHADuWH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D215C606A338;
	Sat,  7 Nov 2026 15:22:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2SHADuWH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07BAA1F0089F;
	Sat,  7 Nov 2026 15:22:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064934;
	bh=TgZLFdDPiSJ/s3tAIGWM39FcPJbIBFjwRfR3+iSSW6A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2SHADuWHHBNQ5s+WcXTrfamoPRrA+7+4/4pIVgnh/653p15mrFlzV0AEKaIIgkBPY
	 mhfJ7XBRCXP/S/SCtFXpV4RncafJXG8SZ9sW8J+iSFPWBvrjzSXz3Qv1V0jEHOeJt+
	 brNaJkIiw/YQ4L6+EN6T92K3suwpInAmkG115XT0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0826/1257] net: skbuff: dont BUG() on a bad csum_start in skb_copy_and_csum_dev()
Date: Sat,  7 Nov 2026 08:52:02 -0500
Message-ID: <20261107135002.151246170@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

From: Josef Bacik <josef@toxicpanda.com>

[ Upstream commit 56453199d28f0072a8196fba14b2d702632e2219 ]

skb_copy_and_csum_dev() copies everything up to the checksum start out
of the linear area, and BUG()s if the checksum start is past the end of
the linear area.  It misses the other direction: a CHECKSUM_PARTIAL skb
that has been pulled past its csum_start gives a negative offset, which
gets past the check and becomes a ~4GB copy.  It also trusts
csum_offset when it stores the folded checksum.  So far
skb_copy_and_csum_bits() BUG()ing on a short skb has covered for that,
but once it returns instead, a bad csum_offset would write past the end
of the caller's buffer.

The function returns void and its callers are drivers copying a frame
into a bounce buffer just before handing it to the hardware.  There's
nothing for them to back out of, so check both ends of csum_start and
that the checksum field fits in the frame, and if not, copy the whole
frame with skb_copy_bits() without filling in the checksum, with a
DEBUG_NET_WARN_ON_ONCE() for debug kernels.  The frame
goes out with a bad checksum and is dropped by the receiver.  If even
that copy fails, zero the buffer so the driver doesn't send stale bytes.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Cc: stable? The trailers only have Assisted-by: and Signed-off-by:. No
Link: https://patch.msgid.link/20261007-b4-skbuff-bug-on-v2-5-b9a5f732895b@toxicpanda.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/skbuff.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 2bfabde31ea93..ea4c38dee19f5 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -3961,7 +3961,18 @@ void skb_copy_and_csum_dev(const struct sk_buff *skb, u8 *to)
 	else
 		csstart = skb_headlen(skb);
 
-	BUG_ON(csstart > skb_headlen(skb));
+	if (unlikely(csstart < 0 || csstart > skb_headlen(skb) ||
+		     (skb->ip_summed == CHECKSUM_PARTIAL &&
+		      csstart + skb->csum_offset + sizeof(__sum16) >
+		      skb->len))) {
+		DEBUG_NET_WARN_ON_ONCE(1);
+		/* Send the frame without the checksum filled in, or send
+		 * zeroes if we can't even copy it.
+		 */
+		if (skb_copy_bits(skb, 0, to, skb->len))
+			memset(to, 0, skb->len);
+		return;
+	}
 
 	skb_copy_from_linear_data(skb, to, csstart);
 
-- 
2.53.0



