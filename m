Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EE08379EE4
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:01:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301693; cv=none; b=nqPhJfThRmR/hBsDAjWU2HVX/nheRoKO7AaPK8fsQvG5Yyl9eG/6uT+dimv8hUQpVrwfBnU0qlgITgisemgDp3LHyA+18YR/Y+vFHsjbsV1mvi/4ExOX8yUjad55L4FpAqtcq3I46PWGYaHMKTMsmN7zvVS2MKQtf6dM80elaqY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301693; c=relaxed/simple;
	bh=77osr6DQ1VZV3fXFkRrww/pN0oI/WsL4mCIIdwhYJMQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PdLqZ5AYwDIbZ6ojOBCy6ca/gXZWUzE3z1wu/WdS+C94oZ585FjDFavCWFZVtzqQxuZalqv3KSO0ayvLod723vvXVr+o+lOcZgT3bTU2Rw3qaYV1UmznCt2u6rn9GDcpMYK4NLJFnCiuMnznPIt05uHKX9FGQIj91Pn0sjNXIYA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cM5iMuG/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cM5iMuG/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71346C116D0;
	Sat, 28 Feb 2026 18:01:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301693;
	bh=77osr6DQ1VZV3fXFkRrww/pN0oI/WsL4mCIIdwhYJMQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cM5iMuG/qVV70+/gOqhrzgUkTSQG9OrsxDdKapxN3Ye44/1n78v/WxL4Wz/1zvfEw
	 2ZNMUwL2Jx2FvWNZgcJTXkP2p72v4IoSAcWUkpRFVNA2dzvC51Y/Y8duip4fXLy76X
	 B/ExLqaq0/csky4yIdt9KbRunFARjp5qRVLcN7fhUgjo/MvOb+/kRp58Ag7zv9dTx1
	 im/IYBgVpyOV/vONeNnoOfrIJcLhhKMJ9SHUN18sFdeLeRIoNfaQ35HJ3fOL6TD6U3
	 kGl7cX48vvRBHGhaZoSvm7VCEGP6Gqnxy9joCOAncIdWWqbJLm0kkoChdyKNySwPGb
	 t42NZRjnOnP6w==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Joel Fernandes <joelagnelf@nvidia.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Andrea Righi <arighi@nvidia.com>,
	Juri Lelli <juri.lelli@redhat.com>,
	Christian Loehle <christian.loehle@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 084/385] sched/deadline: Clear the defer params
Date: Sat, 28 Feb 2026 12:55:06 -0500
Message-ID: <20260228180011.1568201-84-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180011.1568201-1-sashal@kernel.org>
References: <20260228180011.1568201-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Joel Fernandes <joelagnelf@nvidia.com>

[ Upstream commit 3cb3b27693bf30defb16aa096158a3b24583b8d2 ]

The defer params were not cleared in __dl_clear_params. Clear them.

Without this is some of my test cases are flaking and the DL timer is
not starting correctly AFAICS.

Fixes: a110a81c52a9 ("sched/deadline: Deferrable dl server")
Signed-off-by: Joel Fernandes <joelagnelf@nvidia.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Andrea Righi <arighi@nvidia.com>
Acked-by: Juri Lelli <juri.lelli@redhat.com>
Tested-by: Christian Loehle <christian.loehle@arm.com>
Link: https://patch.msgid.link/20260126100050.3854740-2-arighi@nvidia.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/deadline.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index 1689d190dea8f..8acdd97538546 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -3649,6 +3649,9 @@ static void __dl_clear_params(struct sched_dl_entity *dl_se)
 	dl_se->dl_non_contending	= 0;
 	dl_se->dl_overrun		= 0;
 	dl_se->dl_server		= 0;
+	dl_se->dl_defer			= 0;
+	dl_se->dl_defer_running		= 0;
+	dl_se->dl_defer_armed		= 0;
 
 #ifdef CONFIG_RT_MUTEXES
 	dl_se->pi_se			= dl_se;
-- 
2.51.0

