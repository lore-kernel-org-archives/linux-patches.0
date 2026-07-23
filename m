Received: from fout-a7-smtp.messagingengine.com (fout-a7-smtp.messagingengine.com [103.168.172.150])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B95B448B99
	for <patches@lists.linux.dev>; Thu, 23 Jul 2026 15:32:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.150
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784820751; cv=none; b=fnofIuur6ul3fMR8/DF5jdy5xYuLR/8jkhW3CWPTfRO+LEOgDZE9quKRtKPZzVESLFZ2/HOsWwR4WwhBD7ZMiMeUZ0iHTnw9st3BuD1WXQt5xYRiczlxGYD1mz0XV2ZTrztCHpJN6CeS0Bc/MyZTVcpkSB/lU0n6udKwYXoifek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784820751; c=relaxed/simple;
	bh=seaYDwI+nOspPsam8nAG0QjOMH1JMpbMu7zdWL49U/w=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=HHn5zZoxiO/5dStb5pWrRBqc4hENSB9dX+rZRYGRBmZ/dnf3bjYM3V/KcODER4UUQEt3bRzgnDnnDq6kJzpDOAlzy3915zzMpgEj1XbTWmwJ0yfDrBI11CODWaywVUV2eaT7k3DGlugXdNbyMZwZ2Nn5L8h2DPvmMCTfSVdVybw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pobox.com; spf=pass smtp.mailfrom=pobox.com; dkim=pass (2048-bit key) header.d=pobox.com header.i=@pobox.com header.b=agJVx3Y8; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=V2U2pGJI; arc=none smtp.client-ip=103.168.172.150
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pobox.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pobox.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=pobox.com header.i=@pobox.com header.b="agJVx3Y8";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="V2U2pGJI"
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfout.phl.internal (Postfix) with ESMTP id 187A5EC02B7;
	Thu, 23 Jul 2026 11:32:28 -0400 (EDT)
Received: from phl-frontend-02 ([10.202.2.161])
  by phl-compute-05.internal (MEProxy); Thu, 23 Jul 2026 11:32:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pobox.com; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm1; t=1784820748;
	 x=1784907148; bh=uC8O9Vyu/QrSbOX3b8tQmIgdm0AzPdgb0nkxuwubWPM=; b=
	agJVx3Y8kslvZuAu+VhczzMJ49A2rRBl2mTYw79bwBfPPw/vqlvReS2rCidZ5sim
	DLmlxGHbmpFHc80pdURtcVwVI0vJI8Ed8l62+eIyB8jBvjrcb/rWeJ+jQ+Oyktjj
	6TOCtPblnwC2j8Rsp/Qd2ZBXPql2Dz9rDmyjdztRi1YFvNS/fuWusWQcS6qN45Je
	yXVMhALyQTuDDKMMVoDEJQFPhkVZOxODL0j/k6GwNKFQWCR6y+jhzzQ5YdSnwQHR
	WNS78jUEwvyPYiMmx2l1heAv+Oq1sXQ9WdrU79L2yHXrcKcjcSIAzNfV+O2m1T/S
	ci8bJnd9HT3XEXkKMaJ0rA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=1784820748; x=
	1784907148; bh=uC8O9Vyu/QrSbOX3b8tQmIgdm0AzPdgb0nkxuwubWPM=; b=V
	2U2pGJI11I1+XtinyGw449vKlgchUYRkj4apXGRuRkZA7bHjwdwlIDPeivmMBL4D
	UUCPB5NpizCgh/f8DsTS0j1sWo56xGsVfukWC8NglpNO69mp+992Kh96MgQ39iY9
	2C6G5N2xzz4y+a9rSOc/fONjhdjhTXKot40YCqm0IzC+VQYSUHkPIXe2zIOXA7F5
	BOP8GXkbmKjalSd7sjN1SHm3IreR0uMO1ZJuD+cZnrhI1EFxveuz8A/oAZYcHWmf
	51UDZy7VFCdhPM3PlFzl58INNGz8DnW42mXr0ARvsvxaA3hrn9neTNc1+zn05qTw
	KF1syhyuGBOJsji+5UiWA==
X-ME-Sender: <xms:CjRiatQ0UIg0iHMzR1Wuzq0HHEPEYJYG3mS3weQF5hfFAgoUfapHEQ>
    <xme:CjRiatSVegr9ihLvDHZVmkn6mFAi_6cH1Xhl8aGdwXk_CYzpzSZwEGOoOO8oBD5tB
    VlYoUIujMVH7QQ0WWNk-XNCkdrKv_PrhG9_srHQSLP8YDodwQKxAKc>
