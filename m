Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36F2711710
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 15:24:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACA09C433C7;
	Mon, 11 Sep 2023 15:24:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694445861;
	bh=q7dOzc5UbKynKncd6HG6D3R2VMO/+KPsHU1yuUqanrU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AuJYMrwzZCd69gyZiuKptw9NtXS17eDkAQkrsFy7EK8XpMC0UTlE9gjihthKevAUp
	 o1S/kTxXUZa1u49N8vsrMSnltkhYGGZZ5n4J2B/FJ80XQrJT77RF50MvMvxF8bdlIY
	 Z3nMozkKgNM3w7JwZkliLV8Hu0XO4L4gL6xhb2f8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mikhail Kobuk <m.kobuk@ispras.ru>,
	Alexey Khoroshilov <khoroshilov@ispras.ru>,
	Daniel Bristot de Oliveira <bristot@kernel.org>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 498/600] tracing: Remove extra space at the end of hwlat_detector/mode
Date: Mon, 11 Sep 2023 15:48:51 +0200
Message-ID: <20230911134648.329047279@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134633.619970489@linuxfoundation.org>
References: <20230911134633.619970489@linuxfoundation.org>
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

From: Mikhail Kobuk <m.kobuk@ispras.ru>

[ Upstream commit 2cf0dee989a8b2501929eaab29473b6b1fa11057 ]

Space is printed after each mode value including the last one:
$ echo \"$(sudo cat /sys/kernel/tracing/hwlat_detector/mode)\"
"none [round-robin] per-cpu "

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Link: https://lore.kernel.org/linux-trace-kernel/20230825103432.7750-1-m.kobuk@ispras.ru

Cc: Masami Hiramatsu <mhiramat@kernel.org>
Fixes: 8fa826b7344d ("trace/hwlat: Implement the mode config option")
Signed-off-by: Mikhail Kobuk <m.kobuk@ispras.ru>
Reviewed-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
Acked-by: Daniel Bristot de Oliveira <bristot@kernel.org>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/trace_hwlat.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/trace/trace_hwlat.c b/kernel/trace/trace_hwlat.c
index 2f37a6e68aa9f..b791524a6536a 100644
--- a/kernel/trace/trace_hwlat.c
+++ b/kernel/trace/trace_hwlat.c
@@ -635,7 +635,7 @@ static int s_mode_show(struct seq_file *s, void *v)
 	else
 		seq_printf(s, "%s", thread_mode_str[mode]);
 
-	if (mode != MODE_MAX)
+	if (mode < MODE_MAX - 1) /* if mode is any but last */
 		seq_puts(s, " ");
 
 	return 0;
-- 
2.40.1



