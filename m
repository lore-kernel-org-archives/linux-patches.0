Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5E5A1714A8;
	Thu, 15 Aug 2024 13:42:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723729367; cv=none; b=rg3C9nfhOPb7NCxE5v5GbkeMeDygckSobHXF6Gcfi/GJq5/hRdlu6EcpFayKRfeL5rO/b+mu5d71PmZId3GFe1lvaI6620dj5KDaAhgASn/xmsokSEH94cFgNVU8jKr9g7PLNxVofaXEN+mmlwgAkTQI7sFRWIBTlOs4Dt+3CRs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723729367; c=relaxed/simple;
	bh=HQbWPtPbjJcTkIVd7HI/Ipodxx9QvKWsohXXJVteqIw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j7C03jQRNnrjzeShSYT50/zXN15xdDxWUlnwVPYS+bkAJNa3WrGbpkHw4vw4iKSwiUEksGLUAmIji8BAi//ySUKecBscDyrNXG0RF2lpaJQ4mLql3ZX71YtPJ9tW19RgLkbhYXqp0Kty38rs8458OBODuKz3cr9R8MpwV2ePrZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oIQpVDkS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oIQpVDkS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 508C3C32786;
	Thu, 15 Aug 2024 13:42:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723729367;
	bh=HQbWPtPbjJcTkIVd7HI/Ipodxx9QvKWsohXXJVteqIw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oIQpVDkSzBxfCQxOHowX9TyBGE6IPLhCE8nNl1KueqQudzSw+M5BCuk6bNeA0wJPC
	 bOAz5DwRwKqw5ADmsEfvNUqtiewpI1TQODdj1r5lRTFlT+vylbaW0/G71X7gbFacC1
	 X+ymh50OU14T8uB7fa0Un1g/u4z7RKn9bVutRsyg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mirsad Todorovac <mtodorovac69@gmail.com>,
	Alan Maguire <alan.maguire@oracle.com>,
	Mirsad Todorovac <mtodorovac69@yahoo.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 076/484] bpf: annotate BTF show functions with __printf
Date: Thu, 15 Aug 2024 15:18:54 +0200
Message-ID: <20240815131944.222660111@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131941.255804951@linuxfoundation.org>
References: <20240815131941.255804951@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index a0c7e13e0ab4d..0c9d93e2c18f0 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -5808,8 +5808,8 @@ static void btf_type_show(const struct btf *btf, u32 type_id, void *obj,
 	btf_type_ops(t)->show(btf, t, type_id, obj, 0, show);
 }
 
-static void btf_seq_show(struct btf_show *show, const char *fmt,
-			 va_list args)
+__printf(2, 0) static void btf_seq_show(struct btf_show *show, const char *fmt,
+					va_list args)
 {
 	seq_vprintf((struct seq_file *)show->target, fmt, args);
 }
@@ -5842,8 +5842,8 @@ struct btf_show_snprintf {
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