X-ME-Received: <xmr:CjRiag1OKCkO8RGsWFeELfGdCtVs4uxPneHX3h-3kBZcNKSaCPfaXzbyTnwu6W6gSM5XpRXDmfnR4cYw5u2pmXY-21-yZ4Kk>
X-ME-Proxy-Cause: dmFkZTGLzDJ6eA1f46/pGTTCNa9RQ903DHco+Bmz4K6MxvF5YldMvu//KTv+xII7QcGw3J
    xdytwGZQ0qdzuGyHtSRKYhEXUoH2Ui3UhQednuWCJB+IOnALpIro+FDEeHG3r8Mt8Piyyk
    NB+GQYZ7yeSlleCUVnshrqwPmueoc1EZ4AIlKekndhEM4zJDnhf6pcIVx+SsQr+Vwtg+9F
    HTAY1QlbjlKmHpfiNwFu5ZPzyW6BHXh+/1MUAh2OkjV1v2z5SuPnIY/3Spa3LqlOX39VZZ
    In0s4lvobVuZsnczUQ60JT7Bnd0Ez82Dy3oQrYzLriug3T0Q9Atf4piy+HUB/bBjqNJNMw
    ecqdCg2LegFWdBHbXpgnLgXn/cC0qCaGZZ1QIpnMV7qg/aCRuNAgwaH7hjcxts1gCgkb+k
    SzsUACEuDz6YeurmoPneImdEOr9aOl2noMvmAsSfBWZmX8F4ikOR9cD7CU++TGVUETGmdF
    qyrB+Q9H/pcVxoeT63KVxpoaBma3zOmPy3hIBVcuvyEsVln1PR0xgzyr/kOl9YY52ozn5A
    KADk9Cb+cn9H9xa3YyWs9/CPLio1w1RT+mx6Ruo7LgqU67P8SDu4BxXYObJPypFQGXfpJz
    rnjhD5OLtVRxYmoFCf4hpHBAu8ukX93BxMrAiuc89WtVYJKgUaDWzUBit3sg
X-ME-Proxy: <xmx:CjRianw17wNDqa2wMeEPcMoaYYC6mBvwx3tcpl-z7vRA5Y37FTnKlw>
    <xmx:CjRiaswQJefk5GoFQJedxD9ftOUUrho8-4INeQRY8Mdak8S-OFEc1w>
    <xmx:CjRiaj9itblK3k51fqbyt3RmmY8-pxnHCLJnTPxVcbpjAWhHu0CTrA>
    <xmx:CjRiam-8CgSZEWe_WQZlLQYR1dY3dlToVcqco5gU57eyj9bpVXDaXw>
    <xmx:DDRialhXTy7YJVOl7hOlnyGbc9dbJJyxqrHgP-QNMEVXay6i2_34HF8E>
Feedback-ID: i6289494f:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 23 Jul 2026 11:32:25 -0400 (EDT)
Message-ID: <759ee068-9519-4cfa-9be5-1deb0d9fc877@pobox.com>
Date: Thu, 23 Jul 2026 08:32:23 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.10 137/699] tracing: Prevent out-of-bounds read in glob
 matching
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
 Yuan Tan <yuantan098@gmail.com>, Yifan Wu <yifanwucs@gmail.com>,
 Juefei Pu <tomapufckgml@gmail.com>, Zhengchuan Liang <zcliangcn@gmail.com>,
 Xin Liu <bird@lzu.edu.cn>, Huihui Huang <hhhuang@smu.edu.sg>,
 Ren Wei <n05ec@lzu.edu.cn>, "Masami Hiramatsu (Google)"
 <mhiramat@kernel.org>, Steven Rostedt <rostedt@goodmis.org>
References: <20260721152355.667394603@linuxfoundation.org>
 <20260721152358.800887633@linuxfoundation.org>
 <1d60d21d-ea26-4502-afee-c49c750df1e9@pobox.com>
 <2026072339-reshuffle-blizzard-42e9@gregkh>
