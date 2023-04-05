Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB12929A8
	for <patches@lists.linux.dev>; Wed,  5 Apr 2023 12:56:54 +0000 (UTC)
Received: by mail-pj1-f52.google.com with SMTP id lr16-20020a17090b4b9000b0023f187954acso37183922pjb.2
        for <patches@lists.linux.dev>; Wed, 05 Apr 2023 05:56:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680699414; x=1683291414;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=udx9X2lCjzzCQSzA8XrrGEAIdcnTSdsgiQjtx2xR2Fw=;
        b=ovV/7dcXowDzEHyzLv8kBeXAQIuwPo6hYla3+48211R3GHIWym2AcnLzPDFV27XA6O
         6YIi70xwop3UeC5cz8w3zhaTxGIxfXj1zArLZwulXV9zXl8wk/kDF1eGzzeypX9oRUgr
         MQ1C8rjxTAlcaoqbKWcrs+vfHmWKCL9UKerlSJ/CPGVirFdcVhu2kKhSKNmPT2Im9RSk
         qeNbpHpx5u0/LcFQ+Da+Ji1q+PYOsgJv7VN2wo6UrNh31pmhGSQtWPfqv7sqmtI+s4/G
         uIi2OQipue4ad/FFGmQX5pK58FrL8KM4d+m12PZhILmgBiAfjYINshfRTmU2PWKNGSfL
         UxGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680699414; x=1683291414;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=udx9X2lCjzzCQSzA8XrrGEAIdcnTSdsgiQjtx2xR2Fw=;
        b=n03PMf31AvNF7b6s86JZ7KcB+1fx+UwrI9HhRKQJUe1m2rKrAdmucH/asQ/OxEecs6
         iDM0CxKqbHO1V8KNp4WKN4Y6wJ29L8hsC5S9FuGPVaSkyWSVXT+LdRCv57LI2/JzSr2J
         7+tq96P2XrXV2XXkwKr0FWsH51GPFtY6kBU2CfrqmmPf/6g06EzHKh3uiRYOW5Lj6vht
         MuJF3ZW9ZWOa40VNLotFAKQBRF0s60Yra2r3P6cONdcvAi8CbiksQcFvUhP1QBOgq/xe
         uClTgd0O2ZofMBjjc0ppSI/QlCOaE6rLPi3BSvhLFrVTW0ev9nNhWfAl9aiC6URu6yMO
         lO8A==
X-Gm-Message-State: AAQBX9eo1Ni/e5Qmeim4tG2BVMpHklCk9vzsahqb9l9fql/s3dTT40Dt
	G6s8MbYpR1RIKetSxI2p9rw=
X-Google-Smtp-Source: AKy350Y1jyiBFRQpHqT6r35EVxnVjzvfrX8JJvsTYRG9P7lqkNmW/jfcxB16JrNjfdslZTmJwCWX/A==
X-Received: by 2002:a05:6a20:49a4:b0:d5:e2cb:6100 with SMTP id fs36-20020a056a2049a400b000d5e2cb6100mr5243530pzb.49.1680699414008;
        Wed, 05 Apr 2023 05:56:54 -0700 (PDT)
Received: from [192.168.1.105] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id b24-20020a630c18000000b005023496e339sm8950041pgl.63.2023.04.05.05.56.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 Apr 2023 05:56:53 -0700 (PDT)
Message-ID: <c1ea92e1-8d5d-ec2c-71d9-1f386884a31d@gmail.com>
Date: Wed, 5 Apr 2023 05:56:42 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: Re: [PATCH 6.1 000/177] 6.1.23-rc3 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20230405100302.540890806@linuxfoundation.org>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230405100302.540890806@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 4/5/2023 3:03 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.23 release.
> There are 177 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 07 Apr 2023 10:02:26 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.23-rc3.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels build tested on 
BMIPS_GENERIC:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
