Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795704967;
	b=t5V4usNd5igBt4tjUvsoPDjv9Wp2R++iyS0kqzYOH663aWRGnTW/2wuGqJElvmO0eKP+
	 vEx4G8ECKxXR2Fyg3MsAAs2YCeRNuvCYTaoaFXU+KLSQfMH3FODDiwdKb0bTKeZDIdewv
	 8gV4229aHxHYZsHC2vCQatR+EpBpB5Zx9Ev2JrQt3pcHSADO9ZyQIb5cml0MfqhBzk5T6
	 1ROgYdssriyNHMmSCUN6yO14rv+TVjsUepfila02r3AALEzaT1zuqdTQgy3yH6tmNgJyM
	 7ZxnJaDOodDWOZPDIvPDyPzu87G4PAgagGpVXNhtR+nlCu+yX4cqNDiZLQY5O9+fCXA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795704967;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=XQrZ6zpTkl6GXNb4gIA5nYR4q1g88rGO0bp6mBP6kZA=;
	b=05QxDTRC5dQ1691VgWuclI2S8dLzEwbC/672u53PaNpQewbRMUl0OMRY8roTrgu7QOR0
	 KfsNLQRpIwUh3jrNVT6k3rOigLIXGy3kdnGlPIb3csDrd5ssMPpnwoT2qtjeqTogbLqPS
	 L2Lh/b2EYhZbncUkaYxBle/jt4PPG4+l2kmUy6p/QVT3VC37Kay3wZllPk5ZYZJ5XtoNU
	 f47v9JEeuzEG/aNw093ERHxGnV1nElP8wH73VQQsD0hdVFx8sIpUBcB/WquHz77K4jAZG
	 LbQYQfhCRgaR/xWvttyxjr7w3pHMvC41j32Gu5c2ZsOSp1r7Si87nOu94gbeEmgGpkg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=up7WYjyR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83F8D606A31E;
	Thu, 26 Nov 2026 14:56:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=up7WYjyR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C07C01F000D3;
	Thu, 26 Nov 2026 14:56:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795704967;
	bh=XQrZ6zpTkl6GXNb4gIA5nYR4q1g88rGO0bp6mBP6kZA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=up7WYjyRdz8IN/+wyt/fHUYSTk3v1WZ8IhPi2cX2MHYKkPQZx2bWONS9dMmAbEYx2
	 +LfU/SEHqcCO/D9HluwaogNOOPWKOM8y1b4vyW/GhY9VMhx+0T6FrlA5LQZw4KHn/I
	 faqUupV4ztrbRPlZvLCEhR6syx/H1iPwGkD6u2Z4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mason <mason@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 038/319] bpf: Reject non-IPv6 packets in BPF_LWT_ENCAP_SEG6
Date: Thu, 26 Nov 2026 15:36:46 +0100
Message-ID: <20261126144007.597317502@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126144006.732901931@linuxfoundation.org>
References: <20261126144006.732901931@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chris Mason <mason@kernel.org>

[ Upstream commit 58e39f8d58b141b96c030008a20dde9d625ec997 ]

The mode BPF_LWT_ENCAP_SEG6 of bpf_lwt_push_encap() pushes an IPv6 header
and an SRH, and it replaces the dst. The SRH says that IPv6 follows, and
skb->protocol does not change. Thus the mode assumes an IPv6 packet, but an
lwt_in prog also runs for IPv4 packets. After the prog, bpf_input() calls
orig_input() of the old dst. This IPv4 handler reads the pushed headers as
IPv4. It can write after the packet data, and the kernel crashes.

                 after the push         orig_input() expects
                 ---------------------  --------------------
  skb->protocol  ETH_P_IP               ETH_P_IP
  dst            rt6_info               rtable
  packet         | IPv6 | SRH | IPv4 |  | IPv4 |

The mode BPF_LWT_ENCAP_SEG6_INLINE returns -EBADMSG for non-IPv6 packets.
Apply this check to both modes. End.BPF does not change, because
seg6_local_input() drops non-IPv6 packets.

Fixes: fe94cc290f53 ("bpf: Add IPv6 Segment Routing helpers")
Signed-off-by: Chris Mason <mason@kernel.org>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://patch.msgid.link/20261101190535.1454146-17-alexei.starovoitov@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/filter.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/net/core/filter.c b/net/core/filter.c
index 0783fa93319e6..0ecd9f8ac2e80 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -6088,11 +6088,15 @@ static int bpf_push_seg6_encap(struct sk_buff *skb, u32 type, void *hdr, u32 len
 	if (!seg6_validate_srh(srh, len, false))
 		return -EINVAL;
 
+	/*
+	 * The encap mode names IPv6 as the inner protocol, and neither mode
+	 * updates skb->protocol.
+	 */
+	if (skb->protocol != htons(ETH_P_IPV6))
+		return -EBADMSG;
+
 	switch (type) {
 	case BPF_LWT_ENCAP_SEG6_INLINE:
-		if (skb->protocol != htons(ETH_P_IPV6))
-			return -EBADMSG;
-
 		err = seg6_do_srh_inline(skb, srh);
 		break;
 	case BPF_LWT_ENCAP_SEG6:
-- 
2.53.0



