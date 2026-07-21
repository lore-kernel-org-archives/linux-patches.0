Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 800F53C1098;
	Tue, 21 Jul 2026 21:47:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784670440; cv=none; b=kl/im7GdmMbl8ppTdU2dS31sxKjTiYkSQAf317AqHGdggGXrxlKsUK939sJI9vjJA33+CiZUmIrLJX4nyQ/RvkL4Uy0pp+hYhdTOB9Pf9SmT1IUf1iy33grimLjAbWHyKpAbcdZV9jzBEJy8K/A5S4eQgJVigAqOYFNKNNucrtE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784670440; c=relaxed/simple;
	bh=zDIVqTQK3NmrtGzv2SAthZ0eS0OXh5AMJha9kfYgxjg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=APwivANXfjkkzlrdaV3KsjLbeQhSkLYSNCOo/lgLSTtZ5sm0EDI/8Uc7X3vIYm05VE/5S64yRDGHhUGQ6EL7/JFyNnwx9vxehvnNn5LeciYEY1GpdIEz+fB+tryBekNV4NuYJC3xCGCL66c1TWhwdbm4CPLUXDkxIuUbo5E7lOQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=02lADguG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="02lADguG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0F501F000E9;
	Tue, 21 Jul 2026 21:47:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784670439;
	bh=Ytdwjdezc4e9vWBAn6KgGNM078ypxUqiBfWd+PSaaXw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=02lADguGDPPp7saKBKdRKoruePsT2AD4ICFtpPHxBkzETk04PTLhnStwF+pF6IpXb
	 fxw99fupA0WhgAAWoG6K9O+RIjFY6Z8K8tShNrGSQ+kcoONfIkReXuEouyz0bTgdDl
	 YDMe95NyaEwe2eLI65CuxcATCSAiLdnzFNcD5HHQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yikai Zhao <yikai@z1k.dev>,
	SJ Park <sj@kernel.org>,
	Liew Rui Yan <aethernet65535@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0889/1067] mm/damon/reclaim: fix typo in damon_reclaim_timer_fn()
Date: Tue, 21 Jul 2026 17:24:50 +0200
Message-ID: <20260721152444.419855921@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Liew Rui Yan <aethernet65535@gmail.com>

Commit 2f54908fae211 ("mm/damon/reclaim: detect and use fresh enabled
and kdamond_pid values") introduced a typo in damon_reclaim_timer_fn()
where '!=' was used instead of '==' (unlike damon_lru_sort_timer_fn()).
This caused damon_reclaim to return early during the delayed work,
breaking early boot parameter configuration like
'damon_reclaim.enabled=Y'.

Fix this by changing '!=' to '=='.

Fixes: 2f54908fae21 ("mm/damon/reclaim: detect and use fresh enabled and kdamond_pid values")
Cc: <stable@vger.kernel.org> # 6.1.x
Reported-by: Yikai Zhao <yikai@z1k.dev>
Closes: https://lore.kernel.org/CANMyjpgq5n0Ekt4dgyLRHGb89_Ew0aOMZ3j32V_w0GjHkqH1FQ@mail.gmail.com
Reviewed-by: SJ Park <sj@kernel.org>
Signed-off-by: Liew Rui Yan <aethernet65535@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/damon/reclaim.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/damon/reclaim.c b/mm/damon/reclaim.c
index 016cd8d83ca9de..bb4b705d842c1d 100644
--- a/mm/damon/reclaim.c
+++ b/mm/damon/reclaim.c
@@ -198,7 +198,7 @@ static void damon_reclaim_timer_fn(struct work_struct *work)
 	bool now_enabled;
 
 	now_enabled = enabled;
-	if (damon_reclaim_enabled() != now_enabled)
+	if (damon_reclaim_enabled() == now_enabled)
 		return;
 	damon_reclaim_turn(now_enabled);
 }
-- 
2.53.0



