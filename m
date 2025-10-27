Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1503132ABC5;
	Mon, 27 Oct 2025 18:47:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761590841; cv=none; b=KVQ3UE81kc4KsrWtDCakqru+gQ/+il7/KRo0iujCfoNssGbiiCGO23tV3XMuNN472JKGnIGAbr3e77eCn+dbIJmdGcsV6hJqg06ojXalWdIFBvsbe2JSYaPCoKFmg3aj0Nh6UDiRAEBjzZ5LEhRe2UP4HZuKicsJtjh67DcxqD0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761590841; c=relaxed/simple;
	bh=mh3l3BB+nuQzG9Yr+gyjlFwIT+2RnWoy4l5fkgqZXtU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gZtHg5IC4NZdY06lFYMqJlXcFqMEo966wpqQvQY4OIkofGPdPmHTlR7VJ14vgzOrwQSbrGSAPFlp6V30QVxKryRVaKTIou6F79H/n+VrpjfQYAnfRKfF5ZkoVukEPYuvLvjmRfjg4NiygELzf4xuVpB2ZV1OUH7ILLWxDj3s98w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xkvzdAcE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xkvzdAcE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45A05C4CEFD;
	Mon, 27 Oct 2025 18:47:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761590840;
	bh=mh3l3BB+nuQzG9Yr+gyjlFwIT+2RnWoy4l5fkgqZXtU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xkvzdAcEqTX6THu0boqXyiUkMIhykUtcAIYQ6oPZyXX9CKEAnCLj5jGQhXJvknepF
	 ELJRfSciK5OBLXZof35m2YHN+o+VzuTe9+r0DJBl9J1E54NvZnc7eg00HGhxvyG8il
	 PGmwv/n/CtMC7GFddQHU1pj8Wk8OwoHyydK7vNH8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Barry Song <song.bao.hua@hisilicon.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Ingo Molnar <mingo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 167/224] sched/fair: Trivial correction of the newidle_balance() comment
Date: Mon, 27 Oct 2025 19:35:13 +0100
Message-ID: <20251027183513.380134538@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183508.963233542@linuxfoundation.org>
References: <20251027183508.963233542@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Barry Song <song.bao.hua@hisilicon.com>

[ Upstream commit 5b78f2dc315354c05300795064f587366a02c6ff ]

idle_balance() has been renamed to newidle_balance(). To differentiate
with nohz_idle_balance, it seems refining the comment will be helpful
for the readers of the code.

Signed-off-by: Barry Song <song.bao.hua@hisilicon.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Link: https://lkml.kernel.org/r/20201202220641.22752-1-song.bao.hua@hisilicon.com
Stable-dep-of: 17e3e88ed0b6 ("sched/fair: Fix pelt lost idle time detection")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/fair.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index db4a1da522e42..1d82b9cc9eb77 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -9897,7 +9897,7 @@ static inline void nohz_newidle_balance(struct rq *this_rq) { }
 #endif /* CONFIG_NO_HZ_COMMON */
 
 /*
- * idle_balance is called by schedule() if this_cpu is about to become
+ * newidle_balance is called by schedule() if this_cpu is about to become
  * idle. Attempts to pull tasks from other CPUs.
  */
 static int newidle_balance(struct rq *this_rq, struct rq_flags *rf)
-- 
2.51.0



