Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795050389;
	b=4E8vBMm5sKTYbuVA3Q0cXuGinELHoEURWGFnmp9oxZQp2yhYwCR6voBQdP3sBw1rQhpa
	 TBnxtGskIzlpLaFKt9Pr6nyRmxHQxAu57q37YA2FKLCvfyyYPRgpAbz4vKz/nMazMUkks
	 AUcliooKKzH9/BpILfSKpZlWBMrEpK0xR8wAHpbqHE/xJDMPVF6lY7GWioV192VGVi4E9
	 9mHsXQizv2c0hjOzCP08WCgh1MaLBic5aqDfTj0v8k5KHgZFMyXgiiEvnXG45CzCrqVA7
	 PsywHkb34WFA3h/aImpUS/SbDGikV1eicVZPtm/ts54rXHlOWYjps9QbSJGl2MAZMLQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795050389;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=0bp3yFe109NAZ5Deetn0t+CN4b1muBDKg4uNoJZPoGk=;
	b=mhgXqn9eU/ZFxmZnPxSOA8O05kZcQjkudZCUrNIX0LF7aXhYXWbE8eFAi7+gxKr7buGk
	 TB6qjmPW0WTzT3QrOlwDFFJBFvWn/NmFqgwEGNF2+vwjqBcBEuu+oFYoM5MmHK/lZYSRv
	 SSNBkyefqzx/IYmVfL6MpQyzkfdI8yy6LGot3U8+jPDfILFHiVJ3cMU8apZAyAt2VhfpX
	 bXG42pAL1E/hFtZfupBnKp8/UcI6dCfxGbL+AEokrep4IYDC0VhV1yK/tH+QxWf1450Wi
	 yTVA0C0qTQg+H2KmXGCixLu3PdpAJNP1VUS83dHHqY1vzYPaqdPzkYGVdqogixif9Vg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qJmmz5Tk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67F83606A325;
	Thu, 19 Nov 2026 01:06:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qJmmz5Tk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B21F91F000C4;
	Thu, 19 Nov 2026 01:06:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795050389;
	bh=0bp3yFe109NAZ5Deetn0t+CN4b1muBDKg4uNoJZPoGk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qJmmz5TkVinaTSttprVI8pA1J7xpvAXdXn5mFvxR1oipsN2L8i9U3pZQ5XxuS9DuX
	 bsuhpEsh1aG9AkhV5RgDuwYLLMrR5qAtf5zmQ9Aar/s7WdVAGMJXk7TAR5n5cJ95d/
	 vf5imiELtVd+Sy/tGoeFUx3GeZJRcs0VFyr9jzYs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stephan Lipp <Stephan@adalogics.com>,
	Eric Dumazet <edumazet@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2690/2857] net: shrink the payload-only part of skb dataref to one bit
Date: Wed, 18 Nov 2026 16:02:04 +0100
Message-ID: <20261118150338.422499760@linuxfoundation.org>
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

From: Eric Dumazet <edumazet@kernel.org>

[ Upstream commit 4957ea03bf2696f5da12c09144f48d040696ecc2 ]

skb_shinfo(skb)->dataref is split in two 16-bit halves: the lower
one counts all references, the upper one the payload-only (nohdr)
references.

__skb_clone() increments dataref without bound, and skb_cloned()
only checks the low 16 bits. With 65,537 references the low half
reads 1, the head looks private, and pskb_expand_head() (or
skb_unclone(), skb_cow(), ...) frees it while clones still point
to it.

An unprivileged user can reach this from a user and network namespace:
about 32,770 AF_PACKET sockets on lo bring dataref to 0x10001, then
any pskb_expand_head() on the receive path (here a pull of a large
IPv6 Hop-by-Hop header) frees the shared head:

BUG: KASAN: slab-use-after-free in _copy_to_iter+0x187/0x1330
Read of size 1590 at addr ff110001104a9002 by task dataref_wrap/87
 skb_copy_datagram_iter+0x60/0x190
 packet_recvmsg+0x1f5/0x12b0
 __sys_recvfrom+0x18d/0x290
Freed by task 87:
 kfree+0xf3/0x3b0
 pskb_expand_head+0x344/0xeb0
 __pskb_pull_tail+0xf9/0x1bf0
 ipv6_parse_hopopts+0x377/0x4f0
 ip6_rcv_core+0xc67/0x1620

The upper half never holds more than 1. It is only set by
__skb_header_release(), with atomic_set() on an skb owning its head
(TCP/SCTP output, and GRO which never sees cloned skbs).
__skb_clone() clears nohdr, and __copy_skb_header() does not copy it.

Move SKB_DATAREF_SHIFT to 30, so that the reference count gets 30 bits,
and dataref stays positive. Wrapping it would need 2^30 live clones of
a single skb, which socket buffer limits and memory make unreachable.

This issue was found by Anthropic using Claude, and validated by
Ada Logics.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Reported-by: Stephan Lipp <Stephan@adalogics.com>
Signed-off-by: Eric Dumazet <edumazet@kernel.org>
Link: https://patch.msgid.link/20261020151954.22953-1-edumazet@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/skbuff.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index f60bfeeb85285..c19077b1e18a0 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -610,9 +610,9 @@ struct skb_shared_info {
  *
  * Transport layers send out clones of payload skbs they hold for
  * retransmissions. To allow lower layers of the stack to prepend their headers
- * we split &skb_shared_info.dataref into two halves.
- * The lower 16 bits count the overall number of references.
- * The higher 16 bits indicate how many of the references are payload-only.
+ * we split &skb_shared_info.dataref into two parts.
+ * The lower 30 bits count the overall number of references.
+ * Bit 30 indicates whether one of the references is payload-only.
  * skb_header_cloned() checks if skb is allowed to add / write the headers.
  *
  * The creator of the skb (e.g. TCP) marks its skb as &sk_buff.nohdr
@@ -632,7 +632,7 @@ struct skb_shared_info {
  * Having multiple payload-only skbs with different lengths of hdr_len is not
  * possible. The payload-only skbs should never leave their owner.
  */
-#define SKB_DATAREF_SHIFT 16
+#define SKB_DATAREF_SHIFT 30
 #define SKB_DATAREF_MASK ((1 << SKB_DATAREF_SHIFT) - 1)
 
 
-- 
2.53.0



