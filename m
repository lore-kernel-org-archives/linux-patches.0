Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C20536AD9
	for <patches@lists.linux.dev>; Thu,  9 Mar 2023 11:38:03 +0000 (UTC)
Received: by mail-ed1-f50.google.com with SMTP id ec29so5700457edb.6
        for <patches@lists.linux.dev>; Thu, 09 Mar 2023 03:38:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678361882;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mM1ayM67gmODluLDBPt8vqT0sHU0TAIuRWhypzrZ2jE=;
        b=TJ4Hb4mb6Dp21LeW67bohudX4T2daK5KY5wu05ZlL2hHpKXwUGCV3DqSyxF1BEFbmz
         H0yv6LvCabAKUf+wjW++YG0LwzXIAyzClDhZUO1VNpITg1lmMpT5XEhX7E10VQNXc6bJ
         vpKnItGxKZXuR6w+tW+yLrKp9oBIOTgyvWXBwk0QUiHPvDz6JlmU64dK24TQIKRdwQL1
         PEoL4Ih6PU5X5+SwlukBcTG8l0qmZM6eP8rQhL2uegJ2Pm0Xy5AWBTfTcGh5xEvtk6IR
         NVoHXjEB7jXK+x36WTJFWAe5YgCU0m9NlcbNvQfiGcWPcopp7JpYdcbiYm/LyWx8o3bO
         ++UA==
X-Gm-Message-State: AO0yUKX6Pud01x054jElk2ZKHcgwJ2f4WbpnF9Je0jok/TekpZNhfxBK
	q+02/FH8UtIz/OMj8kZTo6M=
X-Google-Smtp-Source: AK7set8uNJKJbmIY/B+3Dtne4qmPemh1ashddWF0pWqFULxC3ibgb+85qsWO9tv0GSp4cOeKaRkwqw==
X-Received: by 2002:aa7:d404:0:b0:4aa:ca81:a528 with SMTP id z4-20020aa7d404000000b004aaca81a528mr17516820edq.40.1678361881859;
        Thu, 09 Mar 2023 03:38:01 -0800 (PST)
Received: from ?IPV6:2a0b:e7c0:0:107::aaaa:49? ([2a0b:e7c0:0:107::aaaa:49])
        by smtp.gmail.com with ESMTPSA id j7-20020a17090643c700b008caaae1f1e1sm8675728ejn.110.2023.03.09.03.38.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Mar 2023 03:38:01 -0800 (PST)
Message-ID: <d02b87ce-3c76-f940-ed01-771a27e79022@kernel.org>
Date: Thu, 9 Mar 2023 12:37:59 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH 6.2 0000/1000] 6.2.3-rc2 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de
References: <20230308091912.362228731@linuxfoundation.org>
From: Jiri Slaby <jirislaby@kernel.org>
In-Reply-To: <20230308091912.362228731@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 08. 03. 23, 10:29, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.2.3 release.
> There are 1000 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 10 Mar 2023 09:16:12 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.2.3-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.2.y
> and the diffstat can be found below.

openSUSE configs¹⁾ all green. x86_64 runs fine in qemu.

Tested-by: Jiri Slaby <jirislaby@kernel.org>

¹⁾ armv6hl armv7hl arm64 i386 ppc64 ppc64le riscv64 s390x x86_64

-- 
js
suse labs

