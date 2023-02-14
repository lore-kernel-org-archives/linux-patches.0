Received: from mail-oa1-f49.google.com (mail-oa1-f49.google.com [209.85.160.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3528BA54
	for <patches@lists.linux.dev>; Tue, 14 Feb 2023 17:04:09 +0000 (UTC)
Received: by mail-oa1-f49.google.com with SMTP id 586e51a60fabf-16ab8581837so19731026fac.4
        for <patches@lists.linux.dev>; Tue, 14 Feb 2023 09:04:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :sender:from:to:cc:subject:date:message-id:reply-to;
        bh=drKO7idz8bniLU0+VGX8stsZ83xhPx1+n6mCtJ3J9lg=;
        b=Dp++Qy93JEem3uE1Pm6TIbd/dOGt62NimziMjkxuvubeWRWW4Fv2lIaiX0e6yM7yst
         dqOcWk1qDMryUzJr4GWbLPxJeon4FvGg3X+JMgepL1Z1invh8HDEAk+t7+Dj7SF7LHf5
         +NzE5phsyJW3U6uuOYovmTu4zJQW4vDMWLfP7JMcDdsfbD0dEcRTTaFk+Il2f9MzQVJx
         zG3iz1Jbso1NGQ7XecaDCfJL3t9nZjkjLr9vkd5e4SFrm66MSxvVXWbKTwN8JLqn+GvL
         SmES3K0SK/r8X/u5VFLGv5ot0RwFu1CB68XdjVXspMlkP+teBWZ0b7d4BAF0fa9krxDg
         SJVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :sender:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=drKO7idz8bniLU0+VGX8stsZ83xhPx1+n6mCtJ3J9lg=;
        b=wo5culHjiyBDBYaeDskzw3RHO8pc4kfh6/l6eMqsGMY2i8KvxC40sbJ8AbiPMVO2Bf
         1LMG40ZWF/RGNd1zPhecVBQVFkLMCXjryE0UVNmgOptADYqkrjononJE8cpbyupKKIRa
         AUTVt0GCmFEr3dPKaSjaAGvry4vJOlEU7FgNPIU0cgdJY0xOD7B1BOGnq2jaUfeK1LUJ
         +nTgmKhxGVn8APO0AkmoV6wQBCB18LnSMA9AL8QgEqPeV8SA9Rj4kEIurUl4csjkjgYD
         m9SNvAd+jGm8Hb7YFDPniJMrMhSWDH0NZkUbwi1tjntzoDJMoaPs8RrzoqJ+bRhF9CGW
         3WKw==
X-Gm-Message-State: AO0yUKXwAImTAc+4qvMQMnLvMwey6eu+8t7D8FPh4TvXp7vmsjXvjuL0
	YXhOxq6riizYla8irTdqgZY=
X-Google-Smtp-Source: AK7set8H552uknuiozheWOs5ix1vqMmOfTiBiJSx4JpmFJ7lcKyF3b9y4uGTNscTAKvbHaSPFuUwSA==
X-Received: by 2002:a05:6870:80d1:b0:16e:223b:1922 with SMTP id r17-20020a05687080d100b0016e223b1922mr1455479oab.15.1676394248976;
        Tue, 14 Feb 2023 09:04:08 -0800 (PST)
Received: from ?IPV6:2600:1700:e321:62f0:329c:23ff:fee3:9d7c? ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id q1-20020a056870e60100b00163b85ef1bfsm6038319oag.35.2023.02.14.09.04.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Feb 2023 09:04:08 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Message-ID: <7106f107-061d-231d-fb09-bf4832e2a5a0@roeck-us.net>
Date: Tue, 14 Feb 2023 09:04:05 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH 5.10 000/139] 5.10.168-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org, shuah@kernel.org,
 patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
 jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
 srw@sladewatkins.net, rwarsow@gmx.de
References: <20230213144745.696901179@linuxfoundation.org>
From: Guenter Roeck <linux@roeck-us.net>
In-Reply-To: <20230213144745.696901179@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/13/23 06:49, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.168 release.
> There are 139 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 15 Feb 2023 14:46:51 +0000.
> Anything received after that time might be too late.
> 

We don't know the reason/cause yet, but Chromebooks with arm64 CPU
no longer boot with this merge applied to chromeos-5.10. We'll revert
the nvmem patches and try again. If that doesn't help we'll need
to bisect which will take some time.

Guenter

