Received: from fhigh-b4-smtp.messagingengine.com (fhigh-b4-smtp.messagingengine.com [202.12.124.155])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA5E924E4C3
	for <patches@lists.linux.dev>; Thu, 23 Jul 2026 23:43:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.155
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784850216; cv=none; b=rrZb5e80Uul/NEblg7OlqZfz3431Pgf5boAuKeEfz/KMP+3U+noCTTaS9NsNG0SYgGxe2h+mcedqRcLAy4/xXQhQuGnJ0EHmaf58WetV17N88Qaz0XYFMcT8lB+rgnB9rENksC8vzjcbSRrrFyMy+fTy9zYLfo/fNaeI0vhViiw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784850216; c=relaxed/simple;
	bh=dpWrc7V2/019G8TSKUs43Spmd3qd63JBWPcxwsZRZTk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BmWjxFWGlsEOjBK05IL9Xs5w22YODN9CydzdpsOXZJoPQy41sZlSPElDnufjxyTXhRdK9tU0VvfUuHK/5VkwAEXLCDhjEmmGOerWGQNt3gyMWK+50/uuEdPmkhlxrStK0PXvDqBk0h6BaLmCpEvRSCU+PaZKnEssqvBqJM3TRVM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pobox.com; spf=pass smtp.mailfrom=pobox.com; dkim=pass (2048-bit key) header.d=pobox.com header.i=@pobox.com header.b=NEgWnGTA; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=BPvxQITG; arc=none smtp.client-ip=202.12.124.155
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pobox.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pobox.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=pobox.com header.i=@pobox.com header.b="NEgWnGTA";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="BPvxQITG"
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfhigh.stl.internal (Postfix) with ESMTP id CB5C87A01AE;
	Thu, 23 Jul 2026 19:43:33 -0400 (EDT)
Received: from phl-frontend-01 ([10.202.2.160])
  by phl-compute-04.internal (MEProxy); Thu, 23 Jul 2026 19:43:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pobox.com; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm1; t=1784850213;
	 x=1784936613; bh=0+240MLf+ObC0J0mdM84c1+yNruvzoWl50QieoDSDF0=; b=
	NEgWnGTA4vOTBbouD/qqpPcwZawTO3KJvPUUOf/4Wq0G0tqXQCeclB3VxqecLMTL
	c+yUGzyf+otTOP8fXvz5sD7JVRiFSadm0gHIA+dzzIZe0goxfzs3UOj/8F4jFNoA
	p0GLwiUfCJM7ulunm2ezMcL9x+ug51UFZAQjsmlQXcjmwwXiVHRZxK91+86+Prjc
	sNZ/zBPZs0oyPuzO71jrC1siOOUJ5XGNWONPq9HEjRRVFKwuIp3M50Cd4XjdbgBE
	4tMxKUTE1nPEWjwQTM/N8Ih8jzYY01H9geFDFkIVTVrpWWDG+a8VLTjb193GvqQa
	Li3NCaWO7gntXdLgU0fa6A==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=1784850213; x=
	1784936613; bh=0+240MLf+ObC0J0mdM84c1+yNruvzoWl50QieoDSDF0=; b=B
	PvxQITGXeXBijS9lHow8cKAmsAwNXeQPIZH7bR30qGFhujey8YrH5rW64VZgTqXu
	VIBIVrUQXiOnImEE+DTjgH3xf0p4HOu8aSlqzX8wP5Oyeyj5SpM8juKmCqwddP2O
	QwvbCV75fwe1bxi1zba0sl7fy9Q4MnuVO4SHwtz8ksI9tPJHyxXt3YtgOEgptFvE
	rTClEp2GkpuwSIpvOKECAbwYOnZH3g0gaBE5JNm2CpLQtRM6/qsj/kSw/YPv3Seu
	1YVE6wRvlzHajCBInhN4Feup9mv8xkp9IwbcnuYvMI82gHtBLm0KQh6EQV3P3i7A
	gGA+uqalvJ74Hh3o/IyJQ==
X-ME-Sender: <xms:JKdiakVeM44MSgLMMuWD8k2mhcQD97v9dp9W5C48h1WxejhvTqfeJg>
    <xme:JKdiavHAmtXoSKWJBTSa6o9rkTnvo-fc5_cl8VY6RdLJ3dgkCN_qZBcKsS88p1xSg
    v11mDcE8fVttzdT9rBCbwywBLL8OMZ-RNWVy9skemPoyWYQI7RHVwl6>
