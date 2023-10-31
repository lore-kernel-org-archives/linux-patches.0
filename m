Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8256E208C7
	for <patches@lists.linux.dev>; Tue, 31 Oct 2023 17:49:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O4OFprfo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03F2DC433C7;
	Tue, 31 Oct 2023 17:49:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698774583;
	bh=LkRzW+D1DOm3W/QYRskMD6EvFC+C/5qzzEKrciOkedo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O4OFprfoStzqJLOQeIAczBi7JrHZ88y7oYlfW9zm/arivfzH7YkzWBsA3MgGGahj0
	 mliwXh8Kvq6ZK/7OF8fHLTFRd32vT/9uArxit9q1nEbqhNy+Fs1oshZ/N9cFC1LEdt
	 9ibd60uMaQdbkWiDDVeFA1oU1nl74Suyrjt/evdU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Yujie Liu <yujie.liu@intel.com>,
	Mukesh Ojha <quic_mojha@quicinc.com>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Subject: [PATCH 6.5 094/112] tracing/kprobes: Fix the description of variable length arguments
Date: Tue, 31 Oct 2023 18:01:35 +0100
Message-ID: <20231031165904.259028310@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231031165901.318222981@linuxfoundation.org>
References: <20231031165901.318222981@linuxfoundation.org>
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

commit e0f831836cead677fb07d54bd6bf499df35640c2 upstream.

Fix the following kernel-doc warnings:

kernel/trace/trace_kprobe.c:1029: warning: Excess function parameter 'args' description in '__kprobe_event_gen_cmd_start'
kernel/trace/trace_kprobe.c:1097: warning: Excess function parameter 'args' description in '__kprobe_event_add_fields'

Refer to the usage of variable length arguments elsewhere in the kernel
code, "@..." is the proper way to express it in the description.

Link: https://lore.kernel.org/all/20231027041315.2613166-1-yujie.liu@intel.com/

Fixes: 2a588dd1d5d6 ("tracing: Add kprobe event command generation functions")
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202310190437.paI6LYJF-lkp@intel.com/
Signed-off-by: Yujie Liu <yujie.liu@intel.com>
Reviewed-by: Mukesh Ojha <quic_mojha@quicinc.com>
Acked-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace_kprobe.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -1022,7 +1022,7 @@ EXPORT_SYMBOL_GPL(kprobe_event_cmd_init)
  * @name: The name of the kprobe event
  * @loc: The location of the kprobe event
  * @kretprobe: Is this a return probe?
- * @args: Variable number of arg (pairs), one pair for each field
+ * @...: Variable number of arg (pairs), one pair for each field
  *
  * NOTE: Users normally won't want to call this function directly, but
  * rather use the kprobe_event_gen_cmd_start() wrapper, which automatically
@@ -1095,7 +1095,7 @@ EXPORT_SYMBOL_GPL(__kprobe_event_gen_cmd
 /**
  * __kprobe_event_add_fields - Add probe fields to a kprobe command from arg list
  * @cmd: A pointer to the dynevent_cmd struct representing the new event
- * @args: Variable number of arg (pairs), one pair for each field
+ * @...: Variable number of arg (pairs), one pair for each field
  *
  * NOTE: Users normally won't want to call this function directly, but
  * rather use the kprobe_event_add_fields() wrapper, which


