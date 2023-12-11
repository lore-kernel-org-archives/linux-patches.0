Received: from mail-qv1-f44.google.com (mail-qv1-f44.google.com [209.85.219.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4058E524AE
	for <patches@lists.linux.dev>; Mon, 11 Dec 2023 19:04:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bDxb+Jr3"
Received: by mail-qv1-f44.google.com with SMTP id 6a1803df08f44-679dd3055faso30159016d6.0
        for <patches@lists.linux.dev>; Mon, 11 Dec 2023 11:04:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1702321474; x=1702926274; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Owb5uItYn8kw7O33SQIVp7iH4r7RmA4K+7xsYCtDFM0=;
        b=bDxb+Jr3RTsDugfdSf7EKMHxCUE7aNeBTvqUllS0vpcURbD1Q07B/q6yJ7C6AVvkmr
         dDUSt4us4qfmXNlmXXWLyJgq0IvjMch83Iq30L3gP+/mPF+S0TPazfp/V+q77aoB+Jnt
         zFyKKHAjmN0M2lHg89kacap4NiBG6d8fImzjcmT5Vsbfh+M3ljLRi+a9VUjpn8EXy948
         a/Yrl6mSi33HY02p+dcwIp5sBs0uGg85p9d2aCED4PQaPwiQIrsjPX7l5YmzJZvcxZRI
         Ugfk5RnAGSPNKNZZEUU+ysNbKcO/0StJ8LtIVcKU+F5PM1OmTRDGrR7Bfn4XkeNR7pt+
         68pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702321474; x=1702926274;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Owb5uItYn8kw7O33SQIVp7iH4r7RmA4K+7xsYCtDFM0=;
        b=XcEy9NTNHIUlMXal5Klx054+PTpa6gpHF9kTJ/kQ1dPikYcoqWEst68ScC+tgeIrMR
         hgIosjc/+/XH3N9Lzlcv8MyXY35RTIzQOfsyM7uH3eFVJIkhnhGCRZrUaFYb24vDjBuk
         2B7fSlezaOk9Mr3mGwqNSI9bDdHKhMAWUY1Vd1sXsmqJw04NxwfhTLUDOIpDp1tmiV+p
         wNpeOoXjbYoeqeto1exQ/Rm1FRgKMIuTGzsD7HQsdZ15AFcFnfrgu16WgCQAJZpGcBB3
         r131yRzi2s7vMMHutwkZD0tAk/CtxPyHBYK6BrlOnFLVatiQ3yaIznRXun37RVzpEwgM
         +XsQ==
X-Gm-Message-State: AOJu0YzvzKevFZ47R4PEj8ELavKA2KGh9GOs5fuAAzlx7gVpDQ1fCN0W
	tGVQt8I6s04BiGUxnabAnOo=
X-Google-Smtp-Source: AGHT+IFIEGUvFHVgU2aCwUnLKbRC8jwfxPyiHXos7n9wRbHv8eqC3u49v9pRWLhJFb2vVFjgm8Jq5A==
X-Received: by 2002:a0c:cd83:0:b0:67e:bc54:8df0 with SMTP id v3-20020a0ccd83000000b0067ebc548df0mr4599938qvm.127.1702321474058;
        Mon, 11 Dec 2023 11:04:34 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id u8-20020a0cf888000000b0067acbd864e0sm3473069qvn.69.2023.12.11.11.04.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 Dec 2023 11:04:33 -0800 (PST)
Message-ID: <1fd0d7c1-70e2-4ee4-89c7-b1085bf078c7@gmail.com>
Date: Mon, 11 Dec 2023 11:04:27 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 000/244] 6.6.7-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, allen.lkml@gmail.com
References: <20231211182045.784881756@linuxfoundation.org>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20231211182045.784881756@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/11/23 10:18, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.7 release.
> There are 244 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 13 Dec 2023 18:19:59 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.7-rc1.gz
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

