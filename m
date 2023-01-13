Received: from mail-io1-f46.google.com (mail-io1-f46.google.com [209.85.166.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62859364
	for <patches@lists.linux.dev>; Fri, 13 Jan 2023 00:27:38 +0000 (UTC)
Received: by mail-io1-f46.google.com with SMTP id y205so5310233iof.0
        for <patches@lists.linux.dev>; Thu, 12 Jan 2023 16:27:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=1GucQ7IC2vs1Pp3LSSYYnizzJcFER36SWu2dsnAe2xY=;
        b=cWrv22mkJqX9J+d6nUQvIN2mIMf7UmYwe3PoTKLngPDf0qrBbZrDjBSakwNv3I/vYi
         tGRhtbFPVt4CBD3IQhffOemqgdqIXbsDHoDroZgEfiad3o3tkSTH5iTyCKpaZEE/rsSd
         NbmB6AwzmBgEzzt7eDVxU4vCK7+xK++zca/0U=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1GucQ7IC2vs1Pp3LSSYYnizzJcFER36SWu2dsnAe2xY=;
        b=XwYUAWeTEowAxGwCawbNAdHifOCXWeGzNuY1aEPIi+ytXU33dHyctmydDefSXrp9nF
         c48wwglRxZIpeWVr8XpeSLCrwO+zCOtMpA1nGHZxSKK0Ux45ovLbxMZ/Y3SJGJ5icEko
         Vzwk0AXysQ/cWjwXW7P7QamMipMAVG26Daq94Gu5LFIp1jYyKuceT8kPw3MJfQBt8xSD
         C1g6ysvwQA9RWH79hPB2QMIGq88cCKLLTnHWyZtA6ZxywSLx1IVD/YGmp0DjMIFxx6Zq
         UTPSuCG3Kp4U7Zh8sxO3QO/RcWA1JA/HTCHzPyQpUI29wIfcmp69vxvQq8Mxyna3hAi6
         KGlw==
X-Gm-Message-State: AFqh2koEshxSG71Ad9EV8Sg+67qscXqhUSpb+Lz/z+W8mLyWrhST8HiB
	vE0RonkrP8FssROTzmik0ywdOA==
X-Google-Smtp-Source: AMrXdXuTDGOoGzU+R8vDvplB1NUrFuoEe6O3G5AkuuM2MqJbjqKDZhBsODiegGWmtuOcoWAYGsPn1Q==
X-Received: by 2002:a05:6602:1cf:b0:6ed:95f:92e7 with SMTP id w15-20020a05660201cf00b006ed095f92e7mr9233757iot.0.1673569657202;
        Thu, 12 Jan 2023 16:27:37 -0800 (PST)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id c15-20020a02330f000000b0038a6ae38ceasm5997415jae.26.2023.01.12.16.27.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Jan 2023 16:27:36 -0800 (PST)
Message-ID: <ae0e974d-1ea8-ddd1-85a2-10e9679854c4@linuxfoundation.org>
Date: Thu, 12 Jan 2023 17:27:35 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH 6.1 00/10] 6.1.6-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, Shuah Khan <skhan@linuxfoundation.org>
References: <20230112135326.981869724@linuxfoundation.org>
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20230112135326.981869724@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/12/23 06:56, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.6 release.
> There are 10 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 14 Jan 2023 13:53:18 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.6-rc1.gz
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
