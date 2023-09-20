Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22AED41206
	for <patches@lists.linux.dev>; Wed, 20 Sep 2023 20:00:02 +0000 (UTC)
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-690d2441b95so88103b3a.1
        for <patches@lists.linux.dev>; Wed, 20 Sep 2023 13:00:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1695240001; x=1695844801; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=GMAeJbPcmItdDgf4xgk+JNHaknHRQgjDFugqEkpXkAc=;
        b=Ms1tUgGOUOxlEkGv3sxKnAEyWDtcOMPr982yPSIdDHH8vEyDgUgIyHNzOeOkGNIIRV
         EuikjHZcnVsD5kfSDSZEfV6tC0cHh1pWkAasectDzRLqhDaOejBBrkI1RMVRNuyn954s
         mMqlGbBtmqddH+t5kuO+foC10wRIG2Awo066H2sEG0pFmC7D0hNEQIARAhPx6ZIvXLxf
         tdun5iruWsBSXr/vDwi99YXcraGzrue+sXnbghlNhSlt7kDEUHlQOTuNdgZDR5s87+f7
         r10/lHRVH9VQ2InhqwjmpIerAsEI6w8oSiOs9OyzzYC9+1eDE2D1x0C/GV+tCED5R0Ys
         8ZQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695240001; x=1695844801;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=GMAeJbPcmItdDgf4xgk+JNHaknHRQgjDFugqEkpXkAc=;
        b=BHpXtOyh3LOIyoxx5/SAmigQTUs6hCidogqGLiwBpGY8ZUXh4d9BDHhPuFuqmzDRDz
         iAl60w0MSFBZ+P1wGzXze8AjTIjWmI6zFqXW/wy2OWeMv5aDp2a4Gi6zLk8mH0flpUv8
         Ukb0eQKDuH1H9l27/3yVO1iUT85Qia0C9vvwJTQIoPEDqzZAWE3A546IDrbh8pp3wTRY
         jz/HIZIj4nTpwiXlpAdPWxt4rhLm4Hk5zS0QE8u+iTU4VYdq7YcqbfzNp3xKpOa2mc5V
         jMBkphIMNUi6ZTPi9xeo7upeUzCLFrOA0DU1qUn10UFeZkixXWOyUhq22aXHuKTzojVL
         ZMhQ==
X-Gm-Message-State: AOJu0YxQNHfwZaLz41TjoL4oypcwlUxgr+neE00cpDh7jfnBR4KLRPs7
	cpzU7h5lrXGWxfgLvjAY24A=
X-Google-Smtp-Source: AGHT+IGQvVEeSuvsRNTzKfh0H6AJmFAA5vkIfdi+bWjfJVdsi4gXOQ/xAkDweZEoNes91BOOHx3/hg==
X-Received: by 2002:a05:6a20:6a23:b0:159:c07d:66f0 with SMTP id p35-20020a056a206a2300b00159c07d66f0mr5162159pzk.6.1695240001285;
        Wed, 20 Sep 2023 13:00:01 -0700 (PDT)
Received: from [10.67.49.139] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id x18-20020aa79192000000b0063b898b3502sm10638330pfa.153.2023.09.20.12.59.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 Sep 2023 13:00:00 -0700 (PDT)
Message-ID: <4ef9c827-f061-7b39-ea4d-6d57c16df9f9@gmail.com>
Date: Wed, 20 Sep 2023 12:59:58 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH 6.5 000/211] 6.5.5-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org
References: <20230920112845.859868994@linuxfoundation.org>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230920112845.859868994@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/20/23 04:27, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.5.5 release.
> There are 211 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 22 Sep 2023 11:28:09 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.5.5-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.5.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels, build tested on 
BMIPS_GENERIC:

Tested-by: Florian Fainelli <florian.fainelli@broadcom.com>
-- 
Florian

