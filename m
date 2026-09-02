Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB1113C1F
	for <patches@lists.linux.dev>; Wed,  2 Sep 2026 08:20:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788337230; cv=none; b=puaNTW2D2mnJV7+CnybJM/RUTTdtqJT9BD4PYC6HV8rdBtM57p0ZEtHk8xt+ZcSHq9kVwCAr01sJc/eNWDFq3Zv1zT4NSwZ9DggStWFzszYmAy1VBLc+NcZY3a/s/cbNZGlLcGxnPJ+AcH/yIGRSYAhfujLi+hmyZdDe1KhlBEA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788337230; c=relaxed/simple;
	bh=2wO/V6+U7w2bGtRa1e8YA94XbpqLc7o53riuolU8UBc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=SuFNhoasrRHt9KhVbs9Oo5fltmz3Bj5vswDHE78JOV4EGq00ZR0lLiGhqRhZB7RnLUWPbCXRS4alLl3oGjZtcu+M586lgYNQNriFtEU2flmT3GxqjmUaPDobFJI99WqksG1KMcWV4C2ogw8dbxDNr3RkxpNXlOFMQmkdvCjc/ls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=none smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.198])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4hZbHd00l1zYQtxJ
	for <patches@lists.linux.dev>; Wed,  2 Sep 2026 16:19:40 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.75])
	by mail.maildlp.com (Postfix) with ESMTP id CEF1F407AE
	for <patches@lists.linux.dev>; Wed,  2 Sep 2026 16:20:21 +0800 (CST)
Received: from [10.67.110.36] (unknown [10.67.110.36])
	by APP2 (Coremail) with UTF8SMTPA id Syh0CgBn0ExE3Jdq1r_dAQ--.7188S2;
	Wed, 02 Sep 2026 16:20:21 +0800 (CST)
Message-ID: <068d6b49-1e79-4d14-a51f-a445c7ecdbd0@huaweicloud.com>
Date: Wed, 2 Sep 2026 16:20:20 +0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 095/261] tracing/probes: Reject $arg0 in meta argument
 expansion
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
 Raushan Patel <raushan.jhon@gmail.com>,
 "Masami Hiramatsu (Google)" <mhiramat@kernel.org>
References: <20260807143415.358597922@linuxfoundation.org>
 <20260807143417.434454264@linuxfoundation.org>
 <7a6417ca-fb4c-40da-8ad1-b9d76a2fa142@huaweicloud.com>
 <2026090227-clash-peroxide-8872@gregkh>
Content-Language: en-US
From: Tengda Wu <wutengda@huaweicloud.com>
In-Reply-To: <2026090227-clash-peroxide-8872@gregkh>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:Syh0CgBn0ExE3Jdq1r_dAQ--.7188S2
X-Coremail-Antispam: 1UD129KBjvJXoWxCrW8Aw4UuFWkZFykKFWxJFb_yoW5XrWxpF
	WfGFnxtr48Jr4fCrW293W8CFyFy3ykXry3XryDJw1fWFn0kF1rJr4xW3yj9a4Du3y8K3yS
	vF4YqFsrKa98ZrDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUymb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Gr0_Xr1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVWxJr0_GcWl84ACjcxK6I8E87Iv6xkF7I
	0E14v26rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40E
	x7xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x
	0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lc7CjxVAaw2AFwI0_JF0_Jw1l42xK82IYc2Ij64vI
	r41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8Gjc
	xK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r126r1DMIIYrxkI7VAKI48JMIIF0xvE2Ix0
	cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r1j6r4UMIIF0xvE42xK8V
	AvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E
	14v26r1j6r4UYxBIdaVFxhVjvjDU0xZFpf9x07jjVbkUUUUU=
X-CM-SenderInfo: pzxwv0hjgdqx5xdzvxpfor3voofrz/



On 2026/9/2 14:29, Greg Kroah-Hartman wrote:
> On Wed, Sep 02, 2026 at 11:17:24AM +0800, Tengda Wu wrote:
>> Hi Greg,
>>
>> On 2026/8/7 22:37, Greg Kroah-Hartman wrote:
>>> 6.6-stable review patch.  If anyone has any objections, please let me know.
>>>
>>> ------------------
>>>
>>> From: Raushan Patel <raushan.jhon@gmail.com>
>>>
>>> commit 00a8ce2a2a9fa17674e1feec4d9105c1a5d6a419 upstream.
>>>
>>> traceprobe_expand_meta_args() parses $argN with simple_strtoul() and
>>> calls sprint_nth_btf_arg(n - 1, ...). For $arg0, n is 0 so the index is
>>> -1. Because ctx->nr_params is signed, the "idx >= nr_params" guard in
>>> sprint_nth_btf_arg() does not catch the negative index, and
>>> ctx->params[-1].name_off is read out of bounds.
>>>
>>> The normal per-argument path (parse_probe_vars()) already rejects
>>> $arg0 via its argument-number check, but meta-argument expansion runs
>>> before per-argument parsing and substitutes the value first, bypassing
>>> that check.
>>>
>>> Reject $arg0 explicitly during expansion.
>>>
>>> Link: https://lore.kernel.org/all/20260724054435.146279-1-raushan.jhon@gmail.com/
>>>
>>> Fixes: 18b1e870a496 ("tracing/probes: Add $arg* meta argument for all function args")
>>> Cc: stable@vger.kernel.org
>>> Signed-off-by: Raushan Patel <raushan.jhon@gmail.com>
>>> Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
>>> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>>> ---
>>>  kernel/trace/trace_probe.c |    6 +++++-
>>>  1 file changed, 5 insertions(+), 1 deletion(-)
>>>
>>> --- a/kernel/trace/trace_probe.c
>>> +++ b/kernel/trace/trace_probe.c
>>> @@ -1721,7 +1721,11 @@ const char **traceprobe_expand_meta_args
>>>  				ret = -ENOENT;
>>>  				goto error;
>>>  			}
>>> -			/* Note: $argN starts from $arg1 */
>>> +			/* Note: $argN starts from $arg1, so $arg0 is invalid. */
>>> +			if (n == 0) {
>>> +				trace_probe_log_err(0, BAD_ARG_NUM);
>>> +				return ERR_PTR(-EINVAL);
>>
>> The control flow here is not quite right.
>>
>> Returning directly within this branch fails to free the new_argv memory,
>> resulting in a memory leak.
>>
>> The mainline does not have this issue because the preceding patch
>> 4af0532a0f47 ("tracing: Use __free() in trace_probe for cleanup") introduced
>> __free to manage the release of new_argv memory. However, due to the extensive
>> changes involved, directly cherry-picking that patch does not seem to be that
>> straightforward.
>>
>> Therefore, it might be more appropriate to simply change it to goto here:
> 
> Thanks for the review, can you send a fix-up patch for this as it is
> already in a release?
> 
> greg k-h

Sure.

Tengda

