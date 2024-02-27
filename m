Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com [209.85.160.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B1E73D988
	for <patches@lists.linux.dev>; Tue, 27 Feb 2024 18:58:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709060326; cv=none; b=ATFBQzMZTER3TlpXYj+p0wXzalUBYYkp+nFe5SCt0qImW35+guv1zVBieZMmuEVtYuC8aACNK07EPY9w00wWUqn5zuShbFGUyITE5EQ77Y7dhPOLMVJkAw5sAFQGBQXul20XN8Xv64IJ8fvy6QHOhOIcJjTkSVzoRD0nWIud5Q4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709060326; c=relaxed/simple;
	bh=Zs76+O63hWdcrw9stSfkc95Kxt2nX61aPPSt8OGVGIo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=VDzA5NQ+CYUQdwPz9r7LSmphQ+c9nuo6LVEAcCxoadkEumcu/oV2oucVWmVcvR1JABCP3oosSVvaXFFLvFG5wbsiOWnOmnTclkURS5sddlmSSNra+zvFARERQHv5ZECBG9zlk9BmjAXYdv9W19KF41DzZPVeEr4ssCY8iDUfk0g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cvRNsuQd; arc=none smtp.client-ip=209.85.160.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cvRNsuQd"
Received: by mail-qt1-f176.google.com with SMTP id d75a77b69052e-429f53f0b0bso32283831cf.2
        for <patches@lists.linux.dev>; Tue, 27 Feb 2024 10:58:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1709060324; x=1709665124; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=k+K4Qa3o+E8D+LDjXO92NrOsZYJ4mnIsJi9fWR3KCCs=;
        b=cvRNsuQdof5n17LSULglCMzkNihHU3P9ugQEEKZPkJULMkrRMREF3aOYAsh7YuefZK
         OUre+P9Da4E6dN/AWYf1zq7mwcMI3vYZUYTVTEfN1TTLLOqDfsoavRbhEOZw5bKd9W60
         dUsmyjBZwC9aAo8A52DeFu0FvG9nh/z7XPb6NYHO9YRX7Fb/Tsj7pcDjijoEZ3G8HCqU
         4owHBOF+nuCUMoTnSV6r4Jg9D1Uiqh2Q+pFIvM3GFa8Z00jFoL7wSj4Bc983WQ/bUhe/
         8wU/Lkmxl0/QcJjCVUvK4qIOcmR4Ulv72tduPY7UvjkXupGMWYLY4oyX9LIRidnkphFL
         9N+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709060324; x=1709665124;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=k+K4Qa3o+E8D+LDjXO92NrOsZYJ4mnIsJi9fWR3KCCs=;
        b=FOOsE4XMoO7OXe7ovCVUOeMyvi6CCQ1UMoIWAK+emgi8fVihWEKLpDwrjmFHYLBgCQ
         wDy0yL56GFICzwooEOA77KdXduppwzpMvaFS2zfWnTVyNea9QCyH/jTOXMl8ixy0Ok50
         9Pa3QUKFjMeEtUTeUxwVIH2+sV8KZ8EcC8iPbuVR+JSUkO3aa34+zoDyiqJNOMQO3Bnk
         xMoKxeqKCp9KQ7jSuReCiaeJ1fqRHq20yqRtAYDstYYswkP0Pc89WsRlx4iWc8gNG2SE
         XD2uFca+vHXHbpHvFWuH1Mgjq4BtNsbRZlbZXYe9GfqT9q1TPd1VfCzvhnY8UMuzlMFA
         Cjug==
X-Gm-Message-State: AOJu0Yznm0zdCPY8FX/PavfKlqkJ1R6t+VSaapkwk8KtoDcoDIzs0DND
	uHKn3G59KAVWRXRYLzEc5vt0liKk6yYCjbhaMdlyjOzdHYoIpuxELoIeneVJmbw=
X-Google-Smtp-Source: AGHT+IHOBBtm+y6Xvne+idIykd5zAmxoipMES/7eQNeUSWqu7AW7Hu/sFYLt2Cug3EoyhvuTfhH4EA==
X-Received: by 2002:ac8:5f92:0:b0:42e:8f05:97b9 with SMTP id j18-20020ac85f92000000b0042e8f0597b9mr5649563qta.46.1709060324481;
        Tue, 27 Feb 2024 10:58:44 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id d20-20020ac851d4000000b0042e0620d2afsm3816973qtn.72.2024.02.27.10.58.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 27 Feb 2024 10:58:43 -0800 (PST)
Message-ID: <cfaa0f4b-f9ef-459e-a174-3062b2d3b514@gmail.com>
Date: Tue, 27 Feb 2024 10:58:39 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.10 000/122] 5.10.211-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, allen.lkml@gmail.com
References: <20240227131558.694096204@linuxfoundation.org>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20240227131558.694096204@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/27/24 05:26, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.211 release.
> There are 122 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 29 Feb 2024 13:15:36 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.211-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels, build tested on 
BMIPS_GENERIC:

Tested-by: Florian Fainelli <florian.fainelli@broadcom.com>

Same warning as what Daniel reported for ARM 32-bit:

In file included from ./include/linux/kernel.h:15,
                  from ./include/linux/list.h:9,
                  from ./include/linux/module.h:12,
                  from net/ipv4/arp.c:74:
net/ipv4/arp.c: In function 'arp_req_get':
./include/linux/minmax.h:20:35: warning: comparison of distinct pointer 
types lacks a cast
    20 |         (!!(sizeof((typeof(x) *)1 == (typeof(y) *)1)))
       |                                   ^~
./include/linux/minmax.h:26:18: note: in expansion of macro '__typecheck'
    26 |                 (__typecheck(x, y) && __no_side_effects(x, y))
       |                  ^~~~~~~~~~~
./include/linux/minmax.h:36:31: note: in expansion of macro '__safe_cmp'
    36 |         __builtin_choose_expr(__safe_cmp(x, y), \
       |                               ^~~~~~~~~~
./include/linux/minmax.h:45:25: note: in expansion of macro '__careful_cmp'
    45 | #define min(x, y)       __careful_cmp(x, y, <)
       |                         ^~~~~~~~~~~~~
net/ipv4/arp.c:1108:32: note: in expansion of macro 'min'
  1108 |                                min(dev->addr_len, 
sizeof(r->arp_ha.sa_data_min)));
       |                                ^~~

-- 
Florian

