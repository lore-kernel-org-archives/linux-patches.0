Received: from fhigh-b4-smtp.messagingengine.com (fhigh-b4-smtp.messagingengine.com [202.12.124.155])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC58AE56A
	for <patches@lists.linux.dev>; Fri, 24 Jul 2026 00:08:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.155
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784851697; cv=none; b=D2EfdU3/NBTyYgDXQPVuFOeVMZXFFm8c5WWgzvfJxpYiRJg1wTBKTDc3PG7MONrzUYT8M3GnopIOe15d1txWnKuX0uLw5n4QD/92Eip2YDRoUDSwhx1mUaXDmKYbLkW0rdkO4ieKdYogL0kKkw70AhNpIdJgBdPssjCaTvXak3I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784851697; c=relaxed/simple;
	bh=WV1BFZoMbBDuca8HRMrHvbdBx3KitPKT9mp9mbazXbs=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=CQaCwX/nu+Lfj7571lsYeBj154uc80Gx7A4VjCgWxUS4zMhjB+JGyTKb5KO62JPZC9Kn23qSE9EYdU2Y2EGP5F4vJ2SdYKf7osUrH52Y26LkcuvWVRuuZAxctzB6zXmTxJTk++3tOK/Uza5u8izExjiNyNBQk7Owm+ezWljd4OY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pobox.com; spf=pass smtp.mailfrom=pobox.com; dkim=pass (2048-bit key) header.d=pobox.com header.i=@pobox.com header.b=u83jtXSI; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=IZmafu6z; arc=none smtp.client-ip=202.12.124.155
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pobox.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pobox.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=pobox.com header.i=@pobox.com header.b="u83jtXSI";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="IZmafu6z"
Received: from phl-compute-11.internal (phl-compute-11.internal [10.202.2.51])
	by mailfhigh.stl.internal (Postfix) with ESMTP id 0EAE67A025F;
	Thu, 23 Jul 2026 20:08:15 -0400 (EDT)
Received: from phl-frontend-01 ([10.202.2.160])
  by phl-compute-11.internal (MEProxy); Thu, 23 Jul 2026 20:08:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pobox.com; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm1; t=1784851694;
	 x=1784938094; bh=yMkEJxJUEaLkgjRC9mha8OzPgcwPJNm8em+Q0MzLgCs=; b=
	u83jtXSI6CJ7clyExGjd47+y+guxAtA/iL7pRpdU3/3mQgm5hkbDa0YUAX+fh8yS
	0N2QatFkB9y45J88xfFzyWIfNggAIAsVzxq4AnZ9Nb7G5u+N0KMXSQU11gk4Kcg1
	j5N+o3gPn5mhOhB+ovQsPv0a5YOw0cNjtMUVIOtSaqG+g4tVCmxkOE0NII9N5vvr
	MOvCcr8B4aeSZydY253eIiEJ9mOsP6CXk6dXn0DeDoqNeO5dIbwH1KkBf9fUkR9/
	bVCUlG9ZJKEy9I0i5fwjOQXfFX9YrJL1MPKZKYF1AMIVkTWIl6w7klevEtvwnDtZ
	x6xnFAQZPWimk7vNKdd7jg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=1784851694; x=
	1784938094; bh=yMkEJxJUEaLkgjRC9mha8OzPgcwPJNm8em+Q0MzLgCs=; b=I
	Zmafu6z2YLe2dkDPcMEyDky+8V3PrxAoDHT/heR01fVUbbsyGa2i9hDysEMKsmte
	x223XaEWh5YZy8KFGr/2dgIVfxN9biJokCNvCbEzHpAlNX2xHSNqQotg3fFIV60u
	mKzVzbmLBNu3iqBjKSl2TR3lbk3VRdBpM5nKyluCHpEvX0O9fp75xQqs+t4EZ72R
	MTSETcq9R5iR+maF44Is7PUS3CuFRggrBAckvMLlXkQyp5lzGqFjP0hILHR7YQdu
	afQ/QwOoVd6B2fHl9mQTk2xPEJ4SMOsX9rsUJocyiEuEX2OwDDz5rT5zMCJs/3Rr
	Hq2YMhacLzEXjqyJQciMg==
X-ME-Sender: <xms:7qxiag6izquJHjo_ec1yXj6X_lfZhvw0oGEFeQDPqtUBEnxKFK1rhg>
    <xme:7qxiaoYz6bomcNtyICF3fW7mpVdpdRQAsPoHeZhP5FzgWImAvC46aPOX7AQksep7W
    bEivLjy6IDQPleoJTPCndZHBFFYqV3WMSzyYS6PhgX-VCMCR7hJEYdp>
