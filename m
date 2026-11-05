Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=103.168.172.145
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793893127;
	b=uZLH+OaheDdDBXx0kr/1zVBAL4lZC6DSjDqWB34WHi0I1BnP22AM5DTiootTpUIvdNWC
	 8WUeHrVRYjHpp58DOYhwQePUXWSI1cLDG2J5PN30iA7++w7n+tXIHpfZAJHyqdHJG21EK
	 IkFgseoHhJpmAQ/EmzJQZchGvixHmL3qYOSE55cXB/UyL8Z4Krlg+qS8eY5E/NvN3jcqF
	 7x0nkXjr3cUkq5LJ4zhiSAl+FoPG2yd4ypYC41GRbi+rtOtDp8Z5rSBteUFu2Sdlf55Mo
	 EuSRzP/4vUiXc//DS490oy1PJ4Gmhms9Yd/FocOlQEuH39yntIYMMy61ROu9dBsGkGA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793893127;
	h=DMARC-Filter:Received:Received:DKIM-Signature:DKIM-Signature:
	 X-DKIM2-Info:DKIM2-Signature:X-DKIM2-Info:Message-Instance:
	 X-ME-Sender:X-ME-Received:X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:
	 Received:Message-ID:Date:MIME-Version:User-Agent:Subject:To:Cc:
	 References:Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=5GjUFtQ3qIkFoEOBZJE7rM+byC57+3IYC5MxETSm0y4=;
	b=J5Id+00eWUn6T+G/Y6+u4VWfhXqtJh82qXcJHtt0Ws8YQWXTE7CP9BfvveHUeKCj5srk
	 u3ommmlXPTM1Nxg/I9ikNr6raf6hUXJsppw0VKevZ4S4aYUFVYpiidkB1n8twe6gnl6Q0
	 iJGfDMPA/N7V80Eu/9wLojICIdVwQEGvDy2cQXmQLLZ+1bbTkyjEJE+lRkALc6g2xi0Pv
	 9PRRdDfe3vRTe/6F3G/WYe+RiFue+Of9hYjUNKjUAyu1h0tYb/LRTzqYqg9L9h4rsfqJM
	 K+3piuVNtXTTzFQP1/I0EUpBiGZdXvRakguR/b1as40Dw6F/0wVsOazaCne7MLK9GVg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=pobox.com;
	spf=pass smtp.mailfrom=pobox.com;
	dkim=pass header.d=pobox.com header.i=@pobox.com header.a=rsa-sha256 header.s=fm2 header.b=gB1lqX3Q;
	dkim=pass header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=mlgN1cWO;
	arc=none smtp.remote-ip=103.168.172.145
