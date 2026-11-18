Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795058155;
	b=SRAlgsd0LoNTTcOabS8Koz6topNYXLfLAGVqHl4GqY3V/uB8xpegBnxYEVxZ4epstkwP
	 gsV/0ZcU5dube/J5KsRVrir1KWFW1zSciCszMVX9fDWq6XUitBNSUutuksPuiVlVGuqiN
	 9LUHGR3bfUysU3RZkzr988lpPKYO6vob3WqoKJ5pr1FBI+2q2eFUi/KhEo7XqehMk93NR
	 HZZdmdPkeRk3YKxi3o8z98gzkREcAK2HAd5ZcExe/W9/CGxPNeST4kOT7K/aa4LZF1VA6
	 vXwzGS6Ggu+wMw1rzhDJHTkFKcz4S15Fqejo/z25YB36Bt2wIl3ZHaWSzm14XG6ZmNA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795058155;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=biEH/Cyd+cEpaap5mYns6OVDuF2M5kmzeOX84DbeYPU=;
	b=Zp+nCxhPuU93SlDtjv3fHW2X9hoH8Z0O2GHWqPELZX8NOnLUZ66A5yKnZjQ5d/jd6RB7
	 Foms7b5UJOAVZYsHqYY7td7jIMeQP0VRsnmLIuwsKIoP84QgNSaC+YBshD/9NhTFA0oKt
	 rQ3WFzcAz3BfbA9gHWseo1xjkirp+GRGs8JP1iXI563jsYL+HK4U0kcJPl1MLp75ozunt
	 2AltH8lWw/yNYkYjY1jlKy8m5EVsvtLkdLf+iCy5a2togQSG7Y6j8Xbn0JBuNhNJM/P+3
	 NkJRMLlw/Rt14j+JW/JTI0V1Ytr4TNxZFsbMvfQ/+1bjTnRUOvc6PASF0KkPaEqCkQA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=q8DBRxGQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFC9D606A31C;
	Thu, 19 Nov 2026 03:15:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=q8DBRxGQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E64501F000C4;
	Thu, 19 Nov 2026 03:15:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795058155;
	bh=biEH/Cyd+cEpaap5mYns6OVDuF2M5kmzeOX84DbeYPU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=q8DBRxGQE9cO4lOxP1F3rhllneM1KaiPxmqw1FTRQNxwJN5LjO/1MUHlMWJHrPEmb
	 Do+jorTnbrH/avcfdLixTEQ3PYT/8WlAjRHT9AY2oYSJm7dQPJ6o4ECulURC+1u1rL
	 uBZfdWm4WZ1FiNuJyJVt8B86eiWi2O8WNtxxKtBw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Binwon Song <qlsdnjs236@chungbuk.ac.kr>,
	Eric Kim <seohyun.kim@outlook.kr>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0384/1848] sched/fair: Reset NUMA fault locality after scan period update
Date: Wed, 18 Nov 2026 15:40:22 +0100
Message-ID: <20261118145929.727299234@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index a2842a6cece63..51940240b89d7 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -2202,7 +2202,7 @@ static void update_task_scan_period(struct task_struct *p,
 		p->mm->numa_next_scan = jiffies +
 			msecs_to_jiffies(p->numa_scan_period);
 
-		return;
+		goto out;
 	}
 
 	/*
@@ -2246,7 +2246,10 @@ static void update_task_scan_period(struct task_struct *p,
 
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



