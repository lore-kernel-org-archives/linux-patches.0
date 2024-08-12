Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 016B2183CA6;
	Mon, 12 Aug 2024 16:08:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723478928; cv=none; b=uQFQtJWghMfqbAK/ZcuS/dl7WYdRQp3+2ThWdYZArLXzt7gNqapyjODfjeziFSGInNEC9wlc9ncgGL216Y2CtztrOwyKfhAPmGQu2ibvsL7rC4Un2Z4DWJ/MDtxgHmOGmjV3jFMqZh3vuxP1Cb1algUWBr+xpgXprWZAvbbvgug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723478928; c=relaxed/simple;
	bh=FxnE8F2akFSOu7htiLwkObYcOiz/E+PLOx7BKXYldXg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OaX9JD4SsDD77z+Qpgdy0oIWv9bwSE8fUp3ApOxnUqkuzt4hxl4AEHlezAfcvFnAdI0kkW+nGsIMXBJzcAd6sa6wqumGdcrhGcc7HvgeMU+i8FQ/j1YPMJzX21zIMhC5Mq98ipe04IguSogB/98B9KGi2bU/RQes3xl+IRPVUvo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fkctJujo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fkctJujo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60DABC32782;
	Mon, 12 Aug 2024 16:08:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723478927;
	bh=FxnE8F2akFSOu7htiLwkObYcOiz/E+PLOx7BKXYldXg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fkctJujoKMIg+iT8OVJKa2ZQfAKI5yoeD5APYcAm+YV65nESPxAxKcO0j3FBxQRam
	 wWhbm0+lyNoRwlIHKtvEoDh5j3mfL9hmLAhAOw66H6PpkwdE258+7r0Cc/eIVQSQ9y
	 MRAjSor03HAIa8d3ZKOzuQIERU1M2suTpex3x+Mg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Menglong Dong <dongml2@chinatelecom.cn>,
	Jiri Olsa <jolsa@kernel.org>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 079/150] bpf: kprobe: remove unused declaring of bpf_kprobe_override
Date: Mon, 12 Aug 2024 18:02:40 +0200
Message-ID: <20240812160128.224953688@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160125.139701076@linuxfoundation.org>
References: <20240812160125.139701076@linuxfoundation.org>
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
index c8b5e9781d01a..f70624ec4188f 100644
--- a/include/linux/trace_events.h
+++ b/include/linux/trace_events.h
@@ -847,7 +847,6 @@ do {									\
 struct perf_event;
 
 DECLARE_PER_CPU(struct pt_regs, perf_trace_regs);
-DECLARE_PER_CPU(int, bpf_kprobe_override);
 
 extern int  perf_trace_init(struct perf_event *event);
 extern void perf_trace_destroy(struct perf_event *event);
-- 
2.43.0



