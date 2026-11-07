Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064945;
	b=u2sDbimf0sLkT+ZkRCVzai9SQXeolQlB9nfNlMOu5hPANK9MNxcWDoROPg3d4QARAjTR
	 pM/8mX8Fscxok+9mFMyVnE+VEmiL8kXn+pINLDLkOdSkAdDSDi/pKksk5JeOIu7FEYx7S
	 er6k3jedYZA3FuNrPtdU0Fm9t8LW+9VBdyGjnggh6/5yjr/S4tzWyZr3ow605WVETC9it
	 bwRROcDj9frXhykzrE9YIfi13XGk6b/C8Afveym4hTYfPrAtMNLBqQ1ymFR7Uz+5GvKmw
	 FBBx1AuGefHyqW3kOm4WLdzyvMguA14o0qgcljvg0/lOWMJQOHNmxyejUhuKqphkoCw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064945;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=TQ2H9NAeGR3kPZuq0cxOt2iEZl3+GkvkN9N5JnvlgZw=;
	b=TKQHhg6bDJwGIRojy0EDkifGl8U7YwHTtUJW7CMiRaaGPNMjrGHPrN27eR0EjGo09vx4
	 EUCxwtjJvM4laOeHUEg2r4/aIQx67vAqgxJXZqru5jjP7jstmR7zKG5VN4nfUdXrelcnY
	 eT1d+JUbJh/g7hQM7Y6gD+nypVMyzklzwLL1v6xMh3BLgimGCss40A0VHyTps/jVR6m+o
	 5JsNXFP8V2rsrsYcz+lBBaY0+m5cJ0gRlHvklT58htYRi3JlH2FKKQjVtfxi1wmaAW6F/
	 vcU97lyGHROsQlJ3LnbWzK00p7Bd9oI8VRNkuX2GntFjrEPjdJJL0p6ZMn/Z2sbDzUw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rIKWQ+xl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01526606A32E;
	Sat,  7 Nov 2026 15:22:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rIKWQ+xl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2AEA1F0089F;
	Sat,  7 Nov 2026 15:22:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064944;
	bh=TQ2H9NAeGR3kPZuq0cxOt2iEZl3+GkvkN9N5JnvlgZw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rIKWQ+xlz4VPClIgnNTbAfECl79B0ttYhnW2lrN+iy9X0eQl5Px6L2Ul2RLGrQTe5
	 znHWtYY05JeJPcx3AptfOaGsYkcsdM7aoUAD723bRlXeJ66ePMCIALu07bPM4LAw5C
	 W+LoOlSjw2PrAloEaSOGnvYFcTlzQYSlYTdUSJX0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tal Zussman <tz2294@columbia.edu>,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0794/1257] gfs2: fix the escaped block copy in gfs2_before_commit()
Date: Sat,  7 Nov 2026 08:51:30 -0500
Message-ID: <20261107135001.259804604@linuxfoundation.org>
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

From: Tal Zussman <tz2294@columbia.edu>

[ Upstream commit 1a4aeb6d6a08af1a2e2c52c84170561625819377 ]

Commit d68d0c6c3fc7 ("gfs2: Use memcpy_{from,to}_page where
appropriate") made the escaped buffer copy read from the mempool page
it had just allocated instead of from the buffer, so the block written
to the log is whatever the pool page last held. If the journal is
replayed after a crash, the block is restored from that and the file's
data is corrupted. Only escaped buffers are affected: jdata blocks
whose first four bytes match GFS2_MAGIC. Copy from the buffer's folio
instead.

Fixes: d68d0c6c3fc7 ("gfs2: Use memcpy_{from,to}_page where appropriate")
Cc: stable@vger.kernel.org
Signed-off-by: Tal Zussman <tz2294@columbia.edu>
Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/gfs2/lops.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/gfs2/lops.c b/fs/gfs2/lops.c
index 6dabe73ad790d..b8c9024c9fede 100644
--- a/fs/gfs2/lops.c
+++ b/fs/gfs2/lops.c
@@ -689,7 +689,9 @@ static void gfs2_before_commit(struct gfs2_sbd *sdp, unsigned int limit,
 
 				page = mempool_alloc(gfs2_page_pool, GFP_NOIO);
 				p = page_address(page);
-				memcpy_from_page(p, page, bh_offset(bd2->bd_bh), bd2->bd_bh->b_size);
+				memcpy_from_folio(p, bd2->bd_bh->b_folio,
+						  bh_offset(bd2->bd_bh),
+						  bd2->bd_bh->b_size);
 				*(__be32 *)p = 0;
 				clear_buffer_escaped(bd2->bd_bh);
 				unlock_buffer(bd2->bd_bh);
-- 
2.53.0



