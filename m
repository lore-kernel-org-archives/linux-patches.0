Received: from fhigh-b1-smtp.messagingengine.com (fhigh-b1-smtp.messagingengine.com [202.12.124.152])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59911258CE7
	for <patches@lists.linux.dev>; Sat, 27 Jun 2026 05:20:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.152
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782537643; cv=none; b=YitOPp3oSYtCm43AGmPBxVMixsZvOVM4/mZ7zDKEowFEwQobN5MWMkl64u1dHPe5LbXfiJ6NnVUT0ejlr8ZUH4KlRXu+V1xzysFh/HfYxldCBCQeOYILKMOfqhudB1dqdCoVOQGEbwuczqa3NTBvxclJjDy0SDGBLM6jheNs/k8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782537643; c=relaxed/simple;
	bh=lM8YOD3A+tTxvK/qKtYk1NjLEt0ijMinaVHvUsMa4Tk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qnAy3BMLdc/HR3LMUYGEf7OGx4R1qr3nYfp2RvfW8rh9qSaCTJQ5yr15UY3+LojNsTcfYVpuHmTsZnHhW0AG+8A1M3ncNS1KCrgknX82eKGXdfwBwrvX8flE/Y58ZcJ28EJeAA5jIjCPHB1klFT/20I1AL9DMVMn5EIGNhySf9g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pobox.com; spf=pass smtp.mailfrom=pobox.com; dkim=pass (2048-bit key) header.d=pobox.com header.i=@pobox.com header.b=A0cldbqP; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=dBxn5nHF; arc=none smtp.client-ip=202.12.124.152
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pobox.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pobox.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=pobox.com header.i=@pobox.com header.b="A0cldbqP";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="dBxn5nHF"
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailfhigh.stl.internal (Postfix) with ESMTP id 06D5B7A00A7;
	Sat, 27 Jun 2026 01:20:41 -0400 (EDT)
Received: from phl-frontend-02 ([10.202.2.161])
  by phl-compute-06.internal (MEProxy); Sat, 27 Jun 2026 01:20:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pobox.com; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1782537640;
	 x=1782624040; bh=C2BAxTlCsIFTf/iT5efb+lPRQ0VGoGSsRUbrGjbBtSU=; b=
	A0cldbqP5MLeO5O0feAU2PyVnskCdWg45aPq5SpQlwsSqcW3cKuMAkZQmz+RGcc3
	m13wKoo6UR1UinuSvCFX6WIsNKH2KQLL2PGWof7+3D+dUYbZgWbjCfdnK4GsoFB7
	a8MPkcbRsuTk/yBXzketOdvAgmoi3qW8jua16xKni99YU8suOsMJqCmi1Ae8C3Cj
	OVrXQ1VWzcKzdH43Vb46T5e4vy/jlqt39Ooy5U1sCxp4igk21O4uhfzpIJ4v9Fif
	4ktNV9UEKGmRrIXdKOZBl7eYpbg4mns+bNh25kUMjoP4QJnV4xXItROe4DuPT1ch
	fLztHBTe6rBpRu3+lj5goQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1782537640; x=
	1782624040; bh=C2BAxTlCsIFTf/iT5efb+lPRQ0VGoGSsRUbrGjbBtSU=; b=d
	Bxn5nHFFofwPU5tey4Asgy5zsAd9oDelnP+dlpDRJtivsIoTO3OKNs2BJ7lMz6yO
	FBp0D33Tgy+xfCjGtkQamaUiiEu1lp49TYdEwjo6NWqfml2vgwUJa6Ss+ghnkxDN
	/JKbcMFE7HJqxX9/lzgwG1fR1+5gyzD3Ea9285w2/u62aFT62QEC/wd5bp+ZQKHe
	LtdE0q+rwtc9CDcqumbl5zb+uNl3ZfYWJ92v0ZaMr32+3NMF1s5iKXnOLArpB487
	aH33fcmcGqTPFz5Mhi61en7b+g2FVszF6mN9kax+z3jlkaUusfCc0IJGrGOo6Xe8
	fxSw9w71ecJaxxPonf6GA==
X-ME-Sender: <xms:pl0_aoGa3XArq08ps6UOADu0qAokiUHpobHVo4r6NTgddF-UeCiPNg>
    <xme:pl0_ahtjJT7edu0y9_9fAV5EVxPwv6-hr2PwLsNlNnbC2ke80cTSJcQXXTIKCkQbb
    O0_jYDP663TpI9TjVcY8j6V3APK3sutvU47QRqU4EjZmW5QqYXtMb0>
