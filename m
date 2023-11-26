Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5F1212E51
	for <patches@lists.linux.dev>; Sun, 26 Nov 2023 18:33:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bGa1a8iR"
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-6c431b91b2aso2596891b3a.1
        for <patches@lists.linux.dev>; Sun, 26 Nov 2023 10:33:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1701023599; x=1701628399; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:autocrypt:from:references:cc
         :to:content-language:subject:user-agent:mime-version:date:message-id
         :sender:from:to:cc:subject:date:message-id:reply-to;
        bh=ZVmDhjOXqhvKgFkEdvXLesWKtT+5+6HRJ1ntux/QoPo=;
        b=bGa1a8iRxAPBebqNfSgH9kXIB7mQ58fRqbZzoySwFEdUidYSDiSlo5tAoAbHUYWAtY
         V6l190rB1VnorbPDWdhw1QoZMr9jbfjdLddt7ziOGvt0ANXTZ0Nywei9kclGDTlG13xy
         Fcqhq4oRL5UvieHK6rqIB+v/2tcw/jcKaMI3PuwvGu+Fbvoqb+tk7sY2+0DR8/ZVwTKo
         YepQagxHfJL4rOmYjrPeOvhIRCE7nhhsHlLndEHK9untEzDlEIv/+UI1JyAV+oLWP7/k
         tvU4eXWf93nM3j34YHsb4J93rPFebmOpxRej397IHXOqvKfNWO2lEXEHWChV2eNnDz8X
         /oCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701023599; x=1701628399;
        h=content-transfer-encoding:in-reply-to:autocrypt:from:references:cc
         :to:content-language:subject:user-agent:mime-version:date:message-id
         :sender:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ZVmDhjOXqhvKgFkEdvXLesWKtT+5+6HRJ1ntux/QoPo=;
        b=uGzKMt6DCLLyNydY9YN555J5uwcvOdqynki81Ytq7VEl4IQjF7KB1rP8meS1hHVy3q
         XcvDitOfRDegCQTMcBLfOaAAOBb3NeQGmgR+J1loGsfitw42M2i29FX9aRhpgdEmXRPK
         lXOmmF+Ip+gT8eO0UVqUnJKNGC+4UXeNCRJV1a6kCBoRhatcWA18FEazW2CO02EuiR0+
         NB755DRzQKGwEmux3ez1UWiPp70M3Kgmme5pOedXmzAkbttMJIMXPnsCUMCFzrnOdgve
         fosnb7NvLkP5EzOHQfJ+U/d1N6QAe0cybVK01BhRmxmlL9lxDpkAHHHOfZQZ01zT4nP0
         /D9g==
X-Gm-Message-State: AOJu0Yyr4a6ZP6QDm3zgU6E7i5FbvNouGiDpMjr21syAz2Ri3mzy8x8E
	i2HsrweJv4V6iKXxY3HHvdw=
X-Google-Smtp-Source: AGHT+IEdVS1JbMFlp6ZZQNruwQlaMMngzWg7HnKoKlQvgn+RUYQwxgW3PasscTn0Hqru5nfHWniQhA==
X-Received: by 2002:a05:6a20:d70a:b0:18a:e7cf:7be with SMTP id iz10-20020a056a20d70a00b0018ae7cf07bemr8470281pzb.52.1701023598811;
        Sun, 26 Nov 2023 10:33:18 -0800 (PST)
Received: from ?IPV6:2600:1700:e321:62f0:329c:23ff:fee3:9d7c? ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id a7-20020a656407000000b005b83bc255fbsm5484576pgv.71.2023.11.26.10.33.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 26 Nov 2023 10:33:18 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Message-ID: <09f33739-9bf6-4ff8-895d-92d3567c3cb9@roeck-us.net>
Date: Sun, 26 Nov 2023 10:33:16 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4.14 00/53] 4.14.331-rc2 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org, shuah@kernel.org,
 patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
 jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
 srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
 allen.lkml@gmail.com, Helge Deller <deller@gmx.de>
References: <20231125163059.878143365@linuxfoundation.org>
From: Guenter Roeck <linux@roeck-us.net>
Autocrypt: addr=linux@roeck-us.net; keydata=
 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
 mDW4+i+XlNFUPUYMrIKi9joBhu18ssf5i5Q=
In-Reply-To: <20231125163059.878143365@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/25/23 08:32, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.331 release.
> There are 53 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Mon, 27 Nov 2023 16:30:48 +0000.
> Anything received after that time might be too late.
> 

Building parisc64:generic-64bit_defconfig ... failed
--------------
Error log:
hppa64-linux-ld: arch/parisc/kernel/head.o: in function `$iodc_panic':
(.head.text+0x64): undefined reference to `init_stack'
hppa64-linux-ld: (.head.text+0x68): undefined reference to `init_stack'
make[1]: *** [Makefile:1049: vmlinux] Error 1
make: *** [Makefile:153: sub-make] Error 2

Bisect log:

# bad: [39ca2c4cec46e5ef545815f62be91cba998b8927] Linux 4.14.331-rc2
# good: [bfa43eeca4797e58975ba8c54057c1f29bf20534] Linux 4.14.330
git bisect start 'HEAD' 'v4.14.330'
# good: [5bc5bf29b42fb16faa4407f9c01f05dadb397f2f] media: venus: hfi: add checks to perform sanity on queue pointers
git bisect good 5bc5bf29b42fb16faa4407f9c01f05dadb397f2f
# good: [2e1d20a37188fbca246de24800f3fb0e9ab8d233] mcb: fix error handling for different scenarios when parsing
git bisect good 2e1d20a37188fbca246de24800f3fb0e9ab8d233
# bad: [6c59b6c8a0be15fa1db3d07ffcad481aa507f8be] media: venus: hfi: fix the check to handle session buffer requirement
git bisect bad 6c59b6c8a0be15fa1db3d07ffcad481aa507f8be
# bad: [581615c5d0e31e0033e3458e248c6e3646b5ab13] ALSA: info: Fix potential deadlock at disconnection
git bisect bad 581615c5d0e31e0033e3458e248c6e3646b5ab13
# bad: [af3526c44f86f56af5963e8ed6dc77fc1e76ccc5] parisc/pgtable: Do not drop upper 5 address bits of physical address
git bisect bad af3526c44f86f56af5963e8ed6dc77fc1e76ccc5
# bad: [6eddd5699c407a706d8e914e0c88934c4e1b6e27] parisc: Prevent booting 64-bit kernels on PA1.x machines
git bisect bad 6eddd5699c407a706d8e914e0c88934c4e1b6e27
# first bad commit: [6eddd5699c407a706d8e914e0c88934c4e1b6e27] parisc: Prevent booting 64-bit kernels on PA1.x machines

FWIW, the offending patch is tagged "Cc:  <stable@vger.kernel.org> # v6.0+"

Guenter