Received: from fout-a2-smtp.messagingengine.com (fout-a2-smtp.messagingengine.com [103.168.172.145])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7035A606A336
	for <patches@lists.linux.dev>; Thu,  5 Nov 2026 15:38:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7035A606A336
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pobox.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pobox.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=pobox.com header.i=@pobox.com header.a=rsa-sha256 header.s=fm2 header.b=gB1lqX3Q;
	dkim=pass (2048-bit key, unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=mlgN1cWO
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfout.phl.internal (Postfix) with ESMTP id BCFEFEC0609
	for <patches@lists.linux.dev>; Thu,  5 Nov 2026 10:38:45 -0500 (EST)
Received: from phl-frontend-02 ([10.202.2.161])
  by phl-compute-02.internal (MEProxy); Thu, 05 Nov 2026 10:38:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pobox.com; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1793893125;
	 x=1793979525; bh=5GjUFtQ3qIkFoEOBZJE7rM+byC57+3IYC5MxETSm0y4=; b=
	gB1lqX3Q4Ga8QwDwaC0wNp/D5T/5LVP6pn2BAozsAhpyyK1CMVTEkW4hRTD/QT0K
	oNHG3dP/OjbGxEgwS/C9EXX2kyjDVN59WYSc0EJiyfb3x1WBZ6NKzP2uNhUZSQjJ
	wqpf1Wplg0iIvIC3lhofxElc5kuXNlXWbxDwHzL46xBXK/i58rf0zZ0WmAxfyupf
	IYzJv4gv24GLzkIyutcekR+JsCWDWlcXVv69fQpvwBBwCXVlC5GyX6NiikFBlkn8
	NKjXc+Fn8Mk1pXV0IQhrR1xXqGJ/N+GTrACi4gQXlqwJt+/yKBX83UnQq66W1U62
	nmdtSlmVwjjnKHM7KGhVtA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1793893125; x=
	1793979525; bh=5GjUFtQ3qIkFoEOBZJE7rM+byC57+3IYC5MxETSm0y4=; b=m
	lgN1cWOaKuDgYsoboVzbQPHmrtYypLvBa1YlVoKSEow/7t+oMApTu8VAMmGtcLoC
	K2xv9r4r7EQ3qVERQF4yYsBeFlpsrpvY+nPQIVvBuAamxdouz9C8LZEnW6G5PHdH
	wZ008RTOQafF6JhVZykzOZ/Adbtdx+NsJWKmeBkNRjxyvgsH8n5qdnwvjqz50Mo8
	6iq4gNmt+3ijn1NiDiFb0POmcKG8uUl1vLHKitRZ1M7Lsmwp0jf3BsNN1+DEwwUP
	4gHnn5K71LHxTHVEq2rxEY7QuP1ye3tTz2+t5rPU1UvwQZaMDsoJ+yu5DpZyz20p
	E/DIwreb4KXdmSWUFXx/A==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=sign d=pobox.com a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1793893125; d=pobox.com;
	mf=PGJhcnJ5bkBwb2JveC5jb20+;
	rt=PHBhdGNoZXNAbGlzdHMubGludXguZGV2Pg==;
	s=fm2:rsa-sha256:dbA0UVLUak+7vsWKSFJsPyM2Fw8Q+oweSICNNVehgn8heWA
	Kjec9DAoe1L1uPDJkNIIGn2bUEyLj5zrPLkr9NqCK07DhPK0+Gh6O5M+nitpOaik
	DHsqjHbhIvo/OfNdRSvcedlQx4FP8B/hecCnyONIxeCXMt22bFEOnFTb3BhuiZTS
	62dcF2ylFciP3wWOK/FQteBX75kAfacMNfgeXr5yGgIk9wlEHdl72s/3RPYXeMme
	RckIyQ1B0MWQ071TUZFaUJihKxWdHQzou5Rh6ectnVdK54PYkM6oV7RGqLU/Etzx
	rjzyvjHDnl9khQAbquKc15XMEYxDLAhZbRyGt2Q==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=mi-m=1; hc=14;
	hn=cc,content-language,content-transfer-encoding,content-type,
	date,feedback-id,from,in-reply-to,message-id,mime-version,
	references,subject,to,user-agent;
Message-Instance: m=1; h=sha256:ai9rMORArZ9yF592+y0LVuxW4c+ZkjeFxDLeO6goDTY=:ZzJAcskJO1M+4glaiBQvKYysgOB1oj78pQatTubnZr0=;
X-ME-Sender: <xms:BaPsaslGIXSdBIVmhsAxxdknA8b8r2s3f0qHwyQ2LPM6wAC7x9c9GA>
    <xme:BaPsalIp_crXiytVWHQqQc5wxPJXv79a4eyffPrszXbbCgqdMtHVmwNesYiwoo-3q
    ZkV4qe84j2N3H8bURBO6JAwHdjkwa1Gw9fa-xxabgWvJmJBrTibkmym>
X-ME-Received: <xmr:BaPsah4T-HrPHMzhVe63nGHGDB45ql7NXmctDN5LRrJ29o_I26NuqBJDu_r5OZhn6c5O1PAywicJc1p8I73ZbJxilD6Zo-80>
X-ME-Proxy-Cause: dmFkZTEIWcxOppbdGW0iFP434fPLloGfCm3GEWGVcOS1MyIKUUR1qXIk3pgdbBVO6je9/e
    e9PJIfdHcB/DrdmernCjm69g58y0qcvFeO3f6b9wDFBfewNFWkT8s/FW0WHRAZXnQWrNNY
    eqWf3N/T5cDos8hzwfT4W5RdmfnTFAoELpupqio6DwDSIBI0P//9tIKKgSR8mp0ifp8xcQ
    2q35a2VgzBBKR9wLSGZZu6bX1ZUqExYyv/dFzAAarJH2w+st24Arbe2cTTGxJNwp5XaHxN
    VRZUszxJBTQfzWh+PxnQxp2sJjofySU6n5Z4qg1Y89aL/OKyNW6fCOF3DeL5mERFvs/Dmj
    f8gADqlc5kuOeM3IrDMY4XvGoQdlv/0LuBQ/jjke05Kf/gWWzHfUzm+dOKPdtqxqeJODDR
    zEKmdqYIEydRtJLYthNDVdltYSPtKTOm6VauoFJFuVYB0gxqB9uQB4RXWs603vQA9rPKH4
    bVedOsXebfYrp8rLUF6H2Jd57PZNb4nygZKToM6DkxNMZpaOHROKqXcUti3dlOwX034Fzj
    bdyyx7BoRvgWNURz8WEkNBiIZWhEpllfPhv7ywn+EY5RE6RyKt1ItORaZfJLeDfvT+APGd
    ZFMaw/AQgVG7ZbufR0sLsaw3n6Q9vZAdPQsoGT20AEbvLwB/deSGYLrRbbXA
X-ME-Proxy: <xmx:BaPsap02pW8CKfRub7P4oLvltGHtyCbICEYCE5Rl7mWvBMQFdhJNIA>
    <xmx:BaPsanfFLYWiN3QQhqpGkw7UrTpJZHVA5_3dBW8h4YBNBPkBGf9b9g>
    <xmx:BaPsavcBaA7HE6EtWNyaaLOi2opGOTxrEVn6nij9Hg9wtNsNaYNZ5g>
    <xmx:BaPsaiycBIG1sZE8wqQsqDsIsscpXQmleNUTEcIb1il5EohnUpWhVQ>
    <xmx:BaPsamy6RIIba4tZOVEvI4IY0fK0smak0BjVoYfNMH4e8rkyZOiNMIgT>
Feedback-ID: i6289494f:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 5 Nov 2026 10:38:44 -0500 (EST)
Message-ID: <194b6b81-1521-4dfe-b86f-c693917bb78e@pobox.com>
Date: Thu, 5 Nov 2026 07:38:43 -0800
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7.3 330/547] xfs: cross-reference the primary superblock
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, "Darrick J. Wong" <djwong@kernel.org>,
 Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>