X-ME-Received: <xmr:7qxiatdeB2Zem0ouYIwNeDorcX002vR8K9mieFzrBUycXekFHmX6s2KewuMzivat6Dw-OXW41Ft-hOKxe9Mb9R9N6hMILmd9>
X-ME-Proxy-Cause: dmFkZTEqRHXHG93drmyH5H+eNofBn2R06g6ZKOBz8Fg2N4IfU56l1O9M7cXJXFw68YpXLx
    e64aeKuKtm3YEOdOz+UzwIRfO80LOQuJu0udnMc65+0foFWxWR28j6HIZXEaCwHNlIYGPD
    cnxFNIx0kjkGWeiOTMwqnZim65asotqW3tSpIVgO5dm7HxXwhd2VnhzWp+2yxJofuMlHhA
    I2wcXqIUbd9uHuHDL5ZyrKV1e42RDdcVv6v/ltSZ6OcH/5Zn4WYiCIsVJymj9/V4GWofHB
    G5keLC13TvDqgqsW7A7y7myGbI415VdM8UOHS1eWIMYN0a2BBFFMFoQsLgy6C+9PrcS7jc
    A0329lo6Go9r3ZutQrR6LMIstu2k+aSjbmqCNo74B550gFJqF+47m5GlRYxt5Yxsy9bwuI
    ErPHL/eXB9ltD0mTGd6ODZEXdtFnfV5pD79LZHy5BiLPxULc5RoMAZlNWSIUPEOKdBjluY
    7QXpO8tsxGGghNBubDdE+k40twkqE6COa38rvWYBww7aks5RL9nS1oZcLO6C0ilDqQhvo8
    BnRrkMWRSFrwEORweEu7rI/NgJSTIwRpA38WsrC10yuFiAC029o5b+cirV/tXNpyw9x7e9
    O1P/fkIbOQ7+2u0tm/qMmPG38JASMesZccuR3lVLKcvqjQaycvz/CuDF2YtQ
X-ME-Proxy: <xmx:7qxian7XNv49ERsoVw4liCfjz81jyVxIZ7knd4qEACIw2KIvFkIcKQ>
    <xmx:7qxiaqbXCukSupTngH023PMNEEvMrOehABpefiO9SVSa4SVZ1rMuJQ>
    <xmx:7qxiahHpKlaIn5ZCnXhzb-fSFkPmvBivyV61WVXuGMVL7mLwlr_oVg>
    <xmx:7qxiatnPzZ71ukp4_9ndNCu1gl0TpzGyfFBnGQXVU7IEiOyQonzSPw>
    <xmx:7qxiat0a_OSS0b5vE2UrQqLHzjAxAswBT5wftgRUC1VuVwdeBcGbtyzp>
Feedback-ID: i6289494f:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 23 Jul 2026 20:08:13 -0400 (EDT)
Message-ID: <f27a8c9a-6538-4d24-9e80-c98c94431e3f@pobox.com>
Date: Thu, 23 Jul 2026 17:08:11 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.10 137/699] tracing: Prevent out-of-bounds read in glob
 matching
From: "Barry K. Nathan" <barryn@pobox.com>
To: "Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
 patches@lists.linux.dev, Yuan Tan <yuantan098@gmail.com>,
 Yifan Wu <yifanwucs@gmail.com>, Juefei Pu <tomapufckgml@gmail.com>,
 Zhengchuan Liang <zcliangcn@gmail.com>, Xin Liu <bird@lzu.edu.cn>,
 Huihui Huang <hhhuang@smu.edu.sg>, Ren Wei <n05ec@lzu.edu.cn>
References: <20260721152355.667394603@linuxfoundation.org>
 <20260721152358.800887633@linuxfoundation.org>
 <1d60d21d-ea26-4502-afee-c49c750df1e9@pobox.com>
 <2026072339-reshuffle-blizzard-42e9@gregkh>
 <759ee068-9519-4cfa-9be5-1deb0d9fc877@pobox.com>
 <20260723114247.00a3f66d@gandalf.local.home>
 <3308ea85-4ae5-4c5d-bfba-67bf7164a5d9@pobox.com>
 <20260724071902.7469bfe5b1f9bfd3bced2cc0@kernel.org>
 <ae1aec5a-9142-4f81-b03b-dc8d8f4018a2@pobox.com>
Content-Language: en-US
In-Reply-To: <ae1aec5a-9142-4f81-b03b-dc8d8f4018a2@pobox.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/23/26 4:43 PM, Barry K. Nathan wrote:
> On 7/23/26 3:19 PM, Masami Hiramatsu (Google) wrote:
>> On Thu, 23 Jul 2026 09:57:56 -0700
>> "Barry K. Nathan"<barryn@pobox.com> wrote:
>>
>>> On 7/23/26 8:42 AM, Steven Rostedt wrote:
>>>> On Thu, 23 Jul 2026 08:32:23 -0700
>>>> "Barry K. Nathan"<barryn@pobox.com> wrote:
>>>>
>>>>> In the process of testing, troubleshooting, and eventually bisecting this,
>>>>> I've tried rebuilding the kernel from scratch maybe 6 or 7 times now. I've
>>>>> tried on two different build systems so far, and it seems deterministic
>>>>> that the build succeeds without this patch and fails with it.
>>>> When you say "from scatch", do you create a new directory and build there?
>>>>
>>>> Is it reproducible with a "make mrproper"? (Need to copy the .config
>>>> elsewhere to not lose it)
>>>>
>>>> As I don't see anything in this patch that would cause filp_close to be
>>>> unresolved. Sounds like a bad object was added somewhere.
>> Yeah, or BTFIDS command (tools/bpf/resolve_btfids/resolve_btfids) may
>> be broken?
> 
> This turned out to be the answer. 5.10.y needs these two commits to fix
> resolve_btfids:
> 
> 22e8ebe35a2e: tools/resolve_btfids: Fix some error messages
> 5aad03685185: tools/resolve_btfids: Emit warnings and patch zero id for missing symbols
> 
> (Alternately, 5aad03685185 could be fixed up by hand and applied alone,
> instead of applying 22e8ebe35a2e as a prerequisite. Probably cleaner to
> just apply both commits though.)
> 
> Applying both of these on top of 5.10.261-rc2 fixes the build for me
> and results in a working kernel, which I am now using to send this email.

I forgot to mention, 5.15 and later already have these two patches
(I think they were merged into mainline in 5.15-rc1), so it's only
5.10 that needs them.
-- 
-Barry K. Nathan  <barryn@pobox.com>

