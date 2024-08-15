Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51FB01A08DB;
	Thu, 15 Aug 2024 14:22:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723731744; cv=none; b=Xu6hso8svRVHwIyEj8WDLtBDgeLnojT2ZDCaQw4533Iw2TKfVfRKMWTeKHds5nvNH8gl6Dzvw1fKumsvrXm2soke+A1t5bSYatUtlOFiNsTwdIN/bcumVF1W9ApQBdhoSSLvCZB51Wce9C4QGtoiwAl9hN0csCcQxbhjt132zrw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723731744; c=relaxed/simple;
	bh=JMlw46eIIs+2Pnombax2VRQXtA8RkCQl/b4QS1LJgS8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X4yo1yCbZ0d/T94Ep4capYYCqJCN0DoU8DFXqppB718s8+BMcUAAAlw9OcOT1MxeFQRLVWi8985ovY7sqrMzrynZxFrbVZpUBhNZLOK+NTUwKHgl0ORsdYP550RXzJ4uJY5w9lRVFxZAyxQK7JIkELhPS4sd36IglGgP4dRaG1I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HUpEI4qs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HUpEI4qs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B790EC32786;
	Thu, 15 Aug 2024 14:22:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723731744;
	bh=JMlw46eIIs+2Pnombax2VRQXtA8RkCQl/b4QS1LJgS8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HUpEI4qsdL6O0seedaO8C6ofSUkUhyrCJ0btlKuKu09naH57Gyk4KFr8OdE2S9Nv/
	 zfJjIIuKHHCizcEBU6ZMiel1rmAH0wyv94rllVGaTeW8q1pCJLkalCAVQMC3qegi3E
	 2Sv7Zh2lgHobmpM3gbbWEwrHA8lJYlNYaYUjhpsc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Menglong Dong <dongml2@chinatelecom.cn>,
	Jiri Olsa <jolsa@kernel.org>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 224/259] bpf: kprobe: remove unused declaring of bpf_kprobe_override
Date: Thu, 15 Aug 2024 15:25:57 +0200
Message-ID: <20240815131911.424589821@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131902.779125794@linuxfoundation.org>
References: <20240815131902.779125794@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 12ee8973ea6f9..d88622a9db7bc 100644
--- a/include/linux/trace_events.h
+++ b/include/linux/trace_events.h
@@ -578,7 +578,6 @@ do {									\
 struct perf_event;
 
 DECLARE_PER_CPU(struct pt_regs, perf_trace_regs);
-DECLARE_PER_CPU(int, bpf_kprobe_override);
 
 extern int  perf_trace_init(struct perf_event *event);
 extern void perf_trace_destroy(struct perf_event *event);
-- 
2.43.0



