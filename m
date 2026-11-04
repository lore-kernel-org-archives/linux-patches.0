Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831793;
	b=jCikkqr+Duouj7zBeW87n4hwxfC/ZICyI+iyqfVw4cvQ9sMgWKgmFhCaDE0ScRS9E596
	 Bt8rlZW645VVu467hDMmqw98LL92u6CZK+6pdsbM7x5yUUN07bEBaIvFPhG0LPzBnQ3eM
	 7vPGkdNXrLuV9J77APsMEgRznCbzq9zj+Gwo8GAwzhtoRdpymrg62OIgLuwHsLDZ9UCsd
	 5+dMAzvDqhn11Jo5ohJMUoFnRmzWHkPpG22aw1xBqRAMGX6m/IuX66/gGFiB68R2pUzQQ
	 tXe7jH2dM7Phce5DklvNQDrHGFC/HOwQNZ0wRdXPPc2kT5wwlaQwhUMLWRIIMU0ObNg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831793;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bYWvGW5Mk/iRE5SVQcV7M3zwFwn4T0L1MzV4/z9yggU=;
	b=T/TdfKIY1TElya2JsDW2YIB5zE7ZgCT1VE6VrGhBIdk+5mblw5lF8B/ju7+ZuEfpVrGY
	 Gg5/+HE296mEvvNpjwOb4p5GqXNsRLfTDLx3Utqz80mQUzN6G2OfuSQdsQyGib73qNNuc
	 mBtU8Ts/TYVMzVXQ65abkD7ICKh8b0FWWBCdlzGWiNPIfSgNIKtwpNdkb3sO8SX51xbt3
	 vyH3NxWhoS9BQDuV/AII5YnUbnhoLuIywkqaSj0QDwlaMl3+ggjI7Vy98MqamVMlhQOw6
	 oQDj7/wkzWtEXN+evfObUrb50XiRPbxO3ZmG+AevrFvh4MuK3mgPRAPys9NY0MbUDtw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hiLVzgw7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AB2F606AC37;
	Wed,  4 Nov 2026 22:36:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hiLVzgw7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17BE21F000C1;
	Wed,  4 Nov 2026 22:36:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831793;
	bh=bYWvGW5Mk/iRE5SVQcV7M3zwFwn4T0L1MzV4/z9yggU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hiLVzgw7E87I3sa8sg01hzFG1YRJXFJysD10zaB23GAvHLV4sovrU3gSWQef0CaB6
	 Bvv3f/Iu146rVqFrwsrICO/SR/q555VeASAYMCsu0lWfBNP8xnAI+pZohi2pf4D56Y
	 uD7IKh8saL/XOG2zrZPUVNWS9RMMm6IA3ovzwxCc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	VEGA <vega@nebusec.ai>,
	Zhiling Zou <zhilinz@nebusec.ai>,
	Chuck Lever <cel@kernel.org>
Subject: [PATCH 6.18 0915/1005] SUNRPC: trace an accepted transport before publishing it
Date: Wed,  4 Nov 2026 16:10:48 -0500
Message-ID: <20261104211108.787776723@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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
@@ -783,8 +783,8 @@ static void svc_handle_xprt(struct svc_r
 		newxpt = xprt->xpt_ops->xpo_accept(xprt);
 		if (newxpt) {
 			newxpt->xpt_cred = get_cred(xprt->xpt_cred);
-			svc_add_new_temp_xprt(serv, newxpt);
 			trace_svc_xprt_accept(newxpt, serv->sv_name);
+			svc_add_new_temp_xprt(serv, newxpt);
 		} else {
 			module_put(xprt->xpt_class->xcl_owner);
 		}


