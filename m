Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68AFF15494
	for <patches@lists.linux.dev>; Mon, 18 Sep 2023 15:17:47 +0000 (UTC)
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-690b85eb2dcso281255b3a.0
        for <patches@lists.linux.dev>; Mon, 18 Sep 2023 08:17:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1695050266; x=1695655066; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:subject:from:references:cc:to
         :content-language:user-agent:mime-version:date:message-id:sender
         :from:to:cc:subject:date:message-id:reply-to;
        bh=81F5bCn6l0BRx0w8BQQ9iQyXJ5D/anBMfPMtaxEr1bY=;
        b=B0u/FbYAj5mk4GvDmRGpKvdxnQnKy+3IJluIjiraC7ccYd1LJvWknvG0D8t1Cj+46Q
         MYdWuLKL/Dbdq5O4Rgzkya87QOLDtzDdr0oQr9E9DKxJfivflbhRZcONgZotf1wcALfG
         25cXSrx3tRK/FhQwUAIPtZfP7DS/++m9kHnUb4ETyYg7jjjwz7+fjR67pIRqdZLh8eGQ
         CdHDRHVOLY7nY+Jrl3TJ1YcjylXLrxKKecp0a9u3eROMXjI4sZ53GqlWk0kUzCzewXJu
         82vTYUU7PVup/0ffqXlHzJK7eTlPq3zrKD1rmMh/g3WhwiZkQbZbvdcZjLn6PrcCa6O8
         CJjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695050266; x=1695655066;
        h=content-transfer-encoding:in-reply-to:subject:from:references:cc:to
         :content-language:user-agent:mime-version:date:message-id:sender
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=81F5bCn6l0BRx0w8BQQ9iQyXJ5D/anBMfPMtaxEr1bY=;
        b=C8uw62TP7bW85pf1sYKHDT9aXaAA1fL7mi0EA5zf69VtvtMV6vukSCEr/MKll1WzzB
         Cmyv6mKL4DS0r4ozUpo3k7WyrHEYzW5zlnyrIPFFIhhLraKIMYQYwgJFxNUEp6je6jv9
         7bE3cPaSQ2YLamt9ucA1/qRId8WvWZ16LChohKVM1TrLTdAffcRUsrcszEPYS8zcJAKT
         RGzKYoi33SwBAaD7Fd95MvfBNFY4V4hHOXeuUIJ26PezBAVNM5Q5GUALw73Gfz+h/S6F
         DK8lIdWYRoWd0fwtG8SDmyiP+dnJ+njX7cMz1sWtQ7/iNqizZ+JgKFm6U1w7ci3B3xQj
         z67Q==
X-Gm-Message-State: AOJu0Yz9OzKWzQREiA8xak00+eWHCWCZ3p45i77mt7giZxLPlmdGU2oX
	pKlim+C5vSWk9hxUyw4OunM=
X-Google-Smtp-Source: AGHT+IEEHnstItrfV2ospP26Zbe9echZD3JFu/HZ+3QxynojEh6WWiPS31m7MAaP+EWyKGulJBd4Xw==
X-Received: by 2002:a05:6a00:1912:b0:68e:23c9:b306 with SMTP id y18-20020a056a00191200b0068e23c9b306mr12385588pfi.30.1695050266548;
        Mon, 18 Sep 2023 08:17:46 -0700 (PDT)
Received: from ?IPV6:2600:1700:e321:62f0:329c:23ff:fee3:9d7c? ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id p15-20020a62ab0f000000b0067aea93af40sm7310632pff.2.2023.09.18.08.17.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Sep 2023 08:17:45 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Message-ID: <bae1a61f-ab9d-2560-9c70-e09092363467@roeck-us.net>
Date: Mon, 18 Sep 2023 08:17:43 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Jon Hunter <jonathanh@nvidia.com>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
 linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
 akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, f.fainelli@gmail.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, Sameer Pujar <spujar@nvidia.com>,
 "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
References: <20230917191051.639202302@linuxfoundation.org>
 <dfe78c1a-8322-413b-f1b7-3a6a307a831c@nvidia.com>
 <2023091846-cabbage-imagines-3fde@gregkh>
From: Guenter Roeck <linux@roeck-us.net>
Subject: Re: [PATCH 6.5 000/285] 6.5.4-rc1 review
In-Reply-To: <2023091846-cabbage-imagines-3fde@gregkh>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/18/23 05:56, Greg Kroah-Hartman wrote:
> On Mon, Sep 18, 2023 at 01:52:10PM +0100, Jon Hunter wrote:
>> Hi Greg,
>>
>> On 17/09/2023 20:10, Greg Kroah-Hartman wrote:
>>> This is the start of the stable review cycle for the 6.5.4 release.
>>> There are 285 patches in this series, all will be posted as a response
>>> to this one.  If anyone has any issues with these being applied, please
>>> let me know.
>>>
>>> Responses should be made by Tue, 19 Sep 2023 19:10:04 +0000.
>>> Anything received after that time might be too late.
>>>
>>> The whole patch series can be found in one patch at:
>>> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.5.4-rc1.gz
>>> or in the git tree and branch at:
>>> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.5.y
>>> and the diffstat can be found below.
>>>
>>> thanks,
>>>
>>> greg k-h
>>>
>>> -------------
>>> Pseudo-Shortlog of commits:
>>
>> ...
>>
>>> Sameer Pujar <spujar@nvidia.com>
>>>       arm64: tegra: Update AHUB clock parent and rate
>>
>>
>> Unfortunately, the above change is causing a regression in one of our audio
>> tests and we are looking into why this is.
>>
>> Can we drop this from stable for now?
> 
> Is it also a problem in Linus's tree?  Keeping bug-compatible is always
> good :)
> 

Sorry, no, it isn't, especially in the context of at the same time suggesting
that everyone should start using the most recent stable release immediately
(instead of, say, selectively picking security patches).

I don't think Tegra users would be happy if their audio stopped working,
and it seems unlikely that they would accept the argument that they should
be happy to be bug-compatible with the latest upstream kernel - even more so
if that latest upstream kernel is a release candidate and the problem was
introduced in the commit window.

Guenter

