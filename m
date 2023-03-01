Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7281F23AF
	for <patches@lists.linux.dev>; Wed,  1 Mar 2023 18:48:56 +0000 (UTC)
Received: by mail-qt1-f175.google.com with SMTP id h19so15412070qtk.7
        for <patches@lists.linux.dev>; Wed, 01 Mar 2023 10:48:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sladewatkins.net; s=googled;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=lgEtVBqhYQM2xpZGmxizRfxew/mOAe3TsmV4ZLiINaw=;
        b=RsU5IMSG1sBe8t0gbZfGIvbtH9WMsbxCL0HIBI7r73OWudhZwiNkJ2YObGnL2Zv04k
         JxVdGGqOBoOZDlrIWfs/R3WB9fUbETelHfXwOVkAgu9Sqh/BPxOB4WjLODzjoANboTmg
         1g0lfzw5n6VGidrPdkQZsJ33K/iw8HptueoykObmlSEyXjYj9GeQNWZeyfvPtrWBG0fs
         lZqMsXUSwBlJiHvswDQMCgCQpE4bwqkmLhuGNWKfrWDpsolPkm0BEjZBXjUaFgtBKQTH
         9qLtbkvurAGjLkLyr0OI8h19AjxJgbiSh0JOPyC9cJzoWST/ziLtZ+R14POzbWDwcY09
         PZnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lgEtVBqhYQM2xpZGmxizRfxew/mOAe3TsmV4ZLiINaw=;
        b=0pn5AuwVcpuwiAAxHMbSWInXRyVsUHZchUfc+qlF2HdfXs8yBElLzZAgORqDczz5oP
         gTHT2gkH0waauosls7skJdIG5djSgLxgvNCnHCl/+LrbcqGpwhP7sbeOK6Ml0q3my5tD
         TexjbDarI+sUgm9UoTCURKa4CG2CcEXwhwlYCEXxba4aRhHHrVgyebTVnlpi4viAch6B
         O3Fgu0XVGxUwpXt0CKAFHxfR7DwSF8hN9m7yKrXbRfI2P5nVr2ZaSVs16xRcKGUBXIDp
         jN2d0zBvCDEsBXQsbV5jTV63pSxs2N1YlWE+DQSWknLV1a6awjxDzUeEseldyjHTECY8
         +rPA==
X-Gm-Message-State: AO0yUKVEw89WyhH1nogeDkM4iGICMz/NrCM64cxtqKhJQkeyqfSxtM4G
	X9L/UUlpj6npF9eEy2C0H0VveA==
X-Google-Smtp-Source: AK7set+1bLqI9kSwZBv3jy3IhBPxDvILB+hOxhOtidyH7eT01aGzUUHCgN8J7MjDAUGUV0Zy+9kb/A==
X-Received: by 2002:ac8:7d42:0:b0:3bf:e005:3a85 with SMTP id h2-20020ac87d42000000b003bfe0053a85mr12492782qtb.5.1677696535305;
        Wed, 01 Mar 2023 10:48:55 -0800 (PST)
Received: from ghost.leviathan.sladewatkins.net (pool-108-44-32-49.albyny.fios.verizon.net. [108.44.32.49])
        by smtp.gmail.com with ESMTPSA id k14-20020ac8604e000000b003bffe7fdc38sm246366qtm.9.2023.03.01.10.48.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Mar 2023 10:48:54 -0800 (PST)
Message-ID: <26116769-3620-0544-cdaf-02516ab5ae60@sladewatkins.net>
Date: Wed, 1 Mar 2023 13:48:52 -0500
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH 5.4 00/13] 5.4.234-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de
References: <20230301180651.177668495@linuxfoundation.org>
From: Slade Watkins <srw@sladewatkins.net>
In-Reply-To: <20230301180651.177668495@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 3/1/23 13:07, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.234 release.
> There are 13 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 03 Mar 2023 18:06:43 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.234-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.

5.4.234-rc1 compiled and booted on my x86_64 test system. No errors or
regressions.

Tested-by: Slade Watkins <srw@sladewatkins.net>

-- Slade

