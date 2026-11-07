Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=202.12.124.155
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794056841;
	b=dROrU4+5mOR+V7ny5OmbE2IgF2HRg+KttLTGMWlR/9gdXTnis6ENL+y+FIr7GzSP62sr
	 rAO3RE8i/pAe2T2n3VyOKkhrWeiU2/ABc2ur4rScsqpwz4BmBRtcu4ZzwF32H0qKW1fFK
	 w9WYnKYpHSyanYQxZyxtxi6UmCJ/juB2Na5bziNuQuTC3OAJCAiQaESnNRQpk8iAVUED8
	 RIs7J0Ogz5oSW+A9V1jhggA+UL03dYmuuReGndvK3gOkEEBdFU4wHqdYRPOGtSaM9REKz
	 Ev1tmEke1dqQDlmo3tb1NIlhE3PVrEHRe1jNRTeqH9jU38t+qbSL89/pBjybuYBNvZA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794056841;
	h=DMARC-Filter:Received:Received:DKIM-Signature:DKIM-Signature:
	 X-DKIM2-Info:DKIM2-Signature:X-DKIM2-Info:Message-Instance:
	 X-ME-Sender:X-ME-Received:X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:
	 Received:Message-ID:Date:MIME-Version:User-Agent:Subject:From:To:Cc:
	 References:Content-Language:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=wdDwWLw8oUqNYv2c9OvRdxGV3qrYo84KzC2YAfBYQL8=;
	b=xft8+WoifD9mv8ZvLQG70BxSYUTrh2/DxzWX/4cGOSOQddPH7QJBugF53lHf2rq8/8bk
	 S/Pwc+DPAdIBiMo9xNSq3bcEJmpWpw909sgiBZAew2LIEL+s1ZOjt4JLMfuCZGO+TCZF2
	 t+KnFPd58vxfZc/OLm63o1Zxp29dN1TEd2PCISFgSuGZjSYqXldvOehh/YWtPmcCMe/lB
	 7zLr+nvdY86F88BakZRZegbAY3zhgNvs3+qqQJxyAhvY887au4vF3PuolbG1/sfENiTCL
	 pUrGkSNJfxFIloqE8zsv2StsXQwvfLBEHZgoeox20g+buoPKXr7mME/S0cZ2g6jpRoQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=pobox.com;
	spf=pass smtp.mailfrom=pobox.com;
	dkim=pass header.d=pobox.com header.i=@pobox.com header.a=rsa-sha256 header.s=fm2 header.b=QCBDDrBG;
	dkim=pass header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=HeBlTmt6;
	arc=none smtp.remote-ip=202.12.124.155
