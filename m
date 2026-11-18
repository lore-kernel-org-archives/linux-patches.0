Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795044595;
	b=5en/xQnjPFs19zKty6GW4UWdNDFQR0nwGAAVo7tXKahZ7EljkofEbwe5V3WhI9+6ul2A
	 kxqkwvPPY3pij9gfBRtPf0sCOeG/IXPzlf+7B3Io/Jbzz+H5s+5jy/ECGXub2THaJVfaZ
	 AUZvSwpIWO7N6KSdgZcUnRbZujU1dkoI68E7eP1cdlXWpSis6yKMLdhSFy/zDxJhxD3rg
	 gLKjL3h2ZKpDsMZZFs/+G3DaOxsFSfjlbbmImc/BHLbwrEPNVm0AZAoib2M58Bw5KUGX4
	 1X7iiK5nGmULVhahEd8fx8UOTR9Dn0phlvahh92Ujb+YoFhey9nraNbOW0ZhU3eEy2A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795044595;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ikso0pw8ucFWwdwreZhv6FFFCB1Xr+J6sSULC8f39tM=;
	b=X/Z/sXxXocKE88peUfrYV2yPFEtHaQIpwJAZtbIy2AhEg4qEHsc13w/aWaBBrF6Jzamd
	 oKZ0yUKDF/FguKx9E67hp1uOM+BDGbH9998pnyBxZRCWQD0LFFaQDpA0a5k4byvQ1II0A
	 Eil/pOv6E1nG2WuBHmGWYGMj6M7nJKYIq2C/EcliGd+9drmpIA10uLLPoYWFxkYzbdm/V
	 RT1YKUSI+RtlLBHLlyNTWbboKHxlZhyER5YR8bFwofbJw1DzRyw1nZcNy3fzmYLs1GbIf
	 z769bZjKmrgFbXrKQfk8TuPBVyWf2xcxZyFox77KbzgP3WV6x4ubinCtFJMH3LO7jOA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KSVVFQl5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04C9E606A31C;
	Wed, 18 Nov 2026 23:29:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KSVVFQl5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D9041F000C4;
	Wed, 18 Nov 2026 23:29:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795044594;
	bh=ikso0pw8ucFWwdwreZhv6FFFCB1Xr+J6sSULC8f39tM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KSVVFQl5tocQh3QtunHQ3gKEQEkaDyyaKFiRaqwNwy/A/nKBcn0eZG4zcVzpGPLTC
	 BUpuHFbsQ8X51OrNw6qENzC4Z5b31ea/sUlbGmy7c6uw2hQRyzjuvN0OOcaRKB5ko+
	 Xxdjx3RxrQwz0P6qNycABPVaYitU04sWlSI6M64o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	VEGA <vega@nebusec.ai>,
	Zhiling Zou <zhilinz@nebusec.ai>,
	Chuck Lever <cel@kernel.org>
Subject: [PATCH 6.1 0620/2857] SUNRPC: trace an accepted transport before publishing it
Date: Wed, 18 Nov 2026 15:27:34 +0100
Message-ID: <20261118150223.813360140@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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
@@ -831,8 +831,8 @@ static int svc_handle_xprt(struct svc_rq
 		newxpt = xprt->xpt_ops->xpo_accept(xprt);
 		if (newxpt) {
 			newxpt->xpt_cred = get_cred(xprt->xpt_cred);
-			svc_add_new_temp_xprt(serv, newxpt);
 			trace_svc_xprt_accept(newxpt, serv->sv_name);
+			svc_add_new_temp_xprt(serv, newxpt);
 		} else {
 			module_put(xprt->xpt_class->xcl_owner);
 		}


