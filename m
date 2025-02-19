Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC8CE1EB187;
	Wed, 19 Feb 2025 08:55:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739955322; cv=none; b=Tddyu5WhlFGwQYASVd/+mZCZUNXU5VpKvEREVoTD+OdpPggXLn1pcK/38SguV6SyAdCa/PO/xCB8Q4vVx2SKRAV/Ldd+U+JZIkLu+qAiQo5U9K0NuUV+gNZqURwJH6/QEsGR4MaUaSYE+3eCBKvKbfdwmiacr2F6Tgmj9W0noZo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739955322; c=relaxed/simple;
	bh=juURhLDD4CddLt9R0alo/N4SeXoUUbMmU9yFuvfliqk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H3tfjm8DSDN7IL2Grq/Kght57PrLpcwKLXjnYYFoVPKxhAIVF9B3bIOPkA4w392oLViJLEKMHY2sAiwQmQbF8pcRgRJYyXKrhVzFCHIUjqZxW/wKvorfp3fxtBPbLgijNvyCpWX91xNSs0vyIKWJqDtbmkWTFebVaJdhp4c80rE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NMGLkjic; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NMGLkjic"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 515A0C4CED1;
	Wed, 19 Feb 2025 08:55:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739955322;
	bh=juURhLDD4CddLt9R0alo/N4SeXoUUbMmU9yFuvfliqk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NMGLkjicGmEbLRzBW2Ap3J1wJDiV2rwBuR/BjRCR0UoSXzTEhA9SuNZQU0dxi/+PX
	 FFgBx3Ss4YihmerJuhHHZx+wigIn7eZi6OFjonGL2IsT8N00ed0HEw7RcY/YzepeoC
	 3rTDalBsYjpHvDOq5Ce8aNEj6rOaG+U3uRUHDv0s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Waiman Long <longman@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	John Stultz <jstultz@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 168/230] clocksource: Use pr_info() for "Checking clocksource synchronization" message
Date: Wed, 19 Feb 2025 09:28:05 +0100
Message-ID: <20250219082608.272214171@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082601.683263930@linuxfoundation.org>
References: <20250219082601.683263930@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 8a40a616288b8..c4e6b5e6af88c 100644
--- a/kernel/time/clocksource.c
+++ b/kernel/time/clocksource.c
@@ -374,7 +374,8 @@ void clocksource_verify_percpu(struct clocksource *cs)
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



