Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E12241C860D;
	Wed,  5 Mar 2025 18:00:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741197613; cv=none; b=rvYjAu6/a4yXTwHLFFXNgE37e2+08YaB0ILzqmC7Zty3HdTvE1tSSZXeYH3pa7O3lTRcftE2lKPyYaoDekD0Vm03e+/Sr5PYWl16Hc3vCfwwvVc5NhPU635FhDpJ1DZb6nmeic/uXDir+BVNB6WuBLqhx37EUIzMlCMNWzhMM8Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741197613; c=relaxed/simple;
	bh=l7r3f8uYsaOZGskMPS43LoeR/tFJbv0SxHGRo64cWtI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hlNfritZF4pDccwSGhxs2R5X9CdNj1CgLOButeRLP1euJNronX3y4rd5xABRA//OeOrh1EMvpBA3GxqBVQ+5Y9rIJeeyHPO7uDQ8SQb8RuwjuFiCampAr6mVVDxsznRZ9CXIuH4+braBxTEiK773wrK5RStVsNz+6iA6xEqeGQw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KywVaXcU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KywVaXcU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AC28C4CED1;
	Wed,  5 Mar 2025 18:00:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741197612;
	bh=l7r3f8uYsaOZGskMPS43LoeR/tFJbv0SxHGRo64cWtI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KywVaXcUT3wdFbLBukDCMG+dCpJ4kb1iWqc8uqI8nNVG9JqLEcVAMFc7goHVLwf5J
	 JwJ/fmzFmygOhqR2COcug4HYGmsudxlpwtM+gkekUGOz+SZsBcqXL110y5DPCc1HDt
	 lS6n2oOHkOrOUYUE4NJOBq54I1IEZozYCScrgneE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stephen Brennan <stephen.s.brennan@oracle.com>,
	Anna Schumaker <anna.schumaker@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 009/142] SUNRPC: convert RPC_TASK_* constants to enum
Date: Wed,  5 Mar 2025 18:47:08 +0100
Message-ID: <20250305174500.710755586@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250305174500.327985489@linuxfoundation.org>
References: <20250305174500.327985489@linuxfoundation.org>
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

From: Stephen Brennan <stephen.s.brennan@oracle.com>

[ Upstream commit 0b108e83795c9c23101f584ef7e3ab4f1f120ef0 ]

The RPC_TASK_* constants are defined as macros, which means that most
kernel builds will not contain their definitions in the debuginfo.
However, it's quite useful for debuggers to be able to view the task
state constant and interpret it correctly. Conversion to an enum will
ensure the constants are present in debuginfo and can be interpreted by
debuggers without needing to hard-code them and track their changes.

Signed-off-by: Stephen Brennan <stephen.s.brennan@oracle.com>
Signed-off-by: Anna Schumaker <anna.schumaker@oracle.com>
Stable-dep-of: 5bbd6e863b15 ("SUNRPC: Prevent looping due to rpc_signal_task() races")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/sunrpc/sched.h | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/include/linux/sunrpc/sched.h b/include/linux/sunrpc/sched.h
index 8f9bee0e21c3b..f80b90aca380a 100644
--- a/include/linux/sunrpc/sched.h
+++ b/include/linux/sunrpc/sched.h
@@ -140,13 +140,15 @@ struct rpc_task_setup {
 #define RPC_WAS_SENT(t)		((t)->tk_flags & RPC_TASK_SENT)
 #define RPC_IS_MOVEABLE(t)	((t)->tk_flags & RPC_TASK_MOVEABLE)
 
-#define RPC_TASK_RUNNING	0
-#define RPC_TASK_QUEUED		1
-#define RPC_TASK_ACTIVE		2
-#define RPC_TASK_NEED_XMIT	3
-#define RPC_TASK_NEED_RECV	4
-#define RPC_TASK_MSG_PIN_WAIT	5
-#define RPC_TASK_SIGNALLED	6
+enum {
+	RPC_TASK_RUNNING,
+	RPC_TASK_QUEUED,
+	RPC_TASK_ACTIVE,
+	RPC_TASK_NEED_XMIT,
+	RPC_TASK_NEED_RECV,
+	RPC_TASK_MSG_PIN_WAIT,
+	RPC_TASK_SIGNALLED,
+};
 
 #define rpc_test_and_set_running(t) \
 				test_and_set_bit(RPC_TASK_RUNNING, &(t)->tk_runstate)
-- 
2.39.5



