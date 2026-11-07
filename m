Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=202.12.124.155
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794056996;
	b=Mq+HDFAEeMdVI3DjwSWCwL+EYinXJYsDFnPu16JVec22E2AL6qEEFEzBY0yO7HEN8lJt
	 U1gYB87hoksFM/eQPYg1vkS4K78YWvA4ChLzWKR8+tbXaIWTpFUoAG8yq0Z1HatxWjYG2
	 M9OgmWOd8qcWkIhisNesmMAUmfTqBIlr3VOyJ+sNjnABh6BQiboTwAcE8NTay8FNrlcIM
	 OdCz80LGDfp/drWS3Me6PkX/vncvu0bCxPhn+0E0NdeDhF2LNZnGD/IBkpKnHobTZQc/g
	 rZPwZYqCgZSFLf0kzHWrOPE7blLXoyjjzACofSNXo1QAZvO/SH2YaNisfh5jmMNLL5g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794056996;
	h=DMARC-Filter:Received:Received:DKIM-Signature:DKIM-Signature:
	 X-DKIM2-Info:DKIM2-Signature:X-DKIM2-Info:Message-Instance:
	 X-ME-Sender:X-ME-Received:X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:
	 Received:Message-ID:Date:MIME-Version:User-Agent:Subject:From:To:Cc:
	 References:Content-Language:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=9l6rdHhASisWsN17Qt71S6XsJq5+Km/0GXmn4dRBL98=;
	b=o5dPRxxyulDFFzwnYoWPR0Bxr+jmTNYUiQkgPs/9roS9kSHTVgkOY1XdrR9+UQELVdSa
	 UwH+KKFgV2V4VxIuM4OJ3zt/E36TLK/+Y/zs7BXDvmtbVcZWronibqw77fE/zEMl8WKeL
	 naM6O8VI9ai0CjWyVNIHfYUemC1yN+PiyEVV9PLZCyDPogxEtWPx6JrasJUE0/Iyy2ykp
	 hvCOMwFEzuuxEam9YOwLIIMtGnMR+9Lzatzquh7sTS8EAEYcPheUH7YOKYWx35cgq2lIH
	 ewiWYrngGuT89tPPO8GzCsIxQp9lBDKIvtCEACCxfyaZyEDvulcQdbsufusnczqkhdQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=pobox.com;
	spf=pass smtp.mailfrom=pobox.com;
	dkim=pass header.d=pobox.com header.i=@pobox.com header.a=rsa-sha256 header.s=fm2 header.b=bnYisetc;
	dkim=pass header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=DkJWQI4a;
	arc=none smtp.remote-ip=202.12.124.155
