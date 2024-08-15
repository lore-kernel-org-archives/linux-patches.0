Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 300061A3BCA;
	Thu, 15 Aug 2024 14:40:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723732822; cv=none; b=kjqtYQs0GPXE9P9FIx2UQT53XfLRH/J0QzvXcAb5XD6R/B62hhTdiZHcTkPNF+xFYn9NlcIzfLiYo+qmnyKiGPyknL+yUFatgostZJIiMgPSg7iUwZK+csmgJ5UlZCOWihkkjIb06XuvHVOIb8oWU823YpZoTOFjeohj49dJtqk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723732822; c=relaxed/simple;
	bh=tXoKkvHFEHZT+q3EVUTkeixHHKBUTNfT0Y96cXOTphE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dzgsUfE6zSZXh6vlll6Os9cXmQrRLnxJPSsArkJUukQQqd8e2uCxgz6/6awk6I3jNXNb8Pr8wqViE/4Ff89UCRHMSEA/HS8cAqJ1H3mSSiwXyAIQCI0mYWJts1HWbe9ipQGZgbTfQmgVhY8jdr1tL54mj6hunSjwHpaBzSKpkRw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PIirrtN3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PIirrtN3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14A56C32786;
	Thu, 15 Aug 2024 14:40:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723732822;
	bh=tXoKkvHFEHZT+q3EVUTkeixHHKBUTNfT0Y96cXOTphE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PIirrtN32/HR/1MRnqf39z2Q1n/rFq3EeA5XDRdwLFTEXh4bcdM88bCFiDygPg1M7
	 EG6SZf549KLtoXnSnXe1CLGCFQI6n7juv+76xCAei91/G3YLDGjGGwgLwnjIIHOOJ+
	 +lPjTRti/27T0g5lZRPAyQ0lKJjKtbBGue0ftcZ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Menglong Dong <dongml2@chinatelecom.cn>,
	Jiri Olsa <jolsa@kernel.org>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 297/352] bpf: kprobe: remove unused declaring of bpf_kprobe_override
Date: Thu, 15 Aug 2024 15:26:03 +0200
Message-ID: <20240815131930.933032892@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131919.196120297@linuxfoundation.org>
References: <20240815131919.196120297@linuxfoundation.org>
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
index dbf0993153d35..64af1e11ea13d 100644
--- a/include/linux/trace_events.h
+++ b/include/linux/trace_events.h
@@ -729,7 +729,6 @@ do {									\
 struct perf_event;
 
 DECLARE_PER_CPU(struct pt_regs, perf_trace_regs);
-DECLARE_PER_CPU(int, bpf_kprobe_override);
 
 extern int  perf_trace_init(struct perf_event *event);
 extern void perf_trace_destroy(struct perf_event *event);
-- 
2.43.0



