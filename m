Received: from mail-oa1-f45.google.com (mail-oa1-f45.google.com [209.85.160.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE63618654
	for <patches@lists.linux.dev>; Fri, 27 Oct 2023 14:54:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QOsTCLpo"
Received: by mail-oa1-f45.google.com with SMTP id 586e51a60fabf-1e9b6f39f9eso1450600fac.2
        for <patches@lists.linux.dev>; Fri, 27 Oct 2023 07:54:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1698418497; x=1699023297; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :sender:from:to:cc:subject:date:message-id:reply-to;
        bh=FRGus6ktymyimDivswpJ27Ui0IhpUZQSXAOmlCFn8oc=;
        b=QOsTCLpo6D0oc+b+lYvg3obxoknGiPtJtZ65HdVv0MNXP2r2wUG4Hw6iz0oP5kLBFy
         VezZCruCW8cdVyPeXBQJTAVqYHX/xK55kmp6MHnFGOzk2BRt18SElPzWRQrPikBirsyK
         Nuu9Tg4B5HBmDh1ZabBPPFFuD/kPbIoG/BGcqxA/aPgDlYcWMt9+2P/DlMfMB3uHQN9P
         jWhRc4jB9AADbvzuvPSj/CfRasKTUiKIFHfXTyPQLnHHLEkmUYIS6C2yU6OXB3cveyvZ
         T5Zbd3avkvwJqeavwMQ9UHAMIyYDtJN1Af2cdvOjG+WxGQ7p4WYg4ejpLfO0pKifrCLV
         WY7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698418497; x=1699023297;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :sender:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FRGus6ktymyimDivswpJ27Ui0IhpUZQSXAOmlCFn8oc=;
        b=ayaOhv/GOWKIoo88wq0ecJeJe/TAk/pl3DC4QssYVPQuChtSOVrH2W1pXkAC/xBieq
         DVv3lUOvOoG5eNg+zbN7F5JaDlkUyVBIuPb6tiex1ifiCewSpEuMJ5Y1z8wSeNJsiDCQ
         pfz/jzuGBYj1WPLfjNNJ9pxSY27vWIvo5DDBMHJGIkInQNgGyxC7zh1+wqooXMTJYkXt
         VcgfJayz+36UAKZqWb2H/8QqF+IVW6kI3eb/qi8B0GkNdrvHpDYDQmbryX2v3qoZngs4
         k9xt/0HelhHI1927mamNsYFlLphkIi6tZ7DQ9HSc4RSFzearo1Jptr72neQABaIZVVbX
         egGQ==
X-Gm-Message-State: AOJu0Yxnr8aXCo7gZL+0nXWpIvYLoSOnZDmswMEkow/fkNqSp1a3vr3k
	/QqB9NAxxt2S5u+YNzjImPLRFxG5l4k=
X-Google-Smtp-Source: AGHT+IHSGc3YoPxDtEzMBIIDVpjwJ36pSYYOeGGCT294/VUaa1hkpwh4XVkxyOqA2FN25iDzWFlFUg==
X-Received: by 2002:a05:6871:7582:b0:1ea:15e6:9420 with SMTP id nz2-20020a056871758200b001ea15e69420mr3162839oac.52.1698418496787;
        Fri, 27 Oct 2023 07:54:56 -0700 (PDT)
Received: from ?IPV6:2600:1700:e321:62f0:329c:23ff:fee3:9d7c? ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id i184-20020a25d1c1000000b00d677aec54ffsm706978ybg.60.2023.10.27.07.54.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 27 Oct 2023 07:54:56 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Message-ID: <43b45922-118c-3f77-80f2-960fa398cf1f@roeck-us.net>
Date: Fri, 27 Oct 2023 07:54:54 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH 5.10 000/199] 5.10.199-rc2 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
 linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
 akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org
References: <20231024083326.219645073@linuxfoundation.org>
 <6413ac66-2608-cd76-1b3c-5a185fe6d88d@roeck-us.net>
 <2023102728-gigantic-favorable-71a6@gregkh>
From: Guenter Roeck <linux@roeck-us.net>
In-Reply-To: <2023102728-gigantic-favorable-71a6@gregkh>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/27/23 05:25, Greg Kroah-Hartman wrote:
> On Wed, Oct 25, 2023 at 08:07:26AM -0700, Guenter Roeck wrote:
>> On 10/24/23 01:36, Greg Kroah-Hartman wrote:
>>> This is the start of the stable review cycle for the 5.10.199 release.
>>> There are 199 patches in this series, all will be posted as a response
>>> to this one.  If anyone has any issues with these being applied, please
>>> let me know.
>>>
>>> Responses should be made by Thu, 26 Oct 2023 08:32:45 +0000.
>>> Anything received after that time might be too late.
>>>
>>
>> Build reference: v5.10.198-200-ge31b6513c43d
>> Compiler version: x86_64-linux-gcc (GCC) 11.4.0
>> Assembler version: GNU assembler (GNU Binutils) 2.40
>>
>> Building x86_64:defconfig ... passed
>> Building x86_64:allyesconfig ... failed
>> --------------
>> Error log:
>> Unsupported relocation type: unknown type rel type name (-1940038754)
>> make[3]: *** [arch/x86/boot/compressed/Makefile:122: arch/x86/boot/compressed/vmlinux.relocs] Error 1
>> make[3]: *** Deleting file 'arch/x86/boot/compressed/vmlinux.relocs'
>> make[3]: *** Waiting for unfinished jobs....
>> x86_64-linux-objcopy: vmlinux: unsupported relocation type 0x9e
>> x86_64-linux-objcopy: vmlinux[.text]: relocation count is negative: bad value
>> make[3]: *** [arch/x86/boot/compressed/Makefile:114: arch/x86/boot/compressed/vmlinux.bin] Error 1
>> make[2]: *** [arch/x86/boot/Makefile:115: arch/x86/boot/compressed/vmlinux] Error 2
>> make[1]: *** [arch/x86/Makefile:274: bzImage] Error 2
>> make: *** [Makefile:192: __sub-make] Error 2
>>
>> No idea what is causing it, but it is persistent. Something odd between
>> compiler/binutils/objcopy.
>>
>> Guess it doesn't matter since the release is out already.
> 
> If the commit that causes this can be figured out, we can revert it.
> 

The final release built fine. I see this happen once in a while but
was never able to figure out what causes it to happen. So far it was
always persistent on a given source but disappeared as soon as something
changed in the code (making it all but impossible to bisect).
Looks like that happened again.

Guenter

