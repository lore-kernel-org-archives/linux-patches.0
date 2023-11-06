Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9ECC42C86F
	for <patches@lists.linux.dev>; Mon,  6 Nov 2023 18:21:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="d3HYFK5Y"
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-41cda69486eso32096621cf.3
        for <patches@lists.linux.dev>; Mon, 06 Nov 2023 10:21:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1699294869; x=1699899669; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=SQrzTgI4HfQNrka2FNCvIJjf2ADMLYsvYWHL3HxoBJw=;
        b=d3HYFK5Y5diN6OLR9YGVueAwuDZCr3nA1AL+3np2587xDIfLCeuYmiJEi9AScvcuWI
         Pw5R/ofNfAX0pn9XYWMGLXa7it4RIXOQ7Ro7tCV5b8okAlHzrRjzlC34dtEyr5VRqrRi
         DXo18vL2P0Rdu/5dH5Ge7RGe8MgYRoqSL75durH/IM22smLXiRc/jsbHK/JN5ln4rC+n
         CCGELflOzMYVD5VE5vIjdr5m4bhDhfxnnALzCUgZ03FBTsbKuAFGLCZUpFScF8DaSdWD
         zBlFN759JzGnNcZ4uXKQpPHFWSXcXpGcOfd+xbjaEvkoJpRZEmchkczilbeXTdimquv/
         jRCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699294869; x=1699899669;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SQrzTgI4HfQNrka2FNCvIJjf2ADMLYsvYWHL3HxoBJw=;
        b=CvFswcGTThn6CDp0mffo0qJMKhurIMwaE5zvq2s8XGyyz81h6itjqC5De/dwtwKFMP
         hbbdINRyGFOjODiFuQCGDJ+lhqmfiJLobZyeTe6z0Z7UDhyAiD9al1FTESvmOFiVSL98
         avMcCs8MLuwyUaln8HNanJHZf+OmzoV/3vrpzSVYDA2orn0Qsuiii9N8HDImPD3BlM3f
         95kMev03gQpePKrKfsRAmTt21aPuIqMx8TW81Utwa4qog2XHAf0+9z2pbZNV7quf34v3
         Hfr0Qj3x45jn1vDCOGW8gIZuyoYp9VswxlemH3PvyFjjVy+jJojGeZHrP43GS6pmwLwd
         MqeA==
X-Gm-Message-State: AOJu0YxqmwQoKbrZMdev2cfMI3LelWxEiH/eJtd0CFoSoM3ogOAIze3e
	rvl/DWNNk9PLOSHoZXQ0NVk=
X-Google-Smtp-Source: AGHT+IG45+mtC2eYMDM6QW7spOj49kaUMAWYaUWRTi1PQTc5vrEi17GCFup6TQj0zomNY52VNMB7Fw==
X-Received: by 2002:a05:622a:1447:b0:417:9646:8e2 with SMTP id v7-20020a05622a144700b00417964608e2mr37140262qtx.17.1699294869280;
        Mon, 06 Nov 2023 10:21:09 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id z9-20020ac86b89000000b0041cb8947ed2sm3595786qts.26.2023.11.06.10.21.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Nov 2023 10:21:08 -0800 (PST)
Message-ID: <2d007bae-c958-4693-9467-ad0f20f68bb2@gmail.com>
Date: Mon, 6 Nov 2023 10:21:05 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 00/30] 6.6.1-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org
References: <20231106130257.903265688@linuxfoundation.org>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20231106130257.903265688@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/6/23 05:03, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.1 release.
> There are 30 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 08 Nov 2023 13:02:46 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.1-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
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

