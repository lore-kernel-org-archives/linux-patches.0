Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FDC723A3
	for <patches@lists.linux.dev>; Fri, 28 Oct 2022 12:06:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B30B9C433C1;
	Fri, 28 Oct 2022 12:06:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1666958789;
	bh=EV1gBDJx/SfFybx7k+PKSktofkEVrXBTiVUpaG/OleA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vsT+VHqC0flmjkn67QaKPy5WHFL15VtorllEqZKJkTzl7nXWxHrQp8idwvjGNISoB
	 hNeJcGZLk4PpRtWgtEixDFlz3lKG7Ps3EzlcO6NiqrI/Vlme5CegZsCjgjNt4zjxz3
	 nnpCPWu/1Z+OZZ4G/sthwt/4/0S2zKE3qJOKder0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sunliming <sunliming@kylinos.cn>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 52/73] tracing: Simplify conditional compilation code in tracing_set_tracer()
Date: Fri, 28 Oct 2022 14:03:49 +0200
Message-Id: <20221028120234.643464673@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221028120232.344548477@linuxfoundation.org>
References: <20221028120232.344548477@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: sunliming <sunliming@kylinos.cn>

[ Upstream commit f4b0d318097e45cbac5e14976f8bb56aa2cef504 ]

Two conditional compilation directives "#ifdef CONFIG_TRACER_MAX_TRACE"
are used consecutively, and no other code in between. Simplify conditional
the compilation code and only use one "#ifdef CONFIG_TRACER_MAX_TRACE".

Link: https://lkml.kernel.org/r/20220602140613.545069-1-sunliming@kylinos.cn

Signed-off-by: sunliming <sunliming@kylinos.cn>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Stable-dep-of: a541a9559bb0 ("tracing: Do not free snapshot if tracer is on cmdline")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/trace.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index a5245362ce7a..870033f9c198 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -6025,9 +6025,7 @@ int tracing_set_tracer(struct trace_array *tr, const char *buf)
 		synchronize_rcu();
 		free_snapshot(tr);
 	}
-#endif
 
-#ifdef CONFIG_TRACER_MAX_TRACE
 	if (t->use_max_tr && !had_max_tr) {
 		ret = tracing_alloc_snapshot_instance(tr);
 		if (ret < 0)
-- 
2.35.1



