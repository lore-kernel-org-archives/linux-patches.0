Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8256022301;
	Thu, 16 Jul 2026 14:20:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784211636; cv=none; b=hjImMPrQ2BvB+uaPvqO9zMbPky85/Zo7MHZHjsgVpyNO6JfY4HHL5e7Oez/1tq2ig73UiSp/KbSL2ocKp4kQA/vgjKsDrrVS5uu7d7opUp07VSDPE0/48KPhOWqcwbFANz0HouAkcfaBthbrbpxnjjvevr/5yGxN9SbvmMxnGjo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784211636; c=relaxed/simple;
	bh=TS+boo78aDUIRrgXSqJiTQFemxK9C5UdS98aJ9BJxs4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b2FXK8dvKnSEdmBbFI5uP744XhUGwotcBPQ1wri5hqs8LHAnBkuHCAIuNiZq778ykijVBjFRARSs9yS2HzypzPs0lJ6iAECA+Blju9A1p9H9+w4NnrinijFhOygZwBuUYZ6j6xTJ58K+piwmd1N4DToNUm2bvRAyQ7rmJ3eYfdY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bi1WqiVy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bi1WqiVy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E83DE1F00A3D;
	Thu, 16 Jul 2026 14:20:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784211635;
	bh=bZFNPEDCOyELDkd7AocGjm/QT/Zrnv0VVsnbnUi/JiU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bi1WqiVy2NdpvLQWGBHdshQ382qA6SwjL3dPMCPECuFklkrbvWekm7aAfvErl07My
	 jGFbm5aSbd7Lv6luLzoY5n/H1b8n2gAsIrSAGv0EoS5RFS92GPbbAHmLjYTtsQKxC6
	 mzueUiAuPNJMeTnHIfZaDbT4RKkyUAD3M/ASMjm0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Guan <guanwentao@uniontech.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 005/349] perf: Fix dangling cgroup pointer in cpuctx backport
Date: Thu, 16 Jul 2026 15:28:59 +0200
Message-ID: <20260716133033.408383950@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133033.287196923@linuxfoundation.org>
References: <20260716133033.287196923@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wentao Guan <guanwentao@uniontech.com>

recently backport of ("perf: Fix dangling cgroup pointer in cpuctx")
use a middle version, so aligned with the upstream commit:
commit 3b7a34aebbdf ("perf: Fix dangling cgroup pointer in cpuctx")

This is a fix for stable v6.12.94 backport commit, so no upstream commit.

Link: https://lore.kernel.org/all/2026070200-uneaten-smock-4130@gregkh/
Fixes: 46f5623f9b0e ("perf: Fix dangling cgroup pointer in cpuctx")
Signed-off-by: Wentao Guan <guanwentao@uniontech.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/events/core.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index 9099c0cc933be2..8fa3ee209a5be6 100644
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
2.53.0



