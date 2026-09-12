Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C4102E06E4;
	Sat, 12 Sep 2026 12:19:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789215557; cv=none; b=ctlNLLn8q28YaK2zjdvQPclkULLYvUmO0HaYRXJiR+NaXSz8r6YZC5TVTiOUhWGzYrv42B82O1wTu4mv6xdN86lOl0B/KZtjMx8CPNdv87TdVEXXkkiPILP42TUKQsqvx+hw+GftA7FMwL9cn4z7YHekT60a9TVdFDruqXXORyo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789215557; c=relaxed/simple;
	bh=HClDEhvDx0q00p84JkVb/M7ZjGoDMrCD7RWxEbYsKnA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GLdr1mchGVe3CX6m+5dKlhpIcknEfcmPXaEMamuEEdIF33X/YLEaW0l7tiXO4Wwf2ebwUTjzN3gLks98rHXAPhI0eyds7kuj+z0Fwm25Srlh/c2ja2KCeVoLxNje8k4U773OpGD7kcdDwuAbpEJE79m/xcP9+7laCZK/PcU882I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ojt9VIi/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ojt9VIi/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC1741F000FF;
	Sat, 12 Sep 2026 12:19:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789215555;
	bh=oq2d209xcbW2TpXWw2IrinJ511ECYqlBceJZO9rvm7s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ojt9VIi/UaFO0Jn0+pkAFNOui/5X7TuLdXIKQDZHJxef5cyonzh8hIGSxkcgbIFRn
	 X75XOY+0dfQ9FWUJFKle5CutevgpebXvmehOXLx3N2KlY94rTzEZhvH9J/0jV7KnbU
	 dz1RpqkVoaW7HYVM53PxUNJmT2BRF6bTuH/mfy+Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gleb Markov <markov.gi@npc-ksb.ru>,
	George Zhang <george.zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0554/1376] drm/amd/display: Remove unused-but-set variable hubp from
Date: Sat, 12 Sep 2026 08:49:40 +0200
Message-ID: <20260912065619.883931361@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index da963f73829f6..c8ae19b37d844 100644
--- a/drivers/gpu/drm/amd/display/dc/hubp/dcn10/dcn10_hubp.c
+++ b/drivers/gpu/drm/amd/display/dc/hubp/dcn10/dcn10_hubp.c
@@ -755,8 +755,7 @@ bool hubp1_is_flip_pending(struct hubp *hubp)
 	if (flip_pending)
 		return true;
 
-	if (hubp &&
-	    earliest_inuse_address.grph.addr.quad_part != hubp->request_address.grph.addr.quad_part)
+	if (earliest_inuse_address.grph.addr.quad_part != hubp->request_address.grph.addr.quad_part)
 		return true;
 
 	return false;
-- 
2.53.0



