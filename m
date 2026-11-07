Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061795;
	b=0vXDJp5YHvVnUiGkBlVFyGNGIf2JWdnoStOY4HiWcW3hU5KXOwzkea/atcSe7CM5FMQG
	 AIAPgAk81yk0qN4Yv2ADo2GbZZoTrhS6vNyVdbCChKqcDdIk9oY/n6s3DbdV52LWClxiT
	 GJtcp7phOkpssrvr6GYR9UnGetykL1fzecxwipze5UQxM+mMBfP6JZEJNtTqnFZ0+FSjh
	 hvJ7psw2YSRO3RcetimB/7AGbsWxxQWMi4xPh5zs30M5V+cA2ya28DzTTaVjXqa8NmQ7n
	 cBCymKvSJ63kEfCO35tK22av1+8dH3hR5WKpof8SI52/29I1ox5sy6gZxTLDBFIUidg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061795;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=kKBGLMEoqYIU3t7ju6aiMSjAE/7bvfkpVsaI9qMUebg=;
	b=MS7e6XIR07p53u2JZ1OQLXQgFSuELRwzcmwp0Q131FVG5i9qYJD2E7na8dBJaFC8he6u
	 U/ooNG6U0gNvabdD/Q1SwfSTC3fsPKqKMdJDeAZy9BrDv2w/qKlFjXwzoHrWPleN+QCFN
	 pOrwrkRfJx6FrjmYR4vz/Qc0U84FNDvLf6tb0W2I7ntcJs10+DYJx7a0jAfUJ2EG8uQN0
	 /URcVZt9JMEKeKoL0H85mEq5xJH29gYGISSdJtezq+XRXdkNdCDDKnBSMfcUBciEa4QW3
	 /PCGT3flLHCRA7chLLZFWPr4+ILMlsH7pHEnvKwImOPbhMl9cBVps7YY00L4cTrwQgw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=b4EAyd5R;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 290D2606A326;
	Sat,  7 Nov 2026 14:29:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=b4EAyd5R
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C64691F0089F;
	Sat,  7 Nov 2026 14:29:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061795;
	bh=kKBGLMEoqYIU3t7ju6aiMSjAE/7bvfkpVsaI9qMUebg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=b4EAyd5R4Irqa/hAxmNe+HOa2sqa4GWQpVvHQLKXbgIykGQr+RzAibxtj0pnIVV1o
	 8xq7tuzmJscnZrysUBEsXBn6i8geLT1Rw+ydcJfSqRSjE3zQfkX+YoEOG+DV7UPXvz
	 3dC5lHHVHSzwMt3lUxb0ePQwIhJY+MrHhUZT6n5g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	VEGA <vega@nebusec.ai>,
	Zhiling Zou <zhilinz@nebusec.ai>,
	Chuck Lever <cel@kernel.org>
Subject: [PATCH 6.12 0787/1536] SUNRPC: trace an accepted transport before publishing it
Date: Sat,  7 Nov 2026 08:46:43 -0500
Message-ID: <20261107135019.645319461@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -797,8 +797,8 @@ static void svc_handle_xprt(struct svc_r
 		newxpt = xprt->xpt_ops->xpo_accept(xprt);
 		if (newxpt) {
 			newxpt->xpt_cred = get_cred(xprt->xpt_cred);
-			svc_add_new_temp_xprt(serv, newxpt);
 			trace_svc_xprt_accept(newxpt, serv->sv_name);
+			svc_add_new_temp_xprt(serv, newxpt);
 		} else {
 			module_put(xprt->xpt_class->xcl_owner);
 		}


