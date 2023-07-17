Received: from mail-io1-f68.google.com (mail-io1-f68.google.com [209.85.166.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0293253AC
	for <patches@lists.linux.dev>; Mon, 17 Jul 2023 20:46:57 +0000 (UTC)
Received: by mail-io1-f68.google.com with SMTP id ca18e2360f4ac-785d3a53ed6so51255439f.1
        for <patches@lists.linux.dev>; Mon, 17 Jul 2023 13:46:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1689626817; x=1690231617;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=o5Y7u4wfa9oxMl286OAt5AFdptDBXZp+DAaKqKC9VPo=;
        b=h9HFz6+BsVaa7HnDrYPrytj3Cs0CLnvdrulRpVKx2ZbdhMu3iSKd7RWNYaCMrDG+ZF
         IHGegPK/6uPuaqemeaDcTFwprLL/SVlqP+b9J9SwTD7aBLgJo+MF86/ytNr1yJTBpqL3
         VZvf0bd7tAsVlfdeQdpeSn4xr7wmmPrls6hT8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689626817; x=1690231617;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=o5Y7u4wfa9oxMl286OAt5AFdptDBXZp+DAaKqKC9VPo=;
        b=kYpxfOM0U9Qj3WUKH3lURl00bALYhy5fDOFNMGGLrb7N7+WvzeBqQGmzLUogNm5KHf
         5CllVmjyma1DLhfJogb88jck2oCXikgWFzpj6DQ3mQIhwAbqXx4WRukG80upnSTVCkkM
         V2LL+TSxe7+RliAziXUtAD6iv80YftOSVWh5v+s0Uzc0oonSBmMpyK+dapGp57BdODiS
         otmficoP3FYoBeXggzL0KanWosYTHU9fILHX39UPYjXhLH0ks2k4HMbvRvBAG9huk6HV
         ZVHOdDRwdA6t+k58ZH1sRr6CtJzsCzO+S4Bbn5+hUffXiEM5KVegW8Zflg/2sB8zHHko
         JNCQ==
X-Gm-Message-State: ABy/qLaSS2AHeioO7r7faxb5RmGF+FhJJ7F2mn3pEcJG1BNdApMFfzGj
	/qYQuRpo95Z8Cg+Rg90ZaufFMQ==
X-Google-Smtp-Source: APBJJlF1StXb1kQ2bKseGNs05QRsBxvtV27vpfuo3v6EBu1Kp/dI/8vKYBw+tyVXSYfP9k4+zCFrPA==
X-Received: by 2002:a05:6e02:3486:b0:33b:d741:5888 with SMTP id bp6-20020a056e02348600b0033bd7415888mr786725ilb.0.1689626816791;
        Mon, 17 Jul 2023 13:46:56 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id v18-20020a92d252000000b00345e3a04f2dsm180502ilg.62.2023.07.17.13.46.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Jul 2023 13:46:56 -0700 (PDT)
Message-ID: <e143da96-6abf-0572-c112-46bb39e11bc1@linuxfoundation.org>
Date: Mon, 17 Jul 2023 14:46:55 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH 6.4 000/800] 6.4.4-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, Shuah Khan <skhan@linuxfoundation.org>
References: <20230716194949.099592437@linuxfoundation.org>
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20230716194949.099592437@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/16/23 13:37, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.4.4 release.
> There are 800 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Tue, 18 Jul 2023 19:48:07 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.4.4-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.4.y
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
