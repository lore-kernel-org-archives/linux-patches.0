Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793216968;
	b=SIG9tawsX38lgfXfky2DJWibkgq0uQeHcV3sscvAyLIDX9avFOEWcjP5kb72fdQOM7g3
	 MjmAwixQN3VuSxru7TmFgpjt9z1y42u2shIr2tVr78OM2r2yym/kEfHoeXWlqBZA2TCcR
	 8vRScec8UxnKjcMwhvoQLO0XYzPbPnUIqjw5Ylrq9B7Lrzxnxv+tebBQs6R8iv4kh3zQv
	 tUZ9Fq0qd3D6Ds58tSAhV3VbW1tgqziEDlmdKO1+j9L+vnPRM0bmEoGUThNSrmULAwvtN
	 UjvD1n8EjzzrgOdquTUs6pT7xEs7/Aco/z9UDKYLgS3p80yb3u4SpdmZjnOMG6beRfQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793216968;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=J1jvEf943BzNbc8sHT7bEMiJo4840ArrsMZ+2v9V/XM=;
	b=RmSYB7MAo9LlugeNP7oHmvpKfVjIUC2sB0raNN978a06sJr7xIkH6HmjLDU63d2SBDr+
	 s1TN4Ikxyb6kQqT+C7nn46KsywH7DDfNqujX+hvB56yJ38720kpXeMc9mEyltKte7Ty5c
	 nMHY7U7tDhaGHR8YNhjZIp+hJhmL+hG9aWpI9ow7maiR+RjYe55m3iglFjNJ82f6ybF/S
	 Ej4FTAS1QJkP40xOiZHJhocMo2QzLIbsK6NLmOxRYMcfhvWaTTVaEQku4kajdM9+4Q05m
	 PWDDgbvHsSX5No3BjJUJcg9snWdCLpGJvLcafZBUbWSgdF+sik3Yxq+v5NIgjqKLSUQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1YldN7t6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60468606A31A;
	Wed, 28 Oct 2026 19:49:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1YldN7t6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A593E1F01825;
	Wed, 28 Oct 2026 19:49:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793216968;
	bh=J1jvEf943BzNbc8sHT7bEMiJo4840ArrsMZ+2v9V/XM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1YldN7t6XOQdpvr1gpzjgYW4I4bjbfObxWc5vUzqAH0mCQcKO+sopqKA4ZMTHi2EW
	 ffpA22Rn9mwtd0mNLTpfKauul8GfU6QaQVgCFwMOFYseRhzbfcZ3le5xPVekAMBh7X
	 jFKNYvbgamkJmS2/tZHXHFPT9Grao04gHa+7U8RA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Justin Stitt <justinstitt@google.com>,
	Kent Overstreet <kent.overstreet@linux.dev>,
	Petr Mladek <pmladek@suse.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Rasmus Villemoes <linux@rasmusvillemoes.dk>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Kees Cook <keescook@chromium.org>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1698/1887] powerpc: Remove initialisation of readpos
Date: Wed, 28 Oct 2026 18:03:14 +0100
Message-ID: <20261028170538.095338791@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthew Wilcox (Oracle) <willy@infradead.org>

[ Upstream commit 0f7f544af60a6082cfaa3ed4c8f4ca1a858807ee ]

While powerpc doesn't use the seq_buf readpos, it did explicitly
initialise it for no good reason.

Link: https://lore.kernel.org/linux-trace-kernel/20231024145600.739451-1-willy@infradead.org

Cc: Christoph Hellwig <hch@lst.de>
Cc: Justin Stitt <justinstitt@google.com>
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Petr Mladek <pmladek@suse.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Reviewed-by: Kees Cook <keescook@chromium.org>
Fixes: d0ed46b60396 ("tracing: Move readpos from seq_buf to trace_seq")
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kernel/setup-common.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/powerpc/kernel/setup-common.c b/arch/powerpc/kernel/setup-common.c
index 41c03c8e41b41..fa8c14e890c87 100644
--- a/arch/powerpc/kernel/setup-common.c
+++ b/arch/powerpc/kernel/setup-common.c
@@ -600,7 +600,6 @@ struct seq_buf ppc_hw_desc __initdata = {
 	.buffer = ppc_hw_desc_buf,
 	.size = sizeof(ppc_hw_desc_buf),
 	.len = 0,
-	.readpos = 0,
 };
 
 static __init void probe_machine(void)
-- 
2.53.0