X-ME-Received: <xmr:pl0_ajSCk1JspTNX3I-twkalQzc6GOjrIl-8aAXHgKfMtt4YQ6orRLmph0K0UFWyz8pAs_vR3jNXGPbuzg6noTuL9RCARtwu>
X-ME-Proxy-Cause: dmFkZTFieHQsw5pN3X1nF5fLYTrT8K1K/TtEmUrmJgfH+Hb1N7pS4/dIIWsk4PgkQplFl5
    IJ+3MgIC7KcP41ImOfhxnAJ/2461OIN0ZM1zjXYwWKxGKJjgjndqZmx86twre9G1EsyDqh
    R2PLj+hW0mLpasG2ZYctbLxKrlQLnvUKAs1mDHCNzbHd3KWjmlvAkPjrWEcECCqMEZV85T
    E2K1/uVoSkhu0fgyNzEUK380QGBWMFPvNOiESTH8/VB5/bhCTDO+CFKDC8X/Azlakb0Ag+
    8xRWtJJjkQe09VPfoqfCuXyF4/J1mzbVQ4XN/c2mGxXB6GHfdMiNAI28xjyOxDLc1WKMAG
    XrkAJ6VcGXW4KrJoNifkaEeZXVTkZGtc1nYPyQIKCGfgfgR20qlGFcXfphD8ScGCfS/CJ8
    TMZzvoIr3dRJCsPdTr4zjjhw51hKkfFFn4oepNmGHuK5ZUNf+Qxdh4IvwXA5a3UGQbj6bG
    18VooyZHTUTn3ZPPNobaEbA+oMxUYzuEXCTEvYPf+YamVdNZNIKF/csevXu8uKPxpCWNMu
    z/esq44H4LWjKNVEWa7LaqofZ60iFLfJThrZiOMJ2HSiWexobvJd9vat3Yh7sAKiLeQUv/
    khCAvMhEfG7rglOvH+A4/1L27PIdLAY5Lm2a8r2FBDVcCF7HShXPAaiiSvIQ
X-ME-Proxy: <xmx:pl0_amHZim2TF2ISfTC873dOwzZJyzzae8UCkfZLEVkA0baQc0mRNQ>
    <xmx:pl0_ate4BoLvoBcc-IFy2FMY2TFLkhly_indQwoL-UdnIYj4eOHt5Q>
    <xmx:pl0_aluF3eljZ3DM98F0tPo93bZ7AjNTS9pmgScOa9tCnylOoaM9WA>
    <xmx:pl0_ajcnK7n80NWcoiwVfMu3Z_TFruw7KPg7oY1NKXzrUPwAO-EOGA>
    <xmx:qF0_anNdIz4_o9lyloN9ejE6dJ48-KOEUORtN_ubHF8EeI_Bm6LdHvjd>
Feedback-ID: i6289494f:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sat,
 27 Jun 2026 01:20:36 -0400 (EDT)
Message-ID: <8d8bb4ba-35fc-48f6-b77d-bd1cf56044c8@pobox.com>
Date: Fri, 26 Jun 2026 22:20:35 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird Beta
Subject: Re: [PATCH 7.1 00/21] 7.1.2-rc1 review
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
 patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260625125613.243729608@linuxfoundation.org>
 <b7bd471b-e9da-4bfc-ad1d-24b378bd1e44@pobox.com>
 <aj7RmyBck8EkPn_s@google.com>
 <ab7df7bf-1b30-40c0-9463-a469abfa2bda@pobox.com>
 <aj7r1Eqt2SEnWsMZ@google.com>
 <626fc564-6f4b-430d-92f3-653981e3dcdd@pobox.com>
 <aj8WEfam__6fnNuM@google.com>
 <2b4c3bdb-5dcd-4834-9ee1-5a9a75ab4815@pobox.com>
 <aj8yGUwvPqiYk4hL@google.com>
