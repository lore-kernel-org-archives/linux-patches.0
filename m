Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85C2935836E;
	Tue, 21 Jul 2026 16:01:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784649706; cv=none; b=EhlfZc75OtT4hskESx2B7TF3BGO2A3ru/zuT2mcLCbroOlaTTsyO3GH35CWa4OWEhDaB9T2DCRdJOrJ6hmbJSsei4/dnetU0MK09N37t/ukuHxRHMhpTXQvQyrDHsvg47NKHfuXerFnrXmidFiW1mbp9BME2tgVzMWKB84Zsk+Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784649706; c=relaxed/simple;
	bh=wJH8xcKt+fjoueS6kt65s8el3FWgh0qYepTi9JYsy88=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=usqOw0nfn4ttssOirY3nRXq/lKevJx3F1v3oGHhtsv4Fbwru328KFzuF0z0/zNd0twCuQJOZyGwAIb6fsehZoRGDV6t33Fg+NLzYgp/ogQ0qktEWeDmD6//j2WLmYHo8AMaSFjPShlESfztPbe7vVaqEQUwQQYo27gnV306//08=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FR+dqFbM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FR+dqFbM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAE9B1F00A3D;
	Tue, 21 Jul 2026 16:01:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784649705;
	bh=H8dgKwUJTrMAAxVhogGhOQWpof4mtJ0wdEfWuiP1AcE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FR+dqFbMlQT3LjwK9+YtFAqSiJPSraX40fuAWrCRUuH34Vm69dkytWEcv3as/wTZ9
	 Wr4NGbw79liA0cap/3RRa7qp78BqjbgllL8SciV7eBtyRawML8IvBZSZnN2S0JZD78
	 97DVWY8j0qBukYm5mhjhyoAmj6cBOLRjDu5d9w5o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0676/2077] s390/process: Fix kernel thread function pointer type
Date: Tue, 21 Jul 2026 17:05:49 +0200
Message-ID: <20260721152608.741364011@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Heiko Carstens <hca@linux.ibm.com>

[ Upstream commit d0478f5d3cba1095bfdeb43a9b063c10cdebef14 ]

In case of a kernel thread __ret_from_fork() calls the specified function
indirectly. Fix the kernel thread function pointer, since kernel threads
return an int instead of void.

Fixes: 56e62a737028 ("s390: convert to generic entry")
Reviewed-by: Alexander Gordeev <agordeev@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/kernel/process.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/s390/kernel/process.c b/arch/s390/kernel/process.c
index 0df95dcb210120..e4bd273e31f4e5 100644
--- a/arch/s390/kernel/process.c
+++ b/arch/s390/kernel/process.c
@@ -50,7 +50,7 @@ void ret_from_fork(void) asm("ret_from_fork");
 
 void __ret_from_fork(struct task_struct *prev, struct pt_regs *regs)
 {
-	void (*func)(void *arg);
+	int (*func)(void *arg);
 
 	schedule_tail(prev);
 
-- 
2.53.0



