Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91ECD7C
	for <patches@lists.linux.dev>; Mon, 23 Jan 2023 19:28:53 +0000 (UTC)
Received: by mail-pf1-f176.google.com with SMTP id i65so9668574pfc.0
        for <patches@lists.linux.dev>; Mon, 23 Jan 2023 11:28:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=LQbopvBj+BKBokjG+wslvSo4KZa52H8rN7zi6aOGZj0=;
        b=Qzcxv9BF7oi7XXqffi4hOCTIIc8Pk9ftKrcqSW8P17KC+CCaKbN4ooY4AEKs/ZEdPL
         EZLPU8CcFp5C706elzCFxKraTiTNOEZBPwGaSBNWGUb/HQTm0P8lau5RSZi86fV1bZ5P
         DK4C/3BMeUqLS5XFJyYF+jcVILUmxIbz/ex6K19sFkJAR1rf57Ys4CPzpJ63y/avMAyb
         t1V9xoQsnifh+kpFSQuSB34ec3ILdsFLwkhA7LCd77vzvnrovivJSTFjDAN9ywiIuEWH
         5oe0wYrE+h2sHWW6209VuM0bJ0JX7XuUDxDplLMpacA57vo4wKJfa33GryPTrsGvtT5T
         kqJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LQbopvBj+BKBokjG+wslvSo4KZa52H8rN7zi6aOGZj0=;
        b=Q3Zum0yRcVdExHcd10+I7zXOnOjSDoD3EXH+I4UMbRcHqz4uL+yGbeKTBiGLjp3GPi
         X8+erApDWdFrOuOvM1hUqJQnXS9UnnvzrM1UfczmmVSb1C5x1gT0dqMcid04q/ct/DUQ
         LrFFEjLIICZOcvPY4p+enJHzOk355aM2sTHnXytXtLmRSivizpCLWTVNhZiKQQ2/UjNe
         JKwV85Kqu8FdvMmWbBlPkF38yQqXMbnDoiElIuNzwIDkjKGSCNUhnRIlpFxDZ1WZtg/+
         jJPPbOprqLTCX0WbXKhhBdMARx5+TphmtArl0gVVKj+Cdn7P2Kilm2EoxXaOv5qKNGJi
         wQAg==
X-Gm-Message-State: AFqh2kpzqBJerUYOpA6cfdcODlh48pbjYzfqOMr9XDDY1WJb4onINDLM
	KRfSPw+FdBLHzty6bWyU4zk=
X-Google-Smtp-Source: AMrXdXvJNhX30buiD3QeyO+hXA5MI3vqDrLuORt9nvYl6AjUhlSTdPa0GErFbZG0rWScEYS1qLgVgA==
X-Received: by 2002:a05:6a00:1c95:b0:581:6f06:659 with SMTP id y21-20020a056a001c9500b005816f060659mr26038056pfw.6.1674502132887;
        Mon, 23 Jan 2023 11:28:52 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id r15-20020aa79ecf000000b0056c2e497b02sm16655561pfq.173.2023.01.23.11.28.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Jan 2023 11:28:52 -0800 (PST)
Message-ID: <18773a19-ede9-bd83-0fa7-2790556f480c@gmail.com>
Date: Mon, 23 Jan 2023 11:28:43 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH 5.10 00/98] 5.10.165-rc2 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20230123094914.748265495@linuxfoundation.org>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230123094914.748265495@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/23/23 01:52, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.165 release.
> There are 98 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 25 Jan 2023 09:48:53 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.165-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit, build tested on BMIPS_GENERIC:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian

