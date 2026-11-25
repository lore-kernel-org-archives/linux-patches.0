Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795617902;
	b=5XBFYQdbYooXx2C6YfcDI0Tjhj4XvWL32u/JcCLRGdcUAw8ayC1IVs7C0wh4PhCXiJWg
	 ccGDC5gkof8IqcxPu7XUg7Z8n8V+A/VxUHZruF+yp8Dy6eFSV+iJRRyIo2z+k6Fa/Dfyu
	 3rTbXgJfuXWXrxzHYp8/DOOxtmYriGhs5+k/Ko3nUTj6kwIgfuUwDnqtMb28d7rAqjreh
	 OUEA4I9WdOi9Ix0cJ+19sMMHmeAHet0vA5NCTW4SBDG03y8LGJbRSuxNt0rw6pkwelMUi
	 1AJAo4RExFL2HWcgIjuUGKxIa0mR4Klogxzyvryhllh26j1NdcT36TMcnjyab9gm2mg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795617902;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+6lAIjQ1KhC2Honzl2MTNtV9bKjHEwpFSZ+CqFh5yPU=;
	b=tK8vfXJ1GDeHia99AjcAcRSbtAVwUUTHx2nT8fqxYecSVKRllMDMbyOF1+iZpt0NRQe2
	 4DY5CnyDOnb/eRp/1L4ha24647JGlNn5PiWZxlxp4s3VanybfkwAM52qECjxZ916aW+UY
	 nOgpSlx34voFMUcZCBWu6Uf6C0RtWIyG2MUegnisVKA1/YvliL3UgLZX8e5MgdIxn/SgU
	 mHRmQYsjECKLmBP3n2/DbSCTEpTnSoHmMa+lBvcI9Cu9PgBvC+924fwThJ2oOVDiljEJb
	 fxKx6kLbfOFL2C25sHRnRSb4mXVX1euKmlsoQJsBIlJKOgQa2AN49hLqjEwRPukUbuw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ndJHw4El;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 170E7606A32C;
	Wed, 25 Nov 2026 14:45:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ndJHw4El
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F8901F000E6;
	Wed, 25 Nov 2026 14:45:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795617901;
	bh=+6lAIjQ1KhC2Honzl2MTNtV9bKjHEwpFSZ+CqFh5yPU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ndJHw4Elhbs7stwBZU0ZvGxacrYYE67xKpn3f3N+ZUfPd15pLJB0MlczhaYY1pp/6
	 3UZ8BSDM8p56cCPb8GbTHzFXti6Jk3uyaSjgl/fJzxfRQzeYZ/AdvlKg7I2OhgjFjQ
	 BSuewC+CEOD3PvobUquaH81MVZh2iJUfgEXeyWiM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mason <mason@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0109/1005] bpf: Limit the SRH length in bpf_lwt_seg6_adjust_srh()
Date: Wed, 25 Nov 2026 15:24:07 +0100
Message-ID: <20261125143824.299057087@linuxfoundation.org>
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

From: Chris Mason <mason@kernel.org>

[ Upstream commit ac159f39b252971141c49b68a27de0b637debfad ]

bpf_lwt_seg6_adjust_srh() lets an End.BPF prog change the size of the TLVs
in the SRH. The helper keeps the SRH length in srh_state->hdrlen, in bytes
and without the first 8 bytes. Later seg6_bpf_has_valid_srh() writes it to
srh->hdrlen, an 8-bit field in units of 8 bytes. But srh_state->hdrlen has
no upper limit, and the cast to u8 can truncate it. After that,
seg6_validate_srh() gets the SRH length from srh->hdrlen, and thus it can
accept the SRH. Then srh->hdrlen is too small, and a parser reads TLVs as
the subsequent header.

Return -EFAULT when the new srh_state->hdrlen is larger than 2040, the
largest length that srh->hdrlen can hold. To replace a TLV in the largest
SRH, a prog can no longer add bytes first. It must remove bytes first.

Fixes: fe94cc290f53 ("bpf: Add IPv6 Segment Routing helpers")
Signed-off-by: Chris Mason <mason@kernel.org>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://patch.msgid.link/20261101190535.1454146-19-alexei.starovoitov@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/filter.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/core/filter.c b/net/core/filter.c
index c2d08dfad40e3..0cc65aff822aa 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -7179,6 +7179,9 @@ BPF_CALL_3(bpf_lwt_seg6_adjust_srh, struct sk_buff *, skb, u32, offset,
 		return -EFAULT;
 	if (unlikely(len < 0 && (void *)((char *)ptr - len) > srh_end))
 		return -EFAULT;
+	/* The length field of the SRH has 8 bits, in units of 8 bytes. */
+	if (unlikely(len > (U8_MAX << 3) - srh_state->hdrlen))
+		return -EFAULT;
 
 	if (len > 0) {
 		ret = skb_cow_head(skb, len);
-- 
2.53.0



