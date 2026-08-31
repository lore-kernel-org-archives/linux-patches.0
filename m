Received: from mail-pg1-f174.google.com (mail-pg1-f174.google.com [209.85.215.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B0D839934A
	for <patches@lists.linux.dev>; Mon, 31 Aug 2026 19:00:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788202844; cv=none; b=Jf90v2LfcUcXc6URSJW2v9yZESST86P9Zqytrgv5V63Qk2peEHekQd+WBSLLQVR3wnKpfzWSC556EN4WNea4NH7QR/zPS0tJJnG6H70H4hIt7n8cAUtlucgwJEHIwGX770rPJwTtbU3IoITE3CE44IcgSmGxXuiJ7jeHriWrBdk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788202844; c=relaxed/simple;
	bh=swFnLySAppNxuSAvXdelckAar1KHHAhbi00Pj7v/3qo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=phYgySVquRHDbkIGIcaMgj87tIQf0yb7VnNDLLrsLwU8mIcmHmA4guvwfH6RqRkUTUR8TCPh5PTdStM46OSU4lTLq2lS71No3vPH6vum5EfUFUkFQBoSnrIwNN/b3tTV28rpj9zdweX356uluSD5N4i5ZTb63Gc1qPADhPilkzM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=aXthjknh; arc=none smtp.client-ip=209.85.215.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aXthjknh"
Received: by mail-pg1-f174.google.com with SMTP id 41be03b00d2f7-cc1c8d4a959so99144a12.3
        for <patches@lists.linux.dev>; Mon, 31 Aug 2026 12:00:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788202841; x=1788807641; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=BLLrMyDTQSEhjgi9BlS/V8xtiJJP4gucQLQ+mXxPqRQ=;
        b=aXthjknh+037KS/oDVFIasZC8n501EdX+9N7kuuoAqv4canYYZCGubw4dScBAdaIW1
         VmiWIL1KaoSHahprSaSFFQlKpr9m7isrbqGx5z4Go8055cKU6x+Yi6lb2JjOiufoL5bM
         iUm8rlvvdBRYU4EGuDpuaYMtATyBo+DdZ8leyDd4nhghf3aawaAyI9eSKQK8bZYxOO5T
         NNS519q2dBv2KtrCoyBZN6E0Hapc/tgeYI3qz9+tySrNxtBqO15U/LoUPDQIeumRB+kk
         oGphsrbcIxch8I32tqHhCm5a2zhAVdpX7ht6/7vQhvUnZbdclEO1udiOm+LEwnfCci8w
         kJXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788202841; x=1788807641;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=BLLrMyDTQSEhjgi9BlS/V8xtiJJP4gucQLQ+mXxPqRQ=;
        b=kSynz6kwKdzy60IhVPvjLPUmzd8lZwOOJ+wfxkYfo+hq0oyQJp/znmG8NaEw0bebf9
         AaTlRv/xk4Z/RycSuojfVNLQ7bLE5U5uw0D0FLLLuqPvielpfRTj/ipN1MYuhF1O42OK
         3u1WAJEywLWeFY8SQ+V/4pUie0evs8syYJ72ZZc2yeeFHNZ0ZH6TFHneLrkN/V8Tz9mK
         4ad9ties3aeoyvJhq9npm2ABfAFgVhaHsYJGf7PkHHswWrAdmjyEstDOW6+GQkmvHReK
         NcYwjP0CcZ3I7zyVBI7cLFmv13Ej/n7jGO+s/gQEZbiEYSWdOOTDHPhcequ2V8rlisQR
         Rwyw==
X-Gm-Message-State: AFuF++kJMujtZ82F+S8eLih0GiMdfL3whok3ZJUeFs2I3JYWsheBQAKQ
	AKoMkL8VhSdjV6fi/q1kGKsRKjyLbhEcIQ6qZ17W+DV2S/KtKfHy1abr
X-Gm-Gg: AR+sD12C6f6+69ahfhjV6isza5uK/TmuAVv164sN2/cMGgQOmrDTgANR8AKwXEXPn/6
	4yV9PP0VDxh0L1DjRDVrFx4yuNTaJwH2Oic0sTCdIjiEjAKPf+tVpq65V46emrojsyOABttu5cJ
	YqKaPPHOYk9nT92+0LB/vR+g99qE39NQb4NUb41FwUBKJLsBQ9EbbtKbxxr2YWlAnpPHlRtE6lV
	NSr7Ji9dL8hP5N1kskEw/M/OMzn+LEprtWoL/7rtcgPxf/XfIehzlCBi1ES62mEvN9E+w/SOGsg
	fBqYWgMqD/46BU7dBopWaoGlu1gi2OrEE2VlSbrFl7QeIAt0JOr5sTfcQOvev7falLMDbnGl6U1
	Xd68onGccPgaO3tGkGMxJsbfbYpG9NTkLr2sDKaj3Bt2iF/pc/qL5ZXxbsIf+3+qvwQDnub5itg
	REY4FBDlbqnaqiQb03DN4mbyYmdWNu33x9PWkdBU91p5yWk3i4jjlAjxpQhEEAmxVoTlqy8ID1l
	EAeGkyza+RR3+AM4k/M4BYXm9EqVw==
X-Received: by 2002:a05:6a21:9098:b0:3d3:adbf:7778 with SMTP id adf61e73a8af0-3d3adbf8191mr30903334637.20.1788202841370;
        Mon, 31 Aug 2026 12:00:41 -0700 (PDT)
Received: from [192.168.1.3] (ip68-4-215-93.oc.oc.cox.net. [68.4.215.93])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3286f7be440sm36737824eec.7.2026.08.31.12.00.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 31 Aug 2026 12:00:40 -0700 (PDT)
Message-ID: <ac8605bf-cb09-4ab1-9487-8e4c58dfeb06@gmail.com>
Date: Mon, 31 Aug 2026 12:00:48 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 00/99] 6.12.108-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20260831133359.740409777@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20260831133359.740409777@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 8/31/2026 6:33 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.108 release.
> There are 99 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 02 Sep 2026 13:32:19 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.108-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels, build tested on 
BMIPS_GENERIC:

Tested-by: Florian Fainelli <florian.fainelli@broadcom.com>
-- 
Florian

