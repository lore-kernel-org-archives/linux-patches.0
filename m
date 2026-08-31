Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00B164AF141;
	Mon, 31 Aug 2026 13:49:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184156; cv=none; b=GEKgNtSvdXJIirQtFoFN090LtfKvB6uv5QMriA3sE4d6iVvAyAYm8Cv8NwrOsfccMiBw/0tmCepoSFBut/JMRfc5WgKuiwzoIxbJiQNz+1rtuug0ocWJkoGzbV3CjjqGxYraNVGPrixjXS4I4vyrmH+m/ehzlzT1svj/5iYYCTA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184156; c=relaxed/simple;
	bh=lDEQp1Jg2Lqzole5zhBgw4Nj1zCSsbuw8fwWkk8HbGU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KepPgk0EJmmTOMv/pc1ucByWvQUCMju+N65X8mpq3qZBt4tRJdYiA3wxWr/5kahw+5wL+ScDVk933ZpAnlLcmx36SVYpjSf9Z843B/Rt8Mm8bfMgJkBaPzj+kXrLr6eoqDJYLlPhiAGR8PT4YO/br24gQI3Lwq2MXvFS/Pu3T+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=R8nsUnYl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="R8nsUnYl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E63721F00A3E;
	Mon, 31 Aug 2026 13:49:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788184154;
	bh=qkxEMTiYxEqz9LqiFfnHD0wIulNBWu8l047Bi/nKhGE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=R8nsUnYlSl8Vyb6UHtPKiPZKbbX1ktt1GsrlTzt0cvcCxbqKwrY20/pNijAyyMRrX
	 qDkQybYBGmOPnyuhdUq1fi5mWbHrB8b6y91N1lbr06+ensePqSG+IWuWwWr1PiejVb
	 YS2RzE609M52khbgC9yB1Rn0GS8OLUznSQ+UCHOrorVQzeW3nwGSu4mbIqo0lOtaKD
	 jCordmLOqOk6WpvMHX2t9LiRjZNVsVwhWAgHhbZ+n+Feuj2+Py+v7CvYLabGDpLJqK
	 drNbyIKGbCrUnFv3e6KS0NHWx/NHzL8uWl9UFFf8lGl3O18fGqm+yWJS4YG8cArj3C
	 LfG/2HJqqyBRw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>,
	andreas.noever@gmail.com,
	westeri@kernel.org,
	YehezkelShB@gmail.com,
	linux-usb@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.12] thunderbolt: Don't disable lane adapter if XDomain lane bonding isn't possible
Date: Mon, 31 Aug 2026 09:29:12 -0400
Message-ID: <20260831133314.4125787-524-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260831133314.4125787-1-sashal@kernel.org>
References: <20260831133314.4125787-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.48
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Mika Westerberg <mika.westerberg@linux.intel.com>

[ Upstream commit 7c7345bcde6c611fa8fa13e624207c6005798aa8 ]

This happens when firmware connection manager is being used. It will
deal with disabling the lane 1 adapter after the tunnel has been
established and re-enabling it afterwards. For this reason only do this
when we know that lane bonding is possible (e.g running software
connection manager).

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The background `git log --all` search was killed — it was hanging on
this repo, as expected.

A follow-up `git log -S 'tb_xdomain_link_exit'` (without `--all`)
finished after ~48s, but the hits (`19eef1d98eeda`, `ac3fd01e4c1ef`) are
base-import commits, not a clean “introduced in commit X” answer. That’s
normal on this 6.18.y tree where history is squashed.

The backport analysis doesn’t depend on that: the buggy
`tb_xdomain_link_exit()` path is present in 6.18.43, and the verdict
remains **YES**.

 drivers/thunderbolt/xdomain.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/thunderbolt/xdomain.c b/drivers/thunderbolt/xdomain.c
index 6b16fc7254b8e..b27ef872edeac 100644
--- a/drivers/thunderbolt/xdomain.c
+++ b/drivers/thunderbolt/xdomain.c
@@ -1951,7 +1951,13 @@ static void tb_xdomain_link_exit(struct tb_xdomain *xd)
 	if (tb_port_get_link_generation(down) >= 4) {
 		down->bonded = false;
 		down->dual_link_port->bonded = false;
-	} else if (xd->link_width > TB_LINK_WIDTH_SINGLE) {
+		return;
+	}
+
+	if (!xd->bonding_possible)
+		return;
+
+	if (xd->link_width > TB_LINK_WIDTH_SINGLE) {
 		/*
 		 * Just return port structures back to way they were and
 		 * update credits. No need to update userspace because
-- 
2.53.0

