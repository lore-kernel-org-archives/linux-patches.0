Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793217383;
	b=2hiPko5QXuwG5qQXnblW2g0jWbs0pTqx7f5owJxRZKOefI9b8qKGi6houLR9ZymFSYl1
	 tIiq9HGaOycNYsfCGNHHCqcfhYbSl8thQxHGsBgNBTDIu32gkLzu5NXp+wT0QL095YtQ0
	 NpMHhNAdQibeidSnBxPvyuK4IvJrLB76ZEofCkHhrOqPm2QzALRoBogd53LgS/oZ6fq4C
	 69eziboM7Ce7RVDXDxNp+PiPx4HvYklFVw6UC4PJm330l5SJzan1RHreiTVJfdkdpNdkx
	 oDSXRWhPBpyOmKbVFi8n6jV5Q7laywafF8nF2kpmGjx5bkIR9vtZOKviUIBbPGTWP5w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793217383;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=PqwIWdpnlvgGE3bb7Q0h7SMoj86byx5JpYjBsjJLd8c=;
	b=m8Ovurj+TGMWuYKTHwR0SizQ+SoqBtFBTCV9k3XqMCbZejKC1pXYINd9FqLVtJji91Zl
	 Qzbuk/rbwuQnUFqpYYEnZfZpAW9YvJMYI5FEiDID7mDvEE0W5ORhCe/1e+Jg211Xt36qa
	 BWE7YEZqbES0xr5iHlGJiTHjj+8BykZeEzHbo26yR8Rlk1iVC1bcpwEHmMtGg7aF/YDTd
	 azMaYQLB9Y46t1Dvnx/QCX2VwMkMg65LsG8Urk7Sy5jkNSM9f6dbv6KHXjwi6ou35ECOY
	 7dhGPjwvuQ37cXlEXxyotgDEBktX8qMzP+/7ILelGLVoF4/s0lzlr+s9n7xaU4o2quA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Yc8DKYqZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 923A9606A31A;
	Wed, 28 Oct 2026 19:56:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Yc8DKYqZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E44711F01825;
	Wed, 28 Oct 2026 19:56:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793217383;
	bh=PqwIWdpnlvgGE3bb7Q0h7SMoj86byx5JpYjBsjJLd8c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Yc8DKYqZR/9Vc8eV6RWka9qk1EQfCy1rMQCiWbRRHXtwGOc3y9L8h0w4bxKCLYc9V
	 axF429bpEH6QS6+USuVBn4Af+K+KCt43faJ7M5RZe2wkhPPmc3Lte1TCaGRjyi7ZPW
	 sLfutE83rMBZjP6C24B+yJzAqfvMr6gahd57dptU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gleb Markov <markov.gi@npc-ksb.ru>,
	George Zhang <george.zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1831/1887] drm/amd/display: Remove unused-but-set variable hubp from
Date: Wed, 28 Oct 2026 18:05:27 +0100
Message-ID: <20261028170541.112815792@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

From: Gleb Markov <markov.gi@npc-ksb.ru>

[ Upstream commit b736792e5bd4a62f24e8d1e310bf4a75bfbeaaaa ]

The final check of hubp for NULL covers all remaining lines of code, since
the value of hubp does not change until the end of the method.

This check is redundant because hubp1 is already dereferenced within the
macro.
If it were NULL, the program would have already failed to proceed.

Remove the left part of the expression with the logical "&&".

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: be1fb44389ca ("drm/amd/display: Check null pointers before used").
Signed-off-by: Gleb Markov <markov.gi@npc-ksb.ru>
Reviewed-by: George Zhang <george.zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hubp.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hubp.c b/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hubp.c
index 3bedc96714ceb..a142a00bc4326 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hubp.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hubp.c
@@ -749,8 +749,7 @@ bool hubp1_is_flip_pending(struct hubp *hubp)
 	if (flip_pending)
 		return true;
 
-	if (hubp &&
-	    earliest_inuse_address.grph.addr.quad_part != hubp->request_address.grph.addr.quad_part)
+	if (earliest_inuse_address.grph.addr.quad_part != hubp->request_address.grph.addr.quad_part)
 		return true;
 
 	return false;
-- 
2.53.0



