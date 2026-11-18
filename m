Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795030919;
	b=rE/x+W4ys/RrpxHxOHGKiVH1t8RJzQ6rJtL4rMYnliDOBVY45dIqrcYERZHVhqbIMjx2
	 AOzyMgQoZLGfNBTZe0gfUYrmeGY+O/MIRSzijH8xbTdq+u7i/CJw6sXpcGPLGXdAl5snk
	 INMwbyPUgg/tm0GvB5I210qTPggJzJ8Zq0OdPpkuxvVTKjeXu4n2daPKP3S08oXO2i7jA
	 sSCAawTnzjpMpRyDcKoF6dHZIn/jSfQdqavsuBhvc4ImBHLfIPEK1sVZ1anR1LD8Ysn2d
	 K5lKVSkKHuelpefdwgE4lmtB9Y8cYS+xFl/FUVzGORhdIfHVWy5wP2eDi6+u/CCsSEA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795030919;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=AO8l2427DKQnGc1nVc50RfQHWk6RtgVjMgk1jisQjV0=;
	b=bPSbRd/5dv9yeKqIy+YFXI4wRsKZ0TOGqHFDoUwq9qFcSQGTbvW9BmusCUx4E0IfwR9G
	 jlksWd24IPJuzrzBLUxzJAZEbsZYwG5or4BXGAXXmnIYZuoi35AplYmXRuUDTZtrQVNa4
	 yYO7B4eky0SGcyfhafF5IqCnwdJXytOy4OAZUmAIncBPZ41GtqsCX8QxFmL2VaXSVtjDu
	 Q7FWz2IW+fpznh9ItMg5Xj/WZQYsbU6LeGutPNCsJgovcfQfpa8WlN5mzzH41RLK9m84Z
	 jAiB8YGpsibphbeTiuTLmyQFIZdpodSeifTkBniSIo7IdR41RNxdD5PyJq+msntqmww==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GEpwtRYI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58053606A7C6;
	Wed, 18 Nov 2026 19:41:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GEpwtRYI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65D561F000C5;
	Wed, 18 Nov 2026 19:41:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795030919;
	bh=AO8l2427DKQnGc1nVc50RfQHWk6RtgVjMgk1jisQjV0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GEpwtRYIiVGGrqVDEvMnHUY13pylZo7ZE5/Hx7HaYFD7YAXyY2fjkV+QNM16k6o5q
	 2HHVyFZvV+klrIAa20nbZ0RQHbUA0ocQA3OOV3HBeCl+tN54qT8dZ5tF3X9DXMoiIB
	 NgL39/kllYBxrAb16jZrvRd81l4vKONadMAglRMk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?J=C3=A9r=C3=A9my=20Jean?= <Jeremy.Jean@oss.cyber.gouv.fr>,
	Anna Schumaker <anna.schumaker@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0872/1756] NFS: filelayout: calculate dense stripe width in 64 bits
Date: Wed, 18 Nov 2026 15:49:59 +0100
Message-ID: <20261118150044.102451828@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>

[ Upstream commit 9ba13ef0e3ad033d3ddbaeb740b12d135a88363d ]

filelayout_get_dense_offset() calculates the stripe width from the
stripe unit and count, where both values are provided by the server.
Their product is stored on 32 bits, and can wrap to zero despite
passing individual checks. For example, a 1 GiB stripe unit (0x40000000)
and four stripes (4) cause the following div_u64() to raise a divide
error during the first read through the dense layout.

Update u32 to u64 and use div64_u64() instead of div_u64().
stripe_unit is a u32 and stripe_count is limited to 4096, so the
product cannot overflow a u64.

Fixes: cfe7f4120f8b ("NFSv4.1: filelayout i/o helpers")
Assisted-by: Codex:gpt-5
Signed-off-by: Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>
Signed-off-by: Anna Schumaker <anna.schumaker@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/filelayout/filelayout.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/nfs/filelayout/filelayout.c b/fs/nfs/filelayout/filelayout.c
index e1eff85b2ded5..caa5eaca24ebc 100644
--- a/fs/nfs/filelayout/filelayout.c
+++ b/fs/nfs/filelayout/filelayout.c
@@ -55,12 +55,13 @@ static loff_t
 filelayout_get_dense_offset(struct nfs4_filelayout_segment *flseg,
 			    loff_t offset)
 {
-	u32 stripe_width = flseg->stripe_unit * flseg->dsaddr->stripe_count;
+	u64 stripe_width = (u64)flseg->stripe_unit *
+			   flseg->dsaddr->stripe_count;
 	u64 stripe_no;
 	u32 rem;
 
 	offset -= flseg->pattern_offset;
-	stripe_no = div_u64(offset, stripe_width);
+	stripe_no = div64_u64(offset, stripe_width);
 	div_u64_rem(offset, flseg->stripe_unit, &rem);
 
 	return stripe_no * flseg->stripe_unit + rem;
-- 
2.53.0