X-ME-Received: <xmr:JKdiama3UnEm43co5QUShkJboJMVlA1DfHn4hOZStdMu1JXR5czeoTsLTuSv8yAieef6N5qWbdkJF5GEMvaHHQeeingIL6up>
X-ME-Proxy-Cause: dmFkZTF1Z3KGWhtQeHaDnQ5t/nWpLQYESidYgAMZhYEXzTHzYp4hONHlaqmJwSRgO2Nusy
    Pbi0UFqTbka/jVS+5JDbv0HxuTmrF1XrzpwJmGqakKHWwE/ipoqMYwf5xdrolEOuT01xeD
    cFvch2uSDfTj9yFUCj6WIPUn1UZvreK5SdeZ2a6ja14BODGZoqQKDpHCT76viedxYToADm
    7OVp/WJOQ5I2rykuNvkTEfnsuFomdOd/FBeFtOuace75jmTyD+TYEq7g0FS/lQ6u+kgVPb
    x+qot6NEbBoo1QHqGI5dmEmXa7Ev9TAng9se4kDgdckQRzB4qdLkyj7bk+fxo14WRR3zl1
    R6lVhk2Qi5PBgp78kaJKg3DOgnOpXtKhUtnGaJtOCL9bbqxP7g3KIujrpZDsfZoHWaHOMS
    JbKlxkPcTuNS8uCnESiKmZd/ystXGNSjs8QqpG0QZRxQRFUR3PyAcSzowzUUcOxxhNZN2Q
    qlvciHGqtgBhZIKy9xNSPU2TgSQynO1upXBca0DkXuRHuogUwTL6/NOM2nT6Z29JcKmsgy
    hX9upWl0OgEdqs71awWjk3bqkCpcJ4FLOU75NFHkUlR6YVfeptAr2V2nV+R+i5Q77FOqxj
    eX3e+BiWA0NMCWp13oUb51RcLDyXbBus58yZDsG2IVmA9skIQwiYxinsli8Q
X-ME-Proxy: <xmx:JKdiamEGsCQ3jPMO3PQY8QjCjebO8VWCb1p-C3qbTwhi0iz6pghtYQ>
    <xmx:JKdiak3ABz5nRLWUlynKUGEoPS4O79fuEOAIEaN0KYcDy6dd6ShfHA>
    <xmx:JKdiaiwC1Aqy7QD32Ze_5__PDYEk086dQfmzWqzt8p2Bk5Y7zY8C2Q>
    <xmx:JKdialjCPwY1GBzZgg-oMAhAUmfCmn0d0rl1Iaqk9-JPL46SPvuvcA>
    <xmx:JadiatTwZ-gVcgjKtBfWIBjOSMyJIa6GR3ztCJ6vVS22EF26aTOLxeIi>
Feedback-ID: i6289494f:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 23 Jul 2026 19:43:30 -0400 (EDT)
Message-ID: <ae1aec5a-9142-4f81-b03b-dc8d8f4018a2@pobox.com>
Date: Thu, 23 Jul 2026 16:43:29 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.10 137/699] tracing: Prevent out-of-bounds read in glob
 matching
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
Content-Language: en-US
From: "Barry K. Nathan" <barryn@pobox.com>
In-Reply-To: <20260724071902.7469bfe5b1f9bfd3bced2cc0@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/23/26 3:19 PM, Masami Hiramatsu (Google) wrote:
> On Thu, 23 Jul 2026 09:57:56 -0700
> "Barry K. Nathan"<barryn@pobox.com> wrote:
> 
>> On 7/23/26 8:42 AM, Steven Rostedt wrote:
>>> On Thu, 23 Jul 2026 08:32:23 -0700
>>> "Barry K. Nathan"<barryn@pobox.com> wrote:
>>>
>>>> In the process of testing, troubleshooting, and eventually bisecting this,
>>>> I've tried rebuilding the kernel from scratch maybe 6 or 7 times now. I've
>>>> tried on two different build systems so far, and it seems deterministic
>>>> that the build succeeds without this patch and fails with it.
>>> When you say "from scatch", do you create a new directory and build there?
>>>
>>> Is it reproducible with a "make mrproper"? (Need to copy the .config
>>> elsewhere to not lose it)
>>>
>>> As I don't see anything in this patch that would cause filp_close to be
>>> unresolved. Sounds like a bad object was added somewhere.
> Yeah, or BTFIDS command (tools/bpf/resolve_btfids/resolve_btfids) may
> be broken?

This turned out to be the answer. 5.10.y needs these two commits to fix
resolve_btfids:

22e8ebe35a2e: tools/resolve_btfids: Fix some error messages
5aad03685185: tools/resolve_btfids: Emit warnings and patch zero id for missing symbols

(Alternately, 5aad03685185 could be fixed up by hand and applied alone,
instead of applying 22e8ebe35a2e as a prerequisite. Probably cleaner to
just apply both commits though.)

Applying both of these on top of 5.10.261-rc2 fixes the build for me
and results in a working kernel, which I am now using to send this email.
-- 
-Barry K. Nathan  <barryn@pobox.com>
