Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com [209.85.160.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB4538490
	for <patches@lists.linux.dev>; Fri, 16 Dec 2022 19:29:44 +0000 (UTC)
Received: by mail-qt1-f169.google.com with SMTP id z12so3503674qtv.5
        for <patches@lists.linux.dev>; Fri, 16 Dec 2022 11:29:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Ivm4Ys7XgJf3YYzv4BAQtpAC/aUCSXOPDDFKz4AguEI=;
        b=T2KjADE3vFRdeeLM3QPEW1ZQxBrwrazAjdzbOtVetkqh5X2egPgvfF4W4abf2+hFt7
         tJJ53H4xNxgVnLzCoH9DyeXWUmrYWx2JvmWhfwNmbOkc+zFOTvGN+BM3h40zHll6N/GK
         Cm2Ou4Qb1L0CV87Nluev0yXYuQxqECe2YaNUIZknKnhjfdZj+vPyGuuOOmsMDiXhlEaE
         rWwpltSuLXzrDOpBGrHRy8I40xQQOK2gYwO6PJAU3TmB5CdOpO9sh6cJc4Z1TE3q4B2F
         2Qxf3jSOrIXtT60nhds+Orh9UuZ1Dd29bNuqvhFnDzDSLRxfIR+gyRowiokookQutO06
         drig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Ivm4Ys7XgJf3YYzv4BAQtpAC/aUCSXOPDDFKz4AguEI=;
        b=UYW19WsuEVsUyzwuxKL/pJt2NbGLPz1yGVKNej2twCzw3mJibzhr0Op5HQE4EQGIrF
         3aXCKidRXoE7xzehxrps18nZpvAfKrZonf5D+Be035dufj9KUdW91J9Lc4oHlAAnsIov
         uArl50000Hci7MLxpf8pS2ERhw+BqHQJrxDn31IfIstFOVbh4OnvZMvkFFzO13Gt7k8Q
         KZ/fB0j5JvH8+UIQQO7CATR0QjwjrPv/MbtIYRZPIrSq/BNTliURRDNqJYEn1H1+XEzV
         GKP6IqABOaUFFnOwxbTZgULL1dsgGyhF/8wGyR+onM+xR0SDQ1jrDGbFkrVruK/Qyv6I
         CoYw==
X-Gm-Message-State: ANoB5pnek8mLNZyLx3C41Te2k8hJzstdPzrmRhMVAIQqyW8kaYnb6s41
	hKwmizNIJnsz2PhyC8hZu38=
X-Google-Smtp-Source: AA0mqf4a2wZSscbBjBMTalnfXiZzcPcbJkPZ2m+oVUABZ87B+JtRN8O6gr7/XDLHldFWYTmheWXkvg==
X-Received: by 2002:a05:622a:5a19:b0:39c:fa1a:af56 with SMTP id fy25-20020a05622a5a1900b0039cfa1aaf56mr43429727qtb.56.1671218983813;
        Fri, 16 Dec 2022 11:29:43 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id h3-20020a05620a244300b006fc9847d207sm2058098qkn.79.2022.12.16.11.29.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 16 Dec 2022 11:29:43 -0800 (PST)
Message-ID: <c25d4315-c609-2fc6-0812-12c9980c1b70@gmail.com>
Date: Fri, 16 Dec 2022 11:29:40 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH 5.10 00/15] 5.10.160-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20221215172906.638553794@linuxfoundation.org>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20221215172906.638553794@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/15/22 10:10, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.160 release.
> There are 15 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 17 Dec 2022 17:28:57 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.160-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
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

