Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F9A2A4C
	for <patches@lists.linux.dev>; Wed,  1 Mar 2023 21:50:36 +0000 (UTC)
Received: by mail-pj1-f41.google.com with SMTP id oj5so10845366pjb.5
        for <patches@lists.linux.dev>; Wed, 01 Mar 2023 13:50:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1677707435;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=CY/G8VL1j9svKq6UXUSNaPlCs+v3E+YYw2wZs/Qarhw=;
        b=KKKukoB/FejKMejFiidmTdPsUROFvlM6TbzAqQXHQP9iA7NMMMaOM/WuYsrJuTemvr
         QtEaSPXhlbxEYkhUa+uQdVegAUXo2ZQfwgL0+Gd6dEqfSufHLbDGG9D34fNvU1s2PIPU
         8w+HmXPRNVzVKW1VLNNh4lo1zLgAs0JiIM5H9oOHUOfwsJMaf312n/n/5dqZpm06tjYa
         QVqyLSJ62TGMi7ILn8RDvt5nYXu1erOp3CWQkFOfYmPvbs6KjM2IMN8+AuwByJqyYA4E
         TGyvSFuNoBThg3ZFXbOX75riN98LNHSDlUpq6sRhn+W+GfZdWpD45Hg4o9LpP/yRP1Qt
         Gm7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677707435;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CY/G8VL1j9svKq6UXUSNaPlCs+v3E+YYw2wZs/Qarhw=;
        b=02KAOAh2B99tEi3cN2U11MCBgKIZSlWv/dCU0deqvU63g4QKH1v5x6PV8obhtaxjh3
         1BI2eXiEtd5IT6kgGztRuN91OeCFAj1DApqTr1qBjDWZFF3XH7PlccYaVPV/TpfWLb6k
         /EK3QTtl/r0UCU1WVqVKoCtzlr8CUtCC14ryyTA5ve5Uv1pKNo/xuyxcyf0t+unlF+wH
         HVdV4M9BUQYaDezEWvpaZf2cLtV2pGoEeTfPd/F+V3jCxrJ3HQR+YDTiWZiyJZkm9NZI
         zPMEw1MHhCvCBGh60YRYZhCPre/99aqqdU+IdCsolufhwCD3qQ9a2zCTsCnEXH+0Ex6h
         nUug==
X-Gm-Message-State: AO0yUKUArogmJ4oovBGJPeRrEIHY/BH9+TkEA72aZX6lu4XwxvlUsSZD
	p6WEfVYwJkEatml+lV2AZbtKEgG3LZA=
X-Google-Smtp-Source: AK7set86T4W4m3qQ09dclQaqBWGByUWQ2bxyxzgNfkKg3sr6yZgUgKjoiTGlSoWT7cXVRWRdj4dZhw==
X-Received: by 2002:a05:6a20:8e18:b0:cd:9664:3d5a with SMTP id y24-20020a056a208e1800b000cd96643d5amr10531686pzj.22.1677707435576;
        Wed, 01 Mar 2023 13:50:35 -0800 (PST)
Received: from [10.69.40.170] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id u8-20020a656708000000b005004919b31dsm7899513pgf.72.2023.03.01.13.50.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Mar 2023 13:50:34 -0800 (PST)
Message-ID: <ddd46923-fc25-504d-394e-2c883977aff8@gmail.com>
Date: Wed, 1 Mar 2023 13:50:33 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
From: Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH 5.15 00/22] 5.15.97-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20230301180652.658125575@linuxfoundation.org>
Content-Language: en-US
In-Reply-To: <20230301180652.658125575@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 3/1/2023 10:08 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.97 release.
> There are 22 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 03 Mar 2023 18:06:43 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.97-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
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

