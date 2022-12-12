Received: from mail-vs1-f53.google.com (mail-vs1-f53.google.com [209.85.217.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E14027475
	for <patches@lists.linux.dev>; Mon, 12 Dec 2022 23:15:05 +0000 (UTC)
Received: by mail-vs1-f53.google.com with SMTP id 3so12955221vsq.7
        for <patches@lists.linux.dev>; Mon, 12 Dec 2022 15:15:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=V48MVKkpHJu7tVHw5UPSyY7rRxcwN3LhwuDRtIvk8io=;
        b=TirRS5W0oF99cVHtue2G5wruRhFSNEBMA0RvKK7R/rVUjBIMRpuq5f7xpkd6Orbt8Y
         z411b6w/Cua/PTgGciAl3pGh6CkYSZewCm9aawzWQuMhyCiF5JjcsvuSRDfDFMQtP//p
         +w78F6rAb2cPp3T0Tr9o7GWA52wQhbSwWpLEohFABfthO3GzupeeAy+vl+qZC6SVJmlr
         zKwlVSrS3Rfg7CSgGTq8Y3prbUfaYir+fEeoHVqU2dMofE/MrFsNroBaaBJxxywdauss
         EZKblUwtf287onCTefsWPqqxjNUWt7SaSIHFW5v4y9PnRI7O0+G/1sF02nAuvNRX8c7V
         e61Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=V48MVKkpHJu7tVHw5UPSyY7rRxcwN3LhwuDRtIvk8io=;
        b=qeyoyMC4Wl4I0+xyDQYGmLVwNrTx9RHgO5XPkN53vULXG9Vq6d2RkcCtLlXy4QQTdY
         8Ttp8WowN5jBM/HOpXBmaM3MqzB6AwRuv+MOhugEtWoY3gNhJcdQtlvVYz6Dzw+Jrhvi
         dEGGDU9C2xmpnKt75vDXwZA/EwVMPQb/ggsNaJ2Zm+j6apuWy4H4RJeTmQ7KgaGzLcPE
         j1A6njdB9tI9rS6Op7VpkRwtCoqYKTwF84l4kzfQETVWV8CZH9nxPkE2J9wlDq+OzQ5L
         yoYKXi7SfSi5i4pDI31ieQ79DfQRzy7Gy00w9xgnxpUS82TYykKsHMMPhdjvyq+w55A2
         eh4Q==
X-Gm-Message-State: ANoB5pnLdhFp9OGn9xao0CxVUJ7mtsxr1s0LZiGylib5QN7SNWDf57cA
	ee9QBHQ7Hyowypt27pS6WV0=
X-Google-Smtp-Source: AA0mqf724J0mpSGaVZ8djr+B7n0KXo1suwu+clUsF5GgAokepedmw8v4XSG1/H8xPUhQnDx+T8PzPg==
X-Received: by 2002:a05:6102:5709:b0:3a7:a0fa:91f2 with SMTP id dg9-20020a056102570900b003a7a0fa91f2mr8033503vsb.0.1670886904664;
        Mon, 12 Dec 2022 15:15:04 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id i22-20020a05620a075600b006ffb452b10asm25924qki.13.2022.12.12.15.14.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 12 Dec 2022 15:15:03 -0800 (PST)
Message-ID: <2625238b-81bc-d098-4cc5-ca2e2318a7bc@gmail.com>
Date: Mon, 12 Dec 2022 15:14:56 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH 6.0 000/157] 6.0.13-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20221212130934.337225088@linuxfoundation.org>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20221212130934.337225088@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/12/22 05:15, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.0.13 release.
> There are 157 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 14 Dec 2022 13:08:57 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.0.13-rc1.gz
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

