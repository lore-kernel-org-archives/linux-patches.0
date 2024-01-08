Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2991254BEB
	for <patches@lists.linux.dev>; Mon,  8 Jan 2024 18:50:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NMdIg4Tx"
Received: by mail-qt1-f175.google.com with SMTP id d75a77b69052e-42786ec994bso18983951cf.1
        for <patches@lists.linux.dev>; Mon, 08 Jan 2024 10:50:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1704739843; x=1705344643; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=rXNycdNMhzMAOfmU6s+i4TfyZEjJm1RCUufm4qHOMfc=;
        b=NMdIg4TxXYkRBwUlto7XbpNqFJVJWUFGkHC9ERH69Gur6iHMp2da+f7VyaLRAhgzMP
         EPUk72a/LTFxgo3lhy2gNPAyx7DXjy9rOTyh1N1hYHfMUjSaczsvGiI0YYg31Gj/MsCO
         VVyso1Q5mLennuheYnVxq+Dv5O6cEIJuLNWN+7G+kglqCMJ2FNk10WveVFgpmmCxzjEr
         u4+H6E8uujjWKxMTCf4dAwscm6p+DcRYwgSvQjUGSl0uUleU0QdtOAybi5au7m35/AAH
         evIjuB59tI2x6xSqrF8r9hewpzK9GRvwQssqWrRd4VySwAolJ3g4kEMSkf97gUQcWUZi
         o8ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704739843; x=1705344643;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rXNycdNMhzMAOfmU6s+i4TfyZEjJm1RCUufm4qHOMfc=;
        b=RURxOIIXfYfK3fOFdfZZiosP+nXv6qLIJl+XD96sS0rZNb5PxrK2rSvWL7s/EgdtcP
         +qgEB3u74gOP70ap8S8nWV7F3ue6NUTe9rYWQLVdrGoJ03QYMUKbCQdiJrvJMWBLiqha
         ZJKNI/15ymt2dmDV2P5skLFwXs8SUvpMmtyfsADJdk+HbVDMowGVfo5bBJuvRE1lkHiO
         ykwiJtQuhciPPOCzxN5DxzP2w1wXBT3enpCS+T7dERPtHweCkgmtMH0gRKylM7THuEsP
         9LGR1H4Orly9bPYQoCB4s8tNtf8g4V8aZeZ0uAqrRWy+gi8llB8h6V6Opmnv5/B1Ndpu
         8N+Q==
X-Gm-Message-State: AOJu0Yw3myqO21Y1lF0v4HJLreReqjcHKrt5sNsi4o78dXLZg5Cg6zrI
	wCyDpRO9FS43TdJbLUVL2j/pyEp9zlk=
X-Google-Smtp-Source: AGHT+IGkEu745dIhOXwmgcY4CYYCXC26b/8Xi2Bh/LkeG67O/UPTWjpOl1ApgtQObG7VGz/BS3dSCA==
X-Received: by 2002:a05:622a:13d2:b0:427:a33e:8b97 with SMTP id p18-20020a05622a13d200b00427a33e8b97mr5719676qtk.5.1704739843068;
        Mon, 08 Jan 2024 10:50:43 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id hb5-20020a05622a2b4500b0042830a16af7sm120591qtb.62.2024.01.08.10.50.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Jan 2024 10:50:39 -0800 (PST)
Message-ID: <1c0762d0-49fc-4740-b092-8012653c7b47@gmail.com>
Date: Mon, 8 Jan 2024 10:50:36 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 000/124] 6.6.11-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, allen.lkml@gmail.com
References: <20240108150602.976232871@linuxfoundation.org>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20240108150602.976232871@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/8/24 07:07, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.11 release.
> There are 124 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 10 Jan 2024 15:05:35 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.11-rc1.gz
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