Content-Language: en-US
From: "Barry K. Nathan" <barryn@pobox.com>
In-Reply-To: <2026072339-reshuffle-blizzard-42e9@gregkh>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/23/26 12:44 AM, Greg Kroah-Hartman wrote:
> On Wed, Jul 22, 2026 at 07:42:14PM -0700, Barry K. Nathan wrote:
>> On 7/21/26 8:18 AM, Greg Kroah-Hartman wrote:
>>> 5.10-stable review patch.  If anyone has any objections, please let me know.
>>>
>>> ------------------
>>>
>>> From: Huihui Huang<hhhuang@smu.edu.sg>
>>>
>>> commit 0a6070839b1ef276d5b05bedfb787743e140fb17 upstream.
>>>
>>> String event fields are not necessarily NUL-terminated, so the filter
>>> predicate functions (filter_pred_string(), filter_pred_strloc() and
>>> filter_pred_strrelloc()) pass the field length to the regex match
>>> callbacks, and the length-aware matchers honour it.
>>>
>>> regex_match_glob() was the exception: it ignored the length and called
>>> glob_match(), which scans the string until it hits a NUL byte. Some
>>> string fields are not NUL-terminated. One example is the dynamic char
>>> array of the xfs_* namespace tracepoints, which is copied without a
>>> trailing NUL. For such a field, glob matching reads past the end of
>>> the event field, causing a KASAN slab-out-of-bounds read in
>>> glob_match(), reached via regex_match_glob() and filter_match_preds()
>>> from the xfs_lookup tracepoint.
>>>
>>> Add a length-bounded glob_match_len() and use it from regex_match_glob()
>>> so glob matching always stops at the field boundary. The matching loop
>>> is factored into a shared helper so glob_match() keeps its behaviour.
>>>
>>> Fixes: 60f1d5e3bac4 ("ftrace: Support full glob matching")
>>> Cc:stable@vger.kernel.org
>>> Link:https://patch.msgid.link/da1aaf125fc3b63320b0c540fd6afa7c3d5b4f1a.1782836943.git.hhhuang@smu.edu.sg
>>> Reported-by: Yuan Tan<yuantan098@gmail.com>
>>> Reported-by: Yifan Wu<yifanwucs@gmail.com>
>>> Reported-by: Juefei Pu<tomapufckgml@gmail.com>
>>> Reported-by: Zhengchuan Liang<zcliangcn@gmail.com>
>>> Reported-by: Xin Liu<bird@lzu.edu.cn>
>>> Assisted-by: Codex:GPT-5.4
>>> Signed-off-by: Huihui Huang<hhhuang@smu.edu.sg>
>>> Signed-off-by: Ren Wei<n05ec@lzu.edu.cn>
>>> Acked-by: Masami Hiramatsu (Google)<mhiramat@kernel.org>
>>> Signed-off-by: Steven Rostedt<rostedt@goodmis.org>
>>> Signed-off-by: Greg Kroah-Hartman<gregkh@linuxfoundation.org>
>>
>> 5.10.261-rc2 does not build for me (nor does -rc1):
>>
>> ...
>>    LD      vmlinux.o
>>    MODPOST vmlinux.symvers
>>    MODINFO modules.builtin.modinfo
>>    GEN     modules.builtin
>>    LD      .tmp_vmlinux.btf
>>    BTF     .btf.vmlinux.bin.o
>>    LD      .tmp_vmlinux.kallsyms1
>>    KSYMS   .tmp_vmlinux.kallsyms1.S
>>    AS      .tmp_vmlinux.kallsyms1.o
>>    LD      .tmp_vmlinux.kallsyms2
>>    KSYMS   .tmp_vmlinux.kallsyms2.S
>>    AS      .tmp_vmlinux.kallsyms2.o
>>    LD      vmlinux
>>    BTFIDS  vmlinux
>> FAILED unresolved symbol filp_close
>> make: *** [Makefile:1228: vmlinux] Error 255
>>
>> I bisected it, and this patch is the culprit. Reverting it fixes the
>> build for me.
>>
>> This is happening on fully updated Debian 13 trixie, compiling with
>> gcc 14.2.0-19. The kernel is being built for an amd64 target. This
>> failure happens whether building natively on amd64 or doing a
>> cross-compile on an arm64 build system.
>>
>> For what it's worth, 5.15.212-rc2, 7.1.4, 7.1.5-rc2, 7.2-rc3, and
>> 7.2-rc4 are all unaffected.
> 
> This is a much-reported issue that seems very flaky and can not be
> reliably triggered.  Try rebuilding from scratch and see if it goes
> away.  The archives of the list has more details, it's been showing up
> for a while now.
> 
> thanks,
> greg k-h

In the process of testing, troubleshooting, and eventually bisecting this,
I've tried rebuilding the kernel from scratch maybe 6 or 7 times now. I've
tried on two different build systems so far, and it seems deterministic
that the build succeeds without this patch and fails with it.

However, I'll keep digging and see if I can figure out more about what's
going on.
-- 
-Barry K. Nathan  <barryn@pobox.com>
