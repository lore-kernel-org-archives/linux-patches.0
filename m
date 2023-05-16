Received: from mail-pg1-f174.google.com (mail-pg1-f174.google.com [209.85.215.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 266D234CE7
	for <patches@lists.linux.dev>; Tue, 16 May 2023 12:53:30 +0000 (UTC)
Received: by mail-pg1-f174.google.com with SMTP id 41be03b00d2f7-5208be24dcbso10164210a12.1
        for <patches@lists.linux.dev>; Tue, 16 May 2023 05:53:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684241609; x=1686833609;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=tlf53SXikb/z19JEmJl8BWwJrESesSp4gphf4RnkfAs=;
        b=mp7oye7ah3vsLF6Ld21S4KL0XTrHi/w61bY7zoUelJwygwXW2pmAzftec/18aD6ihL
         sZbcwxqEXmydZxSjCZpB1sCjA1iMqRJIta7PUKd+pP6tKQgbNezWhSaDcX9MKaDbomYu
         VBj6JegOu+Kxcia5FEqTtCdPj8CDaTf4TrJQC2uesfCo0GKzFzfKjRp6j+RIoMMWFP1X
         /1AAoqRpb3eEyPrlDbSwTvtaDFXNKOhPwECOyFec1IctZa4ydgZPrLZY3RVjaa93N8/i
         5YTlpqXdAWb8VsdAMsxzdIaayAJAsFMSdlHGQZQwpzy9gRBAS8/plxlfZZlP49SGuKZ2
         43Dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684241609; x=1686833609;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tlf53SXikb/z19JEmJl8BWwJrESesSp4gphf4RnkfAs=;
        b=gLTTA+a2E2w6seJtbGRuQM8lSVvBSM/4o8edbrQP2Jj+c9f6+dc8bB1t65qkCD+1pd
         fgxiLW+lyHy/OhHqy2Y/pUqwu88APwseutfrTVI1aC80T42vt4hPrTtp5fYM8ChPWSqR
         gzlorEyMnZdnFZRbK0GEzxEJqW2n499aC46S9f7ivkWVDQ3pZa3vSN9JHlVl1h0SmKLw
         SxZvGUxl/pm5RXHraMQ5ZRuYgXIWty6nC32yYley2jatXPhndyRCJF/QfahRqS0KASRy
         +ob8BXxagKM1j8m7uWZZFtcukxBt1VzpsBKWjKCDePTUwJh6M+PMQY7NSXFhLw3ViNZj
         ry7g==
X-Gm-Message-State: AC+VfDz2Z8WFroNpSI9xo/lbuB5x7gjlfJX9+wAnQxszLQJT/01x1JtG
	/YsQuh6uTriq18uqBllvcPo=
X-Google-Smtp-Source: ACHHUZ61ld0bQ66K0nxyj0WctGp6rkEVUAgGPRlAjOXRjcV5Ep83yiie8a2UX6lc7DGLN2qxURdTdg==
X-Received: by 2002:a17:902:a584:b0:1aa:f173:2892 with SMTP id az4-20020a170902a58400b001aaf1732892mr1402835plb.57.1684241609391;
        Tue, 16 May 2023 05:53:29 -0700 (PDT)
Received: from [192.168.43.80] (subs02-180-214-232-8.three.co.id. [180.214.232.8])
        by smtp.gmail.com with ESMTPSA id w18-20020a170902e89200b001ac4e316b51sm11103462plg.109.2023.05.16.05.53.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 16 May 2023 05:53:29 -0700 (PDT)
Message-ID: <2ecd714e-f00e-3f6a-4ddd-4c67d3798358@gmail.com>
Date: Tue, 16 May 2023 19:53:21 +0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH 5.15 000/134] 5.15.112-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de
References: <20230515161702.887638251@linuxfoundation.org>
Content-Language: en-US
From: Bagas Sanjaya <bagasdotme@gmail.com>
In-Reply-To: <20230515161702.887638251@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 5/15/23 23:27, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.112 release.
> There are 134 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 

Successfully compiled and installed bindeb-pkgs on my computer (Acer
Aspire E15, Intel Core i3 Haswell). No noticeable regressions.

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

-- 
An old man doll... just what I always wanted! - Clara