Content-Language: en-US
From: "Barry K. Nathan" <barryn@pobox.com>
In-Reply-To: <aj8yGUwvPqiYk4hL@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/26/26 7:15 PM, Dmitry Torokhov wrote:
> On Fri, Jun 26, 2026 at 07:09:08PM -0700, Barry K. Nathan wrote:
>> On 6/26/26 5:31 PM, Dmitry Torokhov wrote:
>>> On Fri, Jun 26, 2026 at 03:23:12PM -0700, Barry K. Nathan wrote:
>>>> On 6/26/26 2:17 PM, Dmitry Torokhov wrote:
>>>>> On Fri, Jun 26, 2026 at 01:41:38PM -0700, Barry K. Nathan wrote:
>>>>>> On 6/26/26 12:56 PM, Dmitry Torokhov wrote:
>>>>>>> Hi Barry,
>>>>>>>
>>>>>>> On Fri, Jun 26, 2026 at 10:56:21AM -0700, Barry K. Nathan wrote:
>>>>>>>> (cc Dmitry Torokhov because this is related to two of your commits)
>>>>>>>>
>>>>>>>> On 6/25/26 6:03 AM, Greg Kroah-Hartman wrote:
>>>>>>>>> This is the start of the stable review cycle for the 7.1.2 release.
>>>>>>>>> There are 21 patches in this series, all will be posted as a response
>>>>>>>>> to this one.  If anyone has any issues with these being applied, please
>>>>>>>>> let me know.
>>>>>>>>>
>>>>>>>>> Responses should be made by Sat, 27 Jun 2026 12:54:50 +0000.
>>>>>>>>> Anything received after that time might be too late.
>>>>>>>>>
>>>>>>>>> The whole patch series can be found in one patch at:
>>>>>>>>> 	https://www.kernel.org/pub/linux/kernel/v7.x/stable-review/patch-7.1.2-rc1.gz
>>>>>>>>> or in the git tree and branch at:
>>>>>>>>> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-7.1.y
>>>>>>>>> and the diffstat can be found below.
>>>>>>>>>
>>>>>>>>> thanks,
>>>>>>>>>
>>>>>>>>> greg k-h
>>>>>>>>>
>>>>>>>> Unfortunately, 7.1.2-rc1 breaks the Synaptics touchpad on my Lenovo
>>>>>>>> ThinkPad T14 Gen 1 -- the pointer no longer moves when I touch the
>>>>>>>> touchpad. Potentially relevant line from dmesg:
>>>>>>>>
>>>>>>>> rmi4_f01 rmi4-00.fn01: found RMI device, manufacturer: Synaptics, product: TM3471-020, fw id: 3972349
>>>>>>>>
>>>>>>>>> Dmitry Torokhov<dmitry.torokhov@gmail.com>
>>>>>>>>>          Input: rmi4 - refactor register descriptor parsing
>>>>>>>>>
>>>>>>>>> Dmitry Torokhov<dmitry.torokhov@gmail.com>
>>>>>>>>>          Input: rmi4 - fix register descriptor address calculation
>>>>>>>>>> Both of these patches seem bad in my testing. Either one, individually,
>>>>>>>> causes the pointer to no longer move when I touch the touchpad. If I
>>>>>>>> revert both of them, then my touchpad works again.
>>>>>>>>
>>>>>>>> I have not yet tested 7.0.14-rc1 or 6.18.37-rc1. However, the problem
>>>>>>>> also reproduces on current mainline as of this writing (commit
>>>>>>>> 51cb1aa1250c36269474b8b6ca6b6319e170f5a5).
>>>>>>> Could you please try applying this debug patch and send me dmesg?
>>>>>> Sure, I applied the patch on top of mainline, and the dmesg output is
>>>>>> below.
>>>>> Thank you! So I messed up and "Input: rmi4 - fix register descriptor
>>>>> address calculation" is totally wrong.
>>>>>
>>>>> Can you please revert it (keeping the debug patch) and try booting again
>>>>> and if the touchpad still does not work post the dmesg again.
>>>>>
>>>>> Thanks!
>>>>
>>>> I did the revert, while keeping the debug patch. With this kernel, the
>>>> touchpad still doesn't work for me, so here's the new dmesg.
>>>
>>> Thank you. It looks like the firmware is a bit sloppy and the new
>>> tightened checks are tripping on it. Please try this patch:
>>>
>>>
>>> Input: rmi4 - tolerate short register descriptor structure
>>>
>>> From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
>>>
>>> Some touchpads (e.g. ThinkPad T14 Gen 1) have buggy firmware that reports
>>> a register descriptor structure size that is too small for the number of
>>> registers it claims to have in the presence map. The remaining bytes in
>>> the structure are 0, which with the new strict bounds checking causes the
>>> parser to fail with -EIO, aborting the device probe.
>>>
>>> Tolerate such short reads by dropping the remaining (unparseable or
>>> 0-size) registers from the list instead of failing the probe,
>>> preventing the driver from trying to use them.
>>>
>>> Fixes: 0adb483fbf2d ("Input: rmi4 - refactor register descriptor parsing")
>>> Reported-by: Barry K. Nathan <barryn@pobox.com>
>>> Cc: stable@vger.kernel.org
>>> Assisted-by: Antigravity:gemini-3.5-flash
>>> Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
>>
>> Yes, this worked! To be clear, what I did (and what I'm successfully
>> running now) is:
>>
>> 1. Start with mainline as of commit 51cb1aa1250c36269474b8b6ca6b6319e170f5a5
>> 2. Then revert a98518e72439fd42cbfe641c2896543cb088e3d1
>>     ("Input: rmi4 - fix register descriptor address calculation")
>> 3. Then apply the new patch
>>     ("Input: rmi4 - tolerate short register descriptor structure")
>>
>> If there's anything else I need to test or anything else you want me
>> to try, please let me know. Thank you!
> 
> No, this is it. I will apply this to my tree and send it on to Linus.
> 
> Thanks.

That will take care of mainline, but there's still the issue of the
upcoming stable kernel releases (6.18.37, 7.0.14, 7.1.2).


For brevity in the rest of this email, I'll refer to these patches as
patch A/B/C:

Patch A: "Input: rmi4 - fix register descriptor address calculation"
Patch B: "Input: rmi4 - refactor register descriptor parsing"
Patch C: "Input: rmi4 - tolerate short register descriptor structure"


Perhaps the best way forward for the current stable cycle is to drop
patches A and B from the stable-queue for now, to make sure these
releases don't break any touchpads.

Once patch C lands in mainline, that will fix patch B. So, in a
future stable release cycle, patch B could be added back to the
stable-queue alongside patch C.

-- 
-Barry K. Nathan  <barryn@pobox.com>
