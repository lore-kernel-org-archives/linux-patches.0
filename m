Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016688;
	b=PN8nVY5iPBfOdDktyfQgS+nx7imiKnAZZ3l+yT6TWP2kgm/eBubAT4OibwHrcRCUpi16
	 MxdjOvp5KxdF5wTM5K7L134D8yYQDfFtn2d8zj5Mqr4/d2VoHDp3GWgaLepgLy25ugpZ0
	 3wbg+NjSuNMQZkCQudGFu/I/cM48WPo+Hnh/qHtFwQbLXHPxd4N8lu8aUuZU8RhDQH9J0
	 7PaXJxUIQsBkmqs/ql/uAZPcVAcBMHuIMLNAX5F0Tz3SOXX2HEPC5aeoS0FYYpVCU6AKm
	 wTmY+SGZCopwan/EvcGewcdJOEBfCTuQx9gCXpTgeM9FCWuAvKzvQmudhrpzeE3/Eog==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016688;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=NVzz9p336wDqb1fOVogL0Ox5OJbwJDowZ3Fs5YUTjOg=;
	b=MPolhA3Nl56XsmjF1CdWl/YzlTr6AdNjUXcEMwNI1pHBWiuLiqfHyLKXc2TxmhnkcbA3
	 NEh449lf0hjOQLcFGhbqz6RuW4al6sPHvzyIrivNqdBO3unwlFYPGqi1IJiK80wszsj2f
	 MZOm5ANEFC/aAP9MM1sMO4Dn31oOwIMtVyNAWX3GWAk+RBbQtaPCxmaOViwGn2UdFfhsj
	 ZbbWizignk+e8+XNopl/2fdx+xSyouGKGqmigkId8q9r3HhU3+T62TqLTPhYBjVia8YkE
	 CKiFSbThPxlQcjbeqCr8TbPLLFF1T+I9F+pzdhY4S3qaWwtIkZIFTKueY57ycITHycQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=y7h4MCZJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C176606A31C;
	Wed, 18 Nov 2026 15:44:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=y7h4MCZJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 271E01F000C4;
	Wed, 18 Nov 2026 15:44:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016687;
	bh=NVzz9p336wDqb1fOVogL0Ox5OJbwJDowZ3Fs5YUTjOg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=y7h4MCZJBIRrGyqUnNE3n/q1EE/t6A9+31o8SC80NM12gAlYaWiqu1D5HeB1FVhor
	 Ek/LkJ/wkN4XAIfw5COL75dGAk+1lNzWnEbgAuSHSwuLRt35R9upPw8NZ2Pf13wWSx
	 5rbg+cpNQVnb2rqEbcthnTQ7pmartyKPU9Pjz3XQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0618/2651] bpf: Add printf attributes
Date: Wed, 18 Nov 2026 15:30:58 +0100
Message-ID: <20261118150309.954031826@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 7f2b0b57a8d7dc0772ab998007d5d8e8f1f94966 ]

Building with extra warnings enabled shows a missing printf attribute:

kernel/bpf/diagnostics.c: In function 'bpf_diag_source':
kernel/bpf/diagnostics.c:828:9: error: function 'bpf_diag_source' might be a candidate for 'gnu_printf' format attribute [-Werror=suggest-attribute=format]
  828 |         msg = bpf_diag_vfmt(env, fmt, args);

Add these to shut up the warning and allow the compiler to check the
format strings.

Fixes: b9c5d822f677 ("bpf: Add source and instruction diagnostic context")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/20260915213123.2361066-1-arnd@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/diagnostics.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/kernel/bpf/diagnostics.c b/kernel/bpf/diagnostics.c
index 0abbbe177e317..3aeb55ccf9f9c 100644
--- a/kernel/bpf/diagnostics.c
+++ b/kernel/bpf/diagnostics.c
@@ -794,8 +794,9 @@ static void diag_print_insn_context(struct bpf_verifier_env *env, u32 insn_idx,
 	}
 }
 
-static void bpf_diag_source(struct bpf_verifier_env *env, u32 insn_idx, const char *label,
-			    const char *fmt, ...)
+static __printf(4, 5) void bpf_diag_source(struct bpf_verifier_env *env,
+					   u32 insn_idx, const char *label,
+					   const char *fmt, ...)
 {
 	struct bpf_diag_scratch *scratch;
 	struct bpf_linfo_source *source_lines;
-- 
2.53.0



