Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1103018B481;
	Tue, 10 Sep 2024 09:37:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725961066; cv=none; b=krlLUdwOi5L8cUL26JkcuT16YC7kM9u7+akVjqFFct1oNuzq1Lq49rDo8MSE4eFNWr+N4l8hWCKq5myRIAKdj0AH4QbrVP6a2eYmkpQP2kelWIunzTZFSZ2CqsvimVJdNkBiXr1Ds1SZ5x0BljcAxAssx6LCCVQC6iR2ynCNZaA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725961066; c=relaxed/simple;
	bh=0umO2WCWfdfvx/UiVh9cnJ4Xu2JvW1IgoJ7EJbnx/Ik=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xhn9064zUDgDmDwl3fNHXBCsIt8k7Jt54XRzRQ90f4k0Y00rzHxb00ajfEyKw6SADBJ8AHDKoJAxN/xQWswgtZs1l7/qdJZjDpYz1M3CkupUab6lc+geCJgsrbhUXru59ZyBwsB+GOjSpLR7fXIpW8scwYR9V9+FCBnC6yL7WU0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lx60brSW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lx60brSW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BBA7C4CEC3;
	Tue, 10 Sep 2024 09:37:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725961065;
	bh=0umO2WCWfdfvx/UiVh9cnJ4Xu2JvW1IgoJ7EJbnx/Ik=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lx60brSW2x87IBGG3GYnG+jceKLXC+AtNjMpmGGWuy1ctThpD6D33+1SpJ8ftfBIX
	 2UPHMDl7j7E850kcy3Gb75kL4Dfx2SHdC832VQz1HYlGs0dLo6KGw2OIEkHudvIA/J
	 xfmCpVzAYsXIdxFWlbu7tX3qYuhNXyTCSSktVaLw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Guy Briggs <rgb@redhat.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 42/96] rfkill: fix spelling mistake contidion to condition
Date: Tue, 10 Sep 2024 11:31:44 +0200
Message-ID: <20240910092543.391136197@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092541.383432924@linuxfoundation.org>
References: <20240910092541.383432924@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Richard Guy Briggs <rgb@redhat.com>

[ Upstream commit f404c3ecc401b3617c454c06a3d36a43a01f1aaf ]

This came about while trying to determine if there would be any pattern
match on contid, a new audit container identifier internal variable.
This was the only one.

Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Stable-dep-of: bee2ef946d31 ("net: bridge: br_fdb_external_learn_add(): always set EXT_LEARN")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/rfkill/core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/rfkill/core.c b/net/rfkill/core.c
index d6467cbf5c4f..d138a2123d70 100644
--- a/net/rfkill/core.c
+++ b/net/rfkill/core.c
@@ -510,8 +510,8 @@ void rfkill_remove_epo_lock(void)
 /**
  * rfkill_is_epo_lock_active - returns true EPO is active
  *
- * Returns 0 (false) if there is NOT an active EPO contidion,
- * and 1 (true) if there is an active EPO contition, which
+ * Returns 0 (false) if there is NOT an active EPO condition,
+ * and 1 (true) if there is an active EPO condition, which
  * locks all radios in one of the BLOCKED states.
  *
  * Can be called in atomic context.
-- 
2.43.0



