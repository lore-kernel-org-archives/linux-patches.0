Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com [209.85.160.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 001A1D53E
	for <patches@lists.linux.dev>; Thu,  2 Mar 2023 23:16:22 +0000 (UTC)
Received: by mail-qt1-f177.google.com with SMTP id d7so1062613qtr.12
        for <patches@lists.linux.dev>; Thu, 02 Mar 2023 15:16:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sladewatkins.net; s=googled; t=1677798982;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=C6wk6uyA/I4kJ0qrpbw4f072OcKkiUzKgNLTSxWPahY=;
        b=lAxmF9mrCPEH2For/QcFimI2VcJ8P1+8Tues4emnY5xB9QSfo3ozFerN+4AjcNnKJ3
         VzjgqVjdXE0UizJez6KzHFNKf7xQhibQGzyyJy4GGzp1narGuiBMqx2KX8dL3CDGnvOT
         XJqyBMG9Iy4awk620SBFs9XNQKL3L9ix1HVPDWyZYCib/dcB7nHP7bkoicyV0egsIssp
         NKNcDzmIiyhE7pB1EaszduvxfzO6HosFNNXGvZnyhHY1ViJAMugsIAzS0zj/3vC2Y/K2
         9Elmdetaa0pxf/DGGVthEs4rUF6eIgmRN/crYBCBYVkAox5z3RTYSC52PKZUngCXrl8n
         7gZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677798982;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=C6wk6uyA/I4kJ0qrpbw4f072OcKkiUzKgNLTSxWPahY=;
        b=tz8/uIuxlr79i1A6Fwdww+aaWcs8X6uCC0FY4KKp2auzovAu7NVkFwn6NjAiMR1rxo
         as3xUIoonkrPbmxs91Jt9iTRao4NmGOQcSr+wtKC7e0Fq81ApSfKQkZPBWsUN4KzTnnf
         oJoV1PpJDeJ2rHVEpwdw+hbksfIb4DljATGcKIkfI82Ceip2Y6OihssDO08uMymZLuyI
         AcBsKo+YKKx9+FRFSKwx9SGlsc+r/sTwGaMCfS5P8YsTlYWtbj9R8vrgBmV0oUDxOBGU
         1yc4hgcsinhtnCdwlJ3E+7Uw47Gx0NQjg4T1BVQRyogDOpDMcmZPJUdd+7q8dg0//ugB
         8ngg==
X-Gm-Message-State: AO0yUKVGOtxg49ROHxF0R07WZMXd/VVPI4WPPQUAtVCgXhTA5WQNyOT9
	lvg5iOEG7dp2zik57OhD6M1wv1iBIpiC34a7EKoLlZT08fvUnkjSNJuM7HpgAbDHA8cr+w8H4GY
	9wFERyWawlE4a
X-Google-Smtp-Source: AK7set/kcppLvcyubPB5r+FPoK2bZYHwtckOY9nQSDJAM4KdRP2dG997b3gCxUBe/EXI/lh/27HGYw==
X-Received: by 2002:a05:622a:2c9:b0:3bf:ca92:3b3a with SMTP id a9-20020a05622a02c900b003bfca923b3amr20730412qtx.23.1677798981893;
        Thu, 02 Mar 2023 15:16:21 -0800 (PST)
Received: from ghost.leviathan.sladewatkins.net (pool-108-44-32-49.albyny.fios.verizon.net. [108.44.32.49])
        by smtp.gmail.com with ESMTPSA id q25-20020a37f719000000b007343fceee5fsm608844qkj.8.2023.03.02.15.16.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 02 Mar 2023 15:16:21 -0800 (PST)
Message-ID: <ac0e63e6-294f-5ea7-0e2a-f9386b181d58@sladewatkins.net>
Date: Thu, 2 Mar 2023 18:16:20 -0500
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH 6.2 00/16] 6.2.2-rc1 review
Content-Language: en-US, en-AU
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de
References: <20230301180653.263532453@linuxfoundation.org>
From: Slade Watkins <srw@sladewatkins.net>
In-Reply-To: <20230301180653.263532453@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-SWM-Antispam: Scanned by proxmox-gateway.frozen.leviathan.sladewatkins.net
X-SWM-Root-Server: frozen.leviathan.sladewatkins.net
X-SWM-TLS-Policy-Status: enforced
X-Gm-Spam: 0
X-Gm-Phishy: 0

On 3/1/23 13:07, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.2.2 release.
> There are 16 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 03 Mar 2023 18:06:43 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.2.2-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.2.y
> and the diffstat can be found below.

6.2.2-rc1 compiled and booted on my x86_64 test system. No errors or regressions.

Tested-by: Slade Watkins <srw@sladewatkins.net>

-- Slade

