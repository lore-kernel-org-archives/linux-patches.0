Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795044974;
	b=LzN1KQ+GDqQSzQQAAjFZlDc4e/eIwQBRQpioargmIOdpQ7+8UcjJ6Cs4foO/tuFMlaIG
	 ASv/lq/E3Sm0Romn1lLA/RTnP2hcKu2Th75ChwEqT2OtUa7b+3vX1x4gnhA+DUD6LSW8C
	 Qb15BQnnTmKrRo95Ddz/r89da+Je4tMaUblPQ2CnNn03AfnyvaYlw9VcUa9nw4ABIG0GT
	 hWkZj12NveEk/RTb5fKVUoRq98kgzq6f+YNhXEbrUnOWbMHIhYCRHCnbntdIucY2gtf96
	 c72TE894OXyUco4nA5YpfU2Qj9fuZ1uMLRVzs+oBWK+JkUQdjNceCqTKspPYYTJWlPQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795044974;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=XQqwc5EUIICDi0Cs9QOdutm/2yp+OQW0h+WT88IrQZw=;
	b=2+8CPYgaraCBBIaXfwxuFgG1Mny0WueP5RH+x9V6r/zCKtbahi2nXzR/KuW8WHFSinUq
	 XAcQ3+bprrYBfA1X94qRuIWutVrMN0IlmIVJ/OQpwxx/iI6lvYfXCR3hMQ+2YbyEsIurW
	 1xHgcifrCRpLnJFfTDkTD6V8PM61pRXm9N9NNwZQSzwRgzlc+dxdo6V0uWqIljCgrMAQk
	 E7kTUj7ThufvvjRaPlHZfEO0NQsCUgg3taq8wypAI5heA6Me6RLpJJR054GZNe53cHYeI
	 cLJ5tXJ2mRmf/1OixTk63BJIJnkIEDVY4Qsi7DLp3Klk33jEMOwVeDJ68En9d7XDQdQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=V+F5aRX6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F333360A2602;
	Wed, 18 Nov 2026 23:36:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=V+F5aRX6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DC6B1F000C4;
	Wed, 18 Nov 2026 23:36:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795044973;
	bh=XQqwc5EUIICDi0Cs9QOdutm/2yp+OQW0h+WT88IrQZw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=V+F5aRX6g92lOK+sCQwBrXzO5XfNgtFCgrgcvDYxj9mwDCT0Q5Tb/+IwfzeBn52M+
	 7Xf6Tizn/kBKY2cALmeGuQzLBOfA+rG9cap/Aq/cbPYMOGL5CoBIeWpdBn8OD0rMib
	 13JVp/M6W7U6FYIdA2Nyxie7VXQnthe9gvPjMsBM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Binwon Song <qlsdnjs236@chungbuk.ac.kr>,
	Eric Kim <seohyun.kim@outlook.kr>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0758/2857] sched/fair: Reset NUMA fault locality after scan period update
Date: Wed, 18 Nov 2026 15:29:52 +0100
Message-ID: <20261118150228.844092285@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 325e7542fbb4b..84a007ca144b3 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -2370,7 +2370,7 @@ static void update_task_scan_period(struct task_struct *p,
 		p->mm->numa_next_scan = jiffies +
 			msecs_to_jiffies(p->numa_scan_period);
 
-		return;
+		goto out;
 	}
 
 	/*
@@ -2414,7 +2414,10 @@ static void update_task_scan_period(struct task_struct *p,
 
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



