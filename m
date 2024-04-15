Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7F0976025;
	Mon, 15 Apr 2024 14:40:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713192020; cv=none; b=WEbVGW6U0IJYvFqSeIHG1OxStCJRWBYybHra/Ad+lnNqaITQ9YRQ5XMCnkVRQIVxLGugvog82QUuhvirPn5v4OgJwC3EjIa0uhcgNZw0Im92sRP+DtnPzfNA3qkg4pTLV0sVbWj6VDfn7Z8N2VHBC9YANvZ8iXR8rfkEy4irdkM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713192020; c=relaxed/simple;
	bh=aJ69eu6PzsGbqcLdmjMxVL7SdVR4hbkmbjF8OEe2uzQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sJn/C7ovSslaDzhjabSpLvYUd/IZ4StYKokDhmlbDMUkzYS4OaWeK6WwbVnUsvG7+++ILbL3E5NDmDTsRWhU8mBH9mt+9Q+gl7PAHdBPpTALD8wQcHrgEYin4rOVNKKqi5ditepKia1YK7RxJkym6cUi5mmxLyl1n5ADdxoheGI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NVKrNvTZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NVKrNvTZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35F76C113CC;
	Mon, 15 Apr 2024 14:40:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713192020;
	bh=aJ69eu6PzsGbqcLdmjMxVL7SdVR4hbkmbjF8OEe2uzQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NVKrNvTZhl8KXMWih+RU2FWHp/tw3LKyiun88j9hsbOsivcQO2sORafjdTyRoWnpn
	 9gK010+KyRdAYq1Au2fPmqbJsRWi4hkxDpNwRd1WEwY2pBvgJZS3cH+mv1ogOFymJ0
	 B3z3RDQzjXov8DRs83kebGrMd7jMmit7bpig/OZU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Oleg Nesterov <oleg@redhat.com>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Zheng Yejian <zhengyejian1@huawei.com>,
	Kees Cook <keescook@chromium.org>,
	Ajay Kaher <akaher@vmware.com>,
	Jinjie Ruan <ruanjinjie@huawei.com>,
	=?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>,
	Arnd Bergmann <arnd@arndb.de>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 39/69] tracing: hide unused ftrace_event_id_fops
Date: Mon, 15 Apr 2024 16:21:10 +0200
Message-ID: <20240415141947.340776504@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240415141946.165870434@linuxfoundation.org>
References: <20240415141946.165870434@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 5281ec83454d70d98b71f1836fb16512566c01cd ]

When CONFIG_PERF_EVENTS, a 'make W=1' build produces a warning about the
unused ftrace_event_id_fops variable:

kernel/trace/trace_events.c:2155:37: error: 'ftrace_event_id_fops' defined but not used [-Werror=unused-const-variable=]
 2155 | static const struct file_operations ftrace_event_id_fops = {

Hide this in the same #ifdef as the reference to it.

Link: https://lore.kernel.org/linux-trace-kernel/20240403080702.3509288-7-arnd@kernel.org

Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Zheng Yejian <zhengyejian1@huawei.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Ajay Kaher <akaher@vmware.com>
Cc: Jinjie Ruan <ruanjinjie@huawei.com>
Cc: Clément Léger <cleger@rivosinc.com>
Cc: Dan Carpenter <dan.carpenter@linaro.org>
Cc: "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Fixes: 620a30e97feb ("tracing: Don't pass file_operations array to event_create_dir()")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/trace_events.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index a6d2f99f847d3..24859d9645050 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -1669,6 +1669,7 @@ static int trace_format_open(struct inode *inode, struct file *file)
 	return 0;
 }
 
+#ifdef CONFIG_PERF_EVENTS
 static ssize_t
 event_id_read(struct file *filp, char __user *ubuf, size_t cnt, loff_t *ppos)
 {
@@ -1683,6 +1684,7 @@ event_id_read(struct file *filp, char __user *ubuf, size_t cnt, loff_t *ppos)
 
 	return simple_read_from_buffer(ubuf, cnt, ppos, buf, len);
 }
+#endif
 
 static ssize_t
 event_filter_read(struct file *filp, char __user *ubuf, size_t cnt,
@@ -2127,10 +2129,12 @@ static const struct file_operations ftrace_event_format_fops = {
 	.release = seq_release,
 };
 
+#ifdef CONFIG_PERF_EVENTS
 static const struct file_operations ftrace_event_id_fops = {
 	.read = event_id_read,
 	.llseek = default_llseek,
 };
+#endif
 
 static const struct file_operations ftrace_event_filter_fops = {
 	.open = tracing_open_file_tr,
-- 
2.43.0