References: <20261104211038.406938024@linuxfoundation.org>
 <20261104211047.605532149@linuxfoundation.org>
Content-Language: en-US
From: "Barry K. Nathan" <barryn@pobox.com>
In-Reply-To: <20261104211047.605532149@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/4/26 1:08 PM, Greg Kroah-Hartman wrote:
> 7.3-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Darrick J. Wong <djwong@kernel.org>
> 
> commit 0c61016006ab08f8346f9e7b1e38559bd4ea499e upstream.
> 
> Make sure we cross-reference the primary superblock against the rest of
> the AG 0 space metadata.  Drop the unused @bp parameter of
> xchk_superblock_xref to avoid complaints about uninitialized variables.
> 
> Cc: stable@vger.kernel.org # v4.16
> Fixes: 52dc4b44af7419 ("xfs: cross-reference with the bnobt")
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Carlos Maiolino <cem@kernel.org>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>   fs/xfs/scrub/agheader.c |   15 +++++++--------
>   1 file changed, 7 insertions(+), 8 deletions(-)
> 
> --- a/fs/xfs/scrub/agheader.c
> +++ b/fs/xfs/scrub/agheader.c
> @@ -35,8 +35,7 @@ xchk_setup_agheader(
>   /* Cross-reference with the other btrees. */
>   STATIC void
>   xchk_superblock_xref(
> -	struct xfs_scrub	*sc,
> -	struct xfs_buf		*bp)
> +	struct xfs_scrub	*sc)
>   {
>   	struct xfs_mount	*mp = sc->mp;
>   	xfs_agnumber_t		agno = sc->sm->sm_agno;
> @@ -106,16 +105,12 @@ xchk_superblock(
>   	struct xfs_dsb		*sb;
>   	struct xfs_perag	*pag;
>   	size_t			sblen;
> -	xfs_agnumber_t		agno;
> +	xfs_agnumber_t		agno = sc->sm->sm_agno;
>   	uint32_t		v2_ok;
>   	__be32			features_mask;
>   	int			error;
>   	__be16			vernum_mask;
>   
> -	agno = sc->sm->sm_agno;
> -	if (agno == 0)
> -		return 0;
> -
>   	/*
>   	 * Grab an active reference to the perag structure.  If we can't get
>   	 * it, we're racing with something that's tearing down the AG, so
> @@ -125,6 +120,9 @@ xchk_superblock(
>   	if (!pag)
>   		return -ENOENT;
>   
> +	if (agno == 0)
> +		goto out_xref;
> +
>   	error = xfs_sb_read_secondary(mp, sc->tp, agno, &bp);
>   	/*
>   	 * The superblock verifier can return several different error codes
> @@ -430,7 +428,8 @@ xchk_superblock(
>   	if (memchr_inv((char *)sb + sblen, 0, BBTOB(bp->b_length) - sblen))
>   		xchk_block_set_corrupt(sc, bp);
>   
> -	xchk_superblock_xref(sc, bp);
> +out_xref:
> +	xchk_superblock_xref(sc);
>   out_pag:
>   	xfs_perag_put(pag);
>   	return error;
> 
> 

This patch is breaking the build for me with CONFIG_WERROR enabled,
for both 6.18.61-rc1 and 7.3.2-rc1, on both arm64 and amd64, when
I compile with clang (I tried 19.1.7, 22.1.8 and 23.1.5). It only
happens if I build with CONFIG_XFS_ONLINE_SCRUB enabled. However, it
doesn't happen with 7.4-rc1, and it does not happen with gcc.

fs/xfs/scrub/agheader.c:123:6: error: variable 'error' is used uninitialized
       whenever 'if' condition is true [-Werror,-Wsometimes-uninitialized]
   123 |         if (agno == 0)
       |             ^~~~~~~~~
fs/xfs/scrub/agheader.c:435:9: note: uninitialized use occurs here
   435 |         return error;
       |                ^~~~~
fs/xfs/scrub/agheader.c:123:2: note: remove the 'if' if its condition is always
       false
   123 |         if (agno == 0)
       |         ^~~~~~~~~~~~~~
   124 |                 goto out_xref;
       |                 ~~~~~~~~~~~~~
fs/xfs/scrub/agheader.c:111:13: note: initialize the variable 'error' to silence
       this warning
   111 |         int                     error;
       |                                      ^
       |                                       = 0
1 error generated.
make[4]: *** [scripts/Makefile.build:287: fs/xfs/scrub/agheader.o] Error 1
make[3]: *** [scripts/Makefile.build:544: fs/xfs] Error 2
make[2]: *** [scripts/Makefile.build:544: fs] Error 2
make[2]: *** Waiting for unfinished jobs....

I bisected 7.3.2-rc1 and this patch is the culprit. Reverting it fixes
the build on both 6.18.61-rc1 and 7.3.2-rc1. Another possible fix, which
built successfully for me on top of both 6.18.61-rc1 and 7.3.2-rc1, is to
cherry-pick commit 612d2e7506c3553b1deedc694846d1c0364ae446 from mainline
("xfs: read primary superblock from disk during scrub").
-- 
-Barry K. Nathan  <barryn@pobox.com>
