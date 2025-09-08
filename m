Received: from mail-pg1-f180.google.com (mail-pg1-f180.google.com [209.85.215.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C37BD1DA3D
	for <patches@lists.linux.dev>; Mon,  8 Sep 2025 03:00:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757300443; cv=none; b=bIoIdf9dvnyCdIbTQaW3k72JFDW+w+R7Jxw0lBTXes9VN5RQeAe0yaar57HCnhYTl68hi6q8P82CVpRxhOiPXDGI/H3SApgEETWCB1EMbtsX0al9rPc0OPqLXpuhiJ4C3lAUboSR4+LWi8NaJWIAXXloRcPKyrCTsW9ioXtpqOQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757300443; c=relaxed/simple;
	bh=T5ZhbXKly4qM6QgfOHXDuNQzGu3EBG1+Fd/h0Lzfihw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=TyZ7QbuhYuIVu0m9vuJwZ+4djYDND56ZaWZ0ai8xkSrmaQ4PuYmxvkCNNJD6wFcK+FAmPibARFtoQkxy141oXzv76cTwn0tvIV6kFhX+Vg6jM5QaD5QfR8ajQcOecc4YGLkzx+dyUBKzC2qf1/GkXwvEhpWb2cWeGgk9NzTodGc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=eSds0k21; arc=none smtp.client-ip=209.85.215.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eSds0k21"
Received: by mail-pg1-f180.google.com with SMTP id 41be03b00d2f7-b4cb3367d87so2552403a12.3
        for <patches@lists.linux.dev>; Sun, 07 Sep 2025 20:00:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757300441; x=1757905241; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=2FPoZm8vJfS/oNYy/TGDbhsWmWQ48pnNg0NhQ9OtAi0=;
        b=eSds0k21/uY4aRZ1fHjchYLHAvLC71BYJVZQ1jxLyvLIOvyrFXGsQ1iFistUaI2TE8
         P3Acy+CSHKylU3UuHPBt6RirmX3lmv2E8+mSgWxw/mlz49C72g07wwqonxXzbX+uLwvt
         YkKrnom9Hdkw16PT5O+w4kMRWhWAe6Dj+yvxxT4WW0phDtWK0KZs1AAJta/Gmo9LIhiz
         F+Qzx3yn8NnNpZuG3wuWlDALU8luDuD0Wo1cPAG3QMMDLDAJre4dvClmMil3Kz+G5Rt8
         KKIx+tpZptrRf49OwVbaV6dgQK8IahiG8O3DxuFFYDKFUc3YLWvJMKQFdYO1U95jkL4v
         6+OA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757300441; x=1757905241;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2FPoZm8vJfS/oNYy/TGDbhsWmWQ48pnNg0NhQ9OtAi0=;
        b=JFRVPrmtGfpZ/jy7BfLItEyPYmaSm6yom5SAQAdeFvuDenfxNZaSUrfOrReyR9MaIQ
         cDWWKfgEjwFaAlmN8cbVBI7RaaNkN05pr0GijnIcwp/uwTy01jfx9SrcvNuMmPZ4x8DA
         5iqYwMZqIZpTUEx2Owhis0obgAETO2LA1HR/JSdhjNRAFFdC5euZthm1yAQcicvW+jlq
         +klorFtBla/Peb1VixOs/K7k5IWKD7S58ZRoT+CiKqMRGTYp6QpzbfP4rZiVKmJFL9Xz
         N2RtrJ6+yIDojlEFaAwDzwDaDUfoshzCMFtN78u3J8oc5BnLvfSmyd6hgZTNqXU9EPzP
         YGSQ==
X-Gm-Message-State: AOJu0YzZahTsdXt9D5oIn9KK2ukwIU3xPu19YCi0O2l3zJzHvxfFOS7D
	LLQ1TCF5BDN5FTenX9/p2iVRAEeR8MfH15Bgsp5JmV0toDJHeLGF/XuH
X-Gm-Gg: ASbGncsNHnKw3Z+PEYJOxby4xprSsK3RpvG2eT9JdJr0Ckd89pyPVOXNy0uRgZmKI3Q
	HfnpTtDTH31DPJ5/Z5vc0tliCfYcUDo/3SqSmbplg5tm0fo2vploCb9fR4qcPqYSTCbTy4YgZgB
	/GitswDdzNL7lWotFMVJtBdGal0e9L8Uk4n22EpGd9W7jZxS3SpMWNkB0Zf1x0gUkVlRVUpQV3r
	xeFHjFbCaYKgV/Fhf29iaPKrLD75nE7/te+2K4zY/u0+lw0kBHg40mFAwKLf431zXyvxzwrutpy
	lc8vdtFKGcQM+Eqmi6vC9Ga/EQe/M2QGEew/maIu7jyp0httehzM6y7+KcY7KkV3EZ7HvyGT2da
	V8C9sItZohoidcLBUUYK4hFNVunZRX/0pMm7KmMnQObI8bivAEWAFiyzEX8VukUBxlbrZRGQ5Zf
	Q=
X-Google-Smtp-Source: AGHT+IETTbiAXs/1GXxiYYI7GifjMnzgPvlZg13nmb9R6LYjegKg+PmdWgu81MkIfyknzH4vU/L6Vg==
X-Received: by 2002:a17:903:2450:b0:246:a543:199 with SMTP id d9443c01a7336-25173301e63mr96025445ad.54.1757300440890;
        Sun, 07 Sep 2025 20:00:40 -0700 (PDT)
Received: from [192.168.1.3] (ip68-4-215-93.oc.oc.cox.net. [68.4.215.93])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-24b1d2c2833sm153726625ad.52.2025.09.07.20.00.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 07 Sep 2025 20:00:40 -0700 (PDT)
Message-ID: <6a53318e-13f1-4c38-a9cb-88955247b666@gmail.com>
Date: Sun, 7 Sep 2025 20:00:39 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 000/104] 6.1.151-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org, achill@achill.org
References: <20250907195607.664912704@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20250907195607.664912704@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 9/7/2025 12:57 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.151 release.
> There are 104 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Tue, 09 Sep 2025 19:55:53 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.151-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

perf fails to build with:

util/bpf-utils.c: In function 'get_bpf_prog_info_linear':
util/bpf-utils.c:129:26: error: '__MAX_BPF_PROG_TYPE' undeclared (first 
use in this function); did you mean 'MAX_BPF_LINK_TYPE'?
   129 |         if (info.type >= __MAX_BPF_PROG_TYPE)
       |                          ^~~~~~~~~~~~~~~~~~~
       |                          MAX_BPF_LINK_TYPE
util/bpf-utils.c:129:26: note: each undeclared identifier is reported 
only once for each function it appears in

which is due to  05c6ce9491f1851d63c40e918ed5cf7902fd43d3 ("perf 
bpf-utils: Harden get_bpf_prog_info_linear")

Looks like we need caf8f28e036c4ba1e823355da6c0c01c39e70ab9 ("bpf: Add 
BPF token support to BPF_PROG_LOAD command") which adds the definition 
for __MAX_BPF_PROG_TYPE, unfortunately there is a lot going on there 
that this won't apply cleanly.
-- 
Florian
