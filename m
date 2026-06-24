Received: from smtpbgjp3.qq.com (smtpbgjp3.qq.com [54.92.39.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9E0D20ADF8
	for <patches@lists.linux.dev>; Wed, 24 Jun 2026 10:00:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.92.39.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782295259; cv=none; b=LlPNGAo92GAF32RlUUfosK7xFCXFaNnxdHwVaFJPyRzXTJbf0duwUbbRGIAetUCenUR/2IgVsH0B8zwygVUMsrIQjhhj9a2eELIp++wap1ILj1T/tWLTQfpHjSUi+l7HAthtiyCoUDnSgC+hcylV8qSOOYfxGtP66ZKzkUPy6LY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782295259; c=relaxed/simple;
	bh=oIEYfyBI/HY6darqsVGBC82MMHrJVuN7qqQh5Yujuq0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=EfI1ldDaqgiJn39fd++TY8gUG6PUey8nctyACNhp/el21S8v7YIUbV4RM//b3NpfLronse/bKYUKAllsdh95kHKxAsVJHVxV4oz7AEgYaYb6ldXL0sWi0Yr14H3xtmurlQKuGbGQsy8sKdc72YBgLLZdOv2JyAm71cXfJl6omMA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com; spf=pass smtp.mailfrom=uniontech.com; dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b=ejqkpcJl; arc=none smtp.client-ip=54.92.39.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uniontech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b="ejqkpcJl"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1782295192;
	bh=VkOUhbDww57iO0p2rxbAqZ3RyZ9Ngi7YuBKPJC2iPVk=;
	h=From:To:Subject:Date:Message-Id:MIME-Version;
	b=ejqkpcJl8PlOpgMSoluWekrdqnK0f6hpC47+WDMzyZJ+stBi3ZItDY9zqTxcqvRV5
	 6A/4QpHcU1ZhifpVl74/gecnb4gdXNQ5by7B3zxxvqV7HGBjmz6ZLtQl5L1kkWknJl
	 y1Ki2f7XfPDMSLkTPQ0r1M5SjX0ibAo2P26eUSHk=
X-QQ-mid: esmtpsz21t1782295172t6a960cbd
X-QQ-Originating-IP: 5QqDY9Mz6lwiVbw5RvPqbi8h8LaIAWJ/rqaZHU13jvM=
Received: from localhost.localdomain ( [113.57.152.160])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Wed, 24 Jun 2026 17:59:30 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 14368970454076104944
EX-QQ-RecipientCnt: 9
From: Wentao Guan <guanwentao@uniontech.com>
To: gregkh@linuxfoundation.org
Cc: 00107082@163.com,
	guanwentao@uniontech.com,
	iklatzco@gmail.com,
	patches@lists.linux.dev,
	peterz@infradead.org,
	sashal@kernel.org,
	stable@vger.kernel.org,
	yeoreum.yun@arm.com
Subject: [PATCH] perf: Fix dangling cgroup pointer in cpuctx backport
Date: Wed, 24 Jun 2026 17:59:21 +0800
Message-Id: <20260624095920.2558406-1-guanwentao@uniontech.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <2026062455-obtrusive-sandbox-d6d1@gregkh>
References: <2026062455-obtrusive-sandbox-d6d1@gregkh>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: esmtpsz:uniontech.com:qybglogicsvrgz:qybglogicsvrgz3a-0
X-QQ-XMAILINFO: NRN3UPsLzYKVIW2xGgI+zTzrMhHEZ34YQiVhoPad/kZ0sEXCPJylnjIZ
	A/hVA9DahAmetClMLK1cZTfNBjOJqj7RBxUqZwdctuKehGu7TK70YQ9Sf/OwsXVEagdZpsI
	jaaQxFlCtvdNhaSl7k3u8Vel6y0cuX5DVXA5Ql01AV0aCeyFmm/hsVA0vWAI3DRlJmHYap7
	rNz02g07LFXDKKVKMzor83aMwIJJqxgIe3buA5DO0OPPEhwKacUoHXYcHH/N0mmCDp9PIUx
	H1+diaRUCId/7HjOJPxz/FFOiacs9VcwwlfnBJemLJY03FEkEFbTccEwvyBE76LO/cdRICs
	hHTQ8lm+OM8eybRTn//4XzuenXM4pOsbi9VYccvAtZiSTbMv76yUIn1AFdxPddXMEtzm3L4
	oOAmw1KjjcgBl/SV79XRfRyJzQWyhssHVsH6DHVSjSgP/laaNrzSXiGSENxq9CSAmoZTR2c
	S8PL6WlZt66h0hv8g27Wq2kete9HuqEt6X6YxBMIwBa0kq+fzBI5HIrRMn93E29B/Y891EC
	D+Te6zUNLX0tPdPrHc4c/UFr51h9u7/DFIyWb5GX0YZQA5EDzfZZKJZIysj2XfVP3tYLlf2
	9hd9swjuI0Pd/8Hn5hTT8yIypgj8Hitne8VaVxgUhDdZWZRVg4UVtE3FYXXOXRqIYd22gfg
	0R8qMcCXZbWckcd0OChTlwOZmtmS+9dzBlkVd/bpXrs1WGkPzssWe/aREbCxyOoq1r6FIXy
	32KLfIKkyipvpiJb/gy6hYnFF+CIGcnYL9SsmkLFMYBYjUfYqDVSZmKO9Dlskbvj/a+LGyM
	WLmjJorHOm1GONfR5Someh20e0SxgGc7Paqf6g8uo0vB2QJjkNgQcQuB5fj1FScGYlPKgf7
	eZPErAMON6unXBsIQVPzAvsoamoEE917Mo2+XwmgcM8Sx9QAIuIwxzczl2G0SxJKB4fhB3y
	3hOYDOlVFSMcDEDNI9ntl/EV5tGalZdetIyRDC0V1qqgtvqiBWnJet44lbgiUfoBBwa7+T2
	1t91t19rMs54b5a0cz7imFqAnwA6+itUnkIEpLc6QC5kKGXGyP17WFgxskaHGKPnrjZv52y
	Q==
X-QQ-XMRINFO: Nq+8W0+stu50tPAe92KXseR0ZZmBTk3gLg==
X-QQ-RECHKSPAM: 0

recently backport of ("perf: Fix dangling cgroup pointer in cpuctx")
use a middle version, so aligned with the upstream commit:
3b7a34aebbdf2a4b7295205bf0c654294283ec82

Signed-off-by: Wentao Guan <guanwentao@uniontech.com>
---
 kernel/events/core.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index a4187dea6402a..73a86db06cc9b 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -2384,10 +2384,9 @@ __perf_remove_from_context(struct perf_event *event,
 	 */
 	if (flags & DETACH_EXIT)
 		state = PERF_EVENT_STATE_EXIT;
-	if (flags & DETACH_DEAD) {
-		event->pending_disable = 1;
+	if (flags & DETACH_DEAD)
 		state = PERF_EVENT_STATE_DEAD;
-	}
+
 	event_sched_out(event, ctx);
 
 	if (event->state > PERF_EVENT_STATE_OFF)
-- 
2.30.2

