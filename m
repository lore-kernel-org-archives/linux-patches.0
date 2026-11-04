Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829095;
	b=rdZsg+CYMoKCKgMxHWJ8eIBvoP0WcE7DNsJZ0NvC5JKaQqonwgiKdbTJixhWuLlj66Qy
	 bnWnXpwJUm5ixlhzl7J4i9r83STFhwwU9ASGN5fmmXUt9eFcAE2yG9potCYkLSjRJaFlP
	 Qy/EUfxCK9IJf0gjQH2JEd+Jl0dnYNCeDC6lJ70lxW+pUEQzdZuartsfrlUyA3qT038bL
	 ewxtb4U4t54E6uMQUToOslMNvxYB7E+lq/DRgXSoZh03RWDLL/SvWo1kStUgT1qGVefA7
	 BGC1SKrFdcy7IeypGQO0IqDlLYRb9s3XARY+KOtO3UjcShiYP67KOhgRm4SCGYbFBHA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829095;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=dvEy/83+xeq8pB0xC8tLTER8Oit2srrlCpJ8QLtSB3c=;
	b=m0EvpOwBxXnmAGiiKq0NsiWpdf9wtINwwFXkF9i5eIDKrxyKwTlv8KW+VrQ8wwa8cMQq
	 03NyTPhKxI6E99Ri65xGJvDIxpOlTQuyXZJ0MJURqXxmTgV4ZlqouHYFFEuqGrHBY5ODz
	 6piNOR2FUtRFKDUbEDBcwDYlJ6qGIftVQ4FmMrSD3vm7l5jO+MnoO92pulcupGWjySemZ
	 jXD7HQi4OpIB98IcISNLXG3oMw1WMJFbUUbhtSqedkrULD1OSsdD7Rb1xJD+nrt37pyBc
	 tvo/6mhsnvY+EM6BUWeCFGLWQsPmb2B9goxohk5uJ2R+LTjdzHm/hP1zTdr125ig7Ew==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LSqG4teL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 232206072FB9;
	Wed,  4 Nov 2026 21:51:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LSqG4teL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3EAC1F0093A;
	Wed,  4 Nov 2026 21:51:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829095;
	bh=dvEy/83+xeq8pB0xC8tLTER8Oit2srrlCpJ8QLtSB3c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LSqG4teLRYpZm+3vJWF3G+iRZr+bdSFqbtRVWzApxwSzM6o+LwMTs4U+MgmrU5M6n
	 dJhB/qIPAzYhbcr0bVilk7CUz6CuX+oVrIVCT8bR5IYnmDmXE41L/Jy6+Km2T5ClYV
	 En3At50GNT9a+TGjp/X2dp2hH7s9nFnz31tNeSiE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	VEGA <vega@nebusec.ai>,
	Zhiling Zou <zhilinz@nebusec.ai>,
	Chuck Lever <cel@kernel.org>
Subject: [PATCH 7.3 443/547] SUNRPC: trace an accepted transport before publishing it
Date: Wed,  4 Nov 2026 16:10:27 -0500
Message-ID: <20261104211050.937241374@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
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

From: Zhiling Zou <zhilinz@nebusec.ai>

commit 06f90cf104fc21ee01e7ef1eb80e092173089b9f upstream.

svc_handle_xprt() publishes a newly accepted transport before tracing
it. svc_add_new_temp_xprt() places the transport on sv_tempsocks and
clears XPT_BUSY, so another nfsd thread can dequeue it at once. If the
peer has already closed the connection, that thread runs
svc_delete_xprt(), which drops the list reference, the only reference
the new transport holds. trace_svc_xprt_accept() then reads the
transport's addresses and network namespace from freed memory.

Before publication the accepting thread owns the transport
exclusively: XPT_BUSY is still set from svc_xprt_init() and the
transport is on no list. Emit the tracepoint there.

Fixes: 11bbb0f76e99 ("SUNRPC: Trace a few more generic svc_xprt events")
Cc: stable@vger.kernel.org
Reported-by: VEGA <vega@nebusec.ai>
Assisted-by: LLM
Signed-off-by: Zhiling Zou <zhilinz@nebusec.ai>
Link: https://patch.msgid.link/d15495bff2247e3f9d4f9ef36df8e246a3898380.1789220778.git.zhilinz@nebusec.ai
[ cel: trace before publication instead of taking an extra reference ]
Signed-off-by: Chuck Lever <cel@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sunrpc/svc_xprt.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/sunrpc/svc_xprt.c
+++ b/net/sunrpc/svc_xprt.c
@@ -852,8 +852,8 @@ static void svc_handle_xprt(struct svc_r
 		newxpt = xprt->xpt_ops->xpo_accept(xprt);
 		if (newxpt) {
 			newxpt->xpt_cred = get_cred(xprt->xpt_cred);
-			svc_add_new_temp_xprt(serv, newxpt);
 			trace_svc_xprt_accept(newxpt, serv->sv_name);
+			svc_add_new_temp_xprt(serv, newxpt);
 		} else {
 			module_put(xprt->xpt_class->xcl_owner);
 		}


