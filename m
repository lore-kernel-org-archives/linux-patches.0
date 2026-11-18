Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795042132;
	b=uvo69XwtVPkQ79KeQQv4a1vR2c80VxW1I8jBM8hMP2CuyWASaaYovM+H9H7llnJQ+Ldh
	 Zp3u8z0c/H+VpwCYNRm7yHwnjUg0hJ6xB1wR5wFHjdG5uYH2Ld7xkOwAhCwxxRRF7RDOX
	 KMcm/LioIM3drtETAJtBjK/Alkxj3pHbOFyvzApiWg3U3SulrIwnb3R/r/mx4DUWGg6XR
	 bxTDxRSkRu//p4q+79y9V+q4mf1dbQXxFa+7QnnqIwPU0hNRx5bdIXtT/VyB9L9/royMs
	 V1V1Chf6KZTw00cseFdVGO4kaqAH4EQzaNuHiseFTKpTCVsVyNA0YdhPkpRHwOHtv0w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795042132;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Td2EWUypIH4kADTmZR7IRKUHl7Z8xzDjOPweBsC0grU=;
	b=cZ52mY135gggYwv2Ch+junwSzfC7+T3z6a6XMfB2UEG5r5dOBUp7+Q4l2Z8K7KJGvexg
	 v8+3ZTV+cY7UL+tXmjW3alF+1Z7i7vWocpidnjzoxLCrJUJCihqTtqs0dlIovfcbvXEbZ
	 U47wLB6kuR22rI8N6ePowLeKY/4rGPcCvNL6jGemrvOBCVgxuL/Jkjfq3d+Uh00C/0pcs
	 Spb+jmc4O5/cQaol/i132WykogLc+HLq1WkhtB+lyDwLVnUUkarCziAk/db4xPJyUr1cI
	 KAD7cUTlEaped/seez88bXAkbcdx4I/aoFAYne0qKmcO4IiRMLcg84feqYtGSlMRMUQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xAwP1ehz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBB36606A320;
	Wed, 18 Nov 2026 22:48:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xAwP1ehz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DED11F000C4;
	Wed, 18 Nov 2026 22:48:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795042132;
	bh=Td2EWUypIH4kADTmZR7IRKUHl7Z8xzDjOPweBsC0grU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xAwP1ehzvBQgu1wSPVobPjuZpq0p8vzkWw+ph9yVjt8yczuSuBQnldOCabFYsHpfl
	 kGce/NlfgB7drzVX3v24PXcpXLZ0Ua+j7Eks9W2YMGyctr3q4l05ESogHxxUxeNyST
	 tJt8Ij68fJE5B58EmNo6ut0aNjfAYhFQJyFyuOhU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mat Martineau <martineau@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 3060/3318] mptcp: options: dss: avoid printing uninit csum
Date: Wed, 18 Nov 2026 16:01:22 +0100
Message-ID: <20261118150451.931058273@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthieu Baerts (NGI0) <matttbe@kernel.org>

[ Upstream commit 00e2690c9dad0e09cd2a4435b98de6d8efd5fbc2 ]

When parsing the DSS suboption, this pr_debug() might read and print
uninitialised checksum value.

That's mostly harmless, but that's also confusing. Fixing that also
avoids some tools to complain about accessing uninit data.

So read this csum field only if it has been set.

Note: this was initially reported by Clashiko as an existing issue. The
code has been analysed by a human and confirmed. This is a non-urgent
fix.

Fixes: 390b95a5fb84 ("mptcp: receive checksum for DSS")
Reviewed-by: Mat Martineau <martineau@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20261013-net-next-mptcp-misc-feat-7-4-part2-v1-2-1181e5d2fda4@kernel.org
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mptcp/options.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mptcp/options.c b/net/mptcp/options.c
index a79a4922c6108..44110c0e6cdf6 100644
--- a/net/mptcp/options.c
+++ b/net/mptcp/options.c
@@ -259,7 +259,7 @@ static void mptcp_parse_option(const struct sk_buff *skb,
 			pr_debug("data_seq=%llu subflow_seq=%u data_len=%u csum=%d:%u\n",
 				 mp_opt->data_seq, mp_opt->subflow_seq,
 				 mp_opt->data_len, !!(mp_opt->suboptions & OPTION_MPTCP_CSUMREQD),
-				 mp_opt->csum);
+				 (mp_opt->suboptions & OPTION_MPTCP_CSUMREQD) ? mp_opt->csum : 0);
 		}
 
 		break;
-- 
2.53.0



