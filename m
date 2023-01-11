Received: from mail-io1-f53.google.com (mail-io1-f53.google.com [209.85.166.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17D9F15A7
	for <patches@lists.linux.dev>; Wed, 11 Jan 2023 00:35:52 +0000 (UTC)
Received: by mail-io1-f53.google.com with SMTP id v65so2690381ioe.4
        for <patches@lists.linux.dev>; Tue, 10 Jan 2023 16:35:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Jko9O+H74wBBe0vOgpMZquu4AW4dJPh7ek9zytA8QWA=;
        b=ej5SdkZ0rhZ8OirQ5cw+cdTsBKp2j6imgTWQsU6NomwCVNByPVX27BICW7YY3aAXG8
         h4Ov0PriuTmzAAmr508gHAfF5cYRaxOwM92Lxi2hUoyL5z9H0It0NOOW4uhvNXOF9jnq
         dOzgT57GV/CWsQzGMDChc5kLScIhV2c4JmCGQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Jko9O+H74wBBe0vOgpMZquu4AW4dJPh7ek9zytA8QWA=;
        b=JvWam1sT605jQ2X//BZPpgTHDsXVVKu6Qk/T0/8+l3YlsOWn/uMFiErUX0d4yMAHxp
         y7+C4QT+53CHApJSUiUHV3PgNvHZaL0bEH660wS5F7MKDXPd2vliN/mkNpGNvC1vUVou
         ZgMtBSY6LHAXeImcVDSjC7mTGz3GI3Z4kuSk4TPJiEoD3F+dolD/dm7B6wgJ5fSOqmss
         mSfo3DJgz59x97z3+BYeTYZ7Q3DAtFfpPQs6gvUy3btLBKpD9E65YYDQwd4GNkKsuoiS
         NmjXl3PnvQbfOmYUtJEz5bXB1naNGNwkiLEWdRzn2uhq8w1xlxNwNFQREjrPC87L50z5
         OFNw==
X-Gm-Message-State: AFqh2kqmfVxgZ262fPg0EvIAgrq/OQcZ9JlwiKMSKU+RIvP3RIYaNE5G
	06T/+90RYiSHpkfYlsHKBB4OuA==
X-Google-Smtp-Source: AMrXdXs70iWKDDZEzh1upPNH2VzfIiP+zp3BGuibA61MaamqhSuNsHg+3IfwNjQemF5pZboJPVXJRw==
X-Received: by 2002:a6b:e812:0:b0:6f3:fed4:aa36 with SMTP id f18-20020a6be812000000b006f3fed4aa36mr8574987ioh.1.1673397352003;
        Tue, 10 Jan 2023 16:35:52 -0800 (PST)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id u10-20020a02c04a000000b0039d756fb908sm4086138jam.40.2023.01.10.16.35.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Jan 2023 16:35:51 -0800 (PST)
Message-ID: <ac8d8ff5-75ca-c399-7c1c-b71ebea2229a@linuxfoundation.org>
Date: Tue, 10 Jan 2023 17:35:50 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH 6.1 000/159] 6.1.5-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, Shuah Khan <skhan@linuxfoundation.org>
References: <20230110180018.288460217@linuxfoundation.org>
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20230110180018.288460217@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/10/23 11:02, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.5 release.
> There are 159 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 12 Jan 2023 17:59:42 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.5-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
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

