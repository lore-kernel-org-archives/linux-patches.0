Received: from smtpbgsg1.qq.com (smtpbgsg1.qq.com [54.254.200.92])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 178C7348C63
	for <patches@lists.linux.dev>; Thu,  2 Jul 2026 16:47:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.254.200.92
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783010857; cv=none; b=KisJW15TVlWNNc3vbBJCTTT1aSABt2Eu8siHZWjVpdLWbHH8RCL+s+OeWSzN91Cj1Plky5A05t8s579sJydSPVrTtCQawNPp79oX9xDUZ4yWc/PQkib2NTUWm94MQQEj9wqK7Ecy6YXrzNqvx0URCUbdo1rdx0a0v6NDQ42yDZc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783010857; c=relaxed/simple;
	bh=ONaKedoAz1ZMUYbT86fdH68xNyanLZ4A7ezeq6OWTYg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=pZz45gKpsNisR94FVewLmOktvKPjgBY0P9J7YXtFRhaj9TIlBfXPi8+IlYNmCxU7Uya33U0aTMxVagr7FV510VoTEeUHbK5D5R4jWwaQLH2NxDDIdeCO+HyYkg+FCG0pnWieaBFuP6euJFHlL6mhMxC/ElCTt++UxdtMZ26zgC0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com; spf=pass smtp.mailfrom=uniontech.com; dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b=jS9syefe; arc=none smtp.client-ip=54.254.200.92
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uniontech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b="jS9syefe"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1783010780;
	bh=ywEQIaPdwXqBm2L9NsDVfzNWZ0ixJP2Iy1x1nuGkgbU=;
	h=From:To:Subject:Date:Message-Id:MIME-Version;
	b=jS9syefeAbJDsV2qCQDo/bBGuVR7GEdOeqfeS6Gzmgjit9mFTzM/j7Nmg/y7ebt7b
	 1G5/8/SQYr+IzFbiri2zfgWmT75d6QoRuUEhw6GAHa8jZNTDl1HESVCzVvg+jiKRlo
	 0/h+mIY8l0cZGEduqLFhTDSJ6IeHwjUdODyENqj4=
X-QQ-mid: zesmtpgz4t1783010761td432150e
X-QQ-Originating-IP: XuVxTDBheIZR1nuAnJSqw8c46VDRO+tdQjzu73Sc2Sg=
Received: from localhost.localdomain ( [113.57.152.160])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Fri, 03 Jul 2026 00:45:59 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 4839875498590067258
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
Subject: [PATCH 6.6.y] perf: Fix dangling cgroup pointer in cpuctx backport
Date: Fri,  3 Jul 2026 00:45:54 +0800
Message-Id: <20260702164553.498397-1-guanwentao@uniontech.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <2026070200-uneaten-smock-4130@gregkh>
References: <2026070200-uneaten-smock-4130@gregkh>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: zesmtpgz:uniontech.com:qybglogicsvrgz:qybglogicsvrgz3a-0
X-QQ-XMAILINFO: Ocx62dM7vaMV8DFUrqhZS20s2ZxTKG0n8HN8mRFJ/vXMmmGrE9kJclM1
	zmN7NyN93OZPN+Uoqv57p6IDxv+JcpVwqzxg8tQdLyEBKCwfoNfDFOywI9vE1YS0g4JJFsh
	JM1/61LtqiZ4N/SSZzy+zYXGZdgItw24P0WQPtoncaNb18YeygBHmR90QmgiREENd8WKsuh
	V+MbMfXiUWIHn/UNUOuleguhEZkdl7fOy1zxpXGA6tOSSXcfOf2CWeBowkquf4hxzLKudF4
	uzrEtmj0yk3/LBxgWC66UocJya4xCjycEQquWjFZQ2l7jKxrwtFSK4jvR4lFf9yQICh+oro
	/Xs5IX6Fr1LSo9S2SXPhtWfs40xqs6o7kDgl9EFHZCPD+JxWV+HzJFJOCABcSA6j0Gr1Ka/
	vMX2SiA7i5VRcz0BkD06fYIlQEHrzNvP0fudYfV1sDaXTYDhJFjs575U9g8PzGuHGq1ojei
	Mqv6EhuSfpJ4JuJTpCY6+uO66XYjLwEuVzOYSE/TPGhHtaJobYjdYQdl0ngjPUmFcibOxZI
	S9f5tbMn3YQlKQvTJtYq26Rq3xBUvdWvskt4igpI2M9Z2lVJn9lOwv2GNGUdvXwS+tjkEsx
	gih57+MmiIUlEC4mXTH4v8S5vkrakkInL27cZ6eGTyo+LuafTB0F1O3rl59RCXLhsFo33rD
	3i6gRnL2QaTIFkjzDFJxPNif0VP+vf+KXOcOixlYn16H25BRmjtAg4907DBL5SE3bArfCbg
	PjQuk9ZXZ07kgrgZqD3pr33VAOjD8XWBGS4+yGyHf9nPaVRN4xpqeeFesIuhNZhogReYIaP
	7wb0fmfRXFyfx+8Yl4bH4w6M1Q69qpiJYs6LI8wIadiCbOQGnZEkyQjmqTOdHl0mACkmnbH
	KlEV737SgZY4dnGYlVYZODp0d+VZVJh+EKi/kDTxTSJeEbLi7tR57ojGhGbevLK5r+JhRpw
	65twi01ckl1kHm1zMe30waKOrlzehoUx1pHG4Gh0o79aK5N6j3bSJca/SPIaFPBFDK3MLKv
	Uiyuj1AT9LgEAVgILTYnNoSAIa/KKbhDK3jwJCRUztXBKIaGKwJl192e4lQ/SVjn3zKC51m
	fSrYvSMFfp895k8vZ3pvzQ=
X-QQ-XMRINFO: OWPUhxQsoeAVwkVaQIEGSKwwgKCxK/fD5g==
X-QQ-RECHKSPAM: 0

recently backport of ("perf: Fix dangling cgroup pointer in cpuctx")
use a middle version, so aligned with the upstream commit:
commit 3b7a34aebbdf ("perf: Fix dangling cgroup pointer in cpuctx")

This is a fix for stable v6.6.143 backport commit, so no upstream commit.

Link: https://lore.kernel.org/all/2026070200-uneaten-smock-4130@gregkh/
Fixes: ae1ada0af162 ("perf: Fix dangling cgroup pointer in cpuctx")
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

