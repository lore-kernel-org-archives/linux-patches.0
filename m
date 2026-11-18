Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795051892;
	b=c2QBfzD1+JV8/HSLf8tsvZDXPXjcrNGb/qAissUJ2oF+BJEj/8zD8HcPnbHHgZFchexr
	 ksAA7VbHOz5GiJ8yKtdSVnKVRdUXBEoxCghqlPR7Cc63hKU8vV/q6wp914p1PGe8YAVcz
	 PWuevd/wUlwvx7uLOgKBVV64LqHQof+q4AerzkaVO46XUNuEFEdy9dpUnpljdpDCeJIXQ
	 J6y90vhVnJFgaIxzOWeDBvryqAh/6ph9QZbBuaq1xwRwwi5sRSlVaRZJTcnBLl9bhAaZg
	 u9xuplFvrcq0OF3gihddNLEhL4IvSNYQfF+cxmaMTh/KLHQjsEuQIGtnY4nZOTctOOA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795051892;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=LCqfHNVlQzh2krHfIrk6+646Jk7IXnDXcAki/a8WBMo=;
	b=kzoPkSe91ZVz5jQ2PT2JSOVaK1n2O4vAoE56NCv5UgkR9YVHV5hv0bJ7jDq3azxNQSjD
	 oDpNJitQYlTYJ9mGXLcgSbCLV1qSAvz8FLB6kOzRJd2CHEhJo7KRFkjl8qhDf9R/GWhU9
	 KwG26xKCQECZFjhhYrNBPZ+bJu/r7E1lReXebNgKZ3kldXGthZTtDJUDFatg9fFhDb0mY
	 hRr8PW8rPAcmdAzBnNOy4Iqh5x4/CrEtdhlHU07LGXuzDdZEICkd6cTHm3wOvxB6y+dU/
	 UEJMHJnHsijOtDNoRYlcjTXFXVD1qIw0rKFkm5V6ZxM1MQIWg2qU3fPA7+msFHdSnkA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="BPD/l429";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4272360A3806;
	Thu, 19 Nov 2026 01:31:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BPD/l429
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4731C1F000CA;
	Thu, 19 Nov 2026 01:31:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795051891;
	bh=LCqfHNVlQzh2krHfIrk6+646Jk7IXnDXcAki/a8WBMo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BPD/l429JM/kBIa4y7pQ98k+P4Pl1HdOVgs7i/s342PBVM10wEg40aRnq74C/PaW/
	 4N5fLihXIXTIUGrACnUbt/4HBiqbhyFcAno8lcQYgFHl5n2gx/qai/G/5WG5uqlXvk
	 DUM+VpYKCrz+YG5JOhk28tDEefpBYhJWc8uT6N6A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	VEGA <vega@nebusec.ai>,
	Zhiling Zou <zhilinz@nebusec.ai>,
	Chuck Lever <cel@kernel.org>
Subject: [PATCH 5.15 0363/2214] SUNRPC: trace an accepted transport before publishing it
Date: Wed, 18 Nov 2026 15:33:59 +0100
Message-ID: <20261118150025.194527879@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -834,8 +834,8 @@ static int svc_handle_xprt(struct svc_rq
 		newxpt = xprt->xpt_ops->xpo_accept(xprt);
 		if (newxpt) {
 			newxpt->xpt_cred = get_cred(xprt->xpt_cred);
-			svc_add_new_temp_xprt(serv, newxpt);
 			trace_svc_xprt_accept(newxpt, serv->sv_name);
+			svc_add_new_temp_xprt(serv, newxpt);
 		} else {
 			module_put(xprt->xpt_class->xcl_owner);
 		}


