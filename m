Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061973;
	b=BLUkIZF51w39y0EZpEvj/21WPP9AxwAFZ4IDo7u6lQFhV7eTPAnYKywRqjr+tVQEM+Yk
	 veAd9z+uG+B/5qnkfLhAJWMflLGzHoSrXUBIXTjV8iECWvs37WvFcDoWLwFhT6gOZCw39
	 JEGoauSV0xnXjwUxkGRse/qMqKElxJ/BX1HfaYnNE7W+EMXt6oP01HCXWjqGG1lqX0zTH
	 VkPmDYImMg54oCIa1XmJ2JXuga+ukSs8bFXE3ChIxkLtKzRn/5raSGPMk92cFCjGc33Sm
	 bLUax+E6Pj+dONyzVlEBXKRdmkOE5Giqac0ucR3nA7bC9P0VwGhX1qHt7d1DOjlnZ0w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061973;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=MQ5dUKv0aJVKDf9mTBhKkoyY6shSp6Ypg8qMq+lsgKM=;
	b=zMMyG/mx5ZlG87SIChzUmZ0Y4Jhx4+Kq/N4MyCCPpHtSesQ1w8HIzvyygMJxoQwAYT2X
	 i1yufCQc9zvZK7hWf5GXrpI3BN6KszAznM5IjJjV3LHgP7Yp0DhanOVCr8niszLAqdbY3
	 b87tVpRgGD4IKE/AmMPJGFW3gApEs93ZRqIqpVfsW+McJgdSO7uepa7Y5kdM4L4YAgFi8
	 w+d2q7hIg5NBkCb5V52nibn8McchC24lpXurCPTGhkm+VMOWVRTILJjWxyhpXB4EVLlR5
	 k+k28mvLmnUHQkbASjDlABI3gJnrRNckLz7u79qaA9RwEJvfdgzH8/WLhtGT3fC42GA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jh41CKku;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A74B606A32E;
	Sat,  7 Nov 2026 14:32:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jh41CKku
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 181D01F008A1;
	Sat,  7 Nov 2026 14:32:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061973;
	bh=MQ5dUKv0aJVKDf9mTBhKkoyY6shSp6Ypg8qMq+lsgKM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jh41CKku7mhAT2F6X7FojYQPcjLXSfWIDkG1pU/OsqkB2IJelvilFeEVgr4XfA0Oq
	 +kr7nxbjZDde4ccz0JE4DTXPIzwRKrreaM8b2kdQu8nmGHR+b53BnMUy6qKY1NM3n/
	 0xX/Sda010FIda1q3vMN0LNEZ3ZxHZkWs6D4PdMQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Binwon Song <qlsdnjs236@chungbuk.ac.kr>,
	Eric Kim <seohyun.kim@outlook.kr>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0968/1536] sched/fair: Reset NUMA fault locality after scan period update
Date: Sat,  7 Nov 2026 08:49:44 -0500
Message-ID: <20261107135024.836161790@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 011786704297c..020a39fe0e7b3 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -2727,7 +2727,7 @@ static void update_task_scan_period(struct task_struct *p,
 		p->mm->numa_next_scan = jiffies +
 			msecs_to_jiffies(p->numa_scan_period);
 
-		return;
+		goto out;
 	}
 
 	/*
@@ -2771,7 +2771,10 @@ static void update_task_scan_period(struct task_struct *p,
 
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



