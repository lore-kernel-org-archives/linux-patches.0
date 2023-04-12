Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACA522F24
	for <patches@lists.linux.dev>; Wed, 12 Apr 2023 08:44:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11F71C433D2;
	Wed, 12 Apr 2023 08:44:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1681289077;
	bh=KWC4I4EMt7wAag3IpbqLcsuMvMad7yvicpsrw1qUVt0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eXHQktw+yNID4wXo3lzQ03GISUnCImCCApm6Boee1eNH5rx0KNO27rXuDuuzn8UZ3
	 nDMQgwRoLfd7dFMb11MjsmrPBX5cFXEHSffox5v0EEe/pcjgUJiRwNHqUPlQKSnSjc
	 BsZF7x0h9Qj9/IzP1fbZM8SFV1BSltNAG+XCWrx0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Tze-nan Wu <Tze-nan.Wu@mediatek.com>,
	Mukesh Ojha <quic_mojha@quicinc.com>,
	kernel test robot <lkp@intel.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 6.1 128/164] tracing/synthetic: Make lastcmd_mutex static
Date: Wed, 12 Apr 2023 10:34:10 +0200
Message-Id: <20230412082842.056506969@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230412082836.695875037@linuxfoundation.org>
References: <20230412082836.695875037@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Steven Rostedt (Google) <rostedt@goodmis.org>

commit 31c683967174b487939efaf65e41f5ff1404e141 upstream.

The lastcmd_mutex is only used in trace_events_synth.c and should be
static.

Link: https://lore.kernel.org/linux-trace-kernel/202304062033.cRStgOuP-lkp@intel.com/
Link: https://lore.kernel.org/linux-trace-kernel/20230406111033.6e26de93@gandalf.local.home

Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Tze-nan Wu <Tze-nan.Wu@mediatek.com>
Fixes: 4ccf11c4e8a8e ("tracing/synthetic: Fix races on freeing last_cmd")
Reviewed-by: Mukesh Ojha <quic_mojha@quicinc.com>
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace_events_synth.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/trace/trace_events_synth.c
+++ b/kernel/trace/trace_events_synth.c
@@ -44,7 +44,7 @@ enum { ERRORS };
 
 static const char *err_text[] = { ERRORS };
 
-DEFINE_MUTEX(lastcmd_mutex);
+static DEFINE_MUTEX(lastcmd_mutex);
 static char *last_cmd;
 
 static int errpos(const char *str)


