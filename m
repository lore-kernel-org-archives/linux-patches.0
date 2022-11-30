Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEDCB801
	for <patches@lists.linux.dev>; Wed, 30 Nov 2022 20:35:54 +0000 (UTC)
Received: by mail-pj1-f45.google.com with SMTP id k2-20020a17090a4c8200b002187cce2f92so3119406pjh.2
        for <patches@lists.linux.dev>; Wed, 30 Nov 2022 12:35:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=gSEjPF93GMI3z5E1hQkgEscxi559x8HTBtezk/0B3sM=;
        b=F0XixuXZEk2UTAsNqC7vceNho1K4AE+FJ0RvADRizDnWeTE9clf7X6O8B2gy6wUnZV
         JHGZ8sB0kSijDJfB9lOYv/za7yVGmeWvMgKrh5h9/ocxd6zpBh4iH8+Ac8kGiKA24S7S
         LDy4WxejU6DA3oRZvhxGdEddA+imoExbJvbnBQKAuAhJUy+zpTENRyQYUWu4tjcRjMOR
         EcYR8wPn8kAnMP2yWcbI0ZctL8KIHcCd5rjAw2M5jW7vjMvmutDMz62AmRmk57v7JLAg
         h7SWjFNNJst8+tNLfUklZAS0izR4pQikWoge3vmcJbQ5lqToZ9XnHHGuCupUs8ZvaEJ9
         POIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gSEjPF93GMI3z5E1hQkgEscxi559x8HTBtezk/0B3sM=;
        b=LTgaaxb6FuGMVhMWp4KUyetPnQR7CXeXZUgatPeyMoxYZAn5Xfms+k1JdZ58+9jOPn
         WQeArWNCi3RKq0faSaK2ifz6L8AS8UAGsHdTWaJjbz3T7W8e+Y3gI6G7YfxNAkpzK3pk
         WYVTripNx94gY+j983znIKTx7vwUH6yfpc8w9B5EkHu06cmj/WtW7Ljx9d5lPcoD37Zg
         6Pc8vQems+MpB3KLAHC+p+pN+mkBDbmSG/Jla6ZRk3mTFnzcqhuBzFbb1sQochU4VQmq
         EYkq2HXiVqWLzkNmb+eWZn5XDYhEE76QqnLQIkld60BvGSo7aZkSRV53+DhZkWJw2UNv
         KoJg==
X-Gm-Message-State: ANoB5plEA0C9YFMZCPZJldhlGNJSwvrH+uu/UspXdc6B2IfYTX3/sE7I
	LAZFgutdyYv2lmUKnmguFbgRXVDI06Q=
X-Google-Smtp-Source: AA0mqf5DhFdlnhKi8U10qOmeowf+5XiyAAeogl4c6RW380zZBR5Wev9gOPnGQJ36tCRMNA49oIvJvg==
X-Received: by 2002:a17:903:32ca:b0:189:9031:675c with SMTP id i10-20020a17090332ca00b001899031675cmr14548535plr.139.1669840554198;
        Wed, 30 Nov 2022 12:35:54 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id c1-20020a63d501000000b004351358f056sm1333987pgg.85.2022.11.30.12.35.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Nov 2022 12:35:53 -0800 (PST)
Message-ID: <8a1564c1-3321-e180-7340-f70cdddd40fd@gmail.com>
Date: Wed, 30 Nov 2022 12:35:49 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH 6.0 000/289] 6.0.11-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20221130180544.105550592@linuxfoundation.org>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20221130180544.105550592@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/30/22 10:19, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.0.11 release.
> There are 289 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 02 Dec 2022 18:05:05 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.0.11-rc1.gz
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

