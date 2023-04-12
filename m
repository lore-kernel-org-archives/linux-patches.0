Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F845746F
	for <patches@lists.linux.dev>; Wed, 12 Apr 2023 18:06:32 +0000 (UTC)
Received: by mail-pl1-f181.google.com with SMTP id o2so12223193plg.4
        for <patches@lists.linux.dev>; Wed, 12 Apr 2023 11:06:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681322792; x=1683914792;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Gm3/ETzCMqkiwfcEp3WUrrhX4jWWK8xsRn2G76zJNaM=;
        b=oLCDuBQE/kD8GVPu/3oo4c19DM3uXs75rXuoa00FgdX2qMW8b9YB837IeJvenTFZrw
         Uq5JFjYMaWTURbayIIN5NWTNmkIzQHkIGBHjrArhXVhRk2WIVej1yXuqd8wkfBUbKIwi
         mMQEzgqQUL44xM+Q+ammgqk/T6St/pvapC40MxLdqKFoLE1TaEfyQfzmQLZ7uT1FuJTw
         Dreo9a19jXKNC1v2qbSV5y+Kd5i8opXOmvWnxkxI4Ja9ZMbHiEIkBU35yanGAdpif7r6
         PfZGoa2JRhyVQh0OvwGaBhEoQ1AWrfD0jDMYjyGrLz/y/I4wVNUOb8s1yMlwYZMUuE7J
         gDCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681322792; x=1683914792;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Gm3/ETzCMqkiwfcEp3WUrrhX4jWWK8xsRn2G76zJNaM=;
        b=FR02+L5hTb5mltVhxCWEYJGJ3ZPC7cdwTmJJX8RHb+P47mJwckS40rktHp463btMqX
         hFYTh2ewlKORas12nE1Fj+5JdxuGQQqCi0BNcO+PW0vLqEfnrY9RJXaGW9D2cSibWCXn
         tkRT6ZQCnCdBZD43hSGdQrsBS3uX6QUdRJ5TfZV1SZjpDlYz1lUlRwISpfTnndyvx5Dm
         cLznBVzjVd8aTPPfQ+ke6Hd9PG9kw12nWFpduy87BQXtucaqBe9ngd3zpeLVImSz/QUT
         FL4nIAOmDm6CTf2GRyWMZTLD0fWnOmpL09nuSVLronyVTiKPQC0Uyp2B+cbK1/ucBkq7
         D2vQ==
X-Gm-Message-State: AAQBX9dVFSG0/SDNblW+WkSptzufgwVizjB86kHVsHHinl7tkQCtw7+J
	aHTtahbMmAW6fmDyvW+M+PM=
X-Google-Smtp-Source: AKy350b7qj9vz4EK69M2mBRkYZT9b9Q/qehdpqTVJFlkw07wOdwU0ujbLyHJtrnckc+0J36lT2UKVQ==
X-Received: by 2002:a17:90b:4f4a:b0:23a:6be8:9446 with SMTP id pj10-20020a17090b4f4a00b0023a6be89446mr21903465pjb.48.1681322791977;
        Wed, 12 Apr 2023 11:06:31 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id t21-20020a17090aae1500b00246952877d8sm1771754pjq.34.2023.04.12.11.06.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 12 Apr 2023 11:06:31 -0700 (PDT)
Message-ID: <461b00bb-4f1d-d457-72aa-5ff2dfe828f6@gmail.com>
Date: Wed, 12 Apr 2023 11:06:28 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH 6.1 000/164] 6.1.24-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20230412082836.695875037@linuxfoundation.org>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230412082836.695875037@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/12/23 01:32, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.24 release.
> There are 164 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 14 Apr 2023 08:28:02 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.24-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels, build tested on 
BMIPS_GENERIC:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian

