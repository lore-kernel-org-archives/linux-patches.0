Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6BBD186E34;
	Mon, 12 Aug 2024 16:19:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723479575; cv=none; b=FhqNQH+SHVA4krfVCS8foi+SdOszUA7lv8X6/ZPNQUJMP5gxYpN5SzYfbUj0FMM8v/lalvnHYi4G8tvCZxebpmtjm3GaZfN5RUZApyplEWtKDukwwa62UHuodgxju2O0WmdT7H01t/c1nlj1LJDlMZovvgzb8rbhGzA0BZcNaEU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723479575; c=relaxed/simple;
	bh=6V/argz9w+NNFpkCEhq6rA01sqpgeNfwAGDHeEbaT8k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Tu4yPETx5HTZ+hxwjljjjeGri/Mxc0bHJ8MlXS/gVTqpvbQsowPFWrlQ6OaPl4JLksN/+gwO+AdYOLGvyFOTZKXwz63ql2jkrMeLPGddAJZ8HaAl59myQolydzoDTDwIH6/g6dl7D7udcvmYm4KChKa7kSqo3dvak7Aa70mG3Ho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mG804j8/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mG804j8/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B52EC32782;
	Mon, 12 Aug 2024 16:19:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723479575;
	bh=6V/argz9w+NNFpkCEhq6rA01sqpgeNfwAGDHeEbaT8k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mG804j8/u2gOE5udXmTCzMFL21CIpgTwLVYi54SOHsmHgJFVOItOZaeogFg6scWX/
	 y3+8jfok9u77hYv0HO+owEkKO+OKv1kpqR0gNrt4CS/ZLwe7MqnHTtS/co5HVhjkLd
	 cBgbfrIJMWqVRMoW2qulKzaIJaj8XgUju5ciAA9Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Menglong Dong <dongml2@chinatelecom.cn>,
	Jiri Olsa <jolsa@kernel.org>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 098/189] bpf: kprobe: remove unused declaring of bpf_kprobe_override
Date: Mon, 12 Aug 2024 18:02:34 +0200
Message-ID: <20240812160135.914885455@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160132.135168257@linuxfoundation.org>
References: <20240812160132.135168257@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 696f8dc4aa53c..cb8bd759e8005 100644
--- a/include/linux/trace_events.h
+++ b/include/linux/trace_events.h
@@ -869,7 +869,6 @@ do {									\
 struct perf_event;
 
 DECLARE_PER_CPU(struct pt_regs, perf_trace_regs);
-DECLARE_PER_CPU(int, bpf_kprobe_override);
 
 extern int  perf_trace_init(struct perf_event *event);
 extern void perf_trace_destroy(struct perf_event *event);
-- 
2.43.0



