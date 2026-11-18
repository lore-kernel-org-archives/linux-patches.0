Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795052197;
	b=p/tZKuBOEjVRGlgXXiJbJxlyIrL7xMUiI1Wy+D8LwMO/toFixmlhh39SqlBVP+Q1Yo6v
	 qyX69vpbK2C9MzrHrMGfdMrtE75oVb5rq/sDB3uvEJvBkoeyF1BNam4T45oSPqHXlOcCs
	 4WaPTHmXY1vDJTwP77HMnjiNB7DtEkkPWOtBNHbRoc45M6kR2qiVo+uSivh43yFhYwcoM
	 D7tjTvwRRJdRixF0fhgL7qdqZQ8jSk6GtTqxjMMHWWS4OhLmn9gOFIyGE9jPig7/92pji
	 e00zu43xTYSGOxDhOvUUdx4XEhYFrRxXiWVUYAQYWmpQdY7tdCQwIAAABKawAdRiKtQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795052197;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=CtiZmuSjI1DPXeuPjo290gG3QIQ8OMK7CgJ9GWvhBEo=;
	b=t9nD6Ngg7pVGqsrtkN4ldRb5tqWVA+Ho2iX1pcs5vdB6/pv8+HA98JlNEq/sAwI/AdAS
	 xGQQOlYNc//RLcCBpC3/kLQURFsIPan8izGqJEnUpyoBCSy4sc3ciBm6zCPku5HAxSUpA
	 rvqpZCEkQmt695B4x7IkGfNoa4KrSKKcxe8cA2I5l2mlT+L0iut0zMQqtBTYOYfVc7NF2
	 P/cJ0yeKZM18gaIOzOAbofXkbfJbnJaoOJ/OLi185ADFDWPQlgu5Sk1uA4BzepW06y9Xd
	 xRgQpedw7DeEQSAhdtgTtPqF7AhQ2IOfDlXO0XFSpYrODNW8Qquz0jUfZLHDjhQS7KA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vUo4rfZR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAF13606A320;
	Thu, 19 Nov 2026 01:36:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vUo4rfZR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 500171F000C5;
	Thu, 19 Nov 2026 01:36:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795052196;
	bh=CtiZmuSjI1DPXeuPjo290gG3QIQ8OMK7CgJ9GWvhBEo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vUo4rfZRhWXGdkbV2sHxeaDglP4FUcGMeeBC/wir1Ni3HwIkQNbUa9EY9aBHicR0W
	 1p6oFC17lFS1AB2Zp5EviniQPv1ZxrHa3r1XiVdxTDh7DHPIe417hehZcJ+/00h03W
	 VAMNf50QrUdF0H3c8ZN6gjEx42NxeZq8reGgDYOM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Binwon Song <qlsdnjs236@chungbuk.ac.kr>,
	Eric Kim <seohyun.kim@outlook.kr>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0479/2214] sched/fair: Reset NUMA fault locality after scan period update
Date: Wed, 18 Nov 2026 15:35:55 +0100
Message-ID: <20261118150030.319696327@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 15ea6bded7607..ba208f4c93222 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -2186,7 +2186,7 @@ static void update_task_scan_period(struct task_struct *p,
 		p->mm->numa_next_scan = jiffies +
 			msecs_to_jiffies(p->numa_scan_period);
 
-		return;
+		goto out;
 	}
 
 	/*
@@ -2230,7 +2230,10 @@ static void update_task_scan_period(struct task_struct *p,
 
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



