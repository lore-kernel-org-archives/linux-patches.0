Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023124;
	b=1wwrJELWf/SC6jzaabtmAZGy/wOx6INiP59g63AqoG7STI8wyxQTOaJxWTnYSdjmtLjR
	 Foj/c3GjRQ6vQqtSXhj8BeaNoSXTuxaf+4MDSI8Zu852YcrZRqQzlYtKsqoufXFy3xSSj
	 TyldPmavRiYglH6pf8hGZfQ6+MX7QM8DDw0kcH8ATQhFRBmcArjFmQr5xfpMCIfM9oE9W
	 G8Gg7znO/oC3u7N0QwDZK6Sl60Fy4By5YqPqSmB93bIok1nmnaXaRkUyxckhMaQGsJxF7
	 0coUgUzmIE124KH9EGppdEsmFoq1+F8s4lGI3LcoSmswhr1rJkcX9vFo/wYg3J7I5qQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023124;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=8y7GoPxqgbhRFBdIt67+HFSnNuDL79vo5l9Awknc6u0=;
	b=B5DWHLB3G/eQH2ShKVwNTUK6K/kRBhJHK2NnNAkuoDf5rot7h+jblhaYgTGA6/LSYjkj
	 tPiJXy3oRJrtOY4R2VytxUFTrTBykFvTUWb0+j17pypU4jBaM0jCv5OVenLk0uu8r+8QW
	 lV+4UtrtnmxZMQm5KHNQlWodi7PJpcLCLJVr3TODvg3VUJ0b8XFmX8KSMLvNdx8RWxPsy
	 jhcLZqI5rhAT13WFBXZcacicIbVB8VwRDS1kD7PCdWI971ONhMAmxRIOaUpjg/b8aKcPS
	 KqR0o49uvsVTYmJFmBH3+fQO2CHe3k3ZPmKbkEQk2HuZKgnNMo64+/aMbWm0xja0adA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZbhLptzb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E968606A758;
	Wed, 18 Nov 2026 17:32:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZbhLptzb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03E741F000C8;
	Wed, 18 Nov 2026 17:32:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795023123;
	bh=8y7GoPxqgbhRFBdIt67+HFSnNuDL79vo5l9Awknc6u0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZbhLptzbSi4duB8wsFXb/1lvBjPc7ZiE7ihIbn0vTfdfqrhJQnsu51bZwHycKW6c4
	 eV6hRFtgt5NaRX4ojP9c4Y4zH0X9xUdbW/lVF1nXbVVrRe78f3J0Y2annddzl0KwBP
	 zqsDAv+EEBmo9qwaWebppA8crUVYWFrj0YCy2rEk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Ian Rogers <irogers@google.com>,
	Aaron Tomlin <atomlin@atomlin.com>,
	Howard Chu <howardchu95@gmail.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0258/2151] perf trace: Fix error checking in btf_struct_scnprintf()
Date: Wed, 18 Nov 2026 15:33:13 +0100
Message-ID: <20261118150131.184221007@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aaron Tomlin <atomlin@atomlin.com>

[ Upstream commit 02241f791aa28802cc05223a740e163e14cd5ea2 ]

btf_dump__dump_type_data() returns the positive number of bytes dumped on
success, or a negative error code (e.g., -EINVAL) on failure.

Currently, btf_struct_scnprintf() checks if btf_dump__dump_type_data()
returns 0. When a negative error code is returned on failure, this check
evaluates to false, causing the function to proceed down the success path
and advance arg->augmented.args past the unprinted struct data before
returning 0.

Consequently, when syscall__scnprintf_args() falls back to the default
argument beautifier upon receiving 0 from trace__btf_scnprintf(), the
fallback beautifier or subsequent arguments read from an erroneously
advanced augmented arguments buffer.

Fix this by checking for '<= 0' ensuring that on any failure or 0-byte
dump, 0 is returned without modifying the augmented arguments pointer.

Fixes: cb32035214b9a09d ("perf trace: Pretty print struct data")
Reported-by: sashiko-bot <sashiko-bot@kernel.org>
Reviewed-by: Ian Rogers <irogers@google.com>
Signed-off-by: Aaron Tomlin <atomlin@atomlin.com>
Tested-by: Ian Rogers <irogers@google.com>
Cc: Howard Chu <howardchu95@gmail.com>
[ Restored that call to be a single line ]
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/builtin-trace.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index 2be8c3ed93c96..046db6fcd7f7f 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -1063,7 +1063,7 @@ static size_t btf_struct_scnprintf(const struct btf_type *type, struct btf *btf,
 		return 0;
 
 	/* pretty print the struct data here */
-	if (btf_dump__dump_type_data(btf_dump, type_id, arg->augmented.args->value, type->size, &dump_data_opts) == 0)
+	if (btf_dump__dump_type_data(btf_dump, type_id, arg->augmented.args->value, type->size, &dump_data_opts) <= 0)
 		return 0;
 
 	consumed = sizeof(*augmented_arg) + augmented_arg->size;
-- 
2.53.0



