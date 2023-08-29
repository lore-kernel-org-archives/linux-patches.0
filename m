Received: from mail-il1-f176.google.com (mail-il1-f176.google.com [209.85.166.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F4C817ABE
	for <patches@lists.linux.dev>; Tue, 29 Aug 2023 14:31:30 +0000 (UTC)
Received: by mail-il1-f176.google.com with SMTP id e9e14a558f8ab-34bae11c5a6so3491075ab.0
        for <patches@lists.linux.dev>; Tue, 29 Aug 2023 07:31:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1693319489; x=1693924289;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=2Wv1qx1QuMk9lQBurvufJPtkuCt8LqeR1hukSIeupGQ=;
        b=ASLN4rNXK+TbXbhxgCc0jywxJ6k3fCVXyB/c2YGU+Wviy+PveGSKFK94/MAYQHpVWk
         x5YULkf9ru2Lok44CYdHr9UOcFDqfugiPZQ5vJtkChlSyMn3vKNZtCDhG+YDAS584u3h
         JcilNlI1kMp1KNc5DDbJ0jwgiA6mcSHlD5VOM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693319489; x=1693924289;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2Wv1qx1QuMk9lQBurvufJPtkuCt8LqeR1hukSIeupGQ=;
        b=bk6WVX4z1+nBE066mrP8XPIW11xnzu/yfXiHFFgEtIEpbl9SpVnoGWlOfzFMtRPzlQ
         Gcrlgsf0Yv0c3nWFfyJR3fPROWaC9rU8kgnsbygQlsG2hJGsPFkdK4LnX3jxh05IOrM7
         I3orQw3D7p+lkFcGJmjoefzXU9/dn3DXQJjJgzjU5maKksCttmRi1UO+Zm+AXhwzt6C4
         bJiTmOdbbDg2FYE2218/gWRTcQCntJrm54+DU1Aw4zNJYMb4oUL9h1xMYpMyZLZ/ebBA
         K6MGlLMzZq5jRXbkT2r8TUld8kZSvfwoPQO8s4JjWl1qf+WTEjm4dzQoE1slmWF8WQgQ
         W6wg==
X-Gm-Message-State: AOJu0YzNV3pRcPaECUmg2jsyGYSOtaUS+S4x7WKcCDMRX48ah301uBMa
	ykomndYN47+UheEqffY+SfjWvQ==
X-Google-Smtp-Source: AGHT+IGHEHRGN+SqlSx9SNUOkFSh/Dg8cYNqtY/QuM59ulqH706FbLV81tOCJyH4RuaAanofng3v9w==
X-Received: by 2002:a92:da88:0:b0:349:4e1f:e9a0 with SMTP id u8-20020a92da88000000b003494e1fe9a0mr29377757iln.2.1693319489497;
        Tue, 29 Aug 2023 07:31:29 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id gm10-20020a0566382b8a00b0042b70c5d242sm3056685jab.116.2023.08.29.07.31.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 29 Aug 2023 07:31:28 -0700 (PDT)
Message-ID: <1acdd9ad-2ccf-b576-9ca3-59fcae203c5e@linuxfoundation.org>
Date: Tue, 29 Aug 2023 08:31:27 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH 4.19 000/129] 4.19.293-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, Shuah Khan <skhan@linuxfoundation.org>
References: <20230828101153.030066927@linuxfoundation.org>
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20230828101153.030066927@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/28/23 04:11, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.293 release.
> There are 129 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 30 Aug 2023 10:11:30 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.293-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

Compiled and booted on my test system. No dmesg regressions.

Tested-by: Shuah Khan <skhan@linuxfoundation.org>

thanks,
-- Shuah
