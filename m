Received: from mail-il1-f175.google.com (mail-il1-f175.google.com [209.85.166.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 302D6190
	for <patches@lists.linux.dev>; Tue,  6 Dec 2022 02:34:15 +0000 (UTC)
Received: by mail-il1-f175.google.com with SMTP id h17so5964866ila.6
        for <patches@lists.linux.dev>; Mon, 05 Dec 2022 18:34:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=YQ+tWAhNbDC0gmqSfgmib95RFSeFm70jylleXDIP6pY=;
        b=O7dnDobbSZ5rZ/6HKQT4AQv4tfeKaCnjYVuqVWXewEiU9XUXptBxB9ZQNGTybQVALk
         M+OGuOcu9HjhXbeCltyAl5laJQs7eB0QJEYH7+S7ZPHdfqeiqcZ3hVj/IjHI3l+MfftW
         aiyA82sgTFnqHv+HuYCdBoCB5koUuX0cs+4ts=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YQ+tWAhNbDC0gmqSfgmib95RFSeFm70jylleXDIP6pY=;
        b=nvnrhEJXZgFtUQRLR49zGJlz0oxS2E95NczqU48OcUtCtZss1vpNyRo60c31v48H3d
         vvJJucfRIkB5eFdIpqIeynCIW/IEO5MMJ0xr2pX0QEdQ4dxED21t8STkbplVf/fY9Foa
         cDp1xtOfAeQmNNED1HrT7lDV2R0GyZKvRPSSfsvVtR+pwsW9JwpPIa+VSpxE9SiVaAKe
         +eHTWS3G+X9SknGnsc17iVfAaQwGGuRbYEtRun9OOQGnOInXIJ+/bdg8Nxox+nWWZaBd
         UqYoyaBQff2N1B11vrvE6JSxPzFzMVfQT52zR2sr/NpPN2ZyB7coeQx5YZz/i3q/mDNd
         38AA==
X-Gm-Message-State: ANoB5pnuJIFkfEok/Fcb5PHP4nHK994BZ+KBxBhaFvyxzCmN+/VGHIdJ
	7UUaKpobnli3w4Jjrjkk60DhYw==
X-Google-Smtp-Source: AA0mqf6TZ39fhZkN+lz6iWVbqJnfP7DZb0dFPZCAl8c+38xAhdbnjUMZWZ6eQmFYCF179mKTIk9zfQ==
X-Received: by 2002:a92:2912:0:b0:303:c52:274a with SMTP id l18-20020a922912000000b003030c52274amr18202362ilg.171.1670294055082;
        Mon, 05 Dec 2022 18:34:15 -0800 (PST)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id w193-20020a022aca000000b003760a908bfasm6247677jaw.169.2022.12.05.18.34.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 05 Dec 2022 18:34:14 -0800 (PST)
Message-ID: <0cc3b3ca-ff9a-538b-4e33-a0d805861ab5@linuxfoundation.org>
Date: Mon, 5 Dec 2022 19:34:12 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH 5.15 000/120] 5.15.82-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, Shuah Khan <skhan@linuxfoundation.org>
References: <20221205190806.528972574@linuxfoundation.org>
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20221205190806.528972574@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/5/22 12:09, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.82 release.
> There are 120 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 07 Dec 2022 19:07:46 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.82-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
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
