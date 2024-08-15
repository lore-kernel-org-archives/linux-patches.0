Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 794601714D0;
	Thu, 15 Aug 2024 13:35:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723728956; cv=none; b=FURHJXzMYnUOU0/yRSYamVKQej+tuZJBoPe1pJfQEJpEE49zeWk4DDS+pNl8bGwBBWp0D59hGITt+cJ3WYn4cRmzcDJEvxhqGXL/qNqoBSxv1cshG9lYIrEKolx8pp3D6IXUF4rzsRYo0RzEWUOsKFBnacKoGzx0P5elZqac7Dg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723728956; c=relaxed/simple;
	bh=E62Dqouhcw3r+f7eUAjgyMKetW1BDHkzj86iooPNKlM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=atMYw1XIG1PbgUKogCSV+T0xQjGhsSytx6GC1hXsUtoFD6A1bl3x+fC30LMgm4EstH0t6XpEiFUms4bfikn1TBP5iljtBZVYIhFBUvTrbHYfWYq8pIfu8j4YPDOUteMn/+TZn6WfwSvogx3B6PpyIzFlB/WBCAtzoJEcZ9Cgry4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bl1Qj852; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bl1Qj852"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9348FC32786;
	Thu, 15 Aug 2024 13:35:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723728956;
	bh=E62Dqouhcw3r+f7eUAjgyMKetW1BDHkzj86iooPNKlM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bl1Qj852YomuxOUDQiAoNWZLTNDfdFd9s+A1+AVqN4oL/qjxLXMn2tRPbSTOpIrV1
	 ytQUBaXw6IYIVdzhM5d62B7ai1N3LmHBfYF6n4SAkbegf7KUTynIISv8naFFOmCNMq
	 xJAO7UUxY4ESdBu2zhNd/wPaqEw+4gUn7d19y66I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Menglong Dong <dongml2@chinatelecom.cn>,
	Jiri Olsa <jolsa@kernel.org>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 164/196] bpf: kprobe: remove unused declaring of bpf_kprobe_override
Date: Thu, 15 Aug 2024 15:24:41 +0200
Message-ID: <20240815131858.348707293@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131852.063866671@linuxfoundation.org>
References: <20240815131852.063866671@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Menglong Dong <menglong8.dong@gmail.com>

[ Upstream commit 0e8b53979ac86eddb3fd76264025a70071a25574 ]

After the commit 66665ad2f102 ("tracing/kprobe: bpf: Compare instruction
pointer with original one"), "bpf_kprobe_override" is not used anywhere
anymore, and we can remove it now.

Link: https://lore.kernel.org/all/20240710085939.11520-1-dongml2@chinatelecom.cn/

Fixes: 66665ad2f102 ("tracing/kprobe: bpf: Compare instruction pointer with original one")
Signed-off-by: Menglong Dong <dongml2@chinatelecom.cn>
Acked-by: Jiri Olsa <jolsa@kernel.org>
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/trace_events.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/include/linux/trace_events.h b/include/linux/trace_events.h
index f4077379420fa..f0f7b348fe5e0 100644
--- a/include/linux/trace_events.h
+++ b/include/linux/trace_events.h
@@ -560,7 +560,6 @@ do {									\
 struct perf_event;
 
 DECLARE_PER_CPU(struct pt_regs, perf_trace_regs);
-DECLARE_PER_CPU(int, bpf_kprobe_override);
 
 extern int  perf_trace_init(struct perf_event *event);
 extern void perf_trace_destroy(struct perf_event *event);
-- 
2.43.0



