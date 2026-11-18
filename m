Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795035443;
	b=JIzFzv84Ptqvu5QoRiggqIe1MRB+yHrVzcCkeQIgQMvat84TKKKarTAAsaULqoAil+WL
	 pIcpyaU+giF5sGjFPNUA+3QsFupEcKignloQ3OSvQ+ZYFY+YaJ1UcZOncuFJS5UgJV1qc
	 8HNu3JTRSLpCM/r7RhTw9+AD8hZmP9/5iDjyxJlJl1kmkWNvgzSaBH/dalIpZQRRQECx+
	 z6VrXXlZZCzssJl/J+eR/EMBPawxY+fbEPTK7zVzW5ZsVxG81y4ljpFXR4cJRkfG4uOEF
	 AP/v47dWkrX3794xVYr9m8xfSZjBUVmkYnVTlIn1/u7E37DJG+gJBITT/We4GEsUjAw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795035443;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=tRNATnpDfhj3W6kMpdIBtMCLgIjSkqbqvMiKNK9oIFg=;
	b=biXwQQW9K3oFAmK6jxDN6xyEH32KsHErzctVeAWdTV5MD1dc1/YnvF+ohBtGugmMrApo
	 22xMegC5aVQlyiMAQrZmwM+8UFnmFllpD1F+wYwe3RTpJXL1qs7zz37eScftaAwBHCWGe
	 jTn9PiRoOL2Tfl7uVysdaR9Zh+udHKbtE1AwbQZ1QJDUeHDCKlPNcoj1uW2sYvUBq6wak
	 bNxm2PNu8NyJukwE/82jcWGbmvd2tLidtU7JUXnN9wtmsmN85U5foiKyH+96+EMMiNRLR
	 P7V2t6naxSk3fMDtJNq2gnX/00hkY/dF4AUWDljBLHC419lcI9NpUch6asP0fyHnPHA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QHQW3bwo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FEAD606A320;
	Wed, 18 Nov 2026 20:57:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QHQW3bwo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3E861F000C5;
	Wed, 18 Nov 2026 20:57:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795035443;
	bh=tRNATnpDfhj3W6kMpdIBtMCLgIjSkqbqvMiKNK9oIFg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QHQW3bwoSnFC1HjUqQ7kGImKHT9G72EjPUInaIvohEESPStcnt1v1DfvCr6kiLSme
	 C25B7cPlUG7Dly2rpyOIBIm/9LMV8mNY1ILezXpRVFdYIkrc5haS92++cF6IGvXl3P
	 N9sGgcu9qdiKpUeSiSkaNnIZEKYtML6pH05r4Uhk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	VEGA <vega@nebusec.ai>,
	Zhiling Zou <zhilinz@nebusec.ai>,
	Chuck Lever <cel@kernel.org>
Subject: [PATCH 6.6 0707/3318] SUNRPC: trace an accepted transport before publishing it
Date: Wed, 18 Nov 2026 15:22:09 +0100
Message-ID: <20261118150339.611716378@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -807,8 +807,8 @@ static void svc_handle_xprt(struct svc_r
 		newxpt = xprt->xpt_ops->xpo_accept(xprt);
 		if (newxpt) {
 			newxpt->xpt_cred = get_cred(xprt->xpt_cred);
-			svc_add_new_temp_xprt(serv, newxpt);
 			trace_svc_xprt_accept(newxpt, serv->sv_name);
+			svc_add_new_temp_xprt(serv, newxpt);
 		} else {
 			module_put(xprt->xpt_class->xcl_owner);
 		}


