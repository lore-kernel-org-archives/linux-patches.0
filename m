Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A29B91804E
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:40:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MLaq4OUN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4ACEBC433CA;
	Wed, 15 Nov 2023 19:40:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700077209;
	bh=49da5BXOfKK6+TRQtEZoVevxdOJM87R6MzNoN8S7s9A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MLaq4OUNeYdBw6N8ARqddzVkTuUY1IsdVU8aK79bKcXPxt1eNO7as5Bt6CqfrE1I+
	 yKLU0v3pKS1r3yEybGDDSVp8Z/IWmEC4tHwUCP34t0bt8A2G4hekMyRPVd8XVfhWvl
	 hBb4I+OSrXMuteZx6/bozG/IOnEA3xg/L2Iugdo0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mukesh Ojha <quic_mojha@quicinc.com>,
	Yujie Liu <yujie.liu@intel.com>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 542/550] tracing/kprobes: Fix the order of argument descriptions
Date: Wed, 15 Nov 2023 14:18:46 -0500
Message-ID: <20231115191638.500845887@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191600.708733204@linuxfoundation.org>
References: <20231115191600.708733204@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yujie Liu <yujie.liu@intel.com>

[ Upstream commit f032c53bea6d2057c14553832d846be2f151cfb2 ]

The order of descriptions should be consistent with the argument list of
the function, so "kretprobe" should be the second one.

int __kprobe_event_gen_cmd_start(struct dynevent_cmd *cmd, bool kretprobe,
                                 const char *name, const char *loc, ...)

Link: https://lore.kernel.org/all/20231031041305.3363712-1-yujie.liu@intel.com/

Fixes: 2a588dd1d5d6 ("tracing: Add kprobe event command generation functions")
Suggested-by: Mukesh Ojha <quic_mojha@quicinc.com>
Signed-off-by: Yujie Liu <yujie.liu@intel.com>
Reviewed-by: Mukesh Ojha <quic_mojha@quicinc.com>
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/trace_kprobe.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index c63e25cb9406e..d23b18cbdadd1 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -1019,9 +1019,9 @@ EXPORT_SYMBOL_GPL(kprobe_event_cmd_init);
 /**
  * __kprobe_event_gen_cmd_start - Generate a kprobe event command from arg list
  * @cmd: A pointer to the dynevent_cmd struct representing the new event
+ * @kretprobe: Is this a return probe?
  * @name: The name of the kprobe event
  * @loc: The location of the kprobe event
- * @kretprobe: Is this a return probe?
  * @...: Variable number of arg (pairs), one pair for each field
  *
  * NOTE: Users normally won't want to call this function directly, but
-- 
2.42.0



