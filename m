Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E3D91DF252;
	Wed, 19 Feb 2025 09:02:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739955759; cv=none; b=FvM1kkbQnKu+dMDgmNRahqFpx/jcBrGwocxL/zj4oZmwcYcd3T9PZIXuQuAcsaXQcnQrKrQi6jn92WrGZm7jrJcn2vWok5pGcdybdmmJ1lUd9jokahuLIL2ipeu3z/IUP/RfhiilbZ1Hqs4N1tz+kULfDy30pSnNXuyZ9nTLK7k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739955759; c=relaxed/simple;
	bh=aQkOZ7yUqqsM4T/JQnm1knOlObvHr23zdO7NcSuCNFM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UVZKHxFgAea6RCmAx7Uwgk6KkI0obdiVK+LC7/2Ze1nu6aFMFIRoPGvoxuqCvdrVxQ+pbFtbqDHyJoH5b5EgJfllVBvAtgz8zxkjzdy5AGcY6JsWcvSQgn5GKUajXMeGhq+nd1eL+EcIesKDORBRKx6Ulvmf0EBgW7dWvaX3W4M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U3dc8s8v; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U3dc8s8v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BF2EC4CED1;
	Wed, 19 Feb 2025 09:02:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739955758;
	bh=aQkOZ7yUqqsM4T/JQnm1knOlObvHr23zdO7NcSuCNFM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U3dc8s8vw0M7GtUmYwBaoqk4RdE70yYmCCMe9tJfFwWZ1FwyWCmaakPRNYVwFLgPG
	 Vi4ipw1lIMlvLPjwIYVBw06cIGwlnkma539bVkCKLLvJS9JQRS4WSn52+gbSsLDOsR
	 9dNx0g2zcZGL9T7uFtiBcklwScLBrIwtDwQJ1Fp0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Waiman Long <longman@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	John Stultz <jstultz@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 097/152] clocksource: Use pr_info() for "Checking clocksource synchronization" message
Date: Wed, 19 Feb 2025 09:28:30 +0100
Message-ID: <20250219082553.891887487@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082550.014812078@linuxfoundation.org>
References: <20250219082550.014812078@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Waiman Long <longman@redhat.com>

[ Upstream commit 1f566840a82982141f94086061927a90e79440e5 ]

The "Checking clocksource synchronization" message is normally printed
when clocksource_verify_percpu() is called for a given clocksource if
both the CLOCK_SOURCE_UNSTABLE and CLOCK_SOURCE_VERIFY_PERCPU flags
are set.

It is an informational message and so pr_info() is the correct choice.

Signed-off-by: Waiman Long <longman@redhat.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Paul E. McKenney <paulmck@kernel.org>
Acked-by: John Stultz <jstultz@google.com>
Link: https://lore.kernel.org/all/20250125015442.3740588-1-longman@redhat.com
Stable-dep-of: 6bb05a33337b ("clocksource: Use migrate_disable() to avoid calling get_random_u32() in atomic context")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/time/clocksource.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/time/clocksource.c b/kernel/time/clocksource.c
index aa864999dc21b..6b5b7c9c14732 100644
--- a/kernel/time/clocksource.c
+++ b/kernel/time/clocksource.c
@@ -360,7 +360,8 @@ void clocksource_verify_percpu(struct clocksource *cs)
 		return;
 	}
 	testcpu = smp_processor_id();
-	pr_warn("Checking clocksource %s synchronization from CPU %d to CPUs %*pbl.\n", cs->name, testcpu, cpumask_pr_args(&cpus_chosen));
+	pr_info("Checking clocksource %s synchronization from CPU %d to CPUs %*pbl.\n",
+		cs->name, testcpu, cpumask_pr_args(&cpus_chosen));
 	for_each_cpu(cpu, &cpus_chosen) {
 		if (cpu == testcpu)
 			continue;
-- 
2.39.5



