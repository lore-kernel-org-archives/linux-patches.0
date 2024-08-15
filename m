Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB0751A76C0;
	Thu, 15 Aug 2024 14:27:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723732055; cv=none; b=qOJSOPZRSqhrSSuLo7LmvEGBPeUQuCKyPlUWkX69iWqET07T/O7ZmBrBt26WVglY96prJsZX5rOpXgF3LlxnRNqH3uv+Wbc/7q5n0YJNqkWULXr8pmo20R/INOFlDCuHN+hWc5ZSSRgDncJ92wQwgC94OL+dOyAhbzfZOAQcrco=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723732055; c=relaxed/simple;
	bh=5jBCzi90ULJ8jzmZqaTXGEw+AgZRmSXWUi0CacfxXLA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q3vD2WhVilYIwswfcpvPEwuxmfM6Fy8a5cim0dgPHtFRAT3C/BSUl2b29CLwXZ2nSmudjuRxh3CVZoPnEFG8Yvz2B+N5IHj2cr3Z5jtvY1oEn7kY2x/86AjsHVaHEpKvufEeeLS4TGP5egtuudfCCRSycvV0IP43xqzkTXeaFJ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jxlH1B2x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jxlH1B2x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F29FDC32786;
	Thu, 15 Aug 2024 14:27:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723732055;
	bh=5jBCzi90ULJ8jzmZqaTXGEw+AgZRmSXWUi0CacfxXLA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jxlH1B2xkHg7hyCwU2fr5t1tZhpHT59C7Bq0BnbwDM5dib4gvVH+fMjnxm8ZetSK0
	 12pXittiVe40+tAEO0NkWxpc6V6ioZMQd7OLdP0jenB4Z2TT2Bjqhmn5m0Ev+DDncO
	 ey8o2w+aF72SHHa0Us82B1s7Xb3PSSOl4eCov/hU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mirsad Todorovac <mtodorovac69@gmail.com>,
	Alan Maguire <alan.maguire@oracle.com>,
	Mirsad Todorovac <mtodorovac69@yahoo.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 061/352] bpf: annotate BTF show functions with __printf
Date: Thu, 15 Aug 2024 15:22:07 +0200
Message-ID: <20240815131921.602110652@linuxfoundation.org>
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

From: Alan Maguire <alan.maguire@oracle.com>

[ Upstream commit b3470da314fd8018ee237e382000c4154a942420 ]

-Werror=suggest-attribute=format warns about two functions
in kernel/bpf/btf.c [1]; add __printf() annotations to silence
these warnings since for CONFIG_WERROR=y they will trigger
build failures.

[1] https://lore.kernel.org/bpf/a8b20c72-6631-4404-9e1f-0410642d7d20@gmail.com/

Fixes: 31d0bc81637d ("bpf: Move to generic BTF show support, apply it to seq files/strings")
Reported-by: Mirsad Todorovac <mtodorovac69@gmail.com>
Signed-off-by: Alan Maguire <alan.maguire@oracle.com>
Tested-by: Mirsad Todorovac <mtodorovac69@yahoo.com>
Link: https://lore.kernel.org/r/20240711182321.963667-1-alan.maguire@oracle.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/btf.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index 06c028bdb8d4d..326feb2301700 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -5344,8 +5344,8 @@ static void btf_type_show(const struct btf *btf, u32 type_id, void *obj,
 	btf_type_ops(t)->show(btf, t, type_id, obj, 0, show);
 }
 
-static void btf_seq_show(struct btf_show *show, const char *fmt,
-			 va_list args)
+__printf(2, 0) static void btf_seq_show(struct btf_show *show, const char *fmt,
+					va_list args)
 {
 	seq_vprintf((struct seq_file *)show->target, fmt, args);
 }
@@ -5378,8 +5378,8 @@ struct btf_show_snprintf {
 	int len;		/* length we would have written */
 };
 
-static void btf_snprintf_show(struct btf_show *show, const char *fmt,
-			      va_list args)
+__printf(2, 0) static void btf_snprintf_show(struct btf_show *show, const char *fmt,
+					     va_list args)
 {
 	struct btf_show_snprintf *ssnprintf = (struct btf_show_snprintf *)show;
 	int len;
-- 
2.43.0



