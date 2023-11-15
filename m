Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E6853EA7B
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 20:02:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a0HJ/xln"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39E2BC433C7;
	Wed, 15 Nov 2023 20:02:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700078525;
	bh=z0yIBKW1hzEYYjJsl0IwI9UiLlTCa2UcYQeH1/BxW/4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a0HJ/xlnmStBx5dR7MPR8IEVoZ6DPy4R/RkXSmp2irGn+3BkelEqJUFVcW/N7Ubrt
	 1plC1ggn/lV2zQ+yl9gmN6ll8w0/JJKFqyFIZLWBo3IpKucQ13Q+8H+B4TPd7BOGwC
	 fZr5/oj7WycDCCkNtNPAVpslokz3bYA8bJuTBLUU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mukesh Ojha <quic_mojha@quicinc.com>,
	Yujie Liu <yujie.liu@intel.com>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 375/379] tracing/kprobes: Fix the order of argument descriptions
Date: Wed, 15 Nov 2023 14:27:30 -0500
Message-ID: <20231115192707.341333383@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115192645.143643130@linuxfoundation.org>
References: <20231115192645.143643130@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 56675294d7a3b..a34a4fcdab7b1 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -986,9 +986,9 @@ EXPORT_SYMBOL_GPL(kprobe_event_cmd_init);
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



