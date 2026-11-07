Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063946;
	b=lIINk0Is9ZZ9TBfcfV47VSG0x/VPj+iYhMOoROqjYMZMg1zIITp09zyWxCPCPwrZsp7X
	 /mKTbG7VPUf8Pc4L3fW7718B/pwEX7+/LrE2SLMSSd1y5cJ1Uwr6XTg+HOHOg2slb7X3S
	 kRiMGz0qT9t87xUWlWi/92I3DKDsVFyBZCYn44YIIi5S3pd0W7+Hsc6JqJECuHX1xqu2K
	 u0Vn/+qNwywgJoI+SS9OLzl6MZCZpTCYsk4GUv/zULpB+vnZD+ZrDc1gTeCC1gPNR5T4x
	 90gUhjSzrVFDJQnJ7RBZSIhgsn6Zl6xTfYp9blppE8SRfM0BHiTpvctQJ73QN03h4yA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063946;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=VUQU9Q7CbgBXGXjxPJViiiCQlEfoWtZ04Dbcw5v5QlI=;
	b=FkgzLdqrl3lAjU1OKjcem8RWyI0dheGElpJdwrQuBcw3+KkqLmc/jpyxKsbeVEc5s8yT
	 lt11hJQmaEOLIbbq8crIpCIzXt9IWVJEVmZzrSSWdT2UO2UO//e/ElYhTTzTBOgrXiNN2
	 gicutHf0cAiVmD+h/0W4kAw4KtJmIPJauueEYPkG4Wg2RPEivpz2rsn27a0RfmhOSr4zq
	 6rGLV8FtzfQDv8VYv4iHE66uzxSEgmxwRtSzMEoPkiR0rZ0caLbYOxZe4851WExRHg/v4
	 Mg6UoF4lyPOA+BpRnMoUINwV0cv88iKygWbJ45kvATd1JdSSuOAhQYzZCZjA5ya5xAg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QKXCe5lr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DA8E606D829;
	Sat,  7 Nov 2026 15:05:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QKXCe5lr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C2AF1F0089F;
	Sat,  7 Nov 2026 15:05:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063946;
	bh=VUQU9Q7CbgBXGXjxPJViiiCQlEfoWtZ04Dbcw5v5QlI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QKXCe5lr/589qcYdQcLdnYNEmwOWvqRE3Yzi+7VHe6wqOOqn2nhT0ZPlj6alxflEh
	 nXea+j/CryUkyZZGsbPqBn2b1dINZK7uwNPzM2T1xrzIImLGdLyrsEKY+0XWamJ5Hx
	 zAkJC4/2P7KDMOautp1Cz1bIbRIVGBbtfe9vyRb0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Binwon Song <qlsdnjs236@chungbuk.ac.kr>,
	Eric Kim <seohyun.kim@outlook.kr>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0138/1257] sched/fair: Reset NUMA fault locality after scan period update
Date: Sat,  7 Nov 2026 08:40:34 -0500
Message-ID: <20261107134943.122613247@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 0f2364479f9d2..b336048eafa2c 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -3713,7 +3713,7 @@ static void update_task_scan_period(struct task_struct *p,
 		p->mm->numa_next_scan = jiffies +
 			msecs_to_jiffies(p->numa_scan_period);
 
-		return;
+		goto out;
 	}
 
 	/*
@@ -3757,7 +3757,10 @@ static void update_task_scan_period(struct task_struct *p,
 
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



