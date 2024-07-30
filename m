Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F05EC18454F;
	Tue, 30 Jul 2024 16:23:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722356596; cv=none; b=Zh4GvaPoQbIvfoqryVifw6OriZJSGTSB0mwJ7S1vPoESQAJ1UINNG+j58TxFRn1ZPfQDFBXS7aJ9nUeITvZmRJwMBTmVHbBIEBDmr7X7uWT2myh/t1wgQEolbieOsFaAZ+tXDlIGmna3/qhV7dEHSZSwCq218ck3NBX4N5WQeKg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722356596; c=relaxed/simple;
	bh=Zsiodig7aKjwiKQiGiIVPHsuAC0CPuDvr77iIbHffD0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Sw4YeHxdpHfYrGYP11OCH0UxVr7YghJdVu3slWQziv4ZyXahtMdPCSkmnTMTUtLxFXAq5jHeGf05BLNeab+fcJWe65/NJT4tBrEjr9ozbQYPny/TnguG//Oqr/J7rPKzLyssXp7cmXUMtG3gk7dwnTHNbFn/fQWSAWboN3Avgf0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dps6XzI8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dps6XzI8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65882C4AF0A;
	Tue, 30 Jul 2024 16:23:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722356595;
	bh=Zsiodig7aKjwiKQiGiIVPHsuAC0CPuDvr77iIbHffD0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dps6XzI8NddBoX6kMLwZme4gVpSiWauzIMNi9YqCovRt9LibV/IZq+kWfN5GnImxu
	 hQaOtGImiHYtCq3CDHINFgEmwVwJDKzZjKu4TrF/vqRTT6r+vjYmRoLJ095wkcJoUj
	 wTM6T2FynSFSpD3Et+jklNFEBjvzrjK85pEsPyxQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mirsad Todorovac <mtodorovac69@gmail.com>,
	Alan Maguire <alan.maguire@oracle.com>,
	Mirsad Todorovac <mtodorovac69@yahoo.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 165/568] bpf: annotate BTF show functions with __printf
Date: Tue, 30 Jul 2024 17:44:32 +0200
Message-ID: <20240730151646.337424087@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
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
index a31704a6bb614..896ac05bf1bd1 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -7070,8 +7070,8 @@ static void btf_type_show(const struct btf *btf, u32 type_id, void *obj,
 	btf_type_ops(t)->show(btf, t, type_id, obj, 0, show);
 }
 
-static void btf_seq_show(struct btf_show *show, const char *fmt,
-			 va_list args)
+__printf(2, 0) static void btf_seq_show(struct btf_show *show, const char *fmt,
+					va_list args)
 {
 	seq_vprintf((struct seq_file *)show->target, fmt, args);
 }
@@ -7104,8 +7104,8 @@ struct btf_show_snprintf {
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