Received: from fhigh-b4-smtp.messagingengine.com (fhigh-b4-smtp.messagingengine.com [202.12.124.155])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76CD4606A32C
	for <patches@lists.linux.dev>; Sat,  7 Nov 2026 13:07:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 76CD4606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pobox.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pobox.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=pobox.com header.i=@pobox.com header.a=rsa-sha256 header.s=fm2 header.b=QCBDDrBG;
	dkim=pass (2048-bit key, unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=HeBlTmt6
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfhigh.stl.internal (Postfix) with ESMTP id CDB157A015B
	for <patches@lists.linux.dev>; Sat,  7 Nov 2026 08:07:19 -0500 (EST)
Received: from phl-frontend-01 ([10.202.2.160])
  by phl-compute-01.internal (MEProxy); Sat, 07 Nov 2026 08:07:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pobox.com; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1794056839;
	 x=1794143239; bh=wdDwWLw8oUqNYv2c9OvRdxGV3qrYo84KzC2YAfBYQL8=; b=
	QCBDDrBGl4HPRib5N9/M8Qn2yczOah6UkCXRV2e9MAc5b8m03qffw37HkW9CEqYj
	ysmBnxPET3zWAvohpTUKylIo6GfeV9TNn6v9gqr+jdS3nsgn6Ta/3/OOiwNeFFrN
	uouuppIX4xIZbEn783DVZMHp88nODb5ynIRul8Ci8uuuk2cVpgrvK39S+TxAZlZy
	qzV3TKmt2GojjAsTJTQawEb34Yi8xJ7I3H9YDLkO0L8MYS1Xf1CrUwskoiW1yA4u
	a72onKUEzLUNqjTVrNYxdF97zlP+pDdYlaxlqOVV9nqq0AibFj7yt2LYWhd4H2b4
	gU0urxf1GqNDv36yJ8ZdjQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1794056839; x=
	1794143239; bh=wdDwWLw8oUqNYv2c9OvRdxGV3qrYo84KzC2YAfBYQL8=; b=H
	eBlTmt6/ZjYweL0Clk8pxeBcA6JyU09GhdCGvUWNLKXy+WYLiCtoAVitotkWM+z5
	j7jH6LJ6JcwVGD3Kj9eMcvSZYS/fSNd7iczE4rEEmdAsp/GjXiH7sNqx8ZgPtcZs
	08lwvm64HemJrcC+/iJ/oRnYp7+W6VET4nmBc+aJDe2AXnoQKQDWkQ5WVxq9PFZ4
	tII34jjsuFvRDbJdlr3Ps/rU8xcD6Ew3ds4q30VwhfRjO2SUwxKSC7ytF44labGU
	rHkEJBQljdqhrVyfFuzajAVGfX90LclvAUKxx6FJevlO9Y4VTRtMruZuEatM1ELv
	48O1bEpqVZ92A4ueWaayg==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=sign d=pobox.com a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1794056839; d=pobox.com;
	mf=PGJhcnJ5bkBwb2JveC5jb20+;
	rt=PHBhdGNoZXNAbGlzdHMubGludXguZGV2Pg==;
	s=fm2:rsa-sha256:WMJMYW7eBWF684Wo/Q36R2Ibdy+28s0I8Rzev3HMON824kl
	1bbqyYksE0TffWA4uR34XtDiVfYXi0aTdmoxnsdpsq5TivT1uoms653k+CpRu5s4
	dv6i3ZBQsJJWoJ8aqbtw/hPhao8i62/D8bsLggrkt0cvFcj+8/Yfe0tLum1uc/FU
	c7yRcI478l6roZjlk21NqCCqn4az+Mi79MoMI/zBdR4OGaeUlVhXWw1UvNRTqS5n
	dGRLTdXBYM5s8Gfuav4vF7AWsxSruNTccB9KvDrZpKyIuDEZgws7J0IUEBAVHi32
	NRpW/n54g8DZW0nH8rtnHGlTu7Ioi1XakrnbzWw==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=mi-m=1; hc=14;
	hn=cc,content-language,content-transfer-encoding,content-type,
	date,feedback-id,from,in-reply-to,message-id,mime-version,
	references,subject,to,user-agent;
Message-Instance: m=1; h=sha256:6U5cuYk01P+q++IbdD57gkCorrr3EvkXwHQISqZSVts=:aNs+jOg3Cjx4FXZRYFcy9YR3rt7v5jpzbDoD9+18gqU=;
X-ME-Sender: <xms:hiLvaoy6u6VYdotBfcFDmLBpYbDxeqEoU68hE9CBSn4Hc-jjO1INEw>
    <xme:hiLvalmlhX8z5u0snAggGP15UVLzQ0xqNWCAeRCOnu_D0-AWRH-e2chcKfFPzHJ0J
    PMnz4u7jj4bdb3kMrkcOEhi1kTnCxGk6LqhRl9GM7PEu0n45ZQdy42O>
X-ME-Received: <xmr:hiLvahks92CuM26QAQlmdHEZ6TdZImWrqH7w4VSf8ERTrR4nngda8WUPATNqTEPEmR5g623FXumu_DiIET6s-z4Bg6-OYWIu>
X-ME-Proxy-Cause: dmFkZTEf+pFFFTVm3IEswDBYBUXTyc5+3mbJR+ZuoAU8Cjj9jinNQlbXf368IsalONSUbf
    nfjOlqOW2zP5HJRFL6HOPPg1CGM1OdImorLj6srsgAEZcvh7TQsolZysBHNcWPYFInVe0m
    uL5Ya0P9Pu/Fa3nEE36xBp1xOmeSFBPVKORd7gHlFn3vBzTt37CvCK31fQBbwKQe5eGSkX
    lZSyBQNBQ57Dxdviao1WMMEVzzMYUxF5nMBp9JqcyVhkZ5N1FhNWLTmCqISoEjhe/yrkXy
    EPYHlI4W1nC1tkKZ7a8UXwUaJVc/4krcoFxB35eE1JGyylpSyjpBQmoyT4E0ALpuw4tkfr
    qBhKk1qmmMdI3a9QadDPYwFH3EBkTA+iK2CPgD9/DlcJVmwQTmKiOCEc6AxAQZmKt8MVEa
    BDC0Iyi1pfmmzxtx8ETb+Bsb2wqFYeqCKODw+x66CjIDHwshUzfJjBTdfWFSUKJf/U2YxG
    ZRX9//WlzQBLf/qa5RctXxuMVtQwFHYznudMbRVCmigS8x95jFEv/OJCmeG7fhNqWU69Xq
    kM5wbK6n1Jss57qg0sfYegueeDzitSrUKaErUSeUPLvSXVX/EGBDm9PLhIaXVz8Ol99OzW
    KUpQDGqabAqxBedUJUdwea0S2XENrc6sMKdj/RiAD8R8JUxoSrsPuXX6JLlg
X-ME-Proxy: <xmx:hiLvanxbGD-1PY8R7ifdEG4RbeBeA_M466s7zMNKvpMtuLVtcFcpOw>
    <xmx:hiLvamrS6Ks77JuwWL2SqK6yNrYItgahAGZyX-RaCSSA4ziFTeg3fA>
    <xmx:hiLvam7XskOxGHUoEgWTHlL_si7lm4EkLUHuNCdSXbbGbYNecz3LAA>
    <xmx:hiLvatdpXmk7xZ2A1CLFJ-OJ72HQKcSAesFtywDJnWa55vbpDdfwCA>
    <xmx:hyLvav8SvDtIjEtP49dBU8m9JxDaYe6_rmyxpwlhTESzC3NpsQolBtFT>
Feedback-ID: i6289494f:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sat,
 7 Nov 2026 08:07:17 -0500 (EST)
Message-ID: <15a1f7c4-3110-4a2a-adeb-cd1e97d5b6c3@pobox.com>
Date: Sat, 7 Nov 2026 05:07:16 -0800
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
Content-Language: en-US
In-Reply-To: <194b6b81-1521-4dfe-b86f-c693917bb78e@pobox.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 11/5/26 7:38 AM, Barry K. Nathan wrote:
> This patch is breaking the build for me with CONFIG_WERROR enabled,
> for both 6.18.61-rc1 and 7.3.2-rc1, on both arm64 and amd64, when
> I compile with clang (I tried 19.1.7, 22.1.8 and 23.1.5). It only
> happens if I build with CONFIG_XFS_ONLINE_SCRUB enabled. However, it
> doesn't happen with 7.4-rc1, and it does not happen with gcc.
> 
> fs/xfs/scrub/agheader.c:123:6: error: variable 'error' is used uninitialized
>        whenever 'if' condition is true [-Werror,-Wsometimes-uninitialized]
>    123 |         if (agno == 0)
>        |             ^~~~~~~~~
> fs/xfs/scrub/agheader.c:435:9: note: uninitialized use occurs here
>    435 |         return error;
>        |                ^~~~~
> fs/xfs/scrub/agheader.c:123:2: note: remove the 'if' if its condition is always
>        false
>    123 |         if (agno == 0)
>        |         ^~~~~~~~~~~~~~
>    124 |                 goto out_xref;
>        |                 ~~~~~~~~~~~~~
> fs/xfs/scrub/agheader.c:111:13: note: initialize the variable 'error' to silence
>        this warning
>    111 |         int                     error;
>        |                                      ^
>        |                                       = 0
> 1 error generated.
> make[4]: *** [scripts/Makefile.build:287: fs/xfs/scrub/agheader.o] Error 1
> make[3]: *** [scripts/Makefile.build:544: fs/xfs] Error 2
> make[2]: *** [scripts/Makefile.build:544: fs] Error 2
> make[2]: *** Waiting for unfinished jobs....
> 
> I bisected 7.3.2-rc1 and this patch is the culprit. Reverting it fixes
> the build on both 6.18.61-rc1 and 7.3.2-rc1. Another possible fix, which
> built successfully for me on top of both 6.18.61-rc1 and 7.3.2-rc1, is to
> cherry-pick commit 612d2e7506c3553b1deedc694846d1c0364ae446 from mainline
> ("xfs: read primary superblock from disk during scrub").

This was reverted for 7.3.2, but I see that it's back in the queue again
as of stable-queue commit 77ecab77b25567c54df997dcb8030dea6bca03ed
("Fixes for all trees"). I just tried applying the queue on top of
7.3.3 and the build error still happens.

Since the mainline fix is not a stable candidate, maybe something
like this (just initializing error to 0 when it's first defined)
would work? (This fixes the build error for me, but I haven't
tried running it yet.)

diff -rup a/fs/xfs/scrub/agheader.c b/fs/xfs/scrub/agheader.c
--- a/fs/xfs/scrub/agheader.c	2026-11-06 22:42:57.147299404 -0800
+++ b/fs/xfs/scrub/agheader.c	2026-11-06 22:45:59.898908897 -0800
@@ -108,7 +108,7 @@ xchk_superblock(
  	xfs_agnumber_t		agno = sc->sm->sm_agno;
  	uint32_t		v2_ok;
  	__be32			features_mask;
-	int			error;
+	int			error = 0;
  	__be16			vernum_mask;
  
  	/*

-- 
-Barry K. Nathan  <barryn@pobox.com>

