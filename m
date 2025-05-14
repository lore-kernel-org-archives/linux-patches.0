Received: from mail-pg1-f169.google.com (mail-pg1-f169.google.com [209.85.215.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04DB5C2F2
	for <patches@lists.linux.dev>; Wed, 14 May 2025 20:49:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747255751; cv=none; b=HG+Kh+FKm9BL3UzXJ0G6ZnzzzHKsq/eoZEhtUCWQ3ePrrPSU44uY3/FCiMNs1H0iw+bKN4WfOrwqvVtJ9XTegjgHVRoduY9SJLa7uYtkul+W7oYGAEFL+trrqXjZxFFVOP0VgYF3ixOmtu67Zu6wl0ylsKMlq2GFZlqXt0DqntU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747255751; c=relaxed/simple;
	bh=rE0nme3UR6JGtve/bdvTfkT3GlbF/KK2HGPbSK/ETxQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=CrPVu+FmHGJyjxQ1VUoqiLcRVBwEuwuAAjTFoKUjYwqICqC2RRuFNNaC6SQsjcj2XZd9VaIyd/L0xE36rwZRpyxAoIwKKLkbmgL7zS/oJ4DghvgtDwf2YT+q8zh/Uq928+j4Pkpk3h83ZpNKEFtC3nCdR+rL+BMyod2exVf2Lss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HYyTM74M; arc=none smtp.client-ip=209.85.215.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HYyTM74M"
Received: by mail-pg1-f169.google.com with SMTP id 41be03b00d2f7-af523f4511fso118384a12.0
        for <patches@lists.linux.dev>; Wed, 14 May 2025 13:49:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1747255749; x=1747860549; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:sender:from:to:cc:subject:date:message-id:reply-to;
        bh=4TWkm4Axk1iyu7DwZESVkMnCOkvF4ymCsQoRNABC9NQ=;
        b=HYyTM74MPkSo7V7ZTCNsCTBKH64n1ChWdErQJlit5jczEXvLy9RveZ8vxg8ZY2w5I+
         3lklpWMRu6Ei8ullYlkDJKcpQlCpg4yhovirxkZZMYK7QZV8fM2OEuTzfdDw5atknAmb
         nkZqqeUWlB98zu5qsaXfn0CwTM1ONZIeEkuwoydU6kE7kvDTKO0bnjfwiw7Zax67LcYR
         S6DC3hsPvDbYCBuP+0qmEx/NgyCLtp15MQI6fGbQeJZ9BhLwUHTOu6mWVT5EggaB1UVH
         7BhAxJDmQOWr5etSKyuFEPVVO0so3vXc1h37jFHL+8lcwJu7MdFz307u4lFKNlvj8Woc
         7z7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747255749; x=1747860549;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:sender:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4TWkm4Axk1iyu7DwZESVkMnCOkvF4ymCsQoRNABC9NQ=;
        b=hv82BbCDzlldCrOZDlnBCpdILZE4dBGzbUKHir9+PW2uYO9TTWef3UcnVw0DLgZ4SH
         039MrNcfdFCGbpm4G276DGGo9v3+bBUoGAtPCJLW0XS9nV56teNbb5fi3nNdIVtifwu2
         Qqlz9DGq2dnlxL9EYw8abzKTrnDXDdMTzJfHaiJ4mWIwefDMI6gAO+WkYxs8GRUsBPMk
         B2PLIkSVOAQCgajXG9+nK8WpMjouHYTtHI6lMy5nbz7fYnvrphU5SA29xDT+i6z9vN9X
         hNXt5UGBDbCzDO4wjLkafYd+MP8Iei/CREFPTB0tbeWdHJUT7qwCqp0J/nKU38sew0by
         jVLg==
X-Forwarded-Encrypted: i=1; AJvYcCW8xJjcVMbU3m1dLg3lQ7MeGNG98DLiTNsOsstjt22pLaK1pghsTenfU9ubUd0DNQv5DIeCEAbi@lists.linux.dev
X-Gm-Message-State: AOJu0YwpfrOu6zOJ8s6MYRbcOUb5eX+0nibadYmd4sutnuctazv4JZ3w
	2SSy1k33wwkQ3JAN89y25/QQ3jN8Q1icodWWt1Z/QdEusuoUwDJ2
X-Gm-Gg: ASbGncsWCFCYOsTncxOsVsiA5h9ashrybiOtD2nu5kfNr1objd2V4uRz19VurtkbGPZ
	hAtWC7oM7Vnca+F99G7JezqOOIJs64ccmxg/F04ca8omqoLP/M1mNmCsIa3nKVKkyrOyw+hXP8W
	QS2fiD5ttKb0PjiqJ5t8TQzAzkJnEygr2X1pivrdQMDd26O22LcBiKJJBQGrKHhiMczRq4zE6Yi
	DwhWQyiDLlnsBCF5RESvN1uc9RIIzCbvMSnl+VhB72iLNOUwNNg/E9vX5wk7FZM96UOpi5qHBj6
	FItpfFS41GnDoDfInMhnZc1x89O9TBZRo5BlO6A6pyIkpPgy0TxCO+6RY50PKqorycy2OwsLgKs
	GkC5+3nOhGuTp9F+2vU/5LuasJlWvu4EiG2U=
X-Google-Smtp-Source: AGHT+IG8Hz3dWZ+uZdxCOMvGwrsDdFLZhyO0aJQKCEOYGQQtHCAhGk7ylVgss5kOv8QeH5p7lhEMFQ==
X-Received: by 2002:a17:90b:288b:b0:2ff:693a:7590 with SMTP id 98e67ed59e1d1-30e2e62ff9emr8877929a91.33.1747255749050;
        Wed, 14 May 2025 13:49:09 -0700 (PDT)
Received: from ?IPV6:2600:1700:e321:62f0:da43:aeff:fecc:bfd5? ([2600:1700:e321:62f0:da43:aeff:fecc:bfd5])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-30e3340194asm2019137a91.5.2025.05.14.13.49.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 14 May 2025 13:49:08 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Message-ID: <e1ea37bd-ea7d-4e8a-bb2f-6be709eb99f4@roeck-us.net>
Date: Wed, 14 May 2025 13:49:06 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 000/113] 6.6.91-rc2 review
To: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
 linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
 akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 Darren Kenny <darren.kenny@oracle.com>
References: <20250514125617.240903002@linuxfoundation.org>
 <861004b4-e036-4306-b129-252b9cb983c7@oracle.com>
 <2025051440-sturdily-dragging-3843@gregkh>
 <9af6afb1-9d91-48ea-a212-bcd6d1a47203@oracle.com>
Content-Language: en-US
From: Guenter Roeck <linux@roeck-us.net>
Autocrypt: addr=linux@roeck-us.net; keydata=
 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
 mDW4+i+XlNFUPUYMrIKi9joBhu18ssf5i5Q=
In-Reply-To: <9af6afb1-9d91-48ea-a212-bcd6d1a47203@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 5/14/25 13:33, Harshit Mogalapalli wrote:
> Hi Greg,
> 
> On 15/05/25 01:35, Greg Kroah-Hartman wrote:
>> On Thu, May 15, 2025 at 12:29:40AM +0530, Harshit Mogalapalli wrote:
>>> Hi Greg,
>>> On 14/05/25 18:34, Greg Kroah-Hartman wrote:
>>>> This is the start of the stable review cycle for the 6.6.91 release.
>>>> There are 113 patches in this series, all will be posted as a response
>>>> to this one.  If anyone has any issues with these being applied, please
>>>> let me know.
>>>>
>>>> Responses should be made by Fri, 16 May 2025 12:55:38 +0000.
>>>> Anything received after that time might be too late.
>>>
>>> ld: vmlinux.o: in function `patch_retpoline':
>>> alternative.c:(.text+0x3b6f1): undefined reference to `module_alloc'
>>> make[2]: *** [scripts/Makefile.vmlinux:37: vmlinux] Error 1
>>>
>>> We see this build error in 6.6.91-rc2 tag.
>>
>> What is odd about your .config?  Have a link to it?  I can't duplicate
>> it here on my builds.
>>
> 
> So this is a config where CONFIG_MODULES is unset(!=y) -- with that we could reproduce it on defconfig + disabling CONFIG_MODULES as well.
> 

Key is the combination of CONFIG_MODULES=n with CONFIG_MITIGATION_ITS=y.

Guenter

