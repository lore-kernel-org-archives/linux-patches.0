Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85D56183CD4;
	Mon, 12 Aug 2024 16:31:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723480306; cv=none; b=lo8gURdpw17p7/4OmLSG3D2DKT95QjC9EHY1MEp83mQ/du96/Dcf1GsneQuJCMI+ddKimGCRlHBu+aC3nyS9aQVlvS5ZiBt+IWUTr98STHT0M2AVUl+G9zcsCHIPnly3ZGvnPF/UsinHPY8VOBeESBKmiB2YPQTOGlOJtdWYto0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723480306; c=relaxed/simple;
	bh=z6wANyY/eGPU9nL0fYMogqFCSJg/e46WI01L7nwI4ms=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JnAeJbft2/ghGClQCyj/kFpW5bdlu8XD4hY0SiAvG5VQMJL0e9UaWlOARIPpD9jywt7tDZq4pkSjRtNinw4w74AJQV4u8jSrVQzKefu64O6RMMWOxtRAw5qeW+O7pkGLhGOup68XZnwh6Mpmr1J857kFqY061L8jbYVFXVR1iq4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GN/TwdyD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GN/TwdyD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07BA3C4AF0D;
	Mon, 12 Aug 2024 16:31:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723480306;
	bh=z6wANyY/eGPU9nL0fYMogqFCSJg/e46WI01L7nwI4ms=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GN/TwdyDLHSRxsDSTYHeWBsq78UaLIP0gBRIeQ+GCulV2D/xMXp+dhHVbdIlPioJL
	 wqr9qhrw5LaX6kUduRep70lNqmPhDHcfqV3bli3oLYNok9MCPTPahZ5KK7o2h1VXts
	 r9UVRMY04HUU4qocdJMO6z8ZKzGXL4yKXiXodZzo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Menglong Dong <dongml2@chinatelecom.cn>,
	Jiri Olsa <jolsa@kernel.org>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 150/263] bpf: kprobe: remove unused declaring of bpf_kprobe_override
Date: Mon, 12 Aug 2024 18:02:31 +0200
Message-ID: <20240812160152.289422930@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160146.517184156@linuxfoundation.org>
References: <20240812160146.517184156@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
index 9df3e2973626b..9435185c10ef7 100644
--- a/include/linux/trace_events.h
+++ b/include/linux/trace_events.h
@@ -880,7 +880,6 @@ do {									\
 struct perf_event;
 
 DECLARE_PER_CPU(struct pt_regs, perf_trace_regs);
-DECLARE_PER_CPU(int, bpf_kprobe_override);
 
 extern int  perf_trace_init(struct perf_event *event);
 extern void perf_trace_destroy(struct perf_event *event);
-- 
2.43.0