Received: from fhigh-b4-smtp.messagingengine.com (fhigh-b4-smtp.messagingengine.com [202.12.124.155])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08753606A326
	for <patches@lists.linux.dev>; Sat,  7 Nov 2026 13:09:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 08753606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pobox.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pobox.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=pobox.com header.i=@pobox.com header.a=rsa-sha256 header.s=fm2 header.b=bnYisetc;
	dkim=pass (2048-bit key, unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=DkJWQI4a
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailfhigh.stl.internal (Postfix) with ESMTP id 2B7027A012A
	for <patches@lists.linux.dev>; Sat,  7 Nov 2026 08:09:55 -0500 (EST)
Received: from phl-frontend-01 ([10.202.2.160])
  by phl-compute-03.internal (MEProxy); Sat, 07 Nov 2026 08:09:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pobox.com; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1794056994;
	 x=1794143394; bh=9l6rdHhASisWsN17Qt71S6XsJq5+Km/0GXmn4dRBL98=; b=
	bnYisetcchZTe4wu+vofZEUXCSrUxCJ2qEENcqpU9O1RU76ECQxadT7liEAE8Jqo
	DAZ2vZ4GoFhTbaDoyhy7EXJJx5ooiHphTFYGXMcM8bRATHMR7AkgxI1eu3eLiZ2K
	e3hksrUwlv9hXixvK0YsdykBQTimlUOp9b8z6kdXOHSFK6Km5rmRhvCXmDQWEIyn
	3FPd1XY5ZJoUF0wcuisBR527pAi2ePLEYVrdkFqG2d5kv+w8VhXACFLxnpkJq6R7
	jgduA9xn6xa58G2bA9A/qqZNoDQyJ8Yv6eKTIlF5cUHiMlqAkaCsHbgdgb/XP+dP
	BHx36ud+AyusSBidHTqn9Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1794056994; x=
	1794143394; bh=9l6rdHhASisWsN17Qt71S6XsJq5+Km/0GXmn4dRBL98=; b=D
	kJWQI4ayo2qE3873jm+PwAX16r1YqT5c3R8LNHqKr9ctSBqY6PxYkZ73NBtQUrfk
	o0lf3miB03XABoTvifPLq1dp+xC5Qjz2WCRuYm0aajFIoeR60pIHY3rCQHb+ygIn
	IBaKWI9EJB/o/3jFAVVuDKr7RivCGWV2KgaK3rtcG1GFNI7hbEGMXEMxtS0bv59X
	QxgofF3U3Y/9e1qVApyPQdJprR7gKhG8BbtQY6w1+RjsnxmXSR21Xzw98o0K/SJU
	vaV6ab5kNUHbJ/D5iUceHk9IdLwKLIbMBJZkpZwsDGKCSR+DSjjf/gZTlUnBLWHf
	h1K7Y9UVdiCT1D8wsgG+A==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=sign d=pobox.com a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1794056994; d=pobox.com;
	mf=PGJhcnJ5bkBwb2JveC5jb20+;
	rt=PHBhdGNoZXNAbGlzdHMubGludXguZGV2Pg==;
	s=fm2:rsa-sha256:ffMx104ZZMxVarOfQ2idJCLokUwDD1ZhyqyV2p3E1p1w3kn
	7KGpmbXF21ZSpla69DxzDg32L00Fwdyr4kzN2Y5nB5sbhFAIBin804bEIxMSpRb6
	of9FKJ+DDZz/9Mu70iPzlTMBsvtM4tvzg1GhuVEZ2720cy6idRK8iL2nWcf5zR8b
	irJLaV0iO+pwJ6sNuPPT35Agd/BHmuOySwwh4fhFHT3oinfwrxCPwUBzK88lz1Wy
	pA6VnC6sA7Q28YAL/w1aWHLFyGdVOsCPlV75uYQx8NYqlZO6tlwhr84cOLTTnmVQ
	QautZ4D1Z0St0lQHJH16tpdf3mDrkkLei/yh6iw==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=mi-m=1; hc=14;
	hn=cc,content-language,content-transfer-encoding,content-type,
	date,feedback-id,from,in-reply-to,message-id,mime-version,
	references,subject,to,user-agent;
Message-Instance: m=1; h=sha256:qVyn+63do8ljrgQhFNlI+etN4PtLLJeZC39Z3V4hS4k=:r9iUrbBlc3jb65H1OpY/dV4CzN6MdQ78M1pnTbPNiHk=;
X-ME-Sender: <xms:IiPvarp4tSJUxEe3tQJbb-aPui8r_cJqmQ2yHp95_yPkkOXKAAa7LA>
    <xme:IiPvau_yIE3WjgMDa7EmeI7Xmltv4DQa30yN2Dp1Rg7s1voB5JX3U6cWPYF_72OY3
    bwgVwnbQJO0a0aaCngXhuLxtR9JSBrbuictTDbeDc-Es_UH7gtnbP_M>
X-ME-Received: <xmr:IiPvavf4Ew7xsAbdHi6SenUyEfmmff_n8S9ahuD-bxMrisSlf3VkRSmN5g6liFHhXJbXTBoiT8kx5zg-YTxtjUDu5X_H7ZrA>
X-ME-Proxy-Cause: dmFkZTEf+pFFFTVm3IEswDBYBUXTyc5+3mbJR+ZuoAU8Cjj9jinNQlbXf368IsalONSUbf
    nfjOlqOW2zP5HJRFL6HOPPg1CGM1OdImorLj6srsgAEZcvh7TQsolZysBHNcWPYFInVe0m
    uL5Ya0P9Pu/Fa3nEE36xBp1xOmeSFBPVKORd7gHlFn3vBzTt37CvCK31fQBbwKQe5eGSkX
    lZSyBQNBQ57Dxdviao1WMMEVzzMYUxF5nMBp9JqcyVhkZ5N1FhNWLTmCqISoEjhe/yrkXy
    EPYHlI4W1nC1tkKZ7a8UXwUaJVc/4krcoFxB35eE1JGyylpSyjpBQmoyT4E0ALpuw4tkDy
    40rCpE7UPR92upKy0BiEStxHcwmlGtO3AOAGPxOAbWawgZ/vR2ueG3vL1p7iyKYR/ofzdK
    Hx6Ka4rV2aZ94iZjK8P3YTTe6LIfpE49tBiJRNqtLMPOEbf8dvg2POFedjiajl105p5Tyr
    2V7JNOjKocO/cUYCrNwoOShi+J8eIg+tR5RlIqBCGkq5LYqhyyrRjSIuRdm2qv+ESy+Ydr
    DZQORfYswbwFoyhpzEtDhXAT3eczVYd0y77c46tYoY1L8xuRTRDdNMj6ZqmmvWfreLQ4Y1
    txI71b6ZteQoCy/SQxdCFoalCfcx31W2mXeoSXbg7MsLv5mkz6r9gT3zjpRw
X-ME-Proxy: <xmx:IiPvagIKEzUOyU7R7q6hpj68fOwZ8_bP4oEWehN3dAxfxEdpsxkE7A>
    <xmx:IiPvaniF-bdqXMeP-PwHjY0YZZaMdp4xJpMmQi_8eQ0-76QXKt1t9A>
    <xmx:IiPvamSolZxuYLG_oNnVLIxOf_cNMCNOqT8OXJKuuNIObUwPeBRdvg>
    <xmx:IiPvapVmdgAdrFTw3vM5u_4dP-Qkx30YXlEfMM7hMTEa-Qi59T4Rzw>
    <xmx:IiPvak1otailYMnADYBo4E5aQJ7LbB1Odo8nKY86veDghLPZRr7eM27t>
Feedback-ID: i6289494f:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sat,
 7 Nov 2026 08:09:53 -0500 (EST)
Message-ID: <7840e515-e7d5-4ef9-8c1d-6390374a5b33@pobox.com>
Date: Sat, 7 Nov 2026 05:09:52 -0800
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
From: "Barry K. Nathan" <barryn@pobox.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, "Darrick J. Wong" <djwong@kernel.org>,
 Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>
References: <20261104211038.406938024@linuxfoundation.org>
 <20261104211047.605532149@linuxfoundation.org>
 <194b6b81-1521-4dfe-b86f-c693917bb78e@pobox.com>
 <15a1f7c4-3110-4a2a-adeb-cd1e97d5b6c3@pobox.com>
Content-Language: en-US
In-Reply-To: <15a1f7c4-3110-4a2a-adeb-cd1e97d5b6c3@pobox.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 11/7/26 5:07 AM, Barry K. Nathan wrote:
> On 11/5/26 7:38 AM, Barry K. Nathan wrote:
>> This patch is breaking the build for me with CONFIG_WERROR enabled,
>> for both 6.18.61-rc1 and 7.3.2-rc1, on both arm64 and amd64, when
>> I compile with clang (I tried 19.1.7, 22.1.8 and 23.1.5). It only
>> happens if I build with CONFIG_XFS_ONLINE_SCRUB enabled. However, it
>> doesn't happen with 7.4-rc1, and it does not happen with gcc.
>>
>> fs/xfs/scrub/agheader.c:123:6: error: variable 'error' is used uninitialized
>>        whenever 'if' condition is true [-Werror,-Wsometimes-uninitialized]
>>    123 |         if (agno == 0)
>>        |             ^~~~~~~~~
>> fs/xfs/scrub/agheader.c:435:9: note: uninitialized use occurs here
>>    435 |         return error;
>>        |                ^~~~~
>> fs/xfs/scrub/agheader.c:123:2: note: remove the 'if' if its condition is always
>>        false
>>    123 |         if (agno == 0)
>>        |         ^~~~~~~~~~~~~~
>>    124 |                 goto out_xref;
>>        |                 ~~~~~~~~~~~~~
>> fs/xfs/scrub/agheader.c:111:13: note: initialize the variable 'error' to silence
>>        this warning
>>    111 |         int                     error;
>>        |                                      ^
>>        |                                       = 0
>> 1 error generated.
>> make[4]: *** [scripts/Makefile.build:287: fs/xfs/scrub/agheader.o] Error 1
>> make[3]: *** [scripts/Makefile.build:544: fs/xfs] Error 2
>> make[2]: *** [scripts/Makefile.build:544: fs] Error 2
>> make[2]: *** Waiting for unfinished jobs....
>>
>> I bisected 7.3.2-rc1 and this patch is the culprit. Reverting it fixes
>> the build on both 6.18.61-rc1 and 7.3.2-rc1. Another possible fix, which
>> built successfully for me on top of both 6.18.61-rc1 and 7.3.2-rc1, is to
>> cherry-pick commit 612d2e7506c3553b1deedc694846d1c0364ae446 from mainline
>> ("xfs: read primary superblock from disk during scrub").
> 
> This was reverted for 7.3.2, but I see that it's back in the queue again
> as of stable-queue commit 77ecab77b25567c54df997dcb8030dea6bca03ed
> ("Fixes for all trees"). I just tried applying the queue on top of
> 7.3.3 and the build error still happens.

Just to be clear, I meant "dropped for 7.3.2" not "reverted for 7.3.2".
(Sorry I didn't catch the mistake before hitting send.)

> Since the mainline fix is not a stable candidate, maybe something
> like this (just initializing error to 0 when it's first defined)
> would work? (This fixes the build error for me, but I haven't
> tried running it yet.)
> 
> diff -rup a/fs/xfs/scrub/agheader.c b/fs/xfs/scrub/agheader.c
> --- a/fs/xfs/scrub/agheader.c    2026-11-06 22:42:57.147299404 -0800
> +++ b/fs/xfs/scrub/agheader.c    2026-11-06 22:45:59.898908897 -0800
> @@ -108,7 +108,7 @@ xchk_superblock(
>       xfs_agnumber_t        agno = sc->sm->sm_agno;
>       uint32_t        v2_ok;
>       __be32            features_mask;
> -    int            error;
> +    int            error = 0;
>       __be16            vernum_mask;
> 
>       /*
> 
-- 
-Barry K. Nathan  <barryn@pobox.com>

