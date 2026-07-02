Received: from smtpbgbr1.qq.com (smtpbgbr1.qq.com [54.207.19.206])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B848630C15A
	for <patches@lists.linux.dev>; Thu,  2 Jul 2026 16:50:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.207.19.206
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783011013; cv=none; b=XtCvo9bPOkCjPS2JYhbOnrpce8UoxZU5svXNyUXjRa88FEV4A9pAf5O78uSICUAcZOWtG6DNGA87RupS8zouYQn2gb5KqEAwxVU+j76VKSJiOOJlH/iTjVqQVHMxEFJO9czgV6St0BAa3I05pwEr3pN8u+O4ygH5JGN+qz3OMNQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783011013; c=relaxed/simple;
	bh=sEHMj6/RtevNQP2GPZjL3kSPccCIu75NjhjYiaPqXvQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=jRfixiSzpr5Q3St+46V5WwIIKdTzJatj5cQauDhdPdHFiAcwa8qSRfXQK/YBKOAF9s+18YR2/E4ttdaOx0EWLb98rXR0AcHh4Z+GPxpdoXyDT/zk0/iP2x58Fwq2lbY0j62gnD2Nt12MZYQ7OeMg9BhDD2K7522fOKzd0BgaHRM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com; spf=pass smtp.mailfrom=uniontech.com; dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b=R7vYhouA; arc=none smtp.client-ip=54.207.19.206
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uniontech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b="R7vYhouA"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1783010932;
	bh=ZjZtskYj1lPGP1AN/SwUz6Igvce9elJmGSTGe8lPQsM=;
	h=From:To:Subject:Date:Message-Id:MIME-Version;
	b=R7vYhouAViy9ABaanNriL3yj7r11QWyiEM7onWUSZF/ZL8KqfDlRwY1I6yXT/wkOJ
	 blwLjaBrnZXmNzFtCjOwshve+hm3SfHA+orr/9DQJCDA/0+fcHbiuklV6eiiLjNS2+
	 EI1pZpAa3o7RqcZFB1wa2VTNMkvvx/sa1KawAuKI=
X-QQ-mid: esmtpsz21t1783010912tca81ae3f
X-QQ-Originating-IP: ZqrZKvpZQ6tmI8zlKvlmPl8v6bQZ+npMTU/CL7SiK6Q=
Received: from localhost.localdomain ( [113.57.152.160])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Fri, 03 Jul 2026 00:48:30 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 12144950956054268831
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
Subject: [PATCH 6.12.y] perf: Fix dangling cgroup pointer in cpuctx backport
Date: Fri,  3 Jul 2026 00:48:25 +0800
Message-Id: <20260702164824.498942-1-guanwentao@uniontech.com>
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
Feedback-ID: esmtpsz:uniontech.com:qybglogicsvrgz:qybglogicsvrgz3a-0
X-QQ-XMAILINFO: ML22//DLl/han3iVE2fKLxZY5WUDwMqUEByoYw2F4xqP0Q2h6vEJ8iUt
	winRkYd6JUOZkX2KPsM+BdJD323xmWQ1r0pfNzFQfH3/9J3s/EM0NvsXfCgChtURi7mE4jJ
	4H4HH7hhHmORNngsYovFKFbrn20rH/Qo4lC5LwrEX09EKpxyM3wZEh/pudCsn9TVE5u+bgv
	URmhawejH11UYZeYpo1mUn1BwiJhf5dOovAl+PzOpPAOd9RfI2KrkYZjHh6c7foKwR+qimi
	OfO4CtW0SpnGR84npsAwt+L3+TqMBhRM72QwpoPXcX9hFIZs7Lt8Zdgqpe4qxw+ZjR+n0Kq
	/5BzeK9J/NC+GsdhLuR/ab6oCni4gu6YlChru3wWJyrnPOpCWfBtvBmI19lb27WUum+5+Jx
	69jrWXIYfzTEwMhMmNrKLxB245yokBkcbAabYATXZugdp2NEfDX761X40rNmsVz2XkWyjLq
	RuPzhlddZUQXm0EkHZAc3O3X6dmQlYiv3P34Q7tlWJx5uxPYh00owfCquQjk0Seae6Yi8q1
	K/sqlUIvdn+h2sDAY67MQwMstcSGoHHSEOBHSa13+wgokEb1rWUThwrPn2L5alVVaRxnI9/
	Ymgah/fXecByzubnx99E9cHR/y3eeBrn15Q1s+H9ytGutZH6N+GVWPwNyEay7qh+krY8OFo
	sSVkD+KY5LKh1CWyBipN+LbbCr2jx8/owk7gc2/Yq1YPV/+VRWTTP7cRxwxHazBTQHwqPdE
	ZhEbpAVw1w692xUw/Tx77dv7557IS1Zj1o5ZIBixGvGraHgOyLp1s8RwY9A9Tv4D1/sWoUI
	lpp+kzmZxd5eILorhVrYHxJMnuVJB1PSpwjHgPDQMplhNngDhcahb9DReFtTRFq2j0+/VMm
	RsQ4+rUOX5U6SwA9fJHLbcXNDkN7CWiPi79jR9GVzEYyG2YTjUzPFCrTDqiojvVsFg17PaK
	uHRXCiAHBHW6OzWq4P1uRs6lxjC91b+/RGBObMDRH7yn7W5IibSI8KpvCekAokMXdHT9obl
	NJDn0snleeRK20UONLmhZLWAgOvtzTahDpRdWleAIEN1aYq9+Y+F7SDNVXyo6QdjOgpDTYK
	Ozr6kLg4RoQx7rK/nbLgAz7KIlP0/S3xiWa+F8tUsO5zdchX2eEDuA30vfpwbCwJroxIOfY
	d24FQqXw2ETIHXs=
X-QQ-XMRINFO: Mp0Kj//9VHAxzExpfF+O8yhSrljjwrznVg==
X-QQ-RECHKSPAM: 0

recently backport of ("perf: Fix dangling cgroup pointer in cpuctx")
use a middle version, so aligned with the upstream commit:
commit 3b7a34aebbdf ("perf: Fix dangling cgroup pointer in cpuctx")

This is a fix for stable v6.12.94 backport commit, so no upstream commit.

Link: https://lore.kernel.org/all/2026070200-uneaten-smock-4130@gregkh/
Fixes: 46f5623f9b0e ("perf: Fix dangling cgroup pointer in cpuctx")
Signed-off-by: Wentao Guan <guanwentao@uniontech.com>
---
 kernel/events/core.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index 9099c0cc933be..8fa3ee209a5be 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -2440,10 +2440,9 @@ __perf_remove_from_context(struct perf_event *event,
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

