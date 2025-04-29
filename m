Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5349125485A;
	Tue, 29 Apr 2025 18:10:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745950244; cv=none; b=XKKR1U5uroZz4Sp3XX+vp26LpsXPbjyom+FVur2kU+0aV2jYHLN3SHuT49cphniwrr5pdhVZPe2Zh72qGezmk1nsNrjthE+/kngIXqZnL5Ou0gubgE/ttThrUG30UN5hVxstJnedq5FGUGMF1q0AnfDlfc2XRaxIXiGCvwjgtds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745950244; c=relaxed/simple;
	bh=upv3//YFF/aP2o7DMEopK9YTeSQ982HhFfVryj6cHIg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sG3uf/KlDx9ZhzCv9iQaW8sq/nIpttv4UH0ud18zpl1Ymz3MbsyDPG3U2NniX0WeustqKD1535UPtsRO2VUs350K3G9ynQ7wh/Ferbm0kGzxFg/5Dr5GgmzMKs3Ql5+324EIsPvVVpveRwvU9g+acoO5QrpzT85/G2fYyOKd1is=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0+HQvo29; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0+HQvo29"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86D5CC4CEE9;
	Tue, 29 Apr 2025 18:10:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745950243;
	bh=upv3//YFF/aP2o7DMEopK9YTeSQ982HhFfVryj6cHIg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0+HQvo29irVEwas+Y8S3ttdXs6q8qk0gnxaz7oyBYzecQJ35yhZ+pPTeMf8yECpU4
	 2Qez7APeLg/bloMt98CzN/6ecqvLuvVs+wUnp03kExqJecCKmTpSsFaufiFZcufCZP
	 d/v8HRuz40YAMwwtjBTZ37iBI7f0fSggl606GMZQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 005/204] tracing: Add __string_len() example
Date: Tue, 29 Apr 2025 18:41:33 +0200
Message-ID: <20250429161059.623274557@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161059.396852607@linuxfoundation.org>
References: <20250429161059.396852607@linuxfoundation.org>
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

From: Steven Rostedt (Google) <rostedt@goodmis.org>

[ Upstream commit dd6ae6d90a84d4bec49887c7aa2b22aa1c8b2897 ]

There's no example code that uses __string_len(), and since the sample
code is used for testing the event logic, add a use case.

Link: https://lore.kernel.org/linux-trace-kernel/20240223152827.5f9f78e2@gandalf.local.home

Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Stable-dep-of: ea8d7647f9dd ("tracing: Verify event formats that have "%*p.."")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 samples/trace_events/trace-events-sample.h | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/samples/trace_events/trace-events-sample.h b/samples/trace_events/trace-events-sample.h
index 1c6b843b8c4ee..04541dfbd44cc 100644
--- a/samples/trace_events/trace-events-sample.h
+++ b/samples/trace_events/trace-events-sample.h
@@ -302,6 +302,7 @@ TRACE_EVENT(foo_bar,
 		__bitmask(	cpus,	num_possible_cpus()	)
 		__cpumask(	cpum				)
 		__vstring(	vstr,	fmt,	va		)
+		__string_len(	lstr,	foo,	bar / 2 < strlen(foo) ? bar / 2 : strlen(foo) )
 	),
 
 	TP_fast_assign(
@@ -310,12 +311,13 @@ TRACE_EVENT(foo_bar,
 		memcpy(__get_dynamic_array(list), lst,
 		       __length_of(lst) * sizeof(int));
 		__assign_str(str, string);
+		__assign_str(lstr, foo);
 		__assign_vstr(vstr, fmt, va);
 		__assign_bitmask(cpus, cpumask_bits(mask), num_possible_cpus());
 		__assign_cpumask(cpum, cpumask_bits(mask));
 	),
 
-	TP_printk("foo %s %d %s %s %s %s (%s) (%s) %s", __entry->foo, __entry->bar,
+	TP_printk("foo %s %d %s %s %s %s %s (%s) (%s) %s", __entry->foo, __entry->bar,
 
 /*
  * Notice here the use of some helper functions. This includes:
@@ -359,7 +361,8 @@ TRACE_EVENT(foo_bar,
 		  __print_array(__get_dynamic_array(list),
 				__get_dynamic_array_len(list) / sizeof(int),
 				sizeof(int)),
-		  __get_str(str), __get_bitmask(cpus), __get_cpumask(cpum),
+		  __get_str(str), __get_str(lstr),
+		  __get_bitmask(cpus), __get_cpumask(cpum),
 		  __get_str(vstr))
 );
 
-- 
2.39.5



