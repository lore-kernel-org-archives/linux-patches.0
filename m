Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0BDC339B0
	for <patches@lists.linux.dev>; Mon,  9 Oct 2023 13:43:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WbXO47eJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4ECEEC433C8;
	Mon,  9 Oct 2023 13:43:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696859007;
	bh=3Tz7R9HAYFZEQXhWdgQ2kqrAfyrB3a1QM4t1HUJHQB8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WbXO47eJcQXuZpmczl/C/5Vv1AAGez1jN1QYCJXzJlmzB3Cb3x0VA5+ifRFArIyJ7
	 5cRCB4K7F5tds0T7vu/35LhlILrreO2A360b12QP9mRKF7lzZGzhMsizO3pPYnsGFi
	 3ewRA6bZbm/1tg5DQh1gD2/kEkQVbXwQdhk7DsgU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Ingo Molnar <mingo@elte.hu>,
	Mike Rapoport <mike.rapoport@gmail.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Vlastimil Babka <vbabka@suse.cz>,
	Mukesh Ojha <quic_mojha@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 169/226] ring-buffer: remove obsolete comment for free_buffer_page()
Date: Mon,  9 Oct 2023 15:02:10 +0200
Message-ID: <20231009130131.077767390@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231009130126.697995596@linuxfoundation.org>
References: <20231009130126.697995596@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vlastimil Babka <vbabka@suse.cz>

[ Upstream commit a98151ad53b53f010ee364ec2fd06445b328578b ]

The comment refers to mm/slob.c which is being removed. It comes from
commit ed56829cb319 ("ring_buffer: reset buffer page when freeing") and
according to Steven the borrowed code was a page mapcount and mapping
reset, which was later removed by commit e4c2ce82ca27 ("ring_buffer:
allocate buffer page pointer"). Thus the comment is not accurate anyway,
remove it.

Link: https://lore.kernel.org/linux-trace-kernel/20230315142446.27040-1-vbabka@suse.cz

Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>
Reported-by: Mike Rapoport <mike.rapoport@gmail.com>
Suggested-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Fixes: e4c2ce82ca27 ("ring_buffer: allocate buffer page pointer")
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Mukesh Ojha <quic_mojha@quicinc.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Stable-dep-of: 45d99ea451d0 ("ring-buffer: Fix bytes info in per_cpu buffer stats")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/ring_buffer.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index 7d9af09bb0065..682540bd56355 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -355,10 +355,6 @@ static void rb_init_page(struct buffer_data_page *bpage)
 	local_set(&bpage->commit, 0);
 }
 
-/*
- * Also stolen from mm/slob.c. Thanks to Mathieu Desnoyers for pointing
- * this issue out.
- */
 static void free_buffer_page(struct buffer_page *bpage)
 {
 	free_page((unsigned long)bpage->page);
-- 
2.40.1



