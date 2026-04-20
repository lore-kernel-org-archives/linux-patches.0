Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92FFE3A1A23;
	Mon, 20 Apr 2026 13:16:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776690961; cv=none; b=gzKPEIvd/HLS30qZobg1Q27RphCfU8oRbefdMRMbAvQ14x/DHKgiVZnkMNopEbPM6ZyFZp9Q7pIqE7oqz3SAVBizeQiJ+pnsz5lLuKQ4W0TwfzUtLgsEyIGZlI4dqJzF+URE7SS2N9Zzu947kkL8JgRD1dcTyEwSMDXGmjpWf3M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776690961; c=relaxed/simple;
	bh=Ct6zx4mu+2bQRocHkk0eU+Lde5PNyNNm2EdybrnywK0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KC2/KQOZ/W1h8h4ZguiSNW00K4/AyEwfjUzo65hEwIzITdvfiS+a59Dwib+rApOWmz3hlkBOz3/j4YSdUdUtM36KUbW9svB1G18Oaf5QeZcao1Oo0GhG6BJUA0Lo1kjejdk1fKW62zXnv217fz/Zr2QlIztmcsdAxpaMxulFwpk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IuuJSdwG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IuuJSdwG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6767BC2BCB7;
	Mon, 20 Apr 2026 13:16:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776690961;
	bh=Ct6zx4mu+2bQRocHkk0eU+Lde5PNyNNm2EdybrnywK0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IuuJSdwGxW+HzRwXD8+Z2WoH1FLezNzsbMAaV4xeK7EGXMciaBZe8YulhBuwgnEjU
	 YLhM/1urJIC9ZbAhwBut6h0vUcRoxjvNv774WoWCjf7pdWs8Pi1p7FMoCG8/JHjeIS
	 PKUTcs7PLje1l+/cDR++qahO6V5EGxD4+RicOwW7I2KfUrFRwus/vHEEWgIdXpTjiL
	 i7QpI9JDToaDcVnljbOYFV0H/i8UGbEn1tDLNEW60BK/1qCdMi6ZyJEV2jxLrUxIEJ
	 2XToiSelu1o+dUTgrCBhvEbPQnK2pq7rxWud01x1NWSaCWiL0GL+n3z+PbHKnHyc5V
	 EAP2h5rHGA8ww==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Pengpeng Hou <pengpeng@iscas.ac.cn>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	linux-kernel@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] tracing/probe: reject non-closed empty immediate strings
Date: Mon, 20 Apr 2026 09:08:00 -0400
Message-ID: <20260420131539.986432-14-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420131539.986432-1-sashal@kernel.org>
References: <20260420131539.986432-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.23
Content-Transfer-Encoding: 8bit

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

[ Upstream commit 4346be6577aaa04586167402ae87bbdbe32484a4 ]

parse_probe_arg() accepts quoted immediate strings and passes the body
after the opening quote to __parse_imm_string(). That helper currently
computes strlen(str) and immediately dereferences str[len - 1], which
underflows when the body is empty and not closed with double-quotation.

Reject empty non-closed immediate strings before checking for the closing quote.

Link: https://lore.kernel.org/all/20260401160315.88518-1-pengpeng@iscas.ac.cn/

Fixes: a42e3c4de964 ("tracing/probe: Add immediate string parameter support")
Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Reviewed-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Error: Failed to generate final synthesis

 kernel/trace/trace_probe.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/trace/trace_probe.c b/kernel/trace/trace_probe.c
index 5cbdc423afebc..d7adbf1536c8b 100644
--- a/kernel/trace/trace_probe.c
+++ b/kernel/trace/trace_probe.c
@@ -1068,7 +1068,7 @@ static int __parse_imm_string(char *str, char **pbuf, int offs)
 {
 	size_t len = strlen(str);
 
-	if (str[len - 1] != '"') {
+	if (!len || str[len - 1] != '"') {
 		trace_probe_log_err(offs + len, IMMSTR_NO_CLOSE);
 		return -EINVAL;
 	}
-- 
2.53.0

