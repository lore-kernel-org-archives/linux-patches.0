Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF38E1805E
	for <patches@lists.linux.dev>; Sun, 27 Apr 2025 02:33:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745721236; cv=none; b=XebXhREu3TBYjRFQDkV5wRAFWpbk/sR1c7MQgokdNw/uLHM59+Hc+L5QpdQYSqKXApMuedVOI9H68gg+0EADtQNxIUAe22hqK6k4aV+HXnsg4iiAj4f8oSTW1pIGdJEhz2L7nn+iouc019Z9t2zkWOXvD8riwF6U/R/fKu6zmpk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745721236; c=relaxed/simple;
	bh=ZxtpZAodsYMmprqA/xdBUuYIfmgms6hIglqzoj1gS8k=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=JGluXnhQDJgFlWqYGK5OvqkYYnUVIbBGD8PbsUYX2TfDrV3hxDjaGmMEPJmFyAQ++0O/ouvMK7EeHNlFrF5kAGtCVF++KuvgDYsLRsF1phBleS6MukNB+9mFekM1bTqHVxgNUm77B//M++y4SM0bRhb6conqALTLSoXt1fWQsNk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UmQqpqWx; arc=none smtp.client-ip=209.85.210.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UmQqpqWx"
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-736b0c68092so3121687b3a.0
        for <patches@lists.linux.dev>; Sat, 26 Apr 2025 19:33:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1745721234; x=1746326034; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:sender:from:to:cc:subject:date:message-id:reply-to;
        bh=yuyJuAwZDZC9Or0+LRKFgJLqmkboqSdppgkNjKAxl6Q=;
        b=UmQqpqWxCbFpVLw2d8l2zY8GkJrSx25voFJvbSpb4uasIoeenN+N0Qf6PVsjiYrd0C
         k9XSihD9uovBKHNAj2y+d23qsDPAcd+Gckv3PGNWxY7wkyQCGhmCpks7lxD5uSiCiPbk
         bn+i34vbIsTUGSamdyM0Hs3jTMQpGUCiKoBlcer9ELtE2J6h8AM/jJpBdTHn1+b54qZ2
         zSnTE8OOCry5BY7xs9vS0Oe9+PkEa4Cl+M9hoLti7L0bwUPfK0ustllwPwkI4STddYLz
         WNlWdb3ZhHzprS77mCo/4Xh6oXzuu4jFE+PIxb/3C0jP8rSX6AM6vXyOm4aYp4r6yoA9
         cDzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745721234; x=1746326034;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:sender:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yuyJuAwZDZC9Or0+LRKFgJLqmkboqSdppgkNjKAxl6Q=;
        b=lO1OaDZHVJ1mUsb+2rTjoSOPnPOrCY2Yl4JykXKePHzZOr+ecN9RLZyqrWPe0RJFWY
         RifhKSryQHgYo+14NuG4O4KuQ50yPaek13Hc0tKF+eSroqVCRn88nDZ/z/FenTHtV6w0
         Y8Hh0GzG6Ymoor9Oe8AsK3zzhcn7ty0inHbBa/CA8rJRiJKU30W5kgUQ5RevX1S8CTfB
         G67R7jGI47hG+ZWhD+lh8QJnhkH7Tb/9uziiC4AjbrPNIM/iM05EQroRB8hcgsj4dc5J
         Vzw2yBq5fhofpAtY6JbeXyteAe0yOUul6j1vNQm3Xj6nSBhoC1zX8UCJOtSHzfKpbTiy
         8ElQ==
X-Gm-Message-State: AOJu0YyfT9qtK7gmfQG8f+ATRCRGRnV3MCeRQKJs6cTbGrqu4lJTLdUG
	G5WAouNA/dxurvcWOTi+sYzgfUpxFJqXmPWfo7QmTEI+gujyTCBM
X-Gm-Gg: ASbGnctRM99XPYbkmBjtCb7trVh4inSa03r56Z+dGsZMvNMFqSD9BsiqwzuWF50we9i
	C10qS1YmAk1Ctd772n0Y17T0tShfbdtA6993HuPYFCUiI+oz5K2H4l3Zsjh9qo0pPSItBMAMBCX
	seGXiMmVbykNw8Za0JIxA9wAeRB5lwJ34OiRjAh68sBf3ht2Xm0GYqZK7eByk/I1KQnEu8mI7IP
	yFOrwByTzlb7hzj+MmsABeIqth1cZzCh7DMrCz4mlcwNHMReXy2wlS8Ad4qu2GTPM5D+RUrwOs2
	Pv/2Duc20M7XHH+ytg/ltroWm6eUeVh7lViZMyRkwbWKu91JTltw4i+vXqFNTLRNiezrp3C9Nhl
	wjKv301QM47LlqI5/mDBVIXxs
X-Google-Smtp-Source: AGHT+IF4rpnQ+T6vzivQmEmUzDO2lMYwsNeAH3uLKba/nLKUJoONOmmFovVGVgFTgRL1jHHQTdrxxg==
X-Received: by 2002:a05:6a21:900a:b0:1f3:3ca3:8216 with SMTP id adf61e73a8af0-2045b6b2166mr9700153637.5.1745721234042;
        Sat, 26 Apr 2025 19:33:54 -0700 (PDT)
Received: from ?IPV6:2600:1700:e321:62f0:da43:aeff:fecc:bfd5? ([2600:1700:e321:62f0:da43:aeff:fecc:bfd5])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b15fa80fbb5sm4971990a12.55.2025.04.26.19.33.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 26 Apr 2025 19:33:53 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Message-ID: <de718b6b-cbe1-4ccd-be70-794b60e91e0b@roeck-us.net>
Date: Sat, 26 Apr 2025 19:33:51 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 000/223] 6.12.25-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org, shuah@kernel.org,
 patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
 jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
 srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org
References: <20250423142617.120834124@linuxfoundation.org>
Content-Language: en-US
From: Guenter Roeck <linux@roeck-us.net>
Autocrypt: addr=linux@roeck-us.net; keydata=
 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
 mDW4+i+XlNFUPUYMrIKi9joBhu18ssf5i5Q=
In-Reply-To: <20250423142617.120834124@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Greg,

On 4/23/25 07:41, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.25 release.
> There are 223 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 25 Apr 2025 14:25:27 +0000.
> Anything received after that time might be too late.
> 
...
> Nathan Chancellor <nathan@kernel.org>
>      kbuild: Add '-fno-builtin-wcslen'
> 

This patch was already in 6.12.24, and it is now twice in 6.12.y.

3802df8552de kbuild: Add '-fno-builtin-wcslen'
9c03f6194e88 kbuild: Add '-fno-builtin-wcslen'

and

$ grep fno-builtin-wcslen Makefile
KBUILD_CFLAGS += -fno-builtin-wcslen
KBUILD_CFLAGS += -fno-builtin-wcslen

This is the second time this happened in the 6.12 series. The other sequence is

61749c035911 Revert "vfio/platform: check the bounds of read/write syscalls"
61ba518195d6 vfio/platform: check the bounds of read/write syscalls
a20fcaa230f7 vfio/platform: check the bounds of read/write syscalls

Would it be possible to avoid those duplicates ? It doesn't matter in
the above cases, but we might not always be that lucky.

Thanks,
Guenter

