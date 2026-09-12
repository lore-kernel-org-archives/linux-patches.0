Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B6E434252D;
	Sat, 12 Sep 2026 07:38:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789198704; cv=none; b=LPqaRjUn2YWKXwgSEnRike4Un2MysDfC8BBRD1g2iZgSz5UNvUSlwtQ94JTUzWG3uR19PJRrmYf966RLuJ7kMvWBriwdRS2fGvAAe/tgfVnN1HyUKTBtV320BpNkOPhkavo4lfFZTgxRzqZvizTqvn0bW8jzSMO823BL7qu4Jbg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789198704; c=relaxed/simple;
	bh=/57t02Um6C8RjS4EY1GMa7GAd6/dtmBvPdJPjD554H0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TEfLp7hIv/cWl1X+DVI6l3MP86XONv02gYekS7yKN6PYIwyfyaSlcDnZRnTlSOLtSMVDRKoVtT0CfTqcETtVGohuSZgmOaKUDc9q7jk0J2B7Kj6nYO+v5FzAOhiOHb7+cqjzJMUKhtYy3aNEeE5TtjkFM38tOMzO3ftWKOh+9/s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y9bWcf5C; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y9bWcf5C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E96671F00898;
	Sat, 12 Sep 2026 07:38:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789198703;
	bh=RykUp5duqPyp8yczbPiwt5S7Z4KAjGuOlhgSwHCe8MU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=y9bWcf5CCaF26Zw/BjoH2iCtS0xVCqu0U6CKkK2LlQ/IAe84YpxANZYJFxsfJPTJf
	 jJQ5vltMk7BeYa3TRe7ghaUipIxPm/20kLdVxIAU7YcMliseuy+XM87517rx2zKxoq
	 +T2tE3c4wUjc04JlFdIkvMJkm7aV9j+u0NM01m5E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gleb Markov <markov.gi@npc-ksb.ru>,
	George Zhang <george.zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0435/1815] drm/amd/display: Remove unused-but-set variable hubp from
Date: Sat, 12 Sep 2026 08:36:25 +0200
Message-ID: <20260912065659.105032457@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/gpu/drm/amd/display/dc/hubp/dcn10/dcn10_hubp.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/hubp/dcn10/dcn10_hubp.c b/drivers/gpu/drm/amd/display/dc/hubp/dcn10/dcn10_hubp.c
index 7c97a774141ff..d8eb5996b5774 100644
--- a/drivers/gpu/drm/amd/display/dc/hubp/dcn10/dcn10_hubp.c
+++ b/drivers/gpu/drm/amd/display/dc/hubp/dcn10/dcn10_hubp.c
@@ -772,8 +772,7 @@ bool hubp1_is_flip_pending(struct hubp *hubp)
 	if (flip_pending)
 		return true;
 
-	if (hubp &&
-	    earliest_inuse_address.grph.addr.quad_part != hubp->request_address.grph.addr.quad_part)
+	if (earliest_inuse_address.grph.addr.quad_part != hubp->request_address.grph.addr.quad_part)
 		return true;
 
 	return false;
-- 
2.53.0



