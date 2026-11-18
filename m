Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795035888;
	b=Uv2xJpkMhgqPQte12U9eQLu82WHnsRgrHefXwOl7SC+LBy5Lt/rYeNb+KNF8WJ0DTto8
	 85ZMAnllzlFWZcJ1Yvth+ffCzbAI1DrXGVBRyfDcC8Ah63vQoZlztgJ9jp6oG2uF7WxIv
	 vtPPn9isFC8PKebTr3A+oNgFk17xg6VzeRwYKWK3qPc4UM7xDl6QGpFuyphcixbNBGWvK
	 NiPktES3J5TUUlYeGbs4j0eFVLV0P4NcAfN5Jj8wvnedqlyAv504PEIb5UOy+4uXW2NWN
	 imAsUTtJiW8imZN6ZlpRnGyL8a4o6w15ED85C5wwTjc22JIjpytL8PmnS5hbc0d9Bnw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795035888;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qGyzd3jv6kHmGSACMhL1Je5XqfG7Hf+dIXGSRZN27uk=;
	b=ndAE1hYNNJEqRbbCMTP3T7TtzTRlYqBzeR9QkDVNLvdclNL2YRhYo2TtHPkmwyrqSzb2
	 Oy/bYzgcH2vOOS6t0puVO8Ipc/rOumRUTN3Wb1Wgzw18PnRjYPIav0C52WoeUQKggsrlu
	 Qee3/mxBFk2/qWKYNDr0Fbtq4gPYydyjoGN2oxaA8PYXEygXNTWM+crNknMLrA9SwcqqO
	 cfJaRBp7NrWocjN5/PBQ0HwXLGHkaALP4xEgIuk1xFnJWFfx6Zu/99KuI1oyJdVs8BCOF
	 +tGPmIPVbgwyJzU2Q3M1VK2nSEsCPhAzVHr0pdZtGY4v8NFX9f5OPgKDOqBdJcqlYCw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="Xif3/SEH";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D09060A2613;
	Wed, 18 Nov 2026 21:04:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Xif3/SEH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51ED41F000C8;
	Wed, 18 Nov 2026 21:04:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795035887;
	bh=qGyzd3jv6kHmGSACMhL1Je5XqfG7Hf+dIXGSRZN27uk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Xif3/SEH1w5DwcekqJbxElVUU5ng9DWmlHiHwv3o3waDsOMjwS4VGvwVHaovIt7Lq
	 IGX3+5LaYl00CpzD9DMscbztODmAW/ux2FCOYDZI0YzdrmgGIlpFCBNCKmNU+eMY3F
	 3HtIw3zbR1fOWGEuP3ISvlyqyU7mv3S80DVxgYD4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Binwon Song <qlsdnjs236@chungbuk.ac.kr>,
	Eric Kim <seohyun.kim@outlook.kr>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0862/3318] sched/fair: Reset NUMA fault locality after scan period update
Date: Wed, 18 Nov 2026 15:24:44 +0100
Message-ID: <20261118150345.149411900@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Kim <seohyun.kim@outlook.kr>

[ Upstream commit e81ee06308379a5f2ededf997bcf17551bce5db7 ]

When updating the task scan period for NUMA locality checks,
update_task_scan_period() checks whether there were no faults or failed
migration on the last scan window, at which it prolongs the scan period.

However, p->numa_faults_locality, which is used to check for migration
failure and number of faults at the previous scan window is not cleared
after changing the scan period, which unintentionally increases
numa_scan_period up to numa_scan_period_max even when there were no
migration failures or no faults at previous scan.

Fix this by jumping to the out label on early exit at this case to
ensure p->numa_faults_locality is always cleared before returning.

Closes: https://lore.kernel.org/all/20250404095354.311156-1-qlsdnjs236@chungbuk.ac.kr/
Reported-by: Binwon Song <qlsdnjs236@chungbuk.ac.kr>
Signed-off-by: Eric Kim <seohyun.kim@outlook.kr>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/Message-ID:
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/fair.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index a1bdd45c62932..c9e2b437ca003 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -2668,7 +2668,7 @@ static void update_task_scan_period(struct task_struct *p,
 		p->mm->numa_next_scan = jiffies +
 			msecs_to_jiffies(p->numa_scan_period);
 
-		return;
+		goto out;
 	}
 
 	/*
@@ -2712,7 +2712,10 @@ static void update_task_scan_period(struct task_struct *p,
 
 	p->numa_scan_period = clamp(p->numa_scan_period + diff,
 			task_scan_min(p), task_scan_max(p));
-	memset(p->numa_faults_locality, 0, sizeof(p->numa_faults_locality));
+
+out:
+	memset(p->numa_faults_locality, 0,
+	       sizeof(p->numa_faults_locality));
 }
 
 /*
-- 
2.53.0



