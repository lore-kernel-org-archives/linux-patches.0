Received: from mail-vk1-f181.google.com (mail-vk1-f181.google.com [209.85.221.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E30528F7
	for <patches@lists.linux.dev>; Fri, 30 Dec 2022 17:47:56 +0000 (UTC)
Received: by mail-vk1-f181.google.com with SMTP id i84so3493719vke.7
        for <patches@lists.linux.dev>; Fri, 30 Dec 2022 09:47:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=AyGeXSWlMzOIy/hkiCrKDhhX38vwiuPZQyYWri0c344=;
        b=fR973Yi+rzbjCJmZ2Umj9yji3Guz0I05vIcCGfdewhFGacXUwu4l1TcLcNOBkOurUh
         /XubpBw0bC3q2Q3u0nyc9VXmeN5rKatQJZbrDNFCQybb9Klt0TWsMJYKGN5NOSX7mUeR
         tAg3s13KnfM9q+ncqw2zVuY8RrRaTfXCdCrE3MienFY/5Eag/L8cBJov3UgcqZ3m6NG4
         str981CIrMLdkPUMeJEDv+rHL+Q2l1f4bBYK0df8dQlcVeR48Qt8g86P21dClL8FT5ET
         GcXTDCzyDh3PvEIUjmvoI0DIgLThU1a+gfFJgI7ie/VXv94eF4MxjqtCaZftB4s4DHKe
         o8FA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=AyGeXSWlMzOIy/hkiCrKDhhX38vwiuPZQyYWri0c344=;
        b=DpVJ54PXnFZDxNrKQBMUOwy44NOa/ET2CmRpG04qg9kB1M7/wnwxWyFJ3tZOtGbLtW
         gE0TtyiZlUZOtUKYOB++qObZrPqW41bviRD3EpqFCiaGC60PbrDW7ksnUzXuyDvznnyq
         Dd2OXRG0lHn5SP9j8imdcnrDGM9yPnfH5FzSKGp0tcG9SoJMhNGjzsMITnqKFCez1vbn
         n49y5P04XskJuHU3YICWZt6WzeXiMg6QFd+1+9OmzleKjcnnhRovGy2V5o9EvwyokHQP
         LgCleRW9kNp6o9zHRIChKVyZYoHbv4lkG5k8R0lxHYnT1aR4yy1eYA9IA0Nxx5xiI72Y
         dhig==
X-Gm-Message-State: AFqh2ko74jQhbTXFzOErUg8dCundKYC88vviuCUEoFDKWKCId9fPH38A
	Rv8O4b5pvqyPmrG0m4nQIyM=
X-Google-Smtp-Source: AMrXdXtIKiPWDx+0UOs3naUIh3gCGa8SMJcHXcqH43H23R7Tm8owAXf9uJnog/mXR7egfTPoTxqyGw==
X-Received: by 2002:a1f:19ca:0:b0:3d0:f9d5:637f with SMTP id 193-20020a1f19ca000000b003d0f9d5637fmr14217557vkz.0.1672422474963;
        Fri, 30 Dec 2022 09:47:54 -0800 (PST)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id f9-20020a05620a280900b0070531c5d655sm1233816qkp.90.2022.12.30.09.47.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 30 Dec 2022 09:47:54 -0800 (PST)
Message-ID: <791d5db1-a6a7-fb9c-2623-efadc351d891@gmail.com>
Date: Fri, 30 Dec 2022 09:47:51 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH 6.0 0000/1066] 6.0.16-rc2 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20221230094059.698032393@linuxfoundation.org>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20221230094059.698032393@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 12/30/2022 1:49 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.0.16 release.
> There are 1066 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 01 Jan 2023 09:38:41 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.0.16-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.0.y
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
